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

    conststr PSDeformerNotFound                 = "PoseSpaceDeformer was not found";
    conststr PSDMeshNotFound                    = "PoseMesh was not found";
    conststr PSDSCNotFound                      = "SkinCluster was not found";
    conststr PSDCreateFailed                    = "Failed to create poseSpaceDeformer";
    conststr PSDJointConnectionFailed           = "Couldnt connect joint %s to poseSpaceDeformer";
};


#define FLOAT_TOLERANCE        0.0000001f //std::numeric_limits<float>::epsilon

#define FUNCLINE      MString(__FUNCTION__) + " (" + __FILE__ + " :" + __LINE__ + ")"

#define MCheckStatus(status,message)                    \
    if ( status != MStatus::kSuccess )                  \
    {                                                   \
        if ( MString(message) != "" )                   \
        {                                               \
            MString _msg = message;                     \
            _msg += "    in ";                          \
            _msg += FUNCLINE;                           \
            MGlobal::displayError(_msg);                \
            cerr << _msg << "\n";                       \
        }                                               \
        return status;                                  \
    }

#define MReturnFailure(message)             MCheckStatus(MStatus::kFailure, message)


#define MDebugPrint(message)                            \
    {                                                   \
    MString _msg = message;                             \
    _msg += "    in ";                                  \
    _msg += FUNCLINE;                                   \
    MGlobal::displayInfo(_msg);                         \
    std::cerr << _msg.asChar() << "\n";                 \
    }



#endif