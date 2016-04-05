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

#define SFLAG_CREATE                    "c"
#define LFLAG_CREATE                    "create"

#define SFLAG_SETPOSE                   "sp"
#define LFLAG_SETPOSE                   "setPose"
#define SFLAG_DELETEPOSE                "dp"
#define LFLAG_DELETEPOSE                "deletePose"

#define SFLAG_SETPOSETARGET             "spt"
#define LFLAG_SETPOSETARGET             "setPoseTarget"
#define SFLAG_UPDATEPOSETARGET          "upt"
#define LFLAG_UPDATEPOSETARGET          "updatePoseTarget"
#define SFLAG_DELETEPOSETARGET          "dpt"
#define LFLAG_DELETEPOSETARGET          "deletePoseTarget"

#define SFLAG_POSEINDEX                 "pi"
#define LFLAG_POSEINDEX                 "poseIndex"
#define SFLAG_TARGETINDEX               "ti"
#define LFLAG_TARGETINDEX               "targetIndex"


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

    sprintf(buf, "\n//   %-70s : ", "Create PSD on selected mesh; returns node name");
    str += buf;
    sprintf(buf, "%s -%s <psd name>", cmd, LFLAG_CREATE);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Add pose with given joints; returns poseIndex");
    str += buf;
    sprintf(buf, "%s -%s <psdNode> <joint list>", cmd, LFLAG_SETPOSE);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose by adding new joints or updating given joint rotations");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> <psdNode> <joint list>", cmd, LFLAG_SETPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose's joint rotations with current values");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> <psdNode>", cmd, LFLAG_SETPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Delete pose given poseIndex");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> <psdNode>", cmd, LFLAG_DELETEPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Add pose target using selected mesh; returns poseTargetIndex");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> <psdNode>", cmd, LFLAG_SETPOSETARGET, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> -%s <targetIndex> <psdNode>", cmd, LFLAG_SETPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Update pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> -%s <targetIndex> <psdNode>", cmd, LFLAG_UPDATEPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Delete pose target given pose and target index");
    str += buf;
    sprintf(buf, "%s -%s -%s <poseIndex> -%s <targetIndex> <psdNode>", cmd, LFLAG_DELETEPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    MGlobal::displayInfo( str );


    str = ("\n USAGE: - Create and Sets up poseSpaceDeformer (python)\n" );
    str += ("// ---------------------------------------" );

    sprintf(buf, "\n//   %-70s : ", "Create PSD on selected mesh; returns node name");
    str += buf;
    sprintf(buf, "cmds.%s( %s=<psd name> )", cmd, LFLAG_CREATE);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Add pose with given joints; returns poseIndex");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, <joint list>, %s=1 )", cmd, LFLAG_SETPOSE);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose by adding new joints or updating given joint rotations");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, <joint list>, %s=1, %s=<poseIndex> )", cmd, LFLAG_SETPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose's joint rotations with current values");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex> )", cmd, LFLAG_SETPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Delete pose given poseIndex");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex> )", cmd, LFLAG_DELETEPOSE, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Add pose target using selected mesh; returns poseTargetIndex");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex> )>", cmd, LFLAG_SETPOSETARGET, LFLAG_POSEINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Reset pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex>, %s=<targetIndex> )", cmd, LFLAG_SETPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Update pose target using selected mesh, pose and target index");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex>, %s=<targetIndex> )", cmd, LFLAG_UPDATEPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    sprintf(buf, "\n//   %-70s : ", "Delete pose target given pose and target index");
    str += buf;
    sprintf(buf, "cmds.%s( <psdNode>, %s=1, %s=<poseIndex>, %s=<targetIndex>)", cmd, LFLAG_DELETEPOSETARGET, LFLAG_POSEINDEX, LFLAG_TARGETINDEX);
    str += buf;

    MGlobal::displayInfo( str );    
}



