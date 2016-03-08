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

    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();

    handle = block.inputValue(envelope);
    float env = handle.asFloat();

    // pose-2-pose distance: For each pose, check how far is its poseJointRotations are from other poses

    // pose-2-joint distance: For each pose, check how far is poseJointRotations are from current jointRotations

    // pose-weight: Using pose distances calculate pose weights

    // poseGeometry: If pose's weight is > 0.0001, then calculate poseGeometry in current pose using poseDelta (in bindSpace) and current joint matrices and skinClusterWeights

    // outputGeom: Calculate affected vertex's delta and multiply with envelope and paintWeights

    return MStatus::kSuccess;
}

