#ifndef UTILS_H
#define UTILS_H

#include <limits>


typedef const char* const conststr;


namespace PluginIDs
{
    const long PoseSpaceDeformer     = 0x8104D;
    const long RelaxDeformer         = 0x34567;
};

namespace PluginNames
{
    conststr PoseSpaceCommand      = "poseSpaceCommand";
    conststr PoseSpaceDeformer     = "poseSpaceDeformer";
    conststr RelaxDeformer         = "relaxDeformer";
};


namespace ErrorStr
{
    conststr FailedToParseArgs                  = "Failed to parse arguments";

    conststr PSDeformerNotFound                 = "PoseSpaceDeformer was not found to add pose to";
    conststr PSDMeshNotFound                    = "PoseMesh was not found to add new pose";

    conststr PSDCreateFailed                    = "Failed to create poseSpaceDeformer";
    conststr PSDSCNotFoundCreateFailed          = "Failed to create poseSpaceDeformer, since skinCluster not found on mesh";
};


#define FLOAT_TOLERANCE        0.0000001f //std::numeric_limits<float>::epsilon


#define MCheckStatus(status,message)            \
    if ( status != MStatus::kSuccess )          \
    {                                           \
        if ( MString(message) != "" )           \
        {                                       \
            MGlobal::displayError(message);     \
            cerr << message << "\n";            \
        }                                       \
        return status;                          \
    }

#define MReturnFailure(message)             \
    {                                       \
    MGlobal::displayError(message);         \
    cerr << message << "\n";                \
    return MStatus::kFailure;               \
    }


#define MDebugPrint(message)                                \
    {                                                       \
    MString _msg = MString(__FUNCTION__) + ": " + message;  \
    MGlobal::displayInfo(_msg);                             \
    std::cerr << _msg.asChar() << "\n";                     \
    }



#endif