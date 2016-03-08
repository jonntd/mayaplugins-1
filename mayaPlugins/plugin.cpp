#include <maya/MFnPlugin.h>
#include <maya/MGlobal.h>
#include <maya/MStatus.h>
#include <maya/MPxNode.h>

#include "utils.h"
#include "PSD/PoseSpaceCommand.h"
#include "PSD/PoseSpaceDeformer.h"
#include "Relax/RelaxDeformer.h"


MStatus initializePlugin( MObject obj )
{
    MStatus result;
    MFnPlugin plugin( obj, "YOUR COMPANY", "1.0", "Any" );

    result = plugin.registerCommand( 
                      PoseSpaceCommand::name,
                      PoseSpaceCommand::creator,
                      PoseSpaceCommand::cmdSyntax);
    if (!result)
        result.perror("Register PoseSpace command failed.");

    result = plugin.registerNode(
                      PoseSpaceDeformer::name, 
                      PoseSpaceDeformer::id, 
                      PoseSpaceDeformer::creator, 
                      PoseSpaceDeformer::initialize,
                      MPxNode::kDeformerNode);
    if (!result)
        result.perror("Register PoseSpace deformer failed.");

    result = plugin.registerNode(
                      RelaxDeformer::name, 
                      RelaxDeformer::id, 
                      RelaxDeformer::creator, 
                      RelaxDeformer::initialize,
                      MPxNode::kDeformerNode);
    if (!result)
        result.perror("Register Relax deformer failed.");

    return result;
}

MStatus uninitializePlugin( MObject obj)
{
    MStatus result;
    MFnPlugin plugin( obj );

    result = plugin.deregisterCommand( PoseSpaceCommand::name );
    if (!result)
        result.perror("Deregister PoseSpace command failed.");

    result = plugin.deregisterNode( PoseSpaceDeformer::id );
    if (!result)
        result.perror("Deregister PoseSpace deformer failed.");

    result = plugin.deregisterNode( RelaxDeformer::id );
    if (!result)
        result.perror("Deregister Relax deformer  failed.");

    return result;
}