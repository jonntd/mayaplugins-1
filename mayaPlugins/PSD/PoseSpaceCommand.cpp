#include "PoseSpaceCommand.h"
#include "PoseSpaceDeformer.h"
#include "utils.h"

#include <map>

#include <maya/MGlobal.h>
#include <maya/MMatrix.h>
#include <maya/MFnMatrixData.h>
#include <maya/MFnIntArrayData.h>
#include <maya/MFnVectorArrayData.h>
#include <maya/MFnDependencyNode.h>
#include <maya/MFnMesh.h>
#include <maya/MFnTransform.h>
#include <maya/MFnSkinCluster.h>
#include <maya/MFnGeometryFilter.h>
#include <maya/MDagPath.h>
#include <maya/MArgDatabase.h>
#include <maya/MItDependencyGraph.h>
#include <maya/MIntArray.h>
#include <maya/MPointArray.h>
#include <maya/MEulerRotation.h>


#define SFLAG_HELP                      "h"
#define LFLAG_HELP                      "help"
#define SFLAG_SETPOSETARGET             "spt"
#define LFLAG_SETPOSETARGET             "setPoseTarget"
#define SFLAG_UPDATEPOSETARGET          "upt"
#define LFLAG_UPDATEPOSETARGET          "updatePoseTarget"


#define MATCHARG(str, shortName, longName) \
        (((str)==(shortName))||((str)==(longName)))



const char * PoseSpaceCommand::name(PluginNames::PoseSpaceCommand);


typedef std::map<int, MMatrix>      JointMatrixMap;


void* PoseSpaceCommand::creator()
{
    return new PoseSpaceCommand;
}

void PoseSpaceCommand::usage()
{
    MString str;

    char buf[1024];
    const char *cmd = PoseSpaceCommand::name;

    str = (" USAGE: - Create and Sets up poseSpaceDeformer (mel)\n" );
    str += ("// ---------------------------------------" );

    sprintf(buf, "\n//   %-70s : ", "Set pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "%s -%s <poseIndex> <targetIndex> <psdNode>", cmd, LFLAG_SETPOSETARGET);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Update pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "%s -%s <poseIndex> <targetIndex> <psdNode>", cmd, LFLAG_UPDATEPOSETARGET);
    str += buf;

    MGlobal::displayInfo( str );


    str = ("\n USAGE: - Create and Sets up poseSpaceDeformer (python)\n" );
    str += ("// ---------------------------------------" );

    sprintf(buf, "\n//   %-70s : ", "Reset pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=[<poseIndex>, <targetIndex>[] )", cmd, LFLAG_SETPOSETARGET);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Update pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=[<poseIndex>, <targetIndex>] )", cmd, LFLAG_UPDATEPOSETARGET);
    str += buf;

    MGlobal::displayInfo( str );    
}



MSyntax PoseSpaceCommand::cmdSyntax()
{
    MStatus stat;
    MSyntax syntax;

    syntax.addFlag(SFLAG_HELP, LFLAG_HELP);

    syntax.addFlag(SFLAG_SETPOSETARGET, LFLAG_SETPOSETARGET, MSyntax::kUnsigned, MSyntax::kUnsigned);
    syntax.addFlag(SFLAG_UPDATEPOSETARGET, LFLAG_UPDATEPOSETARGET, MSyntax::kUnsigned, MSyntax::kUnsigned);

    syntax.enableQuery(false);
    syntax.setObjectType(MSyntax::kSelectionList);

    return syntax;
}

MStatus PoseSpaceCommand::parseArgs( const MArgList& args )
{
    MStatus stat;

    MArgDatabase argDB(syntax(), args, &stat);
    MCheckStatus(stat, ErrorStr::FailedToParseArgs);

    // Get selection
    stat = argDB.getObjects( _selList );
    MCheckStatus(stat, ErrorStr::FailedToParseArgs);


    // -help
    if (argDB.isFlagSet(LFLAG_HELP))
    {
        usage();
        return MS::kSuccess;
    }

    _poseIndex = -1;
    _targetIndex = -1;
    _updateTarget = false;

    if (argDB.isFlagSet(LFLAG_SETPOSETARGET))
    {
        _operation = LFLAG_SETPOSETARGET;

        stat = argDB.getFlagArgument(LFLAG_SETPOSETARGET, 0, _poseIndex);
        stat = argDB.getFlagArgument(LFLAG_SETPOSETARGET, 1, _targetIndex);
    }
    else if (argDB.isFlagSet(LFLAG_UPDATEPOSETARGET))
    {
        _operation = LFLAG_SETPOSETARGET;
        _updateTarget = true;

        stat = argDB.getFlagArgument(LFLAG_UPDATEPOSETARGET, 0, _poseIndex);
        stat = argDB.getFlagArgument(LFLAG_UPDATEPOSETARGET, 1, _targetIndex);
    }

    return MS::kSuccess;
}

