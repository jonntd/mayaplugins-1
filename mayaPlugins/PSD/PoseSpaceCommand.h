#ifndef POSESPACECOMMAND_H
#define POSESPACECOMMAND_H

#include <maya/MPxCommand.h>
#include <maya/MSelectionList.h>
#include <maya/MArgList.h>
#include <maya/MSyntax.h>
#include <maya/MStringArray.h>

class PoseSpaceCommand : public MPxCommand 
{
public:
    static void*        creator();    
    static MSyntax      cmdSyntax();

    MStatus             doIt(const MArgList& args);
    //MStatus             redoIt();
    //MStatus             undoIt();

public:
    static  const char*     name;


private:


    MStatus             parseArgs( const MArgList& args );
    MStatus             getDeformerObj(MObject& defObj);
    MStatus             getMeshFromSelList(MObject& meshObj);
    MStatus             create();
    MStatus             addPose();


private:

    MString             _operation;
    MSelectionList      _selList;

    MString             _poseSpaceDeformer;
    MStringArray        _joints;
};


#endif
