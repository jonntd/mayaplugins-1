from functools import partial
from psd import PoseSpaceDeformer


def showUI(psdName):
    
    psd = PoseSpaceDeformer(psdName)

    def setToPose(psd, poseName, v):
        psd.setToPose(poseName)
    
    def selectInScene(jt, v):
        cmds.select(jt)

    cmds.window()
    cmds.scrollLayout(horizontalScrollBarThickness=16, verticalScrollBarThickness=16)
    cmds.gridLayout( numberOfColumns=5, cellWidthHeight=(200, 25) )
    cmds.text(label='Pose')
    cmds.text(label='Weight')
    cmds.text(label='Joint')
    cmds.text(label='Rotation')
    cmds.text(label='FallOff')
    cmds.separator()
    cmds.separator()
    cmds.separator()
    cmds.separator()
    cmds.separator()
    for poseName in psd.poseNames():
        poseAttr = psd.poseAttr(poseName)
        cmds.text(label=poseName)
        cmds.attrControlGrp(attribute=poseAttr+'.poseWeight')
        jts = psd.poseJoints(poseName)
        if len(jts) == 1:
            cmds.button(label=jts[0], c=partial(selectInScene, jts[0]), ann='Click to select joint')
            jtIdx = cmds.getAttr(poseAttr+'.poseJoint', mi=1)[0]
            jtRot = cmds.getAttr('{}.poseJoint[{}].poseJointRot'.format(poseAttr, jtIdx))[0]
            jtRot = '{:.2f}, {:.2f}, {:.2f}'.format(jtRot[0], jtRot[1], jtRot[2])
            cmds.button(label=jtRot, c=partial(setToPose, psd, poseName), ann='Click to setToPose')
            cmds.attrControlGrp(attribute='{}.poseJoint[{}].poseJointFallOff'.format(poseAttr, jtIdx))
        else:
            cmds.text(label='multiple joints')
            cmds.text(label='')
            cmds.text(label='')
    cmds.showWindow()

#showUI('cn_body_hi_geo_poseDef')



def jointAxisUI(psdName):

    Axis = ['X', 'Y', 'Z', '-X', '-Y', '-Z']
    
    def changePrimaryAxis(psdName, jtIdx, axis):
        cmds.setAttr(psdName+'.joint[{}].jointAxis'.format(jtIdx), Axis.index(axis))
   
    cmds.window(title='SET PRIMARY AXIS')
    cmds.columnLayout()
    for i in cmds.getAttr(psdName+'.joint', mi=1):
        conns = cmds.listConnections(psdName+'.joint[{}].jointRot'.format(i))
        if conns:
            optionMenu = cmds.optionMenu( label='  {:50s}'.format(conns[0]), changeCommand=partial(changePrimaryAxis, psdName, i))
            for a in Axis:
                cmds.menuItem( label=a )
            cmds.optionMenu( optionMenu, e=1, select=cmds.getAttr(psdName+'.joint[{}].jointAxis'.format(i)) + 1)
    cmds.showWindow()

#jointAxisUI('cn_body_hi_geo_poseDef')