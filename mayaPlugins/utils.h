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

    conststr PSDDeformerNotProvided             = "PoseSpaceDeformer was not provided";
    conststr PSDMeshNotSelected                 = "Mesh was not selected";
    conststr PSDJointsNotProvided               = "Joints were not provided";
    conststr PSDSCNotFound                      = "SkinCluster was not found";
    conststr PSDCreateFailed                    = "Failed to create poseSpaceDeformer";
    conststr PSDJointConnectionFailed           = "Couldnt connect joint %s to poseSpaceDeformer";
    conststr PSDInvalidPoseIndex                = "No pose found at given pose index";
    conststr PSDInvalidTargetIndex              = "No poseTarget found at given target index";
};


#define FLOAT_TOLERANCE        0.0000001f //std::numeric_limits<float>::epsilon

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
        char buf[1024];                                 \
        sprintf(buf, "%-70s %s", MString(message).asChar(), FUNCLINE);  \
        MGlobal::displayInfo(buf);                      \
        cerr << buf << "\n";                            \
    }


#define MVector2Str(rot)       MString("") + rot.x + ", " + rot.y + ", " + rot.z



#endif