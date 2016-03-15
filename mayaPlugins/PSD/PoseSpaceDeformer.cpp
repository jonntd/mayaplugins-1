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

#define DEG2RAD(angle)     angle * 3.141592653589793 / 180.0
#define RAD2DEG(angle)     angle * 180.0 / 3.141592653589793


MTypeId PoseSpaceDeformer::id( PluginIDs::PoseSpaceDeformer );
const char * PoseSpaceDeformer::name( PluginNames::PoseSpaceDeformer );

MObject PoseSpaceDeformer::aDebug;

MObject PoseSpaceDeformer::aJoint;
MObject PoseSpaceDeformer::aJointRotation;
MObject PoseSpaceDeformer::aJointMatrix;

MObject PoseSpaceDeformer::aPose;
MObject PoseSpaceDeformer::aPoseName;
MObject PoseSpaceDeformer::aPoseJoint;
MObject PoseSpaceDeformer::aPoseJointRotation;
MObject PoseSpaceDeformer::aPoseJointFallOff;
MObject PoseSpaceDeformer::aPoseTarget;
MObject PoseSpaceDeformer::aPoseEnvelope;
MObject PoseSpaceDeformer::aPoseComponents;
MObject PoseSpaceDeformer::aPoseDelta;

MObject PoseSpaceDeformer::aSkinClusterWeightList;
MObject PoseSpaceDeformer::aSkinClusterWeights;

PoseSpaceDeformer::PoseSpaceDeformer()
{
    _posesDirty = true;
}

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

    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean, true);
    addAttribute(aDebug);

    aJointRotation = nAttr.create("jointRotation", "jr", MFnNumericData::k3Double);
    aJointMatrix = mAttr.create("jointMatrix", "jm");

    aJoint = cAttr.create("joint", "j");
    cAttr.setArray(true);
    cAttr.addChild(aJointRotation);
    cAttr.addChild(aJointMatrix);
    addAttribute(aJoint);

    aPoseName = tAttr.create("poseName", "pn", MFnData::kString);

    aPoseJointRotation = nAttr.create("poseJointRotation", "pjr", MFnNumericData::k3Double);
    aPoseJointFallOff = nAttr.create("poseJointFallOff", "pjf", MFnNumericData::kFloat, 90.f);
    aPoseJoint = cAttr.create("poseJoint", "pj");
    cAttr.setArray(true);
    cAttr.addChild(aPoseJointRotation);
    cAttr.addChild(aPoseJointFallOff);

    aPoseEnvelope = nAttr.create("poseEnvelope", "pte", MFnNumericData::kFloat, 1.f);
    aPoseComponents = tAttr.create("poseComponents", "ptc", MFnData::kIntArray);
    aPoseDelta = tAttr.create("poseDelta", "ptd", MFnData::kPointArray);
    aPoseTarget = cAttr.create("poseTarget", "pt");
    cAttr.setArray(true);
    cAttr.addChild(aPoseEnvelope);
    cAttr.addChild(aPoseComponents);
    cAttr.addChild(aPoseDelta);

    aPose = cAttr.create("pose", "p");
    cAttr.setArray(true);
    cAttr.addChild(aPoseName);
    cAttr.addChild(aPoseEnvelope);
    cAttr.addChild(aPoseJoint);
    cAttr.addChild(aPoseTarget);
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


