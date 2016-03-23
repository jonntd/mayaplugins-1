#include "RelaxDeformer.h"
#include "utils.h"

#include <iostream>

#include <maya/MGlobal.h>
#include <maya/MFnNumericAttribute.h>
#include <maya/MFnMesh.h>
#include <maya/MItMeshVertex.h>


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

    handle = block.inputValue(aIterations);
    int iterations = handle.asInt();

    handle = block.inputValue(aAmount);
    float amount = handle.asFloat();

    // Get all positions
    MObject obj = inputShapeAtIndex(geomIndex);
    MFnMesh fnMesh(obj);
    MPointArray positions;
    fnMesh.getPoints(positions);

    // Get connected vertices
    std::vector<MIntArray> connectedVertices;
    MItMeshVertex itVtx(obj);
    int prevIdx;
    for (itVtx.reset(); !itVtx.isDone(); itVtx.next())
        itVtx.getConnectedVertices(connectedVertices[i]);

    // Find relax positions
    MPointArray newPositions = positions;
    for (int i = 0; i < iterations; ++i)
    {
        for (itVtx.reset(); !itVtx.isDone(); itVtx.next())
        {
            MPoint newPos;
            MIntArray connectedVertices;
            itVtx.getConnectedVertices(connectedVertices);
            for (int j = 0; j < connectedVertices.length(); ++j)
                newPos += positions[connectedVertices[j]];

            int index = itVtx.index();
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

