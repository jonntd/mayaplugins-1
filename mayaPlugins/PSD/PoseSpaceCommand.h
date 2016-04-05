#ifndef POSESPACECOMMAND_H
#define POSESPACECOMMAND_H

#include <maya/MPxCommand.h>
#include <maya/MSelectionList.h>
#include <maya/MArgList.h>
#include <maya/MSyntax.h>
#include <maya/MStringArray.h>
#include <maya/MObjectArray.h>


class PoseSpaceCommand : public MPxCommand 
{
public:
    static void*        creator();    

    void                usage();
    static MSyntax      cmdSyntax();

    MStatus             doIt(const MArgList& args);
    //MStatus             redoIt();
    //MStatus             undoIt();

public:
    static  const char*     name;


private:

    MStatus             parseArgs( const MArgList& args );

    MStatus             getMeshFromSelList(MObject& obj);
    MStatus             getDeformerFromSelList(MObject& obj);
    MStatus             getJointsFromSelList(MObjectArray& joints);

    MStatus             create();
    MStatus             setPose();
    MStatus             deletePose();
    MStatus             setPoseTarget();
    MStatus             deletePoseTarget();


private:

    MSelectionList      _selList;

    MString             _operation;

    MString             _poseSpaceDeformer;
    int                 _poseIndex;
    int                 _targetIndex;
    bool                _updateTarget;
};


#endif
