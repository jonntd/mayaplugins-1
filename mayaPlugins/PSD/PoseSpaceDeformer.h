#ifndef POSESPACEDEFORMER_H
#define POSESPACEDEFORMER_H

#include <vector>
#include <map>

#include <maya/MPxDeformerNode.h>
#include <maya/MTypeId.h>
#include <maya/MDataBlock.h>


typedef std::map<int, MVector>  VectorMap;
typedef std::map<int, MMatrix>  MatrixMap;


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

    static MObject          aDebug;

    static MObject          aJoint;
    static MObject          aJointRotation;
    static MObject          aJointMatrix;

    static MObject          aPose;
    static MObject          aPoseName;
    static MObject          aPoseEnvelope;
    static MObject          aPoseJoints;
    static MObject          aPoseJointRotation;
    static MObject          aPoseJointFallOff;
    static MObject          aPoseComponents;
    static MObject          aPoseDelta;

    static MObject          aSkinClusterWeightList;
    static MObject          aSkinClusterWeights;

private:

    class PoseJoint
    {
    public:
        PoseJoint(_rotation, _fallOff) : rotation(_rotation), fallOff(_fallOff) {}

        MVector     rotation;
        float       fallOff;
    };

    typedef std::map<PoseJoint> PoseJointMap;

    bool                        _posesDirty;
    std::vector<MDoubleArray>   _pose2PoseWeights;
    std::vector<PoseJointMap>   _poses;

};

#endif
