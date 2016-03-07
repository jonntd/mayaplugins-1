
namespace PluginIDs
{
    enum PluginIDs
    {
        PoseSpaceDeformer     = 0x8104D,
        RelaxDeformer         = 0x34567,
    };
};


#define MCheckStatus(status,message)    \
    if( MStatus::kSuccess != status ) { \
        cerr << message << "\n";        \
        return status;                  \
    }


#define MPrint(message)                                     \
    MString _msg = MString(__FUNCTION__) + ": " + message;  \
    MGlobal::displayInfo(_msg);                             \
    std::cerr << _msg.asChar() << "\n";
