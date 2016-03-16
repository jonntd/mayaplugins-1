#ifndef RELAXDEFORMER_H
#define RELAXDEFORMER_H

#include <maya/MPxDeformerNode.h> 
#include <maya/MTypeId.h>
#include <maya/MDataBlock.h>

class RelaxDeformer: public MPxDeformerNode
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

    static MObject          aIterations;
    static MObject          aAmount;
};

#endif

