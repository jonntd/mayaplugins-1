#include "PoseSpaceDeformer.h"
#include "utils.h"

#include <iostream>
#include <map>

#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnCompoundAttribute.h>
#include <maya/MFnTypedAttribute.h>
#include <maya/MFnMatrixAttribute.h>

typedef std::map<int, MVector>  VectorMap;
typedef std::map<int, MMatrix>  MatrixMap;


MTypeId PoseSpaceDeformer::id( PluginIDs::PoseSpaceDeformer );
const char * PoseSpaceDeformer::name( PluginNames::PoseSpaceDeformer );

MObject PoseSpaceDeformer::aDebug;

MObject PoseSpaceDeformer::aJoint;
MObject PoseSpaceDeformer::aJointRotation;
MObject PoseSpaceDeformer::aJointMatrix;

MObject PoseSpaceDeformer::aPose;
MObject PoseSpaceDeformer::aPoseName;
MObject PoseSpaceDeformer::aPoseEnvelope;
MObject PoseSpaceDeformer::aPoseJointRotations;
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
    aPoseJointRotations = nAttr.create("poseJointRotations", "pjr", MFnNumericData::k3Double);
    nAttr.setArray(true);
    aPoseComponents = tAttr.create("poseComponents", "pc", MFnData::kIntArray);
    aPoseDelta = tAttr.create("poseDelta", "pd", MFnData::kPointArray);

    aPose = cAttr.create("pose", "p");
    cAttr.setArray(true);
    cAttr.addChild(aPoseName);
    cAttr.addChild(aPoseEnvelope);
    cAttr.addChild(aPoseJointRotations);
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

    // pose-2-pose distance: For each pose, check how far is its poseJointRotations are from other poses
    // TODO : preCalculate pose-2-pose distance and coefficients in when pose is added


    // pose-2-joint distance: For each pose, check how far is poseJointRotations are from current jointRotations
    arrHnd = block.inputArrayValue(aPose);
    for (int i = 0; i < arrHnd.elementCount(); ++i, arrHnd.next())
    {

    }

    // pose-weight: Using pose distances calculate pose weights
  

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