MSyntax PoseSpaceCommand::cmdSyntax()
{
    MStatus stat;
    MSyntax syntax;

    syntax.addFlag(SFLAG_HELP, LFLAG_HELP);

    syntax.addFlag(SFLAG_CREATE, LFLAG_CREATE, MSyntax::kString);

    syntax.addFlag(SFLAG_SETPOSE, LFLAG_SETPOSE);
    syntax.addFlag(SFLAG_DELETEPOSE, LFLAG_DELETEPOSE);

    syntax.addFlag(SFLAG_SETPOSETARGET, LFLAG_SETPOSETARGET);
    syntax.addFlag(SFLAG_UPDATEPOSETARGET, LFLAG_UPDATEPOSETARGET);
    syntax.addFlag(SFLAG_DELETEPOSETARGET, LFLAG_DELETEPOSETARGET);

    syntax.addFlag(SFLAG_POSEINDEX, LFLAG_POSEINDEX, MSyntax::kUnsigned);
    syntax.addFlag(SFLAG_TARGETINDEX, LFLAG_TARGETINDEX, MSyntax::kUnsigned);

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

    if (argDB.isFlagSet(LFLAG_POSEINDEX))
        stat = argDB.getFlagArgument(LFLAG_POSEINDEX, 0, _poseIndex);

    if (argDB.isFlagSet(SFLAG_TARGETINDEX))
        stat = argDB.getFlagArgument(SFLAG_TARGETINDEX, 0, _targetIndex);


    if (argDB.isFlagSet(LFLAG_CREATE))
    {
        _operation = LFLAG_CREATE;

        stat = argDB.getFlagArgument(LFLAG_CREATE, 0, _poseSpaceDeformer);
        MCheckStatus(stat, ErrorStr::FailedToParseArgs);
    }
    else if (argDB.isFlagSet(LFLAG_SETPOSE))
    {
        _operation = LFLAG_SETPOSE;
    }
    else if (argDB.isFlagSet(LFLAG_DELETEPOSE))
    {
        _operation = LFLAG_DELETEPOSE;
    }    
    else if (argDB.isFlagSet(LFLAG_SETPOSETARGET))
    {
        _operation = LFLAG_SETPOSETARGET;
    }
    else if (argDB.isFlagSet(LFLAG_UPDATEPOSETARGET))
    {
        _operation = LFLAG_SETPOSETARGET;
        _updateTarget = true;
    }    
    else if (argDB.isFlagSet(LFLAG_DELETEPOSETARGET))
    {
        _operation = LFLAG_DELETEPOSETARGET;
    }

    return MS::kSuccess;
}

