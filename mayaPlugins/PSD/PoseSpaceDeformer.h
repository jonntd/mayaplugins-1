#ifndef POSESPACEDEFORMER_H
#define POSESPACEDEFORMER_H

#include <vector>
#include <map>

#include <maya/MPxDeformerNode.h>
#include <maya/MTypeId.h>
#include <maya/MDataBlock.h>
#include <maya/MVector.h>
#include <maya/MEulerRotation.h>
#include <maya/MDoubleArray.h>


typedef std::map<int, MVector>  VectorMap;
typedef std::map<int, MEulerRotation>  RotationMap;
typedef std::map<int, MMatrix>  MatrixMap;


class PoseSpaceDeformer: public MPxDeformerNode
{
public:

    PoseSpaceDeformer();

    static  void*       creator();
    static  MStatus     initialize();

    MStatus setDependentsDirty( const MPlug& plugBeingDirtied, 
                                MPlugArray& affectedPlugs );

    MStatus compute(const MPlug& plug, MDataBlock& block);

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
    static MObject          aJointAxis;
    static MObject          aJointRot;
    static MObject          aJointRotX;
    static MObject          aJointRotY;
    static MObject          aJointRotZ;


    static MObject          aPose;
    static MObject          aPoseName;
    static MObject          aPoseIgnore;
    static MObject          aPoseEnvelope;
    static MObject          aPoseWeight;
    static MObject          aPoseJoint;
    static MObject          aPoseJointRot;
    static MObject          aPoseJointRotX;
    static MObject          aPoseJointRotY;
    static MObject          aPoseJointRotZ;
    static MObject          aPoseJointFallOff;
    static MObject          aPoseTarget;
    static MObject          aPoseTargetName;
    static MObject          aPoseTargetEnvelope;
    static MObject          aPoseTargetComponents;
    static MObject          aPoseTargetDelta;

    static MObject          aIncludeTwist;

    static MObject          aSkinClusterWeightList;
    static MObject          aSkinClusterWeights;


private:

    MStatus calcPoseWeights( MDataBlock& block );


private:

    static std::map<short, MVector>     AxisVec;
    static std::map<short, MVector>     UpVec;

    class PoseJoint
    {
    public:
        PoseJoint() {}
        PoseJoint(MEulerRotation _rotation, float _fallOff) : rotation(_rotation), fallOff(_fallOff)   {}

        MEulerRotation  rotation;
        float           fallOff;
    };

    typedef std::map<int, PoseJoint>    PoseJointMap;

    class PoseInfo
    {
    public:
        PoseJointMap jtMap;
        bool ignore;
    };

    bool                        _posesDirty;
    std::vector<MDoubleArray>   _pose2PoseWeights;
    std::vector<PoseInfo>       _poses;    
    MDoubleArray                _poseWeights;

};

#endif
