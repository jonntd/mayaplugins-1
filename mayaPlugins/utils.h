#ifndef UTILS_H
#define UTILS_H

#include <limits>

typedef const char* const conststr;

namespace PluginIDs
{
    const long PoseSpaceDeformer     = 0x00120781;
    const long RelaxDeformer         = 0x00120782;
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

    conststr PSDDeformerNotProvided             = "PoseSpaceDeformer was not provided";
    conststr PSDMeshNotSelected                 = "Mesh was not selected";
    conststr PSDJointsNotProvided               = "Joints were not provided";
    conststr PSDSCNotFound                      = "SkinCluster was not found";
    conststr PSDCreateFailed                    = "Failed to create poseSpaceDeformer";
    conststr PSDJointConnectionFailed           = "Couldnt connect joint %s to poseSpaceDeformer";
    conststr PSDInvalidPoseIndex                = "No pose found at given pose index";
    conststr PSDInvalidTargetIndex              = "No poseTarget found at given target index";
    conststr PSDNoJointConn                     = "No joint is connected at index %d";
    conststr PSDPoseDeleteFailed                = "Failed to delete pose";

    conststr RelaxInvalidInput                  = "Relax deformer works on meshes only";
};

#define DEG2RAD(angle)     angle * 3.141592653589793 / 180.0
#define RAD2DEG(angle)     angle * 180.0 / 3.141592653589793

#define FLOAT_TOLERANCE    0.0000001f //std::numeric_limits<float>::epsilon

#define FUNCLINE      (MString(__FUNCTION__) + " (" + __FILE__ + " :" + __LINE__ + ")").asChar()

#define MCheckStatus(status, message)                   \
    if ( status != MStatus::kSuccess )                  \
    {                                                   \
        if ( MString(message) != "" )                   \
        {                                               \
            MString f = FUNCLINE;                       \
            char buf[1024];                             \
            sprintf(buf, "%-70s %s", MString(message).asChar(), FUNCLINE);  \
            MGlobal::displayError(buf);                 \
            cerr << buf << "\n";                        \
        }                                               \
        return status;                                  \
    }

#define MReturnFailure(message)             MCheckStatus(MStatus::kFailure, message)


#define MDebugPrint(message)                            \
    {                                                   \
        char _buf[1024];                                \
        sprintf(_buf, "%-70s %s", MString(message).asChar(), FUNCLINE);  \
        MGlobal::displayInfo(_buf);                     \
        cerr << _buf << "\n";                           \
    }


#define MVector2Str(rot)       MString("") + rot.x + ", " + rot.y + ", " + rot.z



#endif