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


private:

    static MObject          aDebug;


};

#endif

