import os
import maya.cmds as cmds


PLUGINPATH = 'mayaPlugins'
PLUGIN = 'plugin'
NODETYPE = 'poseSpaceDeformer'

class PoseSpaceDeformer(object):

    name = None
    
    _poseTarget = None    

    @staticmethod
    def create(name='psd'):

        if not cmds.pluginInfo(PLUGIN, q=1, loaded=1):
            pluginPath = os.path.join(PLUGINPATH, PLUGIN)
            cmds.loadPlugin(pluginPath)

        sel = cmds.ls(sl=1)
        if not sel:
            raise RuntimeError('Objects should be selected to create PSD')

        if cmds.nodeType(sel[0]) == 'transform':
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

        name = cmds.deformer(type=NODETYPE, name=name)[0]

        cmds.connectAttr(skinCluster+'.weightList', name+'.skinClusterWeightList')

        return PoseSpaceDeformer(name)

    def __init__(self, name):
        
        if cmds.objExists(name) and cmds.nodeType(name) == NODETYPE:
            self.name = name
            return
        raise RuntimeError('{} is not of type {}'.format(name, NODETYPE))
    
    def poseNames(self):
        '''Get pose names'''

        poseIndices = cmds.getAttr(self.name+'.pose', mi=1) or []

        poseNames = []
        for pi in poseIndices:
            pn = cmds.getAttr('{}.pose[{}].poseName'.format(self.name, pi))
            poseNames.append(pn)
        return poseNames

    def poseIndex(self, poseName):
        '''Get pose index'''

        poseIndices = cmds.getAttr(self.name+'.pose', mi=1) or []

        for pi in poseIndices:
            poseAttr = '{}.pose[{}]'.format(self.name, pi)
            if poseName == cmds.getAttr('{}.poseName'.format(poseAttr)):
                return pi

        raise RuntimeError('{} pose doesnt exist'.format(poseName))        

    def poseAttr(self, poseName):
        '''Get pose attr'''

        index = self.poseIndex(poseName)

        return '{}.pose[{}]'.format(self.name, index)

    def poseWeight(self, poseName):
        
        poseAttr = self.poseAttr(poseName)
        return cmds.getAttr('{}.poseWeight'.format(poseAttr))
        
    def printPoseWeights(self):
        
        for p in self.poseNames():
            print '{}: {}'.format(p, self.poseWeight(p))
        
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
            cmds.setAttr('{}.poseJoint[{}].poseJointRot'.format(poseAttr, index), *rot[0])

    def poseJoints(self, poseName):
        '''Get pose joint names'''

        poseAttr = self.poseAttr(poseName)

        joints = []
        jointIndices = cmds.getAttr('{}.poseJoint'.format(poseAttr), mi=1) or []
        for ji in jointIndices:
            conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji))
            joints.append(conns[0])

        return joints
    
    def updatePoseJoints(self, poseName):
        '''Update pose joint values'''

        poseAttr = self.poseAttr(poseName)

        jointIndices = cmds.getAttr('{}.poseJoint'.format(poseAttr), mi=1) or []
        for ji in jointIndices:
            conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji))

            # Set pose joint values
            rot = cmds.getAttr(conns[0]+'.rotate')
            cmds.setAttr('{}.poseJoint[{}].poseJointRot'.format(poseAttr, ji), *rot[0])

    def setToPose(self, poseName):
        '''Set the joints to pose joint rotations'''

        poseAttr = self.poseAttr(poseName)

        jointIndices = cmds.getAttr('{}.poseJoint'.format(poseAttr), mi=1) or []
        for ji in jointIndices:

            rot = cmds.getAttr('{}.poseJoint[{}].poseJointRot'.format(poseAttr, ji))

            # Set joint values
            conns = cmds.listConnections('{}.joint[{}].jointRot'.format(self.name, ji))
            cmds.setAttr(conns[0]+'.rotate', *rot[0])


    def setPoseFallOff(self, poseName, fallOff):
        '''Set pose fallOff'''

        poseAttr = self.poseAttr(poseName)

        cmds.setAttr('{}.poseFallOff'.format(poseAttr), fallOff)

    def deletePose(self, poseName):
        '''Delete pose'''

        poseAttr = self.poseAttr(poseName)

        cmds.removeMultiInstance(poseAttr, b=1)

    def poseTargetIndex(self, poseName, targetName):

        poseAttr = self.poseAttr(poseName)

        targetIndices = cmds.getAttr('{}.poseTarget'.format(poseAttr), mi=1) or []
        for ti in targetIndices:
            targetAttr = '{}.poseTarget[{}]'.format(poseAttr, ti)
            if cmds.getAttr('{}.poseTargetName'.format(targetAttr)) == targetName:
                return ti

        raise RuntimeError('{} target doesnt exist in pose {}'.format(targetName, poseName))

    def poseTargetAttr(self, poseName, targetName):
        '''Get pose target attr'''

        index = self.poseTargetIndex(poseName, targetName)

        poseAttr = self.poseAttr(poseName)
        return '{}.poseTarget[{}]'.format(poseAttr, index)


    def poseTargets(self, poseName):
        '''Return target names'''

        poseAttr = self.poseAttr(poseName)

        targets = []
        targetIndices = cmds.getAttr('{}.poseTarget'.format(poseAttr), mi=1) or []
        for ti in targetIndices:
            targetName = cmds.getAttr('{}.poseTarget[{}].poseTargetName'.format(poseAttr, ti))
            targets.append(targetName)

        return targets


    def setPoseTargetEnvelope(self, poseName, targetName, envelope):
        
        targetAttr = self.poseTargetAttr(poseName, targetName)
        cmds.setAttr(targetAttr+'.poseTargetEnvelope', envelope)

    def initPoseTarget(self, poseName, targetName):
        '''Initialize to create/reset pose target'''

        if self._poseTarget:
            raise RuntimeError('Pose target is already initialized, set/update/cancel before re-initializing')

        poseAttr = self.poseAttr(poseName)

        # Duplicate geometry for target
        defGeom = cmds.deformer(self.name, q=1, g=1)
        duplicate = cmds.duplicate(defGeom)
        cmds.hide(defGeom)
        cmds.select(duplicate)

        self._poseTarget = (poseName, targetName, duplicate)
        
        cmds.warning('Edit the target geometry')
        return duplicate[0]

    def setPoseTarget(self):
        '''Set pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseName, targetName, duplicate) = self._poseTarget


        # Find target index
        poseAttr = self.poseAttr(poseName)
        index = -1
        targetIndices = cmds.getAttr('{}.poseTarget'.format(poseAttr), mi=1) or []
        for ti in targetIndices:
            poseTargetAttr = '{}.poseTarget[{}]'.format(poseAttr, ti)
            if cmds.getAttr('{}.poseTargetName'.format(poseTargetAttr)) == targetName:
                index = ti
                break

        # Add new target entry
        if index == -1:
            if targetIndices:
                index = targetIndices[-1] + 1
            else:
                index = 0
            poseTargetAttr = '{}.poseTarget[{}]'.format(poseAttr, index)
            cmds.setAttr('{}.poseTargetName'.format(poseTargetAttr), targetName, type='string')

            cmds.aliasAttr(poseName+'_'+targetName, poseTargetAttr+'.poseTargetEnvelope')

        poseIndex = self.poseIndex(poseName)
        targetIndex = index

        cmds.select(duplicate)
        cmds.poseSpaceCommand(self.name, setPoseTarget=[poseIndex, targetIndex])

        self.cancelPoseTarget()
        

    def updatePoseTarget(self):
        '''Update pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseName, targetName, duplicate) = self._poseTarget

        poseIndex = self.poseIndex(poseName)
        targetIndex = self.poseTargetIndex(poseName, targetName)

        cmds.select(duplicate)
        cmds.poseSpaceCommand(self.name, updatePoseTarget=[poseIndex, targetIndex])

        self.cancelPoseTarget()

    def cancelPoseTarget(self):
        '''Cancel pose target after initializing'''

        if not self._poseTarget:
            raise RuntimeError('Pose target should be initialized first')

        (poseName, targetName, duplicate) = self._poseTarget
        self._poseTarget = None

        cmds.delete(duplicate)

        defGeom = cmds.deformer(self.name, q=1, g=1)
        cmds.showHidden(defGeom)
        cmds.select(defGeom)

    def deletePoseTarget(self, poseName, targetName):
        '''Delete pose target'''

        targetAttr = self.poseTargetAttr(poseName, targetName)

        # Remove alias
        aliasAttrs = cmds.aliasAttr(self.name, q=1) or []
        envAttr = targetAttr+'.poseTargetEnvelope'
        for attr in aliasAttrs:
            if envAttr.endswith(attr):
                cmds.aliasAttr(envAttr, rm=1)

        cmds.removeMultiInstance(targetAttr, b=1)
