#
# Running the following script should generate this output
#
# Pose1 added
# pose1: 1.0
# # Warning: Edit the target geometry # 
# Pose1 target added
# Pose2 added, without joints
# pose1: 0.222222223878
# pose2: 0.0
# Pose2 joints added
# pose1: 3.64250603013e-08
# pose2: 1.0
# # Warning: Edit the target geometry # 
# Pose2 target added
# pose1: 3.64250603013e-08
# pose2: 1.0
# Pose1 set
# pose1: 1.00000011921
# pose2: 0.0
# Pose2 set
# pose1: 3.64250603013e-08
# pose2: 1.0
#

cmds.loadPlugin("plugin.mll")

import sys
sys.path.append('PSD')
from psd import PoseSpaceDeformer

# Skinned cylinder
cmds.file(new=1, f=1)
cyl = cmds.polyCylinder(ch=0, o=1, r=15, h=50, sy=10, sz=5)[0]
cmds.move(0,25,0)
cmds.select(cl=1)
rootJoint = cmds.joint()
cmds.joint()
cmds.move(0,25,0)
cmds.joint()
cmds.move(0,50,0)
cmds.skinCluster(cyl, rootJoint)
cmds.select(cyl)

# Create PSD
psd = PoseSpaceDeformer.create('psd')
psd = PoseSpaceDeformer('psd')

# Add pose
psd.addPose('pose1')
cmds.rotate( 0, 0, 50, 'joint2', r=1 )
psd.addPoseJoints('pose1', 'joint2')
print 'Pose1 added'
psd.printPoseWeights()


# Add pose target
dup = psd.initPoseTarget('pose1', 'target1')
cmds.select( dup+'.vtx[216:219]', tgl=1)
cmds.move( 10, 10, 0, r=1)
print 'Pose1 target added'
psd.setPoseTarget()

# Add new pose
psd.addPose('pose2')
cmds.rotate( 0, 0, 35, 'joint2', r=1 )
print 'Pose2 added, without joints'
psd.printPoseWeights()
psd.addPoseJoints('pose2', 'joint2')
print 'Pose2 joints added'
psd.printPoseWeights()

# Add pose target
dup = psd.initPoseTarget('pose2', 'target1')
cmds.select( dup+'.vtx[176:179]', tgl=1)
cmds.move( 10, 10, 0, r=1)
psd.setPoseTarget()
print 'Pose2 target added'
psd.printPoseWeights()

# Check weights
psd.setToPose('pose1')
print 'Pose1 set'
psd.printPoseWeights()
psd.setToPose('pose2')
print 'Pose2 set'
psd.printPoseWeights()

# Use window to script the joint input to see how weights change
cmds.window()
cmds.columnLayout()
cmds.attrControlGrp(attribute='joint2.rz')
cmds.attrControlGrp(attribute=psd.name+'.pose[0].poseWeight')
cmds.attrControlGrp(attribute=psd.name+'.pose[1].poseWeight')
cmds.showWindow()


