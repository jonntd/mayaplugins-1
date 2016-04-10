import maya.cmds as cmds


PLUGIN = 'plugin'
NODETYPE = 'poseSpaceDeformer'

class PoseSpaceDeformer(object):

    name = None
    
    _poseTarget = None    

    @staticmethod
    def create(name='psd'):

        cmds.loadPlugin(PLUGIN)

        sel = cmds.ls(sl=1)
        if not sel:
            return

        if cmds.nodeType(sel[0]) == 'transform:
            sel = cmds.listRelatives(sel[0], c=1)

        if cmds.nodeType(sel[0]) != 'mesh':
            raise RuntimeError('PSD can be created only on mesh')
        
        # Find skinCluster
        skinCluster = None
        history = cmds.listHistory(sel[0]) or []
        for h in history:
            if cmds.nodeType(h) == 'skinCluster':
                skinCluster = h

        if not skinCluster:
            raise RuntimeError('PSD can only be created on mesh with skinCluster')

        name = cmds.deformer(type=NODETYPE, name=name)

        cmds.connectAttr(skinCluster+'.weightList', name+'.skinClusterWeightList')

        return PoseSpaceDeformer(name)

    def __init__(self, name):
        
        if cmds.objExists(name) and cmds.nodeType(name) == NODETYPE:
            self.name = name
            return
        raise RuntimeError('%s is not of type %s'.format(name, NODETYPE))
    
    def poseNames(self):
        '''Get pose names'''

        poseIndices = cmds.getAttr(self.name+'.pose', mi=1) or []

        poseNames = []
        for pi in poseIndices:
            pn = cmds.getAttr('{}.pose[{}].poseName'.format(self.name, pi))
            poseNames.append(pn)
        return poseNames

    def poseAttr(self, poseName):
        '''Get pose attr'''

        poseIndices = cmds.getAttr(self.name+'.pose', mi=1) or []

        for pi in poseIndices:
            poseAttr = '{}.pose[{}]'.format(self.name, pi)
            if poseName == cmds.getAttr('{}.poseName'.format(poseAttr)):
                return poseAttr

        raise RuntimeError('{} pose doesnt exist'.format(poseName))

    def addPose(self, poseName):
        '''Add new pose'''

        if poseName in self.poseNames():
            raise RuntimeError('Pose with name {} already exists'.format(poseName))

        poseIndices = cmds.getAttr(self.name+'.pose', mi=1)

        index = 0
        if poseIndices:
            index = poseIndices[-1] + 1
        
        cmds.setAttr('{}.pose[{}].poseName'.format(self.name, index), poseName, type='string')


    def addPoseJoints(self, poseName, joints):
        '''Get joints that define the pose'''

        poseAttr = self.poseAttr(poseName)

        if type(joints) is not list:
            joints = [joints]

        for joint in joints:

            # Get joint index
            index = -1
            jointIndices = cmds.getAttr(self.name+'.joint', mi=1) or []
            for ji in jointIndices:
                conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji), s=1, d=0) or []
                if conns and conns[0] == joint:
                    index = ji
                    break

            # Connect joint
            if index == -1:
                if jointIndices:
                    index = jointIndices[-1] + 1
                else:
                    index = 0
                cmds.connectAttr(joint+'.rotate', '{}.joint[{}].jointRot'.format(self.name, index))

            # Set pose joint values
            rot = cmds.getAttr(joint+'.rotate')
            cmds.setAttr('{}.poseJoints[{}].poseJointRot'.format(poseAttr, index), *rot)

    def poseJoints(self, poseName):
        '''Get pose joint names'''

        poseAttr = self.poseAttr(poseName)

        joints = []
        jointIndices = cmds.getAttr('{}.poseJoints'.format(poseAttr) or []
        for ji in jointIndices:
            conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji)
            joints.append(conns[0])

        return joints
    
    def updatePoseJoints(self, poseName):
        '''Update pose joint values'''

        poseAttr = self.poseAttr(poseName)

        jointIndices = cmds.getAttr('{}.poseJoints'.format(poseAttr) or []
        for ji in jointIndices:
            conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji)

            # Set pose joint values
            rot = cmds.getAttr(conns[0]+'.rotate')
            cmds.setAttr('{}.poseJoints[{}].poseJointRot'.format(poseAttr, ji), *rot)


    def setPoseFallOff(self, poseName, fallOff):
        '''Set pose fallOff'''

        poseAttr = self.poseAttr(poseName)

        cmds.setAttr('{}.poseFallOff'.format(poseAttr), fallOff)

    def deletePose(self, poseName):
        '''Delete pose'''

        poseAttr = self.poseAttr(poseName)

        cmds.removeMultiInstance(poseAttr, b=1)


    def poseTargetAttr(self, poseName, targetName):
        '''Get pose target attr'''

        poseAttr = self.poseAttr(poseName)

        targetIndices = cmds.getAttr('{}.poseTarget'.format(poseAttr), mi=1) or []
        for ti in targetIndices:
            targetAttr = cmds.getAttr('{}.poseTarget[{}]'.format(poseAttr, ti),
            if cmds.getAttr('{}.poseTargetName'.format(targetAttr)) == targetName:
                return targetAttr

        raise RuntimeError('{} target doesnt exist in pose {}'.format(targetName, poseName))

    def initPoseTarget(self, poseName, targetName):
        '''Initialize to create/reset pose target'''

        if self._poseTarget:
            raise RuntimeError('Pose target is already initialized, set/update/cancel before re-initializing')

        # Find target index
        poseAttr = self.poseAttr(poseName)
        index = -1
        targetIndices = cmds.getAttr('{}.poseTarget'.format(poseAttr), mi=1) or []
        for ti in targetIndices:
            poseTargetAttr = cmds.getAttr('{}.poseTarget[{}]'.format(poseAttr, ti),
            if cmds.getAttr('{}.poseTargetName'.format(poseTargetAttr)) == targetName:
                index = ti
                break

        # Add new target entry
        if index == -1:
            if targetIndices:
                index = targetIndices[-1] + 1
            else:
                index = 0
            poseTargetAttr = cmds.getAttr('{}.poseTarget[{}]'.format(poseAttr, index)
            cmds.setAttr('{}.poseTargetName'.format(poseTargetAttr), targetName, type='string')


        # Duplicate geometry for target
        defGeom = cmds.deformer(self.name, q=1, g=1)
        cmds.hide(defGeom)
        duplicate = cmds.duplicate(defGeom)

        self._poseTarget = (poseTargetAttr, duplicate)
        
        print 'Edit the target geometry'

    def setPoseTarget(self):
        '''Set pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseTargetAttr, duplicate) = self._poseTarget

        cmds.select(duplicate)
        cmds.poseSpaceCommand(self.name, setPoseTarget=poseTargetAttr)

        self.cancelPoseTarget()
        

    def updatePoseTarget(self):
        '''Update pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseTargetAttr, duplicate) = self._poseTarget

        cmds.select(duplicate)
        cmds.poseSpaceCommand(self.name, updatePoseTarget=poseTargetAttr)

        self.cancelPoseTarget()

    def cancelPoseTarget(self):
        '''Cancel pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseTargetAttr, duplicate) = self._poseTarget

        cmds.delete(duplicate)

        defGeom = cmds.deformer(self.name, q=1, g=1)
        cmds.showHidden(defGeom)

    def deletePoseTarget(self, poseName, targetName):
        '''Delete pose target'''

        targetAttr = self.poseTargetAttr(poseName, targetName)

        cmds.removeMultiInstance(targetAttr, b=1)
