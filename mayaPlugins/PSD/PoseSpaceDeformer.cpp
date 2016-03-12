#include "PoseSpaceDeformer.h"
#include "utils.h"

#include <iostream>


#include <maya/MGlobal.h>
#include <maya/MPoint.h>
#include <maya/MMatrix.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnCompoundAttribute.h>
#include <maya/MFnTypedAttribute.h>
#include <maya/MFnMatrixAttribute.h>
#include <maya/MFnIntArrayData.h>
#include <maya/MFnVectorArrayData.h>
#include <maya/MFnMatrixData.h>
#include <maya/MFnSkinCluster.h>
#include <maya/MFnDependencyNode.h>
#include <maya/MItDependencyGraph.h>
#include <maya/MItGeometry.h>
#include <maya/MVectorArray.h>


MTypeId PoseSpaceDeformer::id( PluginIDs::PoseSpaceDeformer );
const char * PoseSpaceDeformer::name( PluginNames::PoseSpaceDeformer );

MObject PoseSpaceDeformer::aDebug;

MObject PoseSpaceDeformer::aJoint;
MObject PoseSpaceDeformer::aJointRotation;
MObject PoseSpaceDeformer::aJointMatrix;

MObject PoseSpaceDeformer::aPose;
MObject PoseSpaceDeformer::aPoseName;
MObject PoseSpaceDeformer::aPoseEnvelope;
MObject PoseSpaceDeformer::aPoseJoints;
MObject PoseSpaceDeformer::aPoseJointRotation;
MObject PoseSpaceDeformer::aPoseJointFallOff;
MObject PoseSpaceDeformer::aPoseComponents;
MObject PoseSpaceDeformer::aPoseDelta;

MObject PoseSpaceDeformer::aSkinClusterWeightList;
MObject PoseSpaceDeformer::aSkinClusterWeights;


void* PoseSpaceDeformer::creator()
{
    return new PoseSpaceDeformer;
}

MStatus PoseSpaceDeformer::initialize()
{
    MStatus stat;

    MFnNumericAttribute nAttr;
    MFnCompoundAttribute cAttr;
    MFnTypedAttribute tAttr;
    MFnMatrixAttribute mAttr;

    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean);
    addAttribute(aDebug);

    aJointRotation = nAttr.create("jointRotation", "jr", MFnNumericData::k3Double);
    aJointMatrix = mAttr.create("jointMatrix", "jm");

    aJoint = cAttr.create("joint", "j");
    cAttr.setArray(true);
    cAttr.addChild(aJointRotation);
    cAttr.addChild(aJointMatrix);
    addAttribute(aJoint);

    aPoseName = tAttr.create("poseName", "pn", MFnData::kString);
    aPoseEnvelope = nAttr.create("poseEnvelope", "pe", MFnNumericData::kFloat);

    aPoseJointRotation = nAttr.create("poseJointRotations", "pjr", MFnNumericData::k3Double);
    aPoseJointFallOff = nAttr.create("poseJointFallOff", "pjf", MFnNumericData::kFloat);
    aPoseJoints = cAttr.create("poseJoints", "pj");
    cAttr.setArray(true);

    aPoseComponents = tAttr.create("poseComponents", "pc", MFnData::kIntArray);
    aPoseDelta = tAttr.create("poseDelta", "pd", MFnData::kPointArray);

    aPose = cAttr.create("pose", "p");
    cAttr.setArray(true);
    cAttr.addChild(aPoseName);
    cAttr.addChild(aPoseEnvelope);
    cAttr.addChild(aPoseJoints);
    cAttr.addChild(aPoseComponents);
    cAttr.addChild(aPoseDelta);
    addAttribute(aPose);

    aSkinClusterWeights = nAttr.create("skinClusterWeights", "scw", MFnNumericData::kDouble);
    nAttr.setArray(true);

    aSkinClusterWeightList = cAttr.create("skinClusterWeightList", "scwl");
    cAttr.setArray(true);
    cAttr.addChild(aSkinClusterWeights);
    addAttribute(aSkinClusterWeightList);


    attributeAffects(aJoint, outputGeom);
    attributeAffects(aPose, outputGeom);
    attributeAffects(aSkinClusterWeightList, outputGeom);

    return MStatus::kSuccess;

}


