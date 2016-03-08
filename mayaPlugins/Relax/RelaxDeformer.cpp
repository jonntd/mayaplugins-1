#include "RelaxDeformer.h"
#include "utils.h"

#include <iostream>

#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>



MTypeId RelaxDeformer::id( PluginIDs::RelaxDeformer );
const char * RelaxDeformer::name( PluginNames::RelaxDeformer );

MObject RelaxDeformer::aDebug;


void* RelaxDeformer::creator()
{
    return new RelaxDeformer;
}

MStatus RelaxDeformer::initialize()
{
    MStatus stat;

    MFnNumericAttribute nAttr;

    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean);
    addAttribute(aDebug);

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

    handle = block.inputValue(aDebug);
    bool debug = handle.asBool();

    handle = block.inputValue(envelope);
    float env = handle.asFloat();


    return MStatus::kSuccess;
}

