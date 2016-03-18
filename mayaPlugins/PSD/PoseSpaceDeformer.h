#ifndef POSESPACEDEFORMER_H
#define POSESPACEDEFORMER_H

#include <vector>
#include <map>

#include <maya/MPxDeformerNode.h>
#include <maya/MTypeId.h>
#include <maya/MDataBlock.h>
#include <maya/MVector.h>
#include <maya/MDoubleArray.h>


typedef std::map<int, MVector>  VectorMap;
typedef std::map<int, MMatrix>  MatrixMap;


class PoseSpaceDeformer: public MPxDeformerNode
{
public:

    PoseSpaceDeformer();

    static  void*       creator();
    static  MStatus     initialize();

    MStatus setDependentsDirty( const MPlug& plugBeingDirtied, 
                                MPlugArray& affectedPlugs );

    MStatus deform( MDataBlock&     block, 
                    MItGeometry&    itGeo, 
                    const MMatrix&  world, 
                    unsigned int    geomIndex );

public:

    static  MTypeId         id;  
    static  const char*     name;

#ifdef _DEBUG
    static MObject          aDebug;
#endif

    static MObject          aJoint;
    static MObject          aJointRot;
    static MObject          aJointRotX;
    static MObject          aJointRotY;
    static MObject          aJointRotZ;


    static MObject          aPose;
    static MObject          aPoseName;
    static MObject          aPoseJoint;
    static MObject          aPoseJointRot;
    static MObject          aPoseJointRotX;
    static MObject          aPoseJointRotY;
    static MObject          aPoseJointRotZ;
    static MObject          aPoseJointFallOff;
    static MObject          aPoseTarget;
    static MObject          aPoseEnvelope;
    static MObject          aPoseComponents;
    static MObject          aPoseDelta;

    static MObject          aSkinClusterWeightList;
    static MObject          aSkinClusterWeights;




private:

    class PoseJoint
    {
    public:
        PoseJoint() {}
        PoseJoint(MVector _rotation, float _fallOff) : rotation(_rotation), fallOff(_fallOff)   {}

        MVector     rotation;
        float       fallOff;
    };

    typedef std::map<int, PoseJoint>    PoseJointMap;

    bool                        _posesDirty;
    std::vector<MDoubleArray>   _pose2PoseWeights;
    std::vector<PoseJointMap>   _poses;

};

#endif