MStatus PoseSpaceCommand::doIt( const MArgList& args )
{
    MStatus stat;
    MString msg;

    stat = parseArgs(args);
    MCheckStatus(stat, "");

    if (_operation == LFLAG_SETPOSETARGET)
    {
        stat = setPoseTarget();
    }

    return stat;
}

// Get mesh name from selection list
MStatus PoseSpaceCommand::getMeshFromSelList(MObject& obj)
{
    MStatus stat;

    MSelectionList selList;
    MGlobal::getActiveSelectionList(selList);

    for( unsigned i=0; i < selList.length(); ++i )
    {
        stat = selList.getDependNode(i, obj);
        MFnDependencyNode fnDep(obj, &stat);

#ifdef _DEBUG
        MString msg = "getMeshFromSelList: ";
        msg += fnDep.name();
        MDebugPrint(msg);
#endif
        if (obj.hasFn(MFn::kMesh))
        {
            return MS::kSuccess;
        }
        else if (obj.hasFn(MFn::kTransform))
        {
            MFnDagNode fnDag(obj);

            MDagPath dag;
            fnDag.getPath(dag);

            dag.extendToShape();
            obj = dag.node();
            return MS::kSuccess;
        }
    }

    MReturnFailure(ErrorStr::PSDMeshNotSelected);
}

// Get PSD node from selection list
MStatus PoseSpaceCommand::getDeformerFromSelList(MObject& obj)
{
    MStatus stat;

    for( unsigned i=0; i < _selList.length(); ++i )
    {    
        stat = _selList.getDependNode(i, obj);
        MFnDependencyNode fnDep(obj, &stat);

        if (fnDep.typeId() == PoseSpaceDeformer::id)
        {
            return MS::kSuccess;
        }
    }

    MReturnFailure(ErrorStr::PSDDeformerNotProvided);
}


