#include "RelaxDeformer.h"
#include "utils.h"

#include <iostream>
#include <vector>

#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnMesh.h>
#include <maya/MItMeshVertex.h>
#include <maya/MPointArray.h>
#include <maya/MIntArray.h>


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
    aDebug = nAttr.create("debug", "d", MFnNumericData::kBoolean, 1);
    addAttribute(aDebug);
#endif

    aIterations = nAttr.create("iterations", "itr", MFnNumericData::kInt, 1);
    nAttr.setMin(0);
    nAttr.setKeyable(true);
    addAttribute(aIterations);

    aAmount = nAttr.create("amount", "amt", MFnNumericData::kFloat, 0.5);
    nAttr.setMin(0);
    nAttr.setMax(1);
    nAttr.setKeyable(true);
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

    handle = block.inputValue(envelope);
    float env = handle.asFloat();
    if (env < FLOAT_TOLERANCE)
        return MS::kSuccess;

    handle = block.inputValue(aIterations);
    int iterations = handle.asInt();

    handle = block.inputValue(aAmount);
    float amount = handle.asFloat();

    // Get mesh fn
    MArrayDataHandle arrHandle = block.inputArrayValue(input);
    arrHandle.jumpToElement(geomIndex);
    handle = arrHandle.inputValue().child(inputGeom);
    if (handle.type() != MFnData::kMesh)
        MReturnFailure(ErrorStr::RelaxInvalidInput);
    MObject obj = handle.asMesh();
    MFnMesh fnMesh(obj);

    // Get all positions
    MPointArray positions;
    fnMesh.getPoints(positions);


    // Get connected vertices
    MItMeshVertex itVtx(obj);
    std::vector<MIntArray> connectedVertices(itVtx.count());
    for (itVtx.reset(); !itVtx.isDone(); itVtx.next())
        itVtx.getConnectedVertices(connectedVertices[itVtx.index()]);

    // Find relax positions
    MPointArray newPositions = positions;
    for (int i = 0; i < iterations; ++i)
    {
        for (itVtx.reset(); !itVtx.isDone(); itVtx.next())
        {
            int index = itVtx.index();

            MPoint newPos = positions[index];
            MIntArray connectedVertices;
            itVtx.getConnectedVertices(connectedVertices);

            for (unsigned j = 0; j < connectedVertices.length(); ++j)
                newPos += positions[connectedVertices[j]];

            newPos = newPos / (connectedVertices.length()+1);

            newPositions[index] = positions[index] + (newPos-positions[index]) * amount;
        }

        positions = newPositions;
    }


    // Set the final positions
    for (itGeo.reset(); !itGeo.isDone(); itGeo.next())
    {
        int i = itGeo.index();

        float wt = weightValue(block, geomIndex, i);

        MPoint position = itGeo.position();
        position += (newPositions[i] - position) * wt * env;
        itGeo.setPosition(position);
    }


    return MStatus::kSuccess;
}

