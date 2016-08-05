#include "PoseSpaceDeformer.h"
#include "utils.h"

#include <iostream>

#ifdef USEMKL
#include "mkl_types.h"
#include "mkl_lapack.h"
#elif USEEIGEN
#include <Eigen/Dense>
using namespace Eigen;
#endif

#include <maya/MGlobal.h>
#include <maya/MPoint.h>
#include <maya/MMatrix.h>
#include <maya/MEulerRotation.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnCompoundAttribute.h>
#include <maya/MFnTypedAttribute.h>
#include <maya/MFnMatrixAttribute.h>
#include <maya/MFnUnitAttribute.h>
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

#ifdef _DEBUG
MObject PoseSpaceDeformer::aDebug;
#endif

MObject PoseSpaceDeformer::aJoint;
MObject PoseSpaceDeformer::aJointRot;
MObject PoseSpaceDeformer::aJointRotX;
MObject PoseSpaceDeformer::aJointRotY;
MObject PoseSpaceDeformer::aJointRotZ;

MObject PoseSpaceDeformer::aPose;
MObject PoseSpaceDeformer::aPoseName;
MObject PoseSpaceDeformer::aPoseEnvelope;
MObject PoseSpaceDeformer::aPoseWeight;
MObject PoseSpaceDeformer::aPoseJoint;
MObject PoseSpaceDeformer::aPoseJointRot;
MObject PoseSpaceDeformer::aPoseJointRotX;
MObject PoseSpaceDeformer::aPoseJointRotY;
MObject PoseSpaceDeformer::aPoseJointRotZ;
MObject PoseSpaceDeformer::aPoseJointFallOff;
MObject PoseSpaceDeformer::aPoseTarget;
MObject PoseSpaceDeformer::aPoseTargetName;
MObject PoseSpaceDeformer::aPoseTargetEnvelope;
MObject PoseSpaceDeformer::aPoseTargetComponents;
MObject PoseSpaceDeformer::aPoseTargetDelta;

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
    MFnUnitAttribute uAttr;


#ifdef _DEBUG
    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean, true);
    addAttribute(aDebug);
#endif

    aJointRotX = uAttr.create("jointRotX", "jrx", MFnUnitAttribute::kAngle);
    aJointRotY = uAttr.create("jointRotY", "jry", MFnUnitAttribute::kAngle);
    aJointRotZ = uAttr.create("jointRotZ", "jrz", MFnUnitAttribute::kAngle);
    aJointRot = nAttr.create("jointRot", "jr", aJointRotX, aJointRotY, aJointRotZ);

    aJoint = cAttr.create("joint", "j");
    cAttr.setHidden(true);
    cAttr.setArray(true);
    cAttr.addChild(aJointRot);
    addAttribute(aJoint);

    aPoseName = tAttr.create("poseName", "pn", MFnData::kString);

    aPoseEnvelope = nAttr.create("poseEnvelope", "pe", MFnNumericData::kFloat, 1.f);
    nAttr.setKeyable(true);

    aPoseWeight = nAttr.create("poseWeight", "pw", MFnNumericData::kFloat, 0.f);

    aPoseJointRotX = uAttr.create("poseJointRotX", "pjrx", MFnUnitAttribute::kAngle);
    aPoseJointRotY = uAttr.create("poseJointRotY", "pjry", MFnUnitAttribute::kAngle);
    aPoseJointRotZ = uAttr.create("poseJointRotZ", "pjrz", MFnUnitAttribute::kAngle);
    aPoseJointRot = nAttr.create("poseJointRot", "pjr", aPoseJointRotX, aPoseJointRotY, aPoseJointRotZ);
    aPoseJointFallOff = nAttr.create("poseJointFallOff", "pjf", MFnNumericData::kFloat, 45.f);
    aPoseJoint = cAttr.create("poseJoint", "pj");
    cAttr.setHidden(true);
    cAttr.setArray(true);
    cAttr.addChild(aPoseJointRot);
    cAttr.addChild(aPoseJointFallOff);

    aPoseTargetName = tAttr.create("poseTargetName", "ptn", MFnData::kString);
    aPoseTargetEnvelope = nAttr.create("poseTargetEnvelope", "pte", MFnNumericData::kFloat, 1.f);
    nAttr.setKeyable(true);
    aPoseTargetComponents = tAttr.create("poseTargetComponents", "ptc", MFnData::kIntArray);
    tAttr.setHidden(true);
    aPoseTargetDelta = tAttr.create("poseTargetDelta", "ptd", MFnData::kVectorArray);
    tAttr.setHidden(true);
    aPoseTarget = cAttr.create("poseTarget", "pt");
    cAttr.setArray(true);
    cAttr.addChild(aPoseTargetName);
    cAttr.addChild(aPoseTargetEnvelope);
    cAttr.addChild(aPoseTargetComponents);
    cAttr.addChild(aPoseTargetDelta);

    aPose = cAttr.create("pose", "p");
    cAttr.setArray(true);
    cAttr.addChild(aPoseName);
    cAttr.addChild(aPoseEnvelope);
    cAttr.addChild(aPoseWeight);
    cAttr.addChild(aPoseJoint);
    cAttr.addChild(aPoseTarget);
    addAttribute(aPose);

    aSkinClusterWeights = nAttr.create("skinClusterWeights", "scw", MFnNumericData::kDouble);
    nAttr.setArray(true);
    nAttr.setHidden(true);

    aSkinClusterWeightList = cAttr.create("skinClusterWeightList", "scwl");
    cAttr.setArray(true);
    cAttr.addChild(aSkinClusterWeights);
    cAttr.setHidden(true);
    addAttribute(aSkinClusterWeightList);


    attributeAffects(aJoint, outputGeom);
    attributeAffects(aPose, outputGeom);
    attributeAffects(aSkinClusterWeightList, outputGeom);

    attributeAffects(aJoint, aPoseWeight);
    attributeAffects(aPoseJoint, aPoseWeight);

    return MStatus::kSuccess;

}