MStatus PoseSpaceDeformer::setDependentsDirty(  const MPlug& plugBeingDirtied, 
                                                MPlugArray& affectedPlugs )
{
    MDebugPrint(plugBeingDirtied.name());

    if (plugBeingDirtied == aPose ||
        plugBeingDirtied == aPoseJoint ||
        plugBeingDirtied == aPoseJointRotation ||
        plugBeingDirtied == aPoseJointFallOff )
        _posesDirty = true;
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
            handle = handle.child(aPoseJoint);
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

                if (debug)
                {
                    MString msg = "Collect posesJts: pose: ";
                    msg += i;
                    msg += ", joint: ";
                    msg += j;
                    msg += ", rot: ";
                    msg += MVector2Str(rot);
                    msg += ", fallOff: ";
                    msg += fallOff;
                    MDebugPrint(msg);
                }
            }

            _poses.push_back(jtMap);
        }

        // pose-2-pose weights: For each pose, check how far is its poseJointRotations are from other poses
        _pose2PoseWeights.resize(_poses.size());
        for (int i = 0; i < _poses.size(); ++i)
        {
            _pose2PoseWeights[i].setLength(_poses.size());

            // Same pose
            _pose2PoseWeights[i][i] = 1;

            if (debug)
            {
                MString msg = "Pose2PoseWts: posei: ";
                msg += i;
                MDebugPrint(msg);
            }

            if (i+1 == _poses.size())
                break;

            // Other poses
            for (int j = i+1; j < _poses.size(); ++j)
            {
                if (debug)
                {
                    MString msg = "Pose2PoseWts: posei: ";
                    msg += i;
                    msg += ", posej: ";
                    msg += j;
                    MDebugPrint(msg);
                }

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
                        float dist = (rot1 - rot2).length();

                        if (debug)
                        {
                            MString msg = "Pose2PoseWts: posei: ";
                            msg += i;
                            msg += ", posej: ";
                            msg += j;
                            msg += ", jtIdx: ";
                            msg += jtIdx;
                            msg += ", rot1: ";
                            msg += MVector2Str(rot1);
                            msg += ", fallOff1: ";
                            msg += fallOff1;
                            msg += ", rot2: ";
                            msg += MVector2Str(rot2);
                            msg += ", fallOff2: ";
                            msg += fallOff2;
                            msg += ", dist: ";
                            msg += dist;
                            MDebugPrint(msg);
                        }                        

                        // Accumulate pose weight using weight of this joint (dist/fallOff)
                        if (dist < fallOff2)
                            weightij *= dist / fallOff2;
                        else
                            weightij = 0;

                        if (dist < fallOff1)
                            weightji *= dist / fallOff1;
                        else
                            weightji = 0;

                    }
                }

                // If distance cannot be found between poses because of differnt poseJoint, weight them 1
                if (weightij < 0)
                {
                    weightij = 1;
                    weightji = 1;
                }

                if (debug)
                {
                    MString msg = "Pose2PoseWts: posei: ";
                    msg += i;
                    msg += ", posej: ";
                    msg += j;
                    msg += ", weightij: ";
                    msg += weightij;
                    msg += ", weightji: ";
                    msg += weightji;
                    MDebugPrint(msg);
                }

                _pose2PoseWeights[i][j] = weightij;
                _pose2PoseWeights[j][i] = weightji;
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
        MVector rot(DEG2RAD(data[0]), DEG2RAD(data[1]), DEG2RAD(data[2]));

        currJointRot[jtIdx] = rot;

        if (debug)
        {
            MString msg = "CurJoints: jtIdx: ";
            msg += jtIdx;
            MDebugPrint(msg);
        }
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
            double dist = (currJointRot[jtIdx] - poseJt.rotation).length();

            if (debug)
            {
                MString msg = "Pose2CurrJointWts: pose: ";
                msg += i;
                msg += ", joint: ";
                msg += jtIdx;

                msg += ", currRot: ";
                msg += MVector2Str(currJointRot[jtIdx]);
                msg += ", poseRot: ";
                msg += MVector2Str(poseJt.rotation);
                msg += ", fallOff: ";
                msg += poseJt.fallOff;

                msg += ", dist: ";
                msg += dist;
                msg += ", fallOff: ";
                msg += poseJt.fallOff;
                MDebugPrint(msg);
            }

            if (dist < poseJt.fallOff)
            {
                weight *= 1 - (dist / poseJt.fallOff);
                if (debug)
                {
                    MString msg = "Pose2CurrJointWts: pose: ";
                    msg += i;
                    msg += ", joint: ";
                    msg += jtIdx;
                    msg += ", weight: ";
                    msg += weight;
                    MDebugPrint(msg);
                }
            }
            else
            {
                weight = 0;
                break;
            }
        }

        if (debug)
        {
            MString msg = "Pose2CurrJointWts: pose: ";
            msg += i;
            msg += ", weight: ";
            msg += weight;
            MDebugPrint(msg);
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
            double wt = _pose2PoseWeights[i][j] * pose2CurrJointWeights[j];

            if (debug)
            {
                MString msg = "FinalPoseWts: posei: ";
                msg += i;
                msg += ", posej: ";
                msg += j;
                msg += ", weight: ";
                msg += wt;
                MDebugPrint(msg);
            }

            weight += wt;
        }

        if (debug)
        {
            MString msg = "FinalPoseWts: posei: ";
            msg += i;
            msg += ", weight: ";
            msg += weight;
            MDebugPrint(msg);
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

        if (poseWeights[i] < FLOAT_TOLERANCE)
            continue;

        MArrayDataHandle poseTargetArrHnd(poseHnd.child(aPoseTarget));
        for(int j = 0; j < poseTargetArrHnd.elementCount(); ++j, poseTargetArrHnd.next())
        {
            MDataHandle poseTargetHnd = poseTargetArrHnd.inputValue();

            handle = poseTargetHnd.child(aPoseEnvelope);
            float poseEnv = handle.asFloat();

            double poseWt = poseEnv * poseWeights[i];

            handle = poseTargetHnd.child(aPoseComponents);
            obj = handle.data();
            MFnIntArrayData fnIntArrData(obj);
            MIntArray components = fnIntArrData.array();

            handle = poseTargetHnd.child(aPoseDelta);
            obj = handle.data();
            MFnVectorArrayData fnVectorArrData(obj);
            MVectorArray delta = fnVectorArrData.array();

            for(int j = 0; j < components.length(); ++j)
                deltaMap[components[j]] += delta[j] * poseWt;
        }
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