MStatus PoseSpaceCommand::doIt( const MArgList& args )
{
    MStatus stat;
    MString msg;

    stat = parseArgs(args);
    MCheckStatus(stat, "");

    if (_operation == LFLAG_CREATE)
    {
        stat = create();
    }
    else if (_operation == LFLAG_SETPOSE)
    {
        stat = setPose();
    }
    else if (_operation == LFLAG_DELETEPOSE)
    {
        stat = deletePose();
    }
    else if (_operation == LFLAG_SETPOSETARGET)
    {
        stat = setPoseTarget();
    }
    else if (_operation == LFLAG_DELETEPOSETARGET)
    {
        stat = deletePoseTarget();
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

// Get joints from selection list
MStatus PoseSpaceCommand::getJointsFromSelList(MObjectArray& joints)
{
    MStatus stat;

    for( unsigned i=0; i < _selList.length(); ++i )
    {    
        MObject obj;
        stat = _selList.getDependNode(i, obj);
        MFnDependencyNode fnDep(obj, &stat);

        if (obj.apiType() == MFn::kJoint)
            joints.append(obj);
    }


    return MS::kSuccess;
}



MStatus PoseSpaceCommand::create()
{
    MStatus stat;
    MString msg;
    MObject obj;

    // Get mesh fn
    stat = getMeshFromSelList(obj);
    MCheckStatus(stat, "");
    MFnMesh fnMesh(obj);


    // Get skinCluster
    MFnSkinCluster fnSkinCluster;
    {
        MPlug plug = fnMesh.findPlug("inMesh");

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
    }


    // Create deformer
    MString cmd = "deformer -type ";
    cmd += PoseSpaceDeformer::name;
    cmd += " -name ";
    cmd += _poseSpaceDeformer;
    MStringArray result;
    stat = MGlobal::executeCommand(cmd, result, 1, 1);
    MCheckStatus(stat, ErrorStr::PSDCreateFailed);

    MSelectionList sel;
    sel.add(result[0]);
    sel.getDependNode(0, obj);
    MFnDependencyNode fnDeformer(obj);


    // Connect skinCluster weights
    MPlug srcPlug = fnSkinCluster.findPlug("weightList");
    MPlug dstPlug = fnDeformer.findPlug(PoseSpaceDeformer::aSkinClusterWeightList);

    MDGModifier dgMod;
    stat = dgMod.connect(srcPlug, dstPlug);
    stat = dgMod.doIt();
    MCheckStatus(stat, ErrorStr::PSDCreateFailed);

    setResult(_poseSpaceDeformer);

    return MS::kSuccess;
}


MStatus PoseSpaceCommand::setPose()
{
    MStatus stat;
    MString msg;
    MObject obj;

    // Get deformer
    stat = getDeformerFromSelList(obj);
    MCheckStatus(stat, "");
    MFnGeometryFilter fnDeformer(obj);


    // Check joints
    MObjectArray joints;
    stat = getJointsFromSelList(joints);
    MCheckStatus(stat, "");



    // Get next pose index
    MPlug pPose = fnDeformer.findPlug(PoseSpaceDeformer::aPose);
    if ( _poseIndex == -1 )
    {
        // Make sure joints are provided
        if (joints.length() == 0)
            MReturnFailure(ErrorStr::PSDJointsNotProvided);

        _poseIndex = 0;
        if (pPose.numElements())
            _poseIndex = pPose[pPose.numElements()-1].logicalIndex() + 1;
    }
    else
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
            MReturnFailure(ErrorStr::PSDInvalidPoseIndex);
    }

    pPose = pPose.elementByLogicalIndex(_poseIndex);
    MPlug pPoseJoint = pPose.child(PoseSpaceDeformer::aPoseJoint);
    MPlug jointPlug = fnDeformer.findPlug(PoseSpaceDeformer::aJoint);


    // Get current joint names
    if (joints.length() == 0)
    {
        for(unsigned i=0; i < pPoseJoint.numElements(); ++i)
        {
            int jtIndex = pPoseJoint[i].logicalIndex();
            MPlug jointPlugE = jointPlug.elementByLogicalIndex(jtIndex);
            MPlug jtRotPlug = jointPlugE.child(PoseSpaceDeformer::aJointRot);

            MPlugArray conns;
            jtRotPlug.connectedTo(conns, 1, 0);
            if (conns.length() != 1)
            {
                char buf[1024];
                sprintf(buf, ErrorStr::PSDNoJointConn, jtIndex);
                MReturnFailure(buf);
            }

            joints.append(conns[0].node());
        }
    }



    // Add joints to pose
    for (unsigned i = 0; i < joints.length(); ++i)
    {
        MFnTransform fnJnt(joints[i]);

        // Check if joint index exists in deformer
        int jtIndex = -1;

        MPlug rotPlug = fnJnt.findPlug("rotate");
        MPlugArray conns;
        rotPlug.connectedTo(conns, 0, 1);

        for (unsigned j = 0; j < conns.length(); ++j)
        {
            MPlug conn = conns[j];
            if (conn.node() == fnDeformer.object() && conn == PoseSpaceDeformer::aJointRot)
            {
                jtIndex = conn.parent().logicalIndex();
                break;
            }
        }

#ifdef _DEBUG
        msg = "setPose: jtIdx; ";
        msg += jtIndex;
        MDebugPrint(msg);
#endif

        // Connect joint
        if (jtIndex < 0)
        {
            int numJts = jointPlug.numElements();
            if (numJts)
                jtIndex = jointPlug[numJts - 1].logicalIndex() + 1;
            else
                jtIndex = 0;

            MPlug jointPlugE = jointPlug.elementByLogicalIndex(jtIndex);
            MPlug jtRotPlug = jointPlugE.child(PoseSpaceDeformer::aJointRot);

#ifdef _DEBUG
            msg = "setPose: connect; ";
            msg += rotPlug.name();
            msg += ", ";
            msg += jtRotPlug.name();
            MDebugPrint(msg);
#endif
            MDGModifier dgMod;
            stat = dgMod.connect(rotPlug, jtRotPlug);
            stat = dgMod.doIt();
            char buf[1024];
            sprintf(buf, ErrorStr::PSDJointConnectionFailed, fnJnt.name().asChar());
            MCheckStatus(stat, buf);
        }

        // Set poseJoint
        MPlug pPoseJoint = pPose.child(PoseSpaceDeformer::aPoseJoint);
        pPoseJoint = pPoseJoint.elementByLogicalIndex(jtIndex);
        MPlug pRotation = pPoseJoint.child(PoseSpaceDeformer::aPoseJointRot);

        // Set joint rotation data
        MEulerRotation rot;
        fnJnt.getRotation(rot);
        MFnNumericData fnData;
        obj = fnData.create(MFnNumericData::k3Double);
        fnData.setData(rot.x, rot.y, rot.z);
        pRotation.setValue(obj);
    }


    setResult(_poseIndex);

    return MS::kSuccess;
}

MStatus PoseSpaceCommand::deletePose()
{
    MStatus stat;
    MString msg;
    MObject obj;

    // Get deformer
    stat = getDeformerFromSelList(obj);
    MCheckStatus(stat, "");
    MFnGeometryFilter fnDeformer(obj);

    // Check if given poseIndex exists
    MPlug pPose = fnDeformer.findPlug(PoseSpaceDeformer::aPose);
    bool found = false;
    for( unsigned i=0; i < pPose.numElements(); ++i )
        if (_poseIndex == pPose[i].logicalIndex())
        {
            found = true;
            break;
        }
    if (found == false)
        MReturnFailure(ErrorStr::PSDInvalidPoseIndex);

    pPose = pPose.elementByLogicalIndex(_poseIndex);

    // Remove pose plug
    MDGModifier dgMod;
    stat = dgMod.removeMultiInstance(pPose, true);
    stat = dgMod.doIt();
    MCheckStatus(stat, ErrorStr::PSDPoseDeleteFailed);

    return MS::kSuccess;
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
            MReturnFailure(ErrorStr::PSDInvalidPoseIndex);
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
            MReturnFailure(ErrorStr::PSDInvalidTargetIndex);
    }
    pPoseTarget = pPoseTarget.elementByLogicalIndex(_targetIndex);

    // Set pose components and delta
    MPlug pPoseComp = pPoseTarget.child(PoseSpaceDeformer::aPoseComponents);
    MPlug pPoseDelta = pPoseTarget.child(PoseSpaceDeformer::aPoseDelta);




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


MStatus PoseSpaceCommand::deletePoseTarget()
{
    MStatus stat;
    MString msg;
    MObject obj;

    // Get deformer
    stat = getDeformerFromSelList(obj);
    MCheckStatus(stat, "");
    MFnGeometryFilter fnDeformer(obj);

    // Check if given poseIndex exists
    MPlug pPose = fnDeformer.findPlug(PoseSpaceDeformer::aPose);
    bool found = false;
    for( unsigned i=0; i < pPose.numElements(); ++i )
        if (_poseIndex == pPose[i].logicalIndex())
        {
            found = true;
            break;
        }
    if (found == false)
        MReturnFailure(ErrorStr::PSDInvalidPoseIndex);

    pPose = pPose.elementByLogicalIndex(_poseIndex);



    // Check if given targetIndex exists
    found = false;
    MPlug pPoseTarget = pPose.child(PoseSpaceDeformer::aPoseTarget);
    for( unsigned i=0; i < pPoseTarget.numElements(); ++i )
        if (_targetIndex == pPoseTarget[i].logicalIndex())
        {
            found = true;
            break;
        }
    if (found == false)
        MReturnFailure(ErrorStr::PSDInvalidTargetIndex);

    pPoseTarget = pPoseTarget.elementByLogicalIndex(_targetIndex);


    // Remove pose plug
    MDGModifier dgMod;
    stat = dgMod.removeMultiInstance(pPoseTarget, true);
    stat = dgMod.doIt();
    MCheckStatus(stat, ErrorStr::PSDPoseTargetDeleteFailed);

    return MS::kSuccess;
}