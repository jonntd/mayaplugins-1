#ifndef POSESPACEDEFORMER_H
#define POSESPACEDEFORMER_H

#include <maya/MPxDeformerNode.h>
#include <maya/MTypeId.h>
#include <maya/MDataBlock.h>


class PoseSpaceDeformer: public MPxDeformerNode
{
public:

    static  void*       creator();
    static  MStatus     initialize();

    MStatus deform( MDataBlock&     block, 
                    MItGeometry&    itGeo, 
                    const MMatrix&  world, 
                    unsigned int    geomIndex );

public:

    static  MTypeId         id;  
    static  const char*     name;


public:
    static MObject          aDebug;

    static MObject          aJoint;
    static MObject          aJointRotation;
    static MObject          aJointMatrix;

    static MObject          aPose;
    static MObject          aPoseName;
    static MObject          aPoseEnvelope;
    static MObject          aPoseJointRotations;
    static MObject          aPoseComponents;
    static MObject          aPoseDelta;

    static MObject          aSkinClusterWeightList;
    static MObject          aSkinClusterWeights;
};

#endif