MStatus PoseSpaceDeformer::deform(  MDataBlock&     block, 
                                    MItGeometry&    itGeo, 
                                    const MMatrix&  world, 
                                    unsigned int    geomIndex )
{
    MStatus stat;
    MString msg;
    MDataHandle handle;
    MObject obj;

    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();

    handle = block.inputValue(envelope);
    float env = handle.asFloat();
    if (env < FLOAT_TOLERANCE)
        return MS::kSuccess;


    // If poses are dirty, recalculate pose2Pose weights
    if (_posesDirty)
    {
        _posesDirty = false;

        // Collect all pose joint rotations values
        MArrayDataHandle arrHnd = block.inputArrayValue(aPose);
        for (int i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
        {
            handle = arrHnd.inputValue();
            handle = handle.child(aPoseJoints);
            MArrayDataHandle jtArrHnd(handle);

            PoseJointMap jtMap;
            for (int j = 0; j < jtArrHnd.elementCount(); ++j, jtArrHnd.next())
            {
                handle = jtArrHnd.inputValue();
                handle = handle.child(aPoseJointRotation);
                double3& data = handle.asDouble3();
                MVector rot(data[0], data[1], data[2]);

                handle = jtArrHnd.inputValue();
                handle = handle.child(aPoseJointFallOff);
                double fallOff = handle.asFloat();

                jtMap[jtArrHnd.elementIndex()] = PoseJoint(rot, fallOff);
            }

            _poses.push_back(jtMap);
        }

        // pose-2-pose weights: For each pose, check how far is its poseJointRotations are from other poses
        std::vector<MDoubleArray> pose2PoseWeights(_poses.size());
        for (int i = 0; i < _poses.size(); ++i)
        {
            pose2PoseWeights[i].setLength(_poses.size());

            // Same pose
            pose2PoseWeights[i][i] = 1;

            if (i+1 == _poses.size())
                break;

            // Other poses
            for (int j = i+1; j < _poses.size(); ++j)
            {
                double weightij = 1;
                double weightji = 1;
                for (PoseJointMap::const_iterator iter1 = _poses[i].begin(); iter1 != _poses[i].end(); ++iter1)
                {
                    // If joint in pose[i] matches pose[j], calc distance, else return distance as -1
                    int jtIdx = iter1->first;
                    PoseJointMap::const_iterator iter2 = _poses[j].find(jtIdx);
                    if (iter2 == _poses[j].end())
                    {
                        weightij = -1;
                        weightji = -1;
                        break;
                    }
                    else
                    {
                        // PoseJoint of ith pose
                        MVector rot1 = iter1->second.rotation;
                        float fallOff1 = iter1->second.fallOff;

                        // PoseJoint of jth pose
                        MVector rot2 = iter2->second.rotation;
                        float fallOff2 = iter2->second.fallOff;

                        // Distance between poseJoint
                        float angle = rot1.angle(rot2);
                        
                        // Accumulate pose weight using weight of this joint (angle/fallOff)
                        if (angle < fallOff2)
                            weightij *= angle / fallOff2;
                        else
                            weightij = 0;

                        if (angle < fallOff1)
                            weightji *= angle / fallOff1;
                        else
                            weightji = 0;

                    }
                }

                // If distance cannot be found between poses because of differnt poseJoints, weight them 1
                if (weightij < 0)
                {
                    pose2PoseWeights[i][j] = 1;
                    pose2PoseWeights[j][i] = 1;
                    continue;
                }

                pose2PoseWeights[i][j] = weightij;
                pose2PoseWeights[j][i] = weightji;
            }
        }

        // TODO : Re-weight pose2PoseWeights using Scattered Data Interpolation (solve Ax = B)
    }


    // Get current joint rotations
    VectorMap currJointRot;
    MArrayDataHandle jtArrHnd = block.inputArrayValue(aJoint);
    for (int i = 0; i < jtArrHnd.elementCount(); ++i, jtArrHnd.next())
    {
        int jtIdx = jtArrHnd.elementIndex();
        MDataHandle jtHnd = jtArrHnd.inputValue();

        handle = jtHnd.child(aJointRotation);
        double3& data = handle.asDouble3();
        MVector rot(data[0], data[1], data[2]);

        currJointRot[jtIdx] = rot;
    }


    // pose-2-currJoints weights: For each pose, check how far is poseJointRotations are from current jointRotations
    MDoubleArray pose2CurrJointWeights(_poses.size());
    for (int i = 0; i < _poses.size(); ++i)
    {
        double weight = 1;
        for (PoseJointMap::const_iterator iter = _poses[i].begin(); iter != _poses[i].end(); ++iter)
        {
            int jtIdx = iter->first;
            const PoseJoint& poseJt = iter->second;

            // TODO: Get current joint's rotation and get distance between that and poseJt.rotation and fallOff dist
            double angle = currJointRot[jtIdx].angle(poseJt.rotation);
            if (angle < poseJt.fallOff)
                weight *= 1 - (angle / poseJt.fallOff);
            else
            {
                weight = 0;
                break;
            }
        }

        pose2CurrJointWeights[i] = weight;
    }


    // Calculate final weights for each pose, from pose-2-currJoint weights re-weighted by pose2PoseWeights
    MDoubleArray poseWeights(_poses.size());
    for (int i = 0; i < _poses.size(); ++i)
    {
        double weight = 0;
        for (int j = 0; j < _poses.size(); ++j)
        {
            weight += _pose2PoseWeights[i][j] * pose2CurrJointWeights[j];
        }
        poseWeights[i] = weight;
    }


    // Get delta from weighted poses
    MArrayDataHandle poseArrHnd = block.inputArrayValue(aPose);
    VectorMap deltaMap;
    for(int i = 0; i < poseArrHnd.elementCount(); ++i, poseArrHnd.next())
    {
        int poseIndex = poseArrHnd.elementIndex();
        MDataHandle poseHnd = poseArrHnd.inputValue();

        handle = poseHnd.child(aPoseEnvelope);
        float poseEnv = handle.asFloat();

        if (poseEnv < FLOAT_TOLERANCE)
            continue;

        handle = poseHnd.child(aPoseComponents);
        obj = handle.data();
        MFnIntArrayData fnIntArrData(obj);
        MIntArray components = fnIntArrData.array();

        handle = poseHnd.child(aPoseDelta);
        obj = handle.data();
        MFnVectorArrayData fnVectorArrData(obj);
        MVectorArray delta = fnVectorArrData.array();

        for(int j = 0; j < components.length(); ++j)
            deltaMap[components[j]] += delta[j] * poseEnv;
    }

    if (deltaMap.empty())
        return MS::kSuccess;

    // Get joint matrices from skinCluster
    MatrixMap jtMatrices;
    {
        // Get skinCluster
        MFnSkinCluster fnSkinCluster;
        {
            MFnDependencyNode fnDeformer(thisMObject());
            MPlug plug = fnDeformer.findPlug("input");
            plug = plug[0];
            plug = plug.child(0);

            MItDependencyGraph iter(
                plug,
                MFn::kSkinClusterFilter,
                MItDependencyGraph::kUpstream,
                MItDependencyGraph::kDepthFirst,
                MItDependencyGraph::kNodeLevel,
                &stat);
            MCheckStatus(stat, ErrorStr::PSDSCNotFound);

            if (iter.isDone())
                MReturnFailure(ErrorStr::PSDSCNotFound);

            stat = fnSkinCluster.setObject(iter.currentItem());
            MCheckStatus(stat, ErrorStr::PSDSCNotFound);
#if 0
            MPlug plug = fnDeformer.findPlug(aSkinClusterWeightList);
            MPlugArray plugArr;
            plug.connectedTo(plugArr, 1, 0);
            obj = plugArr[0].node();
            fnSkinCluster.setObject(obj);
#endif
        }

        MPlug bindPlug = fnSkinCluster.findPlug("bindPreMatrix");
        MPlug jtMatPlug = fnSkinCluster.findPlug("matrix");

        MFnMatrixData fnMatrix;
        for (int i = 0; i < jtMatPlug.numElements(); ++i)
        {
            if (jtMatPlug[i].logicalIndex() != bindPlug[i].logicalIndex())
            {
                MReturnFailure("Matrix and bindPreMatrix plugs in skincluster doesnt match");
            }

            fnMatrix.setObject(bindPlug[i].asMObject());
            MMatrix bindInvMat = fnMatrix.matrix();

            fnMatrix.setObject(jtMatPlug[i].asMObject());
            MMatrix jtMat = fnMatrix.matrix();

            MMatrix scMat = world * bindInvMat * jtMat * world.inverse();
            jtMatrices[jtMatPlug[i].logicalIndex()] = scMat;
        }
    }

    
    // Convert delta to skinSpace
    MArrayDataHandle wtListArrHnd = block.inputArrayValue(aSkinClusterWeightList);
    for (int i = 0; i < wtListArrHnd.elementCount(); ++i, wtListArrHnd.next())
    {
        int c = wtListArrHnd.elementIndex();

        if (deltaMap.find(c) == deltaMap.end())
            continue;

        handle = wtListArrHnd.inputValue();
        handle = handle.child(aSkinClusterWeights);
        MArrayDataHandle wtArrHnd(handle);

        MMatrix bindToSkinMat;
        for (int j = 0; j < wtArrHnd.elementCount(); ++j, wtArrHnd.next())
        {
            int jtIdx = wtArrHnd.elementIndex();
            double wt = wtArrHnd.inputValue().asDouble();
            MMatrix mat = jtMatrices[jtIdx] * wt;

            if (j)
                bindToSkinMat += mat;
            else
                bindToSkinMat = mat;
        }

        deltaMap[c] *= bindToSkinMat;
    }


    // Set the final positions
    for (itGeo.reset(); !itGeo.isDone(); itGeo.next())
    {
        int i = itGeo.index();

        if (deltaMap.find(i) != deltaMap.end())
        {
            float wt = weightValue(block, geomIndex, i);
            MPoint position = itGeo.position();
            position += deltaMap[i] * wt * env;
            itGeo.setPosition(position);
        }
    }

    return MStatus::kSuccess;
}

