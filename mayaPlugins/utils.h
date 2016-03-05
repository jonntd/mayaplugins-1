#include <maya/MFnPlugin.h>
#include <maya/MGlobal.h>
#include <maya/MStatus.h>

#include "PSD/PoseSpaceDeformer.h"
#include "Relax/RelaxDeformer.h"


MStatus initializePlugin( MObject obj )
{
    MStatus result;
    MFnPlugin plugin( obj, "YOUR COMPANY", "1.0", "Any" );

    result = plugin.registerNode(
                      PoseSpaceDeformer::name, 
                      PoseSpaceDeformer::id, 
                      PoseSpaceDeformer::creator, 
                      PoseSpaceDeformer::initialize);
    if (!result)
        result.perror("Register PoseSpaceDeformer node failed.");

    result = plugin.registerNode(
                      RelaxDeformer::name, 
                      RelaxDeformer::id, 
                      RelaxDeformer::creator, 
                      RelaxDeformer::initialize);
    if (!result)
        result.perror("Register RelaxDeformer node failed.");

    return result;
}

MStatus uninitializePlugin( MObject obj)
{
    MStatus result;
    MFnPlugin plugin( obj );

    result = plugin.deregisterNode( PoseSpaceDeformer::id );
    if (!result)
        result.perror("Deregister PoseSpaceDeformer node failed.");

    result = plugin.deregisterNode( RelaxDeformer::id );
    if (!result)
        result.perror("Deregister RelaxDeformer node failed.");

    return result;
}