MStatus PoseSpaceCommand::setPoseTarget()
{
    MStatus stat;
    MString msg;
    MObject obj;


    // Get deformer
    stat = getDeformerFromSelList(obj);
    MCheckStatus(stat, "");
    MFnGeometryFilter fnDeformer(obj);




    // Get pose and poseTarget
    MPlug pPose = fnDeformer.findPlug(PoseSpaceDeformer::aPose);
    {        
        // Check if given poseIndex exists
        bool found = false;
        for( unsigned i=0; i < pPose.numElements(); ++i )
            if (_poseIndex == pPose[i].logicalIndex())
            {
                found = true;
                break;
            }
        if (found == false)
        {
            char buf[1024];
            sprintf(buf, ErrorStr::PSDInvalidPoseIndex, _poseIndex);
            MReturnFailure(buf);
        }
    }
    pPose = pPose.elementByLogicalIndex(_poseIndex);

    // Get next pose target index
    MPlug pPoseTarget = pPose.child(PoseSpaceDeformer::aPoseTarget);
    if ( _targetIndex == -1 )
    {
        _targetIndex = 0;
        if (pPoseTarget.numElements())
            _targetIndex = pPoseTarget[pPoseTarget.numElements()-1].logicalIndex() + 1;
    }
    else
    {        
        // Check if given targetIndex exists
        bool found = false;
        for( unsigned i=0; i < pPoseTarget.numElements(); ++i )
            if (_targetIndex == pPoseTarget[i].logicalIndex())
            {
                found = true;
                break;
            }
        if (found == false)
        {
            char buf[1024];
            sprintf(buf, ErrorStr::PSDInvalidTargetIndex, _targetIndex);
            MReturnFailure(buf);
        }
    }
    pPoseTarget = pPoseTarget.elementByLogicalIndex(_targetIndex);

    // Set pose components and delta
    MPlug pPoseComp = pPoseTarget.child(PoseSpaceDeformer::aPoseTargetComponents);
    MPlug pPoseDelta = pPoseTarget.child(PoseSpaceDeformer::aPoseTargetDelta);




    // Get output mesh from deformer
    MDagPath srcPath;
    fnDeformer.getPathAtIndex(0, srcPath);
    obj = fnDeformer.outputShapeAtIndex(0);
    MFnMesh fnSrcMesh(obj);


    // Get pose/target mesh from selection list
    stat = getMeshFromSelList(obj);
    MCheckStatus(stat, "");
    MFnMesh fnTgtMesh(obj);



    // Get skinCluster weightsPlug and joint matrices
    MPlug scWtsPlug;
    JointMatrixMap jtMatrices;
    {
        // Get skinCluster
        MFnSkinCluster fnSkinCluster;
        {
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
            MPlug plug = fnDeformer.findPlug(PoseSpaceDeformer::aSkinClusterWeightList);
            MPlugArray plugArr;
            plug.connectedTo(plugArr, 1, 0);
            obj = plugArr[0].node();
            fnSkinCluster.setObject(obj);
#endif
        }
        
        scWtsPlug = fnSkinCluster.findPlug("weightList");
        MPlug bindPlug = fnSkinCluster.findPlug("bindPreMatrix");
        MPlug jtMatPlug = fnSkinCluster.findPlug("matrix");
        MMatrix srcGeomWorldMat = srcPath.inclusiveMatrix();

        MFnMatrixData fnMatrix;

        for( unsigned i=0; i < jtMatPlug.numElements(); ++i )
        {
            if ( jtMatPlug[i].logicalIndex() != bindPlug[i].logicalIndex() )
            {
                MReturnFailure("Matrix and bindPreMatrix plugs in skincluster doesnt match");
            }

            fnMatrix.setObject(bindPlug[i].asMObject());
            MMatrix bindInvMat = fnMatrix.matrix();

            fnMatrix.setObject(jtMatPlug[i].asMObject());
            MMatrix jtMat = fnMatrix.matrix();

            MMatrix scMat = srcGeomWorldMat * bindInvMat * jtMat * srcGeomWorldMat.inverse();
            jtMatrices[jtMatPlug[i].logicalIndex()] = scMat;
        }
    }



    // Get vertices that differ from src and target mesh
    MPointArray srcPositions;
    MPointArray tgtPositions;

    fnSrcMesh.getPoints(srcPositions);
    fnTgtMesh.getPoints(tgtPositions);

    if ( srcPositions.length() != tgtPositions.length() )
    {
        MReturnFailure(ErrorStr::PSDInvalidPoseTarget);
    }



    // Get existing delta, if we want to updateTarget
    std::map<int, MVector> deltaMap;
    if (_updateTarget)
    {
        pPoseComp.getValue(obj);
        MFnIntArrayData fnIntArrData(obj);
        MIntArray components = fnIntArrData.array();

        pPoseDelta.getValue(obj);
        MFnVectorArrayData fnVectorArrData(obj);
        MVectorArray deltas = fnVectorArrData.array();

        if ( components.length() != deltas.length() )
        {
            MReturnFailure(ErrorStr::PSDInvalidTargetDelta);
        }

        for(unsigned i=0; i < components.length(); ++i)
            deltaMap[components[i]] = deltas[i];
    }


    // Get components with delta (in bind space)
    for( unsigned i=0; i < srcPositions.length(); ++i )
    {
        // Delta in skin space
        MVector delta = tgtPositions[i] - srcPositions[i];
        if ( delta.length() < FLOAT_TOLERANCE )
            continue;

        // Find skinMatrix
        MMatrix skinMatrix;        
        MPlug wtsPlug = scWtsPlug[i].child(0);
        for( unsigned j=0; j < wtsPlug.numElements(); ++j )
        {
            int jtIdx = wtsPlug[j].logicalIndex();
            MMatrix mat = wtsPlug[j].asDouble() * jtMatrices[jtIdx];

            if (j)
                skinMatrix += mat;
            else
                skinMatrix = mat;
        }

        // Convert delta from skin to bind space
        delta = delta * skinMatrix.inverse();

        deltaMap[i] = deltaMap[i] + delta;
    }

    if (deltaMap.size() == 0)
    {
        MReturnFailure(ErrorStr::PSDPoseTargetDoesntDiffer);
    }


    // Copy components/delta onto plug
    MIntArray components;
    MVectorArray deltas;
    std::map<int,MVector>::const_iterator iter;
    for(iter=deltaMap.begin(); iter != deltaMap.end(); ++iter)
    {
        components.append(iter->first);
        deltas.append(iter->second);
    }


    MFnIntArrayData fnIntArrData;
    obj = fnIntArrData.create();
    fnIntArrData.set(components);
    pPoseComp.setValue(obj);

    MFnVectorArrayData fnVectorArrData;
    obj = fnVectorArrData.create();
    fnVectorArrData.set(deltas);
    pPoseDelta.setValue(obj);


    setResult(_targetIndex);

    return MS::kSuccess;
}
