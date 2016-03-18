#include "RelaxDeformer.h"
#include "utils.h"

#include <iostream>

#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>



MTypeId RelaxDeformer::id( PluginIDs::RelaxDeformer );
const char * RelaxDeformer::name( PluginNames::RelaxDeformer );

#ifdef _DEBUG
MObject RelaxDeformer::aDebug;
#endif

MObject RelaxDeformer::aIterations;
MObject RelaxDeformer::aAmount;


void* RelaxDeformer::creator()
{
    return new RelaxDeformer;
}

MStatus RelaxDeformer::initialize()
{
    MStatus stat;

    MFnNumericAttribute nAttr;

#ifdef _DEBUG
    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean);
    addAttribute(aDebug);
#endif

    aIterations = nAttr.create("iterations", "itr", MFnNumericData::kInt, 1);
    nAttr.setMin(1);
    nAttr.setChannelBox(true);
    addAttribute(aIterations);

    aAmount = nAttr.create("amount", "amt", MFnNumericData::kFloat, 1);
    nAttr.setChannelBox(true);
    addAttribute(aAmount);

    attributeAffects(aIterations, outputGeom);
    attributeAffects(aAmount, outputGeom);

    return MStatus::kSuccess;

}


MStatus RelaxDeformer::deform(  MDataBlock&     block, 
                                MItGeometry&    itGeo, 
                                const MMatrix&  world, 
                                unsigned int    geomIndex )
{
    MStatus stat;
    MString msg;
    MDataHandle handle;

#ifdef _DEBUG
    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();
#endif

    return MStatus::kSuccess;
}