MStatus PoseSpaceDeformer::setDependentsDirty(  const MPlug& plugBeingDirtied, 
                                                MPlugArray& affectedPlugs )
{
#ifdef _DEBUG
    MDebugPrint(plugBeingDirtied.name());
#endif

    if (plugBeingDirtied == aPose ||
        plugBeingDirtied == aPoseJoint ||
        plugBeingDirtied == aPoseJointRot ||
        plugBeingDirtied == aPoseJointRotX ||
        plugBeingDirtied == aPoseJointRotY ||
        plugBeingDirtied == aPoseJointRotZ ||        
        plugBeingDirtied == aPoseJointFallOff )
        _posesDirty = true;

    return MPxDeformerNode::setDependentsDirty(plugBeingDirtied, affectedPlugs);
}

MStatus PoseSpaceDeformer::compute(const MPlug& plug, MDataBlock& block)
{
    MStatus stat = calcPoseWeights(block);
    MCheckStatus(stat, "");

    return MPxDeformerNode::compute(plug, block);
}


MStatus PoseSpaceDeformer::calcPoseWeights( MDataBlock& block )
{
    MStatus stat;
    MString msg;
    MDataHandle handle;
    MObject obj;

#ifdef _DEBUG
    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();
#endif

    // If poses are dirty, recalculate pose2Pose weights
    if (_posesDirty)
    {
        _posesDirty = false;

        // Collect all pose joint rotations values
        _poses.clear();
        MArrayDataHandle arrHnd = block.inputArrayValue(aPose);
        for (unsigned i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
        {
            handle = arrHnd.inputValue();
            handle = handle.child(aPoseJoint);
            MArrayDataHandle jtArrHnd(handle);

            PoseJointMap jtMap;
            for (unsigned j = 0; j < jtArrHnd.elementCount(); ++j, jtArrHnd.next())
            {
                handle = jtArrHnd.inputValue();
                handle = handle.child(aPoseJointRot);
                double3& data = handle.asDouble3();
                MVector rot(RAD2DEG(data[0]), RAD2DEG(data[1]), RAD2DEG(data[2]));

                handle = jtArrHnd.inputValue();
                handle = handle.child(aPoseJointFallOff);
                float fallOff = handle.asFloat();

                jtMap[jtArrHnd.elementIndex()] = PoseJoint(rot, fallOff);

#ifdef _DEBUG
                if (debug)
                {
                    MString msg = "Collect posesJts: pose: ";
                    msg += i;
                    msg += ", joint: ";
                    msg += jtArrHnd.elementIndex();
                    msg += ", rot: ";
                    msg += MVector2Str(rot);
                    msg += ", fallOff: ";
                    msg += fallOff;
                    MDebugPrint(msg);
                }
#endif
            }

            _poses.push_back(jtMap);
        }

        // pose-2-pose weights: For each pose, check how far is its poseJointRotations are from other poses
        if (_poses.size() == 0)
            return MS::kSuccess;


        _pose2PoseWeights.clear();
        _pose2PoseWeights.resize(_poses.size());
        for (unsigned i = 0; i < _poses.size(); ++i)
        {
            _pose2PoseWeights[i].setLength((unsigned)_poses.size());

            // Same pose
            _pose2PoseWeights[i][i] = 1;

#ifdef _DEBUG
            if (debug)
            {
                MString msg = "Pose2PoseWts: posei: ";
                msg += i;
                MDebugPrint(msg);
            }
#endif

            if (i+1 == _poses.size())
                break;

            // Other poses
            for (unsigned j = i+1; j < _poses.size(); ++j)
            {
                _pose2PoseWeights[j].setLength((unsigned)_poses.size());

#ifdef _DEBUG
                if (debug)
                {
                    MString msg = "Pose2PoseWts: posei: ";
                    msg += i;
                    msg += ", posej: ";
                    msg += j;
                    MDebugPrint(msg);
                }
#endif
                double weightij = 1;
                double weightji = 1;
                for (PoseJointMap::const_iterator iter1 = _poses[i].begin(); iter1 != _poses[i].end(); ++iter1)
                {
                    // If joint in pose[i] matches pose[j], calc distance, else return distance as -1
                    int jtIdx = iter1->first;
                    PoseJointMap::const_iterator iter2 = _poses[j].find(jtIdx);

                    if (iter2 == _poses[j].end())
                    {
                        // Distance cannot be found between poses because of different poseJoints between them
                        weightij = 0;
                        weightji = 0;
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
                        double dist = (rot1 - rot2).length();

#ifdef _DEBUG
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
#endif
                        // Accumulate pose weight using weight of this joint (dist/fallOff)
                        if (dist < fallOff2)
                            weightij *= 1 - dist / fallOff2;
                        else
                            weightij = 0;

                        if (dist < fallOff1)
                            weightji *= 1 - dist / fallOff1;
                        else
                            weightji = 0;
                    }
                }


#ifdef _DEBUG
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
#endif
                _pose2PoseWeights[i][j] = weightij;
                _pose2PoseWeights[j][i] = weightji;
            }
        }

#ifdef _DEBUG
        if (debug)
        {
            char buf[1024] = "";
            MDebugPrint("Pose2PoseWts:================");
            for (unsigned i = 0; i < _pose2PoseWeights.size(); ++i)
                SPRINTF(buf, "%s%8d", buf, i);
            MDebugPrint(buf);
            for (unsigned i = 0; i < _pose2PoseWeights.size(); ++i)
            {
                SPRINTF(buf, "%2d", i);
                for (unsigned j = 0; j < _pose2PoseWeights.size(); ++j)
                    SPRINTF(buf, "%s%8.3f", buf, _pose2PoseWeights[i][j]);
                MDebugPrint(buf);
            }
            MDebugPrint("=============================");
        }
#endif

        // Re-weight pose2PoseWeights using Scattered Data Interpolation (solve Ax = B)
        {
            unsigned n = (unsigned)_pose2PoseWeights.size();

            MatrixXf a(n, n);
            MatrixXf b(n, n);
            for (unsigned i = 0; i < n; ++i)
                for (unsigned j = 0; j < n; ++j)
                {
                    a(i, j) = (float)_pose2PoseWeights[i][j];
                    b(i, j) = i == j;
                }

            cerr << "Num poses:\n" << n << endl;
            cerr << "Here is the matrix a:\n" << a << endl;
            cerr << "Here is the right hand side b:\n" << b << endl;

            MatrixXf x = a.colPivHouseholderQr().solve(b);

            cerr << "The solution is:\n" << x << endl;


            for (unsigned i = 0; i < n; ++i)
                for (unsigned j = 0; j < n; ++j)
                    _pose2PoseWeights[i][j] = x(i, j);
        }



#ifdef _DEBUG
        if (debug)
        {
            char buf[1024] = "";
            MDebugPrint("Pose2PoseWts:================");
            for (unsigned i = 0; i < _pose2PoseWeights.size(); ++i)
                SPRINTF(buf, "%s%8d", buf, i);
            MDebugPrint(buf);
            for (unsigned i = 0; i < _pose2PoseWeights.size(); ++i)
            {
                SPRINTF(buf, "%2d", i);
                for (unsigned j = 0; j < _pose2PoseWeights.size(); ++j)
                    SPRINTF(buf, "%s%8.3f", buf, _pose2PoseWeights[i][j]);
                MDebugPrint(buf);
            }
            MDebugPrint("=============================");
        }
#endif
    }

    _poseWeights.setLength((unsigned)_poses.size());

    // No poses, return
    if (_poses.size() == 0)
        return MS::kSuccess;

    // Get current joint rotations
    VectorMap currJointRot;
    MArrayDataHandle jtArrHnd = block.inputArrayValue(aJoint);
    for (unsigned i = 0; i < jtArrHnd.elementCount(); ++i, jtArrHnd.next())
    {
        int jtIdx = jtArrHnd.elementIndex();
        MDataHandle jtHnd = jtArrHnd.inputValue();

        handle = jtHnd.child(aJointRot);
        double3& data = handle.asDouble3();
        MVector rot(RAD2DEG(data[0]), RAD2DEG(data[1]), RAD2DEG(data[2]));

        currJointRot[jtIdx] = rot;

#ifdef _DEBUG
        if (debug)
        {
            MString msg = "CurJoints: jtIdx: ";
            msg += jtIdx;
            MDebugPrint(msg);
        }
#endif
    }


    // pose-2-currJoints weights: For each pose, check how far is poseJointRotations are from current jointRotations
    MDoubleArray pose2CurrJointWeights((unsigned)_poses.size());
    for (unsigned i = 0; i < _poses.size(); ++i)
    {
        double weight = 1;
        for (PoseJointMap::const_iterator iter = _poses[i].begin(); iter != _poses[i].end(); ++iter)
        {
            int jtIdx = iter->first;
            const PoseJoint& poseJt = iter->second;

            // TODO: Get current joint's rotation and get distance between that and poseJt.rotation and fallOff dist
            double dist = (currJointRot[jtIdx] - poseJt.rotation).length();

#ifdef _DEBUG
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
#endif
            if (dist < poseJt.fallOff)
            {
                double jtWeight = 1 - (dist / poseJt.fallOff);
                weight *= jtWeight;

#ifdef _DEBUG                
                if (debug)
                {
                    MString msg = "Pose2CurrJointWts: pose: ";
                    msg += i;
                    msg += ", joint: ";
                    msg += jtIdx;
                    msg += ", jtWeight: ";
                    msg += jtWeight;                    
                    msg += ", weight: ";
                    msg += weight;
                    MDebugPrint(msg);
                }
#endif
            }
            else
            {
                weight = 0;
                break;
            }
        }

#ifdef _DEBUG
        if (debug)
        {
            MString msg = "Pose2CurrJointWts: pose: ";
            msg += i;
            msg += ", weight: ";
            msg += weight;
            MDebugPrint(msg);
        }
#endif

        pose2CurrJointWeights[i] = weight;
    }


    // Calculate final weights for each pose, from pose-2-currJoint weights re-weighted by pose2PoseWeights    
    for (unsigned i = 0; i < _poses.size(); ++i)
    {
        double weight = 0;
        for (unsigned j = 0; j < _poses.size(); ++j)
        {
            double wt = pose2CurrJointWeights[j] * _pose2PoseWeights[j][i];

#ifdef _DEBUG
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
#endif
            weight += wt;
        }

        if ( weight < 0 )
            weight = 0;

#ifdef _DEBUG
        if (debug)
        {
            MString msg = "FinalPoseWts: posei: ";
            msg += i;
            msg += ", weight: ";
            msg += weight;
            MDebugPrint(msg);
        }
#endif
        _poseWeights[i] = weight;
    }


    // Save final pose weights in plug
    MArrayDataHandle poseArrHnd = block.outputArrayValue(aPose);
    for(unsigned i = 0; i < poseArrHnd.elementCount(); ++i, poseArrHnd.next())
    {
        MDataHandle poseHnd = poseArrHnd.outputValue();
        MDataHandle wtHnd = poseHnd.child(aPoseWeight);

        wtHnd.setFloat((float)_poseWeights[i]);
        wtHnd.setClean();
    }

    return MS::kSuccess;
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

#ifdef _DEBUG
    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();
#endif

    handle = block.inputValue(envelope);
    float env = handle.asFloat();
    if (env < FLOAT_TOLERANCE)
        return MS::kSuccess;



    MArrayDataHandle poseArrHnd = block.inputArrayValue(aPose);

#ifdef _DEBUG
        if (debug)
        {
            msg += "NumPoses: ";
            msg += poseArrHnd.elementCount();
            msg += ", NumWeights: ";
            msg += _poseWeights.length();
            MDebugPrint(msg);
        }
#endif

    VectorMap deltaMap;
    for(unsigned i = 0; i < poseArrHnd.elementCount(); ++i, poseArrHnd.next())
    {
        int poseIndex = poseArrHnd.elementIndex();
        MDataHandle poseHnd = poseArrHnd.inputValue();

        handle = poseHnd.child(aPoseEnvelope);
        float poseEnv = handle.asFloat();

        if (i >= _poseWeights.length() || _poseWeights[i] < FLOAT_TOLERANCE || fabs(poseEnv) < FLOAT_TOLERANCE)
            continue;

#ifdef _DEBUG
        if (debug)
        {
            MString msg = "Posei: ";
            msg += i;
            msg += ", weight: ";
            msg += _poseWeights[i];
            MDebugPrint(msg);
        }
#endif

        MArrayDataHandle poseTargetArrHnd(poseHnd.child(aPoseTarget));
        for(unsigned j = 0; j < poseTargetArrHnd.elementCount(); ++j, poseTargetArrHnd.next())
        {
            MDataHandle poseTargetHnd = poseTargetArrHnd.inputValue();

            handle = poseTargetHnd.child(aPoseTargetEnvelope);
            float targetEnv = handle.asFloat();

            double poseWt = poseEnv * targetEnv * _poseWeights[i];

            handle = poseTargetHnd.child(aPoseTargetComponents);
            obj = handle.data();
            MFnIntArrayData fnIntArrData(obj);
            MIntArray components = fnIntArrData.array();

            handle = poseTargetHnd.child(aPoseTargetDelta);
            obj = handle.data();
            MFnVectorArrayData fnVectorArrData(obj);
            MVectorArray delta = fnVectorArrData.array();

#ifdef _DEBUG
            if (debug)
            {
                MString msg = "components: ";
                msg += components.length();
                msg += ", delta: ";
                msg += delta.length();
                MDebugPrint(msg);
        }
#endif
            for(unsigned j = 0; j < components.length(); ++j)
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
        for (unsigned i = 0; i < jtMatPlug.numElements(); ++i)
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
    for (unsigned i = 0; i < wtListArrHnd.elementCount(); ++i, wtListArrHnd.next())
    {
        int c = wtListArrHnd.elementIndex();

        if (deltaMap.find(c) == deltaMap.end())
            continue;

        handle = wtListArrHnd.inputValue();
        handle = handle.child(aSkinClusterWeights);
        MArrayDataHandle wtArrHnd(handle);

        MMatrix bindToSkinMat;
        for (unsigned j = 0; j < wtArrHnd.elementCount(); ++j, wtArrHnd.next())
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

