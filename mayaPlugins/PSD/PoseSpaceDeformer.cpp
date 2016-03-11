#include "PoseSpaceDeformer.h"
#include "utils.h"

#include <iostream>


#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnCompoundAttribute.h>
#include <maya/MFnTypedAttribute.h>
#include <maya/MFnMatrixAttribute.h>



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
    MArrayDataHandle arrHnd;
    MObject obj;

    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();

    handle = block.inputValue(envelope);
    float env = handle.asFloat();
    if (env < FLOAT_TOLERANCE)
        return MS::kSuccess;


    // Cacu
    if (_posesDirty)
    {
        _posesDirty = false;

        // Collect all pose joint rotations values
        arrHnd = block.inputArrayValue(aPose);
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
            _poses.append(jtMap);
        }

        // pose-2-pose weights: For each pose, check how far is its poseJointRotations are from other poses
        std::vector<MDoubleArray> pose2PoseWeights(_poses.size());
        for (int i = 0; i < _poses.size(); ++i)
        {
            pose2PoseWeights[i].setLength(_poses.size());

            // Same pose
            pose2PoseWeights[i][i] = 1;

            if (i+1 == poseJoints.size())
                break;

            // Other poses
            for (int j = i+1; j < _poses.size(); ++j)
            {
                double weightij = 1;
                double weightji = 1;
                for (VectorMap::const_iterator iter1 = _poses[i].begin(); iter1 != _poses[i].end(); ++iter1)
                {
                    // If joint in pose[i] matches pose[j], calc distance, else return distance as -1
                    int jtIdx = iter1.first;
                    VectorMap::const_iterator iter2 = _poses[j].find(jtIdx);
                    if (iter2 == poseJoints[j].end())
                    {
                        weightij = -1;
                        weightji = -1;
                        break;
                    }
                    else
                    {
                        // PoseJoint of ith pose
                        MVector rot1 = iter1.second.rotation;
                        float fallOff1 = iter1.second.fallOff;

                        // PoseJoint of jth pose
                        MVector rot2 = iter2.second.rotation;
                        float fallOff2 = iter2.second.fallOff;

                        // Distance between poseJoint
                        float angle = jtRot1.angle(jtRot2);
                        
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
    arrHnd = block.inputArrayValue(aJoint);
    for (int i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
    {
        int jtIdx = arrHnd.elementIndex();
        MDataHandle jtHnd = arrHnd.inputValue();

        handle = jtHnd.child(aJointRotation);
        double3& data = handle.asDouble3();
        MVector rot(data[0], data[1], data[2]);

        currJointRot[jtIdx] = rot;
    }


    // pose-2-currJoints weights: For each pose, check how far is poseJointRotations are from current jointRotations
    MDoubleArray pose2CurrJoints(_poses.size());
    for (int i = 0; i < _poses.size(); ++i)
    {
        double weight = 1;
        for (PoseJointMap::const_iterator iter = _poses[i].begin(); iter != _poses[i].end(); ++iter)
        {
            int jtIdx = iter.first;
            const PoseJoint& poseJt = iter.second;

            // TODO: Get current joint's rotation and get distance between that and poseJt.rotation and fallOff dist
            double angle = currJointRot[jtIdx].angle(poseJt.rotation);
            if (angle < poseJt.fallOff)
                weight *= angle / poseJt.fallOff;
            else
                weight = 0;
        }

        pose2CurrJointsWeights[i] = weight;
    }


    // Calculate final weights for each pose, from pose-2-currJoint weights re-weighted by pose2PoseWeights
    MDoubleArray poseWeights(_poses.size());
    for (int i = 0; i < _poses.size(); ++i)
    {
        double weight = 0;
        for (int j = 0; j < _poses.size(); ++j)
        {
            weight += _pose2PoseWeights[i][j] * pose2CurrJoints[j];
        }
        poseWeights[i] = weight;
    }


    // Get delta from weighted poses
    arrHnd = block.inputArrayValue(aPose);
    VectorMap deltaMap;
    for(int i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
    {
        int poseIndex = arrHnd.elementIndex();
        MDataHandle poseHnd = arrHnd.inputValue();

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
            MFnDependencyNode fnDeformer(thisMObect());
            MPlug plug = fnDeformer.findPlug("input[0].inputGeom");

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
    arrHnd = block.inputArrayValue(aSkinClusterWeightList);
    for (int i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
    {
        int c = arrHnd.elementIndex();

        if (deltaMap.find(c) == deltaMap.end())
            continue;

        handle = arrHnd.inputValue();
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
    for (itGeo.reset(); !itGeom.isDone(); itGeo.next())
    {
        int i = itGeo.index();

        if (deltaMap.find(i) != deltaMap.end())
        {
            float wt = weightValue(block, geomIndex, i);
            itGeo.setPosition(itGeo.position() + deltaMap[i] * wt * env);
        }
    }

    return MStatus::kSuccess;
}

