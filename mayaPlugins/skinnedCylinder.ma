//Maya ASCII 2015ff05 scene
//Name: skinnedCylinder.ma
//Last modified: Thu, May 14, 2015 10:57:26 AM
//Codeset: UTF-8
requires maya "2015ff05";
requires -nodeType "BFD_NullNode" "BFD_NullNode.py" "1.0";
requires -nodeType "ilrOptionsNode" -nodeType "ilrUIOptionsNode" -nodeType "ilrBakeLayerManager"
		 -nodeType "ilrBakeLayer" "Turtle" "2015.0.0";
currentUnit -l centimeter -a degree -t film;
fileInfo "application" "maya";
fileInfo "product" "Maya 2015";
fileInfo "version" "2015";
fileInfo "cutIdentifier" "201503261530-955654-1";
fileInfo "osv" "Linux 2.6.32-358.2.1.el6.x86_64 #1 SMP Tue Mar 12 14:18:09 CDT 2013 x86_64";
createNode transform -s -n "persp";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 199.83177348009178 125.28983141943036 687.82547585450743 ;
	setAttr ".r" -type "double3" -9.9218466252630861 16.199999999998308 2.0700403486599842e-16 ;
createNode camera -s -n "perspShape" -p "persp";
	setAttr -k off ".v" no;
	setAttr ".fl" 34.999999999999993;
	setAttr ".ncp" 1;
	setAttr ".fcp" 100000;
	setAttr ".coi" 727.14109001195891;
	setAttr ".imn" -type "string" "persp";
	setAttr ".den" -type "string" "persp_depth";
	setAttr ".man" -type "string" "persp_mask";
	setAttr ".hc" -type "string" "viewSet -p %camera";
createNode transform -s -n "top";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 200.09999999999997 0 ;
	setAttr ".r" -type "double3" -89.999999999999986 0 0 ;
createNode camera -s -n "topShape" -p "top";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".ncp" 1;
	setAttr ".fcp" 100000;
	setAttr ".coi" 200.09999999999997;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "top";
	setAttr ".den" -type "string" "top_depth";
	setAttr ".man" -type "string" "top_mask";
	setAttr ".hc" -type "string" "viewSet -t %camera";
	setAttr ".o" yes;
createNode transform -s -n "front";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 0 0 200.09999999999997 ;
createNode camera -s -n "frontShape" -p "front";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".ncp" 1;
	setAttr ".fcp" 100000;
	setAttr ".coi" 200.09999999999997;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "front";
	setAttr ".den" -type "string" "front_depth";
	setAttr ".man" -type "string" "front_mask";
	setAttr ".hc" -type "string" "viewSet -f %camera";
	setAttr ".o" yes;
createNode transform -s -n "side";
	setAttr ".v" no;
	setAttr ".t" -type "double3" 200.09999999999997 0 0 ;
	setAttr ".r" -type "double3" 0 89.999999999999986 0 ;
createNode camera -s -n "sideShape" -p "side";
	setAttr -k off ".v" no;
	setAttr ".rnd" no;
	setAttr ".ncp" 1;
	setAttr ".fcp" 100000;
	setAttr ".coi" 200.09999999999997;
	setAttr ".ow" 30;
	setAttr ".imn" -type "string" "side";
	setAttr ".den" -type "string" "side_depth";
	setAttr ".man" -type "string" "side_mask";
	setAttr ".hc" -type "string" "viewSet -s %camera";
	setAttr ".o" yes;
createNode transform -n "pCylinder1";
	setAttr ".t" -type "double3" 0 97.662383178362518 0 ;
	setAttr -l on ".tx";
	setAttr -l on ".ty";
	setAttr -l on ".tz";
	setAttr -l on ".rx";
	setAttr -l on ".ry";
	setAttr -l on ".rz";
	setAttr -l on ".sx";
	setAttr -l on ".sy";
	setAttr -l on ".sz";
createNode mesh -n "pCylinderShape1" -p "pCylinder1";
	setAttr -k off ".v";
	setAttr -s 6 ".iog[0].og";
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
	setAttr ".vcs" 2;
createNode mesh -n "pCylinderShape1Orig" -p "pCylinder1";
	setAttr -k off ".v";
	setAttr ".io" yes;
	setAttr ".vir" yes;
	setAttr ".vif" yes;
	setAttr ".uvst[0].uvsn" -type "string" "map1";
	setAttr ".cuvs" -type "string" "map1";
	setAttr ".dcc" -type "string" "Ambient+Diffuse";
	setAttr ".covm[0]"  0 1 1;
	setAttr ".cdvm[0]"  0 1 1;
createNode joint -n "joint1";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".jo" -type "double3" 0 121.27438097593466 0 ;
	setAttr ".bps" -type "matrix" -0.5191370003804554 0 -0.85469104057313194 0 0 1 0 0
		 0.85469104057313194 0 -0.5191370003804554 0 0 0 0 1;
	setAttr ".radi" 2;
createNode joint -n "joint2" -p "joint1";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".oc" 1;
	setAttr ".t" -type "double3" 2.9865722321170058e-30 96.314536256099558 2.1316282072803002e-14 ;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".bps" -type "matrix" -0.5191370003804554 0 -0.85469104057313194 0 0 1 0 0
		 0.85469104057313194 0 -0.5191370003804554 0 1.8218835305954396e-14 96.314536256099558 -1.1066070734538632e-14 1;
	setAttr ".radi" 2;
createNode joint -n "joint3" -p "joint2";
	addAttr -ci true -sn "liw" -ln "lockInfluenceWeights" -min 0 -max 1 -at "bool";
	setAttr ".uoc" 1;
	setAttr ".oc" 2;
	setAttr ".t" -type "double3" 0 100 -8.5265128291212022e-14 ;
	setAttr ".mnrl" -type "double3" -360 -360 -360 ;
	setAttr ".mxrl" -type "double3" 360 360 360 ;
	setAttr ".jo" -type "double3" 0 235.01106511876404 0 ;
	setAttr ".bps" -type "matrix" 0.99789919399637872 0 0.064785790273621024 0 0 1 0 0
		 -0.064785790273621024 0 0.99789919399637872 0 -5.4656505917863199e-14 196.31453625609956 3.3198212203615886e-14 1;
	setAttr ".radi" 2;
createNode lightLinker -s -n "lightLinker1";
	setAttr -s 2 ".lnk";
	setAttr -s 2 ".slnk";
createNode displayLayerManager -n "layerManager";
createNode displayLayer -n "defaultLayer";
createNode renderLayerManager -n "renderLayerManager";
createNode renderLayer -n "defaultRenderLayer";
	setAttr ".g" yes;
createNode ilrOptionsNode -s -n "TurtleRenderOptions";
lockNode -l 1 ;
createNode ilrUIOptionsNode -s -n "TurtleUIOptions";
lockNode -l 1 ;
createNode ilrBakeLayerManager -s -n "TurtleBakeLayerManager";
lockNode -l 1 ;
createNode ilrBakeLayer -s -n "TurtleDefaultBakeLayer";
lockNode -l 1 ;
createNode polyCylinder -n "polyCylinder1";
	setAttr ".r" 45.820612448739681;
	setAttr ".h" 195.32476635672504;
	setAttr ".sh" 13;
	setAttr ".sc" 2;
	setAttr ".cuv" 3;
createNode groupId -n "skinCluster1GroupId";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster1GroupParts";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode groupId -n "groupId2";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts2";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode BFD_NullNode -n "BFD_panelPrefs";
	addAttr -ci true -sn "BFD_panelPrefs" -ln "BFD_panelPrefs" -min 0 -max 1 -at "bool";
	addAttr -ci true -sn "panelsCount" -ln "panelsCount" -at "long";
	addAttr -ci true -sn "config" -ln "config" -dt "string";
	addAttr -ci true -m -sn "label" -ln "label" -dt "string";
	addAttr -ci true -m -sn "type" -ln "type" -dt "string";
	addAttr -ci true -m -sn "create" -ln "create" -dt "string";
	addAttr -ci true -m -sn "edit" -ln "edit" -dt "string";
	setAttr ".BFD_panelPrefs" yes;
	setAttr ".panelsCount" 2;
	setAttr ".config" -type "string" "global string $gMainPane; paneLayout -e -cn \"vertical2\" -ps 1 20 100 -ps 2 80 100 $gMainPane;";
	setAttr -s 2 ".label";
	setAttr ".label[0]" -type "string" "Outliner";
	setAttr ".label[1]" -type "string" "Persp View";
	setAttr -s 2 ".type";
	setAttr ".type[0]" -type "string" "outlinerPanel";
	setAttr ".type[1]" -type "string" "modelPanel";
	setAttr -s 2 ".create";
	setAttr ".create[0]" -type "string" (
		"$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels `;\n$editorName = $panelName;\noutlinerEditor -e \n    -docTag \"isolOutln_fromSeln\" \n    -showShapes 0\n    -showReferenceNodes 1\n    -showReferenceMembers 1\n    -showAttributes 0\n    -showConnected 0\n    -showAnimCurvesOnly 0\n    -showMuteInfo 0\n    -organizeByLayer 1\n    -showAnimLayerWeight 1\n    -autoExpandLayers 1\n    -autoExpand 0\n    -showDagOnly 1\n    -showAssets 1\n    -showContainedOnly 1\n    -showPublishedAsConnected 0\n    -showContainerContents 1\n    -ignoreDagHierarchy 0\n    -expandConnections 0\n    -showUpstreamCurves 1\n    -showUnitlessCurves 1\n    -showCompounds 1\n    -showLeafs 1\n    -showNumericAttrsOnly 0\n    -highlightActive 1\n    -autoSelectNewObjects 0\n    -doNotSelectNewObjects 0\n    -dropIsParent 1\n    -transmitFilters 0\n    -setFilter \"defaultSetFilter\" \n    -showSetMembers 1\n    -allowMultiSelection 1\n    -alwaysToggleSelect 0\n    -directSelect 0\n    -displayMode \"DAG\" \n    -expandObjects 0\n    -setsIgnoreFilters 1\n"
		+ "    -containersIgnoreFilters 0\n    -editAttrName 0\n    -showAttrValues 0\n    -highlightSecondary 0\n    -showUVAttrsOnly 0\n    -showTextureNodesOnly 0\n    -attrAlphaOrder \"default\" \n    -animLayerFilterOptions \"allAffecting\" \n    -sortOrder \"none\" \n    -longNames 0\n    -niceNames 1\n    -showNamespace 1\n    -showPinIcons 0\n    -mapMotionTrails 0\n    -ignoreHiddenAttribute 0\n    $editorName");
	setAttr ".create[1]" -type "string" (
		"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels `;\n$editorName = $panelName;\nmodelEditor -e \n    -cam `findStartUpCamera persp` \n    -useInteractiveMode 0\n    -displayLights \"default\" \n    -displayAppearance \"smoothShaded\" \n    -activeOnly 0\n    -ignorePanZoom 0\n    -wireframeOnShaded 1\n    -headsUpDisplay 1\n    -selectionHiliteDisplay 1\n    -useDefaultMaterial 0\n    -bufferMode \"double\" \n    -twoSidedLighting 0\n    -backfaceCulling 0\n    -xray 1\n    -jointXray 0\n    -activeComponentsXray 0\n    -displayTextures 0\n    -smoothWireframe 0\n    -lineWidth 1\n    -textureAnisotropic 0\n    -textureHilight 1\n    -textureSampling 2\n    -textureDisplay \"modulate\" \n    -textureMaxSize 8192\n    -fogging 0\n    -fogSource \"fragment\" \n    -fogMode \"linear\" \n    -fogStart 0\n    -fogEnd 100\n    -fogDensity 0.1\n    -fogColor 0.5 0.5 0.5 1 \n    -maxConstantTransparency 1\n    -rendererName \"base_OpenGL_Renderer\" \n    -objectFilterShowInHUD 1\n    -isFiltered 0\n    -colorResolution 256 256 \n"
		+ "    -bumpResolution 512 512 \n    -textureCompression 0\n    -transparencyAlgorithm \"frontAndBackCull\" \n    -transpInShadows 0\n    -cullingOverride \"none\" \n    -lowQualityLighting 0\n    -maximumNumHardwareLights 1\n    -occlusionCulling 0\n    -shadingModel 0\n    -useBaseRenderer 0\n    -useReducedRenderer 0\n    -smallObjectCulling 0\n    -smallObjectThreshold -1 \n    -interactiveDisableShadows 0\n    -interactiveBackFaceCull 0\n    -sortTransparent 1\n    -nurbsCurves 1\n    -nurbsSurfaces 1\n    -polymeshes 1\n    -subdivSurfaces 1\n    -planes 1\n    -lights 1\n    -cameras 1\n    -controlVertices 0\n    -hulls 0\n    -grid 1\n    -imagePlane 0\n    -joints 1\n    -ikHandles 1\n    -deformers 1\n    -dynamics 1\n    -particleInstancers 0\n    -fluids 0\n    -hairSystems 0\n    -follicles 0\n    -nCloths 0\n    -nParticles 0\n    -nRigids 0\n    -dynamicConstraints 0\n    -locators 1\n    -manipulators 1\n    -pluginShapes 0\n    -dimensions 1\n    -handles 1\n    -pivots 1\n    -textures 1\n    -strokes 1\n    -motionTrails 0\n    -clipGhosts 0\n    -greasePencils 0\n"
		+ "    -shadows 0\n    $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\nmodelEditor -e \n    -pluginObjects \"gpuCacheDisplayFilter\" 1 \n    $editorName");
	setAttr -s 2 ".edit";
	setAttr ".edit[0]" -type "string" (
		"outlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n$editorName = $panelName;\noutlinerEditor -e \n    -docTag \"isolOutln_fromSeln\" \n    -showShapes 0\n    -showReferenceNodes 1\n    -showReferenceMembers 1\n    -showAttributes 0\n    -showConnected 0\n    -showAnimCurvesOnly 0\n    -showMuteInfo 0\n    -organizeByLayer 1\n    -showAnimLayerWeight 1\n    -autoExpandLayers 1\n    -autoExpand 0\n    -showDagOnly 1\n    -showAssets 1\n    -showContainedOnly 1\n    -showPublishedAsConnected 0\n    -showContainerContents 1\n    -ignoreDagHierarchy 0\n    -expandConnections 0\n    -showUpstreamCurves 1\n    -showUnitlessCurves 1\n    -showCompounds 1\n    -showLeafs 1\n    -showNumericAttrsOnly 0\n    -highlightActive 1\n    -autoSelectNewObjects 0\n    -doNotSelectNewObjects 0\n    -dropIsParent 1\n    -transmitFilters 0\n    -setFilter \"defaultSetFilter\" \n    -showSetMembers 1\n    -allowMultiSelection 1\n    -alwaysToggleSelect 0\n    -directSelect 0\n    -displayMode \"DAG\" \n    -expandObjects 0\n    -setsIgnoreFilters 1\n"
		+ "    -containersIgnoreFilters 0\n    -editAttrName 0\n    -showAttrValues 0\n    -highlightSecondary 0\n    -showUVAttrsOnly 0\n    -showTextureNodesOnly 0\n    -attrAlphaOrder \"default\" \n    -animLayerFilterOptions \"allAffecting\" \n    -sortOrder \"none\" \n    -longNames 0\n    -niceNames 1\n    -showNamespace 1\n    -showPinIcons 0\n    -mapMotionTrails 0\n    -ignoreHiddenAttribute 0\n    $editorName");
	setAttr ".edit[1]" -type "string" (
		"modelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n$editorName = $panelName;\nmodelEditor -e \n    -cam `findStartUpCamera persp` \n    -useInteractiveMode 0\n    -displayLights \"default\" \n    -displayAppearance \"smoothShaded\" \n    -activeOnly 0\n    -ignorePanZoom 0\n    -wireframeOnShaded 1\n    -headsUpDisplay 1\n    -selectionHiliteDisplay 1\n    -useDefaultMaterial 0\n    -bufferMode \"double\" \n    -twoSidedLighting 0\n    -backfaceCulling 0\n    -xray 1\n    -jointXray 0\n    -activeComponentsXray 0\n    -displayTextures 0\n    -smoothWireframe 0\n    -lineWidth 1\n    -textureAnisotropic 0\n    -textureHilight 1\n    -textureSampling 2\n    -textureDisplay \"modulate\" \n    -textureMaxSize 8192\n    -fogging 0\n    -fogSource \"fragment\" \n    -fogMode \"linear\" \n    -fogStart 0\n    -fogEnd 100\n    -fogDensity 0.1\n    -fogColor 0.5 0.5 0.5 1 \n    -maxConstantTransparency 1\n    -rendererName \"base_OpenGL_Renderer\" \n    -objectFilterShowInHUD 1\n    -isFiltered 0\n    -colorResolution 256 256 \n"
		+ "    -bumpResolution 512 512 \n    -textureCompression 0\n    -transparencyAlgorithm \"frontAndBackCull\" \n    -transpInShadows 0\n    -cullingOverride \"none\" \n    -lowQualityLighting 0\n    -maximumNumHardwareLights 1\n    -occlusionCulling 0\n    -shadingModel 0\n    -useBaseRenderer 0\n    -useReducedRenderer 0\n    -smallObjectCulling 0\n    -smallObjectThreshold -1 \n    -interactiveDisableShadows 0\n    -interactiveBackFaceCull 0\n    -sortTransparent 1\n    -nurbsCurves 1\n    -nurbsSurfaces 1\n    -polymeshes 1\n    -subdivSurfaces 1\n    -planes 1\n    -lights 1\n    -cameras 1\n    -controlVertices 0\n    -hulls 0\n    -grid 1\n    -imagePlane 0\n    -joints 1\n    -ikHandles 1\n    -deformers 1\n    -dynamics 1\n    -particleInstancers 0\n    -fluids 0\n    -hairSystems 0\n    -follicles 0\n    -nCloths 0\n    -nParticles 0\n    -nRigids 0\n    -dynamicConstraints 0\n    -locators 1\n    -manipulators 1\n    -pluginShapes 0\n    -dimensions 1\n    -handles 1\n    -pivots 1\n    -textures 1\n    -strokes 1\n    -motionTrails 0\n    -clipGhosts 0\n    -greasePencils 0\n"
		+ "    -shadows 0\n    $editorName;\nmodelEditor -e -viewSelected 0 $editorName;\nmodelEditor -e \n    -pluginObjects \"gpuCacheDisplayFilter\" 1 \n    $editorName");
createNode hyperGraphInfo -n "nodeEditorPanel1Info";
createNode hyperView -n "hyperView1";
	setAttr ".dag" no;
createNode hyperLayout -n "hyperLayout1";
	setAttr ".ihi" 0;
	setAttr -s 24 ".hyp";
	setAttr ".hyp[0].x" 532.85711669921875;
	setAttr ".hyp[0].y" -72.857139587402344;
	setAttr ".hyp[0].nvs" 1920;
	setAttr ".hyp[1].x" 772.85711669921875;
	setAttr ".hyp[1].y" -72.857139587402344;
	setAttr ".hyp[1].nvs" 1920;
	setAttr ".hyp[2].x" 1.4285714626312256;
	setAttr ".hyp[2].y" -72.857139587402344;
	setAttr ".hyp[2].nvs" 1920;
	setAttr ".hyp[3].x" 241.42857360839844;
	setAttr ".hyp[3].y" -72.857139587402344;
	setAttr ".hyp[3].nvs" 1920;
	setAttr ".hyp[4].nvs" 1920;
	setAttr ".hyp[5].nvs" 1920;
	setAttr ".hyp[6].nvs" 1920;
	setAttr ".hyp[7].nvs" 1920;
	setAttr ".hyp[8].nvs" 1920;
	setAttr ".hyp[9].nvs" 1920;
	setAttr ".hyp[10].nvs" 1920;
	setAttr ".hyp[11].nvs" 1920;
	setAttr ".hyp[12].nvs" 1920;
	setAttr ".hyp[13].nvs" 1920;
	setAttr ".hyp[14].nvs" 1920;
	setAttr ".hyp[15].nvs" 1920;
	setAttr ".hyp[16].nvs" 1920;
	setAttr ".hyp[17].nvs" 1920;
	setAttr ".hyp[18].nvs" 1920;
	setAttr ".hyp[19].nvs" 1920;
	setAttr ".hyp[20].nvs" 1920;
	setAttr ".hyp[21].nvs" 1920;
	setAttr ".hyp[22].nvs" 1920;
	setAttr ".hyp[23].nvs" 1920;
	setAttr ".anf" yes;
createNode script -n "uiConfigurationScriptNode";
	setAttr ".b" -type "string" (
		"// Maya Mel UI Configuration File.\n//\n//  This script is machine generated.  Edit at your own risk.\n//\n//\n\nglobal string $gMainPane;\nif (`paneLayout -exists $gMainPane`) {\n\n\tglobal int $gUseScenePanelConfig;\n\tint    $useSceneConfig = $gUseScenePanelConfig;\n\tint    $menusOkayInPanels = `optionVar -q allowMenusInPanels`;\tint    $nVisPanes = `paneLayout -q -nvp $gMainPane`;\n\tint    $nPanes = 0;\n\tstring $editorName;\n\tstring $panelName;\n\tstring $itemFilterName;\n\tstring $panelConfig;\n\n\t//\n\t//  get current state of the UI\n\t//\n\tsceneUIReplacement -update $gMainPane;\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Top View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"top\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n"
		+ "                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -rendererName \"base_OpenGL_Renderer\" \n"
		+ "                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n"
		+ "                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Top View\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"top\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n"
		+ "            -rendererName \"base_OpenGL_Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n"
		+ "            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Side View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"side\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n"
		+ "                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -rendererName \"base_OpenGL_Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n"
		+ "                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n"
		+ "                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Side View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"side\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n"
		+ "            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -rendererName \"base_OpenGL_Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n"
		+ "            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Front View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"front\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n"
		+ "                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -rendererName \"base_OpenGL_Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n"
		+ "                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n"
		+ "                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Front View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"front\" \n            -useInteractiveMode 0\n            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 0\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n"
		+ "            -backfaceCulling 0\n            -xray 0\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -rendererName \"base_OpenGL_Renderer\" \n            -objectFilterShowInHUD 1\n            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n"
		+ "            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 1\n            -hulls 1\n            -grid 1\n            -imagePlane 1\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 1\n            -fluids 1\n            -hairSystems 1\n            -follicles 1\n            -nCloths 1\n            -nParticles 1\n            -nRigids 1\n            -dynamicConstraints 1\n            -locators 1\n            -manipulators 1\n            -pluginShapes 1\n            -dimensions 1\n            -handles 1\n            -pivots 1\n"
		+ "            -textures 1\n            -strokes 1\n            -motionTrails 1\n            -clipGhosts 1\n            -greasePencils 1\n            -shadows 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"modelPanel\" (localizedPanelLabel(\"Persp View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `modelPanel -unParent -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            modelEditor -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 1\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n"
		+ "                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 1\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -rendererName \"base_OpenGL_Renderer\" \n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 256 256 \n                -bumpResolution 512 512 \n                -textureCompression 0\n"
		+ "                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 1\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 0\n                -hulls 0\n                -grid 1\n                -imagePlane 0\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 0\n"
		+ "                -fluids 0\n                -hairSystems 0\n                -follicles 0\n                -nCloths 0\n                -nParticles 0\n                -nRigids 0\n                -dynamicConstraints 0\n                -locators 1\n                -manipulators 1\n                -pluginShapes 0\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 0\n                -clipGhosts 0\n                -greasePencils 0\n                -shadows 0\n                $editorName;\n            modelEditor -e -viewSelected 0 $editorName;\n            modelEditor -e \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tmodelPanel -edit -l (localizedPanelLabel(\"Persp View\")) -mbv $menusOkayInPanels  $panelName;\n\t\t$editorName = $panelName;\n        modelEditor -e \n            -camera \"persp\" \n            -useInteractiveMode 0\n"
		+ "            -displayLights \"default\" \n            -displayAppearance \"smoothShaded\" \n            -activeOnly 0\n            -ignorePanZoom 0\n            -wireframeOnShaded 1\n            -headsUpDisplay 1\n            -selectionHiliteDisplay 1\n            -useDefaultMaterial 0\n            -bufferMode \"double\" \n            -twoSidedLighting 0\n            -backfaceCulling 0\n            -xray 1\n            -jointXray 0\n            -activeComponentsXray 0\n            -displayTextures 0\n            -smoothWireframe 0\n            -lineWidth 1\n            -textureAnisotropic 0\n            -textureHilight 1\n            -textureSampling 2\n            -textureDisplay \"modulate\" \n            -textureMaxSize 8192\n            -fogging 0\n            -fogSource \"fragment\" \n            -fogMode \"linear\" \n            -fogStart 0\n            -fogEnd 100\n            -fogDensity 0.1\n            -fogColor 0.5 0.5 0.5 1 \n            -maxConstantTransparency 1\n            -rendererName \"base_OpenGL_Renderer\" \n            -objectFilterShowInHUD 1\n"
		+ "            -isFiltered 0\n            -colorResolution 256 256 \n            -bumpResolution 512 512 \n            -textureCompression 0\n            -transparencyAlgorithm \"frontAndBackCull\" \n            -transpInShadows 0\n            -cullingOverride \"none\" \n            -lowQualityLighting 0\n            -maximumNumHardwareLights 1\n            -occlusionCulling 0\n            -shadingModel 0\n            -useBaseRenderer 0\n            -useReducedRenderer 0\n            -smallObjectCulling 0\n            -smallObjectThreshold -1 \n            -interactiveDisableShadows 0\n            -interactiveBackFaceCull 0\n            -sortTransparent 1\n            -nurbsCurves 1\n            -nurbsSurfaces 1\n            -polymeshes 1\n            -subdivSurfaces 1\n            -planes 1\n            -lights 1\n            -cameras 1\n            -controlVertices 0\n            -hulls 0\n            -grid 1\n            -imagePlane 0\n            -joints 1\n            -ikHandles 1\n            -deformers 1\n            -dynamics 1\n            -particleInstancers 0\n"
		+ "            -fluids 0\n            -hairSystems 0\n            -follicles 0\n            -nCloths 0\n            -nParticles 0\n            -nRigids 0\n            -dynamicConstraints 0\n            -locators 1\n            -manipulators 1\n            -pluginShapes 0\n            -dimensions 1\n            -handles 1\n            -pivots 1\n            -textures 1\n            -strokes 1\n            -motionTrails 0\n            -clipGhosts 0\n            -greasePencils 0\n            -shadows 0\n            $editorName;\n        modelEditor -e -viewSelected 0 $editorName;\n        modelEditor -e \n            -pluginObjects \"gpuCacheDisplayFilter\" 1 \n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"outlinerPanel\" (localizedPanelLabel(\"Outliner\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels `;\n\t\t\t$editorName = $panelName;\n            outlinerEditor -e \n"
		+ "                -docTag \"isolOutln_fromSeln\" \n                -showShapes 0\n                -showReferenceNodes 1\n                -showReferenceMembers 1\n                -showAttributes 0\n                -showConnected 0\n                -showAnimCurvesOnly 0\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 1\n                -showAssets 1\n                -showContainedOnly 1\n                -showPublishedAsConnected 0\n                -showContainerContents 1\n                -ignoreDagHierarchy 0\n                -expandConnections 0\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 0\n                -highlightActive 1\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 0\n"
		+ "                -setFilter \"defaultSetFilter\" \n                -showSetMembers 1\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 0\n                -ignoreHiddenAttribute 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\toutlinerPanel -edit -l (localizedPanelLabel(\"Outliner\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\t$editorName = $panelName;\n        outlinerEditor -e \n            -docTag \"isolOutln_fromSeln\" \n            -showShapes 0\n            -showReferenceNodes 1\n            -showReferenceMembers 1\n            -showAttributes 0\n            -showConnected 0\n            -showAnimCurvesOnly 0\n            -showMuteInfo 0\n            -organizeByLayer 1\n            -showAnimLayerWeight 1\n            -autoExpandLayers 1\n            -autoExpand 0\n            -showDagOnly 1\n            -showAssets 1\n            -showContainedOnly 1\n            -showPublishedAsConnected 0\n            -showContainerContents 1\n            -ignoreDagHierarchy 0\n            -expandConnections 0\n            -showUpstreamCurves 1\n            -showUnitlessCurves 1\n            -showCompounds 1\n            -showLeafs 1\n            -showNumericAttrsOnly 0\n            -highlightActive 1\n            -autoSelectNewObjects 0\n            -doNotSelectNewObjects 0\n            -dropIsParent 1\n            -transmitFilters 0\n            -setFilter \"defaultSetFilter\" \n"
		+ "            -showSetMembers 1\n            -allowMultiSelection 1\n            -alwaysToggleSelect 0\n            -directSelect 0\n            -displayMode \"DAG\" \n            -expandObjects 0\n            -setsIgnoreFilters 1\n            -containersIgnoreFilters 0\n            -editAttrName 0\n            -showAttrValues 0\n            -highlightSecondary 0\n            -showUVAttrsOnly 0\n            -showTextureNodesOnly 0\n            -attrAlphaOrder \"default\" \n            -animLayerFilterOptions \"allAffecting\" \n            -sortOrder \"none\" \n            -longNames 0\n            -niceNames 1\n            -showNamespace 1\n            -showPinIcons 0\n            -mapMotionTrails 0\n            -ignoreHiddenAttribute 0\n            $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"graphEditor\" (localizedPanelLabel(\"Graph Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"graphEditor\" -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n"
		+ "                -transmitFilters 1\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n"
		+ "                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -stackedCurves 0\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Graph Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n"
		+ "                -showShapes 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 1\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 1\n                -showCompounds 0\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 1\n                -doNotSelectNewObjects 0\n                -dropIsParent 1\n                -transmitFilters 1\n                -setFilter \"0\" \n"
		+ "                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 1\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"GraphEd\");\n            animCurveEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 1\n"
		+ "                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -showResults \"off\" \n                -showBufferCurves \"off\" \n                -smoothness \"fine\" \n                -resultSamples 1\n                -resultScreenSamples 0\n                -resultUpdate \"delayed\" \n                -showUpstreamCurves 1\n                -stackedCurves 0\n                -stackedCurvesMin -1\n                -stackedCurvesMax 1\n                -stackedCurvesSpace 0.2\n                -displayNormalized 0\n                -preSelectionHighlight 0\n                -constrainDrag 0\n                -classicMode 1\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dopeSheetPanel\" (localizedPanelLabel(\"Dope Sheet\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dopeSheetPanel\" -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n"
		+ "                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n"
		+ "                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dope Sheet\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"OutlineEd\");\n            outlinerEditor -e \n                -showShapes 1\n                -showReferenceNodes 0\n                -showReferenceMembers 0\n                -showAttributes 1\n                -showConnected 1\n                -showAnimCurvesOnly 1\n                -showMuteInfo 0\n                -organizeByLayer 1\n                -showAnimLayerWeight 1\n                -autoExpandLayers 1\n"
		+ "                -autoExpand 0\n                -showDagOnly 0\n                -showAssets 1\n                -showContainedOnly 0\n                -showPublishedAsConnected 0\n                -showContainerContents 0\n                -ignoreDagHierarchy 0\n                -expandConnections 1\n                -showUpstreamCurves 1\n                -showUnitlessCurves 0\n                -showCompounds 1\n                -showLeafs 1\n                -showNumericAttrsOnly 1\n                -highlightActive 0\n                -autoSelectNewObjects 0\n                -doNotSelectNewObjects 1\n                -dropIsParent 1\n                -transmitFilters 0\n                -setFilter \"0\" \n                -showSetMembers 0\n                -allowMultiSelection 1\n                -alwaysToggleSelect 0\n                -directSelect 0\n                -displayMode \"DAG\" \n                -expandObjects 0\n                -setsIgnoreFilters 1\n                -containersIgnoreFilters 0\n                -editAttrName 0\n                -showAttrValues 0\n"
		+ "                -highlightSecondary 0\n                -showUVAttrsOnly 0\n                -showTextureNodesOnly 0\n                -attrAlphaOrder \"default\" \n                -animLayerFilterOptions \"allAffecting\" \n                -sortOrder \"none\" \n                -longNames 0\n                -niceNames 1\n                -showNamespace 1\n                -showPinIcons 0\n                -mapMotionTrails 1\n                -ignoreHiddenAttribute 0\n                $editorName;\n\n\t\t\t$editorName = ($panelName+\"DopeSheetEd\");\n            dopeSheetEditor -e \n                -displayKeys 1\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"integer\" \n                -snapValue \"none\" \n                -outliner \"dopeSheetPanel1OutlineEd\" \n                -showSummary 1\n                -showScene 0\n                -hierarchyBelow 0\n                -showTicks 1\n                -selectionWindow 0 0 0 0 \n"
		+ "                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"clipEditorPanel\" (localizedPanelLabel(\"Trax Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"clipEditorPanel\" -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -manageSequencer 0 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Trax Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = clipEditorNameFromPanel($panelName);\n"
		+ "            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -manageSequencer 0 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"sequenceEditorPanel\" (localizedPanelLabel(\"Camera Sequencer\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"sequenceEditorPanel\" -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n"
		+ "                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -manageSequencer 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Camera Sequencer\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = sequenceEditorNameFromPanel($panelName);\n            clipEditor -e \n                -displayKeys 0\n                -displayTangents 0\n                -displayActiveKeys 0\n                -displayActiveKeyTangents 0\n                -displayInfinities 0\n                -autoFit 0\n                -snapTime \"none\" \n                -snapValue \"none\" \n                -manageSequencer 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperGraphPanel\" (localizedPanelLabel(\"Hypergraph Hierarchy\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperGraphPanel\" -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels `;\n"
		+ "\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showConnectionFromSelected 0\n                -showConnectionToSelected 0\n                -showConstraintLabels 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n"
		+ "                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypergraph Hierarchy\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"HyperGraphEd\");\n            hyperGraph -e \n                -graphLayoutStyle \"hierarchicalLayout\" \n                -orientation \"horiz\" \n                -mergeConnections 0\n                -zoom 1\n                -animateTransition 0\n                -showRelationships 1\n                -showShapes 0\n                -showDeformers 0\n                -showExpressions 0\n                -showConstraints 0\n                -showConnectionFromSelected 0\n                -showConnectionToSelected 0\n                -showConstraintLabels 0\n                -showUnderworld 0\n                -showInvisible 0\n                -transitionFrames 1\n                -opaqueContainers 0\n                -freeform 0\n"
		+ "                -imagePosition 0 0 \n                -imageScale 1\n                -imageEnabled 0\n                -graphType \"DAG\" \n                -heatMapDisplay 0\n                -updateSelection 1\n                -updateNodeAdded 1\n                -useDrawOverrideColor 0\n                -limitGraphTraversal -1\n                -range 0 0 \n                -iconSize \"smallIcons\" \n                -showCachedConnections 0\n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"hyperShadePanel\" (localizedPanelLabel(\"Hypershade\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"hyperShadePanel\" -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Hypershade\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n"
		+ "\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"visorPanel\" (localizedPanelLabel(\"Visor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"visorPanel\" -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Visor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"nodeEditorPanel\" (localizedPanelLabel(\"Node Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"nodeEditorPanel\" -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels `;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n"
		+ "                -defaultPinnedState 0\n                -ignoreAssets 1\n                -additiveGraphingMode 0\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -keyReleaseCommand \"nodeEdKeyReleaseCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                $editorName;\n\t\t\tif (`objExists nodeEditorPanel1Info`) nodeEditor -e -restoreInfo nodeEditorPanel1Info $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Node Editor\")) -mbv $menusOkayInPanels  $panelName;\n\n\t\t\t$editorName = ($panelName+\"NodeEditorEd\");\n"
		+ "            nodeEditor -e \n                -allAttributes 0\n                -allNodes 0\n                -autoSizeNodes 1\n                -createNodeCommand \"nodeEdCreateNodeCommand\" \n                -defaultPinnedState 0\n                -ignoreAssets 1\n                -additiveGraphingMode 0\n                -settingsChangedCallback \"nodeEdSyncControls\" \n                -traversalDepthLimit -1\n                -keyPressCommand \"nodeEdKeyPressCommand\" \n                -keyReleaseCommand \"nodeEdKeyReleaseCommand\" \n                -nodeTitleMode \"name\" \n                -gridSnap 0\n                -gridVisibility 1\n                -popupMenuScript \"nodeEdBuildPanelMenus\" \n                -showNamespace 1\n                -showShapes 1\n                -showSGShapes 0\n                -showTransforms 1\n                -useAssets 1\n                -syncedSelection 1\n                -extendToShapes 1\n                $editorName;\n\t\t\tif (`objExists nodeEditorPanel1Info`) nodeEditor -e -restoreInfo nodeEditorPanel1Info $editorName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"createNodePanel\" (localizedPanelLabel(\"Create Node\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"createNodePanel\" -l (localizedPanelLabel(\"Create Node\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Create Node\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"polyTexturePlacementPanel\" (localizedPanelLabel(\"UV Texture Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"polyTexturePlacementPanel\" -l (localizedPanelLabel(\"UV Texture Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"UV Texture Editor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"renderWindowPanel\" (localizedPanelLabel(\"Render View\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"renderWindowPanel\" -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Render View\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextPanel \"blendShapePanel\" (localizedPanelLabel(\"Blend Shape\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\tblendShapePanel -unParent -l (localizedPanelLabel(\"Blend Shape\")) -mbv $menusOkayInPanels ;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tblendShapePanel -edit -l (localizedPanelLabel(\"Blend Shape\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n"
		+ "\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynRelEdPanel\" (localizedPanelLabel(\"Dynamic Relationships\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynRelEdPanel\" -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Dynamic Relationships\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"relationshipPanel\" (localizedPanelLabel(\"Relationship Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"relationshipPanel\" -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Relationship Editor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"referenceEditorPanel\" (localizedPanelLabel(\"Reference Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"referenceEditorPanel\" -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Reference Editor\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"componentEditorPanel\" (localizedPanelLabel(\"Component Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"componentEditorPanel\" -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Component Editor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"dynPaintScriptedPanelType\" (localizedPanelLabel(\"Paint Effects\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"dynPaintScriptedPanelType\" -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Paint Effects\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"scriptEditorPanel\" (localizedPanelLabel(\"Script Editor\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"scriptEditorPanel\" -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Script Editor\")) -mbv $menusOkayInPanels  $panelName;\n"
		+ "\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\tif ($useSceneConfig) {\n\t\tscriptedPanel -e -to $panelName;\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"profilerPanel\" (localizedPanelLabel(\"Profiler Tool\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"profilerPanel\" -l (localizedPanelLabel(\"Profiler Tool\")) -mbv $menusOkayInPanels `;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Profiler Tool\")) -mbv $menusOkayInPanels  $panelName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\t$panelName = `sceneUIReplacement -getNextScriptedPanel \"Stereo\" (localizedPanelLabel(\"Stereo\")) `;\n\tif (\"\" == $panelName) {\n\t\tif ($useSceneConfig) {\n\t\t\t$panelName = `scriptedPanel -unParent  -type \"Stereo\" -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels `;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n"
		+ "                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n"
		+ "                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n"
		+ "                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n"
		+ "                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\t}\n\t} else {\n\t\t$label = `panel -q -label $panelName`;\n\t\tscriptedPanel -edit -l (localizedPanelLabel(\"Stereo\")) -mbv $menusOkayInPanels  $panelName;\nstring $editorName = ($panelName+\"Editor\");\n            stereoCameraView -e \n                -camera \"persp\" \n                -useInteractiveMode 0\n                -displayLights \"default\" \n                -displayAppearance \"smoothShaded\" \n                -activeOnly 0\n                -ignorePanZoom 0\n                -wireframeOnShaded 0\n                -headsUpDisplay 1\n                -selectionHiliteDisplay 1\n                -useDefaultMaterial 0\n                -bufferMode \"double\" \n                -twoSidedLighting 0\n                -backfaceCulling 0\n                -xray 0\n                -jointXray 0\n                -activeComponentsXray 0\n                -displayTextures 0\n                -smoothWireframe 0\n                -lineWidth 1\n                -textureAnisotropic 0\n"
		+ "                -textureHilight 1\n                -textureSampling 2\n                -textureDisplay \"modulate\" \n                -textureMaxSize 8192\n                -fogging 0\n                -fogSource \"fragment\" \n                -fogMode \"linear\" \n                -fogStart 0\n                -fogEnd 100\n                -fogDensity 0.1\n                -fogColor 0.5 0.5 0.5 1 \n                -maxConstantTransparency 1\n                -objectFilterShowInHUD 1\n                -isFiltered 0\n                -colorResolution 4 4 \n                -bumpResolution 4 4 \n                -textureCompression 0\n                -transparencyAlgorithm \"frontAndBackCull\" \n                -transpInShadows 0\n                -cullingOverride \"none\" \n                -lowQualityLighting 0\n                -maximumNumHardwareLights 0\n                -occlusionCulling 0\n                -shadingModel 0\n                -useBaseRenderer 0\n                -useReducedRenderer 0\n                -smallObjectCulling 0\n                -smallObjectThreshold -1 \n"
		+ "                -interactiveDisableShadows 0\n                -interactiveBackFaceCull 0\n                -sortTransparent 1\n                -nurbsCurves 1\n                -nurbsSurfaces 1\n                -polymeshes 1\n                -subdivSurfaces 1\n                -planes 1\n                -lights 1\n                -cameras 1\n                -controlVertices 1\n                -hulls 1\n                -grid 1\n                -imagePlane 1\n                -joints 1\n                -ikHandles 1\n                -deformers 1\n                -dynamics 1\n                -particleInstancers 1\n                -fluids 1\n                -hairSystems 1\n                -follicles 1\n                -nCloths 1\n                -nParticles 1\n                -nRigids 1\n                -dynamicConstraints 1\n                -locators 1\n                -manipulators 1\n                -pluginShapes 1\n                -dimensions 1\n                -handles 1\n                -pivots 1\n                -textures 1\n                -strokes 1\n"
		+ "                -motionTrails 1\n                -clipGhosts 1\n                -greasePencils 1\n                -shadows 0\n                -displayMode \"centerEye\" \n                -viewColor 0 0 0 1 \n                -useCustomBackground 1\n                $editorName;\n            stereoCameraView -e -viewSelected 0 $editorName;\n            stereoCameraView -e \n                -pluginObjects \"gpuCacheDisplayFilter\" 1 \n                $editorName;\n\t\tif (!$useSceneConfig) {\n\t\t\tpanel -e -l $label $panelName;\n\t\t}\n\t}\n\n\n\tif ($useSceneConfig) {\n        string $configName = `getPanel -cwl (localizedPanelLabel(\"Current Layout\"))`;\n        if (\"\" != $configName) {\n\t\t\tpanelConfiguration -edit -label (localizedPanelLabel(\"Current Layout\")) \n\t\t\t\t-defaultImage \"vacantCell.xP:/\"\n\t\t\t\t-image \"\"\n\t\t\t\t-sc false\n\t\t\t\t-configString \"global string $gMainPane; paneLayout -e -cn \\\"vertical2\\\" -ps 1 20 100 -ps 2 80 100 $gMainPane;\"\n\t\t\t\t-removeAllPanels\n\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Outliner\")) \n\t\t\t\t\t\"outlinerPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `outlinerPanel -unParent -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t\t\"outlinerPanel -edit -l (localizedPanelLabel(\\\"Outliner\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\noutlinerEditor -e \\n    -docTag \\\"isolOutln_fromSeln\\\" \\n    -showShapes 0\\n    -showReferenceNodes 1\\n    -showReferenceMembers 1\\n    -showAttributes 0\\n    -showConnected 0\\n    -showAnimCurvesOnly 0\\n    -showMuteInfo 0\\n    -organizeByLayer 1\\n    -showAnimLayerWeight 1\\n    -autoExpandLayers 1\\n    -autoExpand 0\\n    -showDagOnly 1\\n    -showAssets 1\\n    -showContainedOnly 1\\n    -showPublishedAsConnected 0\\n    -showContainerContents 1\\n    -ignoreDagHierarchy 0\\n    -expandConnections 0\\n    -showUpstreamCurves 1\\n    -showUnitlessCurves 1\\n    -showCompounds 1\\n    -showLeafs 1\\n    -showNumericAttrsOnly 0\\n    -highlightActive 1\\n    -autoSelectNewObjects 0\\n    -doNotSelectNewObjects 0\\n    -dropIsParent 1\\n    -transmitFilters 0\\n    -setFilter \\\"defaultSetFilter\\\" \\n    -showSetMembers 1\\n    -allowMultiSelection 1\\n    -alwaysToggleSelect 0\\n    -directSelect 0\\n    -displayMode \\\"DAG\\\" \\n    -expandObjects 0\\n    -setsIgnoreFilters 1\\n    -containersIgnoreFilters 0\\n    -editAttrName 0\\n    -showAttrValues 0\\n    -highlightSecondary 0\\n    -showUVAttrsOnly 0\\n    -showTextureNodesOnly 0\\n    -attrAlphaOrder \\\"default\\\" \\n    -animLayerFilterOptions \\\"allAffecting\\\" \\n    -sortOrder \\\"none\\\" \\n    -longNames 0\\n    -niceNames 1\\n    -showNamespace 1\\n    -showPinIcons 0\\n    -mapMotionTrails 0\\n    -ignoreHiddenAttribute 0\\n    $editorName\"\n"
		+ "\t\t\t\t-ap false\n\t\t\t\t\t(localizedPanelLabel(\"Persp View\")) \n\t\t\t\t\t\"modelPanel\"\n"
		+ "\t\t\t\t\t\"$panelName = `modelPanel -unParent -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels `;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 1\\n    -headsUpDisplay 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 1\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 8192\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -maxConstantTransparency 1\\n    -rendererName \\\"base_OpenGL_Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 0\\n    -hulls 0\\n    -grid 1\\n    -imagePlane 0\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 0\\n    -fluids 0\\n    -hairSystems 0\\n    -follicles 0\\n    -nCloths 0\\n    -nParticles 0\\n    -nRigids 0\\n    -dynamicConstraints 0\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 0\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 0\\n    -clipGhosts 0\\n    -greasePencils 0\\n    -shadows 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t\t\"modelPanel -edit -l (localizedPanelLabel(\\\"Persp View\\\")) -mbv $menusOkayInPanels  $panelName;\\n$editorName = $panelName;\\nmodelEditor -e \\n    -cam `findStartUpCamera persp` \\n    -useInteractiveMode 0\\n    -displayLights \\\"default\\\" \\n    -displayAppearance \\\"smoothShaded\\\" \\n    -activeOnly 0\\n    -ignorePanZoom 0\\n    -wireframeOnShaded 1\\n    -headsUpDisplay 1\\n    -selectionHiliteDisplay 1\\n    -useDefaultMaterial 0\\n    -bufferMode \\\"double\\\" \\n    -twoSidedLighting 0\\n    -backfaceCulling 0\\n    -xray 1\\n    -jointXray 0\\n    -activeComponentsXray 0\\n    -displayTextures 0\\n    -smoothWireframe 0\\n    -lineWidth 1\\n    -textureAnisotropic 0\\n    -textureHilight 1\\n    -textureSampling 2\\n    -textureDisplay \\\"modulate\\\" \\n    -textureMaxSize 8192\\n    -fogging 0\\n    -fogSource \\\"fragment\\\" \\n    -fogMode \\\"linear\\\" \\n    -fogStart 0\\n    -fogEnd 100\\n    -fogDensity 0.1\\n    -fogColor 0.5 0.5 0.5 1 \\n    -maxConstantTransparency 1\\n    -rendererName \\\"base_OpenGL_Renderer\\\" \\n    -objectFilterShowInHUD 1\\n    -isFiltered 0\\n    -colorResolution 256 256 \\n    -bumpResolution 512 512 \\n    -textureCompression 0\\n    -transparencyAlgorithm \\\"frontAndBackCull\\\" \\n    -transpInShadows 0\\n    -cullingOverride \\\"none\\\" \\n    -lowQualityLighting 0\\n    -maximumNumHardwareLights 1\\n    -occlusionCulling 0\\n    -shadingModel 0\\n    -useBaseRenderer 0\\n    -useReducedRenderer 0\\n    -smallObjectCulling 0\\n    -smallObjectThreshold -1 \\n    -interactiveDisableShadows 0\\n    -interactiveBackFaceCull 0\\n    -sortTransparent 1\\n    -nurbsCurves 1\\n    -nurbsSurfaces 1\\n    -polymeshes 1\\n    -subdivSurfaces 1\\n    -planes 1\\n    -lights 1\\n    -cameras 1\\n    -controlVertices 0\\n    -hulls 0\\n    -grid 1\\n    -imagePlane 0\\n    -joints 1\\n    -ikHandles 1\\n    -deformers 1\\n    -dynamics 1\\n    -particleInstancers 0\\n    -fluids 0\\n    -hairSystems 0\\n    -follicles 0\\n    -nCloths 0\\n    -nParticles 0\\n    -nRigids 0\\n    -dynamicConstraints 0\\n    -locators 1\\n    -manipulators 1\\n    -pluginShapes 0\\n    -dimensions 1\\n    -handles 1\\n    -pivots 1\\n    -textures 1\\n    -strokes 1\\n    -motionTrails 0\\n    -clipGhosts 0\\n    -greasePencils 0\\n    -shadows 0\\n    $editorName;\\nmodelEditor -e -viewSelected 0 $editorName;\\nmodelEditor -e \\n    -pluginObjects \\\"gpuCacheDisplayFilter\\\" 1 \\n    $editorName\"\n"
		+ "\t\t\t\t$configName;\n\n            setNamedPanelLayout (localizedPanelLabel(\"Current Layout\"));\n        }\n\n        panelHistory -e -clear mainPanelHistory;\n        setFocus `paneLayout -q -p1 $gMainPane`;\n        sceneUIReplacement -deleteRemaining;\n        sceneUIReplacement -clear;\n\t}\n\n\ngrid -spacing 100 -size 200 -divisions 10 -displayAxes yes -displayGridLines yes -displayDivisionLines yes -displayPerspectiveLabels no -displayOrthographicLabels no -displayAxesBold yes -perspectiveLabelPosition axis -orthographicLabelPosition edge;\nviewManip -drawCompass 0 -compassAngle 0 -frontParameters \"\" -homeParameters \"\" -selectionLockParameters \"\";\n}\n");
	setAttr ".st" 3;
createNode script -n "sceneConfigurationScriptNode";
	setAttr ".b" -type "string" "playbackOptions -min 1 -max 120 -ast 1 -aet 200 ";
	setAttr ".st" 6;
createNode skinCluster -n "skinCluster2";
	setAttr -s 322 ".wl";
	setAttr -s 3 ".wl[0].w[0:2]"  0.99696091394472452 0.0028590981843169662 0.00017998787095853372;
	setAttr -s 3 ".wl[1].w[0:2]"  0.99696091419192234 0.0028590979523434095 0.00017998785573431785;
	setAttr -s 3 ".wl[2].w[0:2]"  0.99696091419192234 0.0028590979523434095 0.00017998785573431785;
	setAttr -s 3 ".wl[3].w[0:2]"  0.99696091500312456 0.0028590971911008354 0.00017998780577465259;
	setAttr -s 3 ".wl[4].w[0:2]"  0.99696091570356704 0.0028590965337965762 0.00017998776263636627;
	setAttr -s 3 ".wl[5].w[0:2]"  0.99696091591360747 0.0028590963366920442 0.00017998774970057343;
	setAttr -s 3 ".wl[6].w[0:2]"  0.99696091735949499 0.0028590949798525498 0.00017998766065242201;
	setAttr -s 3 ".wl[7].w[0:2]"  0.9969609176408496 0.0028590947158258365 0.00017998764332458739;
	setAttr -s 3 ".wl[8].w[0:2]"  0.99696091803040621 0.0028590943502609279 0.00017998761933289313;
	setAttr -s 3 ".wl[9].w[0:2]"  0.996960918575581 0.0028590938386619351 0.00017998758575711409;
	setAttr -s 3 ".wl[10].w[0:2]"  0.99696091803040621 0.0028590943502609279 0.00017998761933289321;
	setAttr -s 3 ".wl[11].w[0:2]"  0.99696091897806105 0.002859093460969471 0.00017998756096949972;
	setAttr -s 3 ".wl[12].w[0:2]"  0.99696091975256318 0.0028590927341666035 0.00017998751327008629;
	setAttr -s 3 ".wl[13].w[0:2]"  0.99696091985137048 0.0028590926414447273 0.00017998750718483371;
	setAttr -s 3 ".wl[14].w[0:2]"  0.99696092049025586 0.0028590920419065062 0.00017998746783768428;
	setAttr -s 3 ".wl[15].w[0:2]"  0.99696092014720394 0.0028590923638307903 0.00017998748896528289;
	setAttr -s 3 ".wl[16].w[0:2]"  0.99696092059662644 0.0028590919420869911 0.00017998746128662012;
	setAttr -s 3 ".wl[17].w[0:2]"  0.9969609208084198 0.0028590917433373507 0.00017998744824286172;
	setAttr -s 3 ".wl[18].w[0:2]"  0.99696092098372735 0.0028590915788264753 0.00017998743744616241;
	setAttr -s 3 ".wl[19].w[0:2]"  0.99696092144759296 0.0028590911435290804 0.00017998740887798997;
	setAttr -s 3 ".wl[20].w[0:2]"  0.96457075184180863 0.032854739660553765 0.0025745084976376569;
	setAttr -s 3 ".wl[21].w[0:2]"  0.96457075426640848 0.032854737439422216 0.002574508294169265;
	setAttr -s 3 ".wl[22].w[0:2]"  0.96457075426640848 0.032854737439422216 0.0025745082941692667;
	setAttr -s 3 ".wl[23].w[0:2]"  0.96457076222295668 0.032854730150574232 0.0025745076264690019;
	setAttr -s 3 ".wl[24].w[0:2]"  0.96457076909313655 0.032854723856928406 0.0025745070499349917;
	setAttr -s 3 ".wl[25].w[0:2]"  0.96457077115328393 0.03285472196966522 0.0025745068770508771;
	setAttr -s 3 ".wl[26].w[0:2]"  0.96457078533504548 0.032854708978013257 0.0025745056869412456;
	setAttr -s 3 ".wl[27].w[0:2]"  0.96457078809466756 0.032854706449974055 0.0025745054553584111;
	setAttr -s 3 ".wl[28].w[0:2]"  0.9645707919155726 0.03285470294971294 0.0025745051347144999;
	setAttr -s 3 ".wl[29].w[0:2]"  0.96457079726283435 0.032854698051184364 0.0025745046859813161;
	setAttr -s 3 ".wl[30].w[0:2]"  0.9645707919155726 0.03285470294971294 0.0025745051347144999;
	setAttr -s 3 ".wl[31].w[0:2]"  0.96457080121049754 0.032854694434802365 0.0025745043547000901;
	setAttr -s 3 ".wl[32].w[0:2]"  0.96457080880708312 0.03285468747570941 0.002574503717207494;
	setAttr -s 3 ".wl[33].w[0:2]"  0.96457080977621745 0.032854686587903151 0.0025745036358793788;
	setAttr -s 3 ".wl[34].w[0:2]"  0.96457081604262596 0.032854680847360991 0.0025745031100130149;
	setAttr -s 3 ".wl[35].w[0:2]"  0.96457081267785449 0.032854683929766544 0.0025745033923789203;
	setAttr -s 3 ".wl[36].w[0:2]"  0.9645708170859455 0.03285467989159515 0.0025745030224594212;
	setAttr -s 3 ".wl[37].w[0:2]"  0.96457081916328835 0.032854677988579328 0.0025745028481323341;
	setAttr -s 3 ".wl[38].w[0:2]"  0.96457082088276569 0.032854676413397579 0.0025745027038367192;
	setAttr -s 3 ".wl[39].w[0:2]"  0.96457082543251993 0.032854672245451015 0.0025745023220291011;
	setAttr -s 3 ".wl[40].w[0:2]"  0.94184761056301747 0.054756547204672781 0.0033958422323097934;
	setAttr -s 3 ".wl[41].w[0:2]"  0.94184761418686802 0.054756543842224489 0.0033958419709074648;
	setAttr -s 3 ".wl[42].w[0:2]"  0.94184761418686802 0.054756543842224475 0.0033958419709074661;
	setAttr -s 3 ".wl[43].w[0:2]"  0.94184762607886841 0.05475653280804002 0.0033958411130916443;
	setAttr -s 3 ".wl[44].w[0:2]"  0.94184763634716306 0.054756523280436946 0.0033958403724000134;
	setAttr -s 3 ".wl[45].w[0:2]"  0.94184763942629657 0.054756520423413182 0.0033958401502902718;
	setAttr -s 3 ".wl[46].w[0:2]"  0.94184766062261438 0.054756500756067153 0.0033958386213184437;
	setAttr -s 3 ".wl[47].w[0:2]"  0.94184766474719572 0.054756496929007754 0.0033958383237965798;
	setAttr -s 3 ".wl[48].w[0:2]"  0.94184767045798989 0.054756491630155078 0.0033958379118551058;
	setAttr -s 3 ".wl[49].w[0:2]"  0.94184767845010475 0.05475648421454208 0.003395837335353247;
	setAttr -s 3 ".wl[50].w[0:2]"  0.94184767045798989 0.054756491630155078 0.0033958379118551058;
	setAttr -s 3 ".wl[51].w[0:2]"  0.94184768435035415 0.054756478739900145 0.0033958369097456705;
	setAttr -s 3 ".wl[52].w[0:2]"  0.9418476957043499 0.054756468204911618 0.0033958360907385527;
	setAttr -s 3 ".wl[53].w[0:2]"  0.94184769715283589 0.054756466860910451 0.0033958359862537243;
	setAttr -s 3 ".wl[54].w[0:2]"  0.94184770651872496 0.054756458170618721 0.0033958353106563915;
	setAttr -s 3 ".wl[55].w[0:2]"  0.94184770148967578 0.054756462836903413 0.0033958356734209009;
	setAttr -s 3 ".wl[56].w[0:2]"  0.94184770807808926 0.054756456723737273 0.0033958351981734853;
	setAttr -s 3 ".wl[57].w[0:2]"  0.9418477111829241 0.054756453842865968 0.003395834974209901;
	setAttr -s 3 ".wl[58].w[0:2]"  0.94184771375288656 0.054756451458284727 0.0033958347888287115;
	setAttr -s 3 ".wl[59].w[0:2]"  0.94184772055303279 0.054756445148658947 0.0033958342983082452;
	setAttr -s 3 ".wl[60].w[0:2]"  0.90120975066717235 0.094299816744878653 0.004490432587948962;
	setAttr -s 3 ".wl[61].w[0:2]"  0.9012097559343496 0.094299811810324416 0.0044904322553259626;
	setAttr -s 3 ".wl[62].w[0:2]"  0.90120975593434971 0.094299811810324374 0.0044904322553259643;
	setAttr -s 3 ".wl[63].w[0:2]"  0.90120977321907825 0.09429979561712884 0.0044904311637929536;
	setAttr -s 3 ".wl[64].w[0:2]"  0.90120978814379171 0.094299781634913052 0.0044904302212953268;
	setAttr -s 3 ".wl[65].w[0:2]"  0.9012097926192365 0.094299777442093169 0.0044904299386704146;
	setAttr -s 3 ".wl[66].w[0:2]"  0.9012098234275645 0.094299748579314779 0.0044904279931207523;
	setAttr -s 3 ".wl[67].w[0:2]"  0.90120982942254246 0.094299742962920333 0.0044904276145372075;
	setAttr -s 3 ".wl[68].w[0:2]"  0.90120983772304231 0.094299735186597997 0.0044904270903597205;
	setAttr -s 3 ".wl[69].w[0:2]"  0.9012098493393863 0.094299724303827409 0.004490426356786351;
	setAttr -s 3 ".wl[70].w[0:2]"  0.90120983772304231 0.094299735186598038 0.0044904270903597223;
	setAttr -s 3 ".wl[71].w[0:2]"  0.90120985791525532 0.094299716269525408 0.0044904258152193358;
	setAttr -s 3 ".wl[72].w[0:2]"  0.90120987441801204 0.094299700808919362 0.0044904247730686167;
	setAttr -s 3 ".wl[73].w[0:2]"  0.90120987652335127 0.094299698836532428 0.0044904246401162411;
	setAttr -s 3 ".wl[74].w[0:2]"  0.90120989013644404 0.094299686083107737 0.0044904237804481856;
	setAttr -s 3 ".wl[75].w[0:2]"  0.90120988282684289 0.09429969293110696 0.0044904242420501584;
	setAttr -s 3 ".wl[76].w[0:2]"  0.90120989240294236 0.094299683959738964 0.0044904236373186097;
	setAttr -s 3 ".wl[77].w[0:2]"  0.90120989691574471 0.094299679731920424 0.0044904233523347398;
	setAttr -s 3 ".wl[78].w[0:2]"  0.90120990065112316 0.094299676232431587 0.00449042311644528;
	setAttr -s 3 ".wl[79].w[0:2]"  0.90120991053497157 0.094299666972749066 0.0044904224922794325;
	setAttr -s 3 ".wl[80].w[0:2]"  0.83021412201315714 0.16391780827842822 0.0058680697084147289;
	setAttr -s 3 ".wl[81].w[0:2]"  0.83021412889906299 0.16391780180601384 0.0058680692949231814;
	setAttr -s 3 ".wl[82].w[0:2]"  0.83021412889906299 0.16391780180601384 0.0058680692949231754;
	setAttr -s 3 ".wl[83].w[0:2]"  0.83021415149580036 0.16391778056618717 0.0058680679380125568;
	setAttr -s 3 ".wl[84].w[0:2]"  0.8302141710072346 0.16391776222639412 0.0058680667663713543;
	setAttr -s 3 ".wl[85].w[0:2]"  0.83021417685809074 0.16391775672687567 0.005868066415033602;
	setAttr -s 3 ".wl[86].w[0:2]"  0.83021421713455812 0.16391771886896739 0.0058680639964745207;
	setAttr -s 3 ".wl[87].w[0:2]"  0.83021422497193731 0.16391771150221443 0.0058680635258483056;
	setAttr -s 3 ".wl[88].w[0:2]"  0.83021423582338127 0.16391770130238795 0.0058680628742307809;
	setAttr -s 3 ".wl[89].w[0:2]"  0.8302142510097088 0.16391768702798298 0.0058680619623082434;
	setAttr -s 3 ".wl[90].w[0:2]"  0.83021423582338116 0.163917701302388 0.0058680628742307835;
	setAttr -s 3 ".wl[91].w[0:2]"  0.83021426222115036 0.16391767648977626 0.0058680612890733737;
	setAttr -s 3 ".wl[92].w[0:2]"  0.83021428379560536 0.16391765621084378 0.0058680599935509673;
	setAttr -s 3 ".wl[93].w[0:2]"  0.83021428654796658 0.16391765362375882 0.0058680598282746981;
	setAttr -s 3 ".wl[94].w[0:2]"  0.83021430434469501 0.16391763689570427 0.0058680587596008091;
	setAttr -s 3 ".wl[95].w[0:2]"  0.83021429478867492 0.16391764587789595 0.0058680593334292453;
	setAttr -s 3 ".wl[96].w[0:2]"  0.8302143073077437 0.16391763411058338 0.0058680585816730177;
	setAttr -s 3 ".wl[97].w[0:2]"  0.83021431320744055 0.16391762856515665 0.0058680582274027665;
	setAttr -s 3 ".wl[98].w[0:2]"  0.83021431809079205 0.16391762397504508 0.0058680579341629426;
	setAttr -s 3 ".wl[99].w[0:2]"  0.83021433101218922 0.16391761182956333 0.0058680571582474684;
	setAttr -s 3 ".wl[100].w[0:2]"  0.71984450410846534 0.27271713779141482 0.0074383581001199149;
	setAttr -s 3 ".wl[101].w[0:2]"  0.71984451101247815 0.27271713139065223 0.0074383575968695985;
	setAttr -s 3 ".wl[102].w[0:2]"  0.71984451101247804 0.27271713139065246 0.0074383575968696054;
	setAttr -s 3 ".wl[103].w[0:2]"  0.71984453366863543 0.27271711038595714 0.0074383559454073199;
	setAttr -s 3 ".wl[104].w[0:2]"  0.71984455323137841 0.27271709224918972 0.0074383545194318433;
	setAttr -s 3 ".wl[105].w[0:2]"  0.71984455909762068 0.27271708681055196 0.0074383540918273724;
	setAttr -s 3 ".wl[106].w[0:2]"  0.71984459948000656 0.27271704937173441 0.0074383511482590346;
	setAttr -s 3 ".wl[107].w[0:2]"  0.71984460733799704 0.27271704208653147 0.0074383505754715305;
	setAttr -s 3 ".wl[108].w[0:2]"  0.71984461821797918 0.27271703199961683 0.007438349782403977;
	setAttr -s 3 ".wl[109].w[0:2]"  0.71984463344424587 0.27271701788322844 0.0074383486725256394;
	setAttr -s 3 ".wl[110].w[0:2]"  0.71984461821797918 0.27271703199961683 0.0074383497824039805;
	setAttr -s 3 ".wl[111].w[0:2]"  0.7198446446851734 0.27271700746167843 0.0074383478531481534;
	setAttr -s 3 ".wl[112].w[0:2]"  0.71984466631637045 0.27271698740722972 0.0074383462763999006;
	setAttr -s 3 ".wl[113].w[0:2]"  0.71984466907597056 0.27271698484878315 0.0074383460752462461;
	setAttr -s 3 ".wl[114].w[0:2]"  0.71984468691950676 0.2727169683059037 0.0074383447745897087;
	setAttr -s 3 ".wl[115].w[0:2]"  0.71984467733835278 0.27271697718866511 0.0074383454729820934;
	setAttr -s 3 ".wl[116].w[0:2]"  0.71984468989034867 0.27271696555161323 0.0074383445580381959;
	setAttr -s 3 ".wl[117].w[0:2]"  0.71984469580556265 0.27271696006757273 0.0074383441268646372;
	setAttr -s 3 ".wl[118].w[0:2]"  0.71984470070175821 0.27271695552827219 0.007438343769969707;
	setAttr -s 3 ".wl[119].w[0:2]"  0.71984471365714164 0.27271694351723619 0.007438342825622184;
	setAttr -s 3 ".wl[120].w[0:2]"  0.59020640385307754 0.40056085827460391 0.009232737872318493;
	setAttr -s 3 ".wl[121].w[0:2]"  0.59020640784455758 0.40056085491529292 0.0092327372401494762;
	setAttr -s 3 ".wl[122].w[0:2]"  0.59020640784455758 0.40056085491529292 0.0092327372401494762;
	setAttr -s 3 ".wl[123].w[0:2]"  0.5902064209429686 0.40056084389140262 0.0092327351656286312;
	setAttr -s 3 ".wl[124].w[0:2]"  0.59020643225295621 0.4005608343726858 0.0092327333743580323;
	setAttr -s 3 ".wl[125].w[0:2]"  0.59020643564446107 0.40056083151832578 0.0092327328372132297;
	setAttr -s 3 ".wl[126].w[0:2]"  0.59020645899110136 0.40056081186931375 0.0092327291395848422;
	setAttr -s 3 ".wl[127].w[0:2]"  0.59020646353411399 0.40056080804582084 0.009232728420065171;
	setAttr -s 3 ".wl[128].w[0:2]"  0.59020646982425873 0.40056080275190548 0.0092327274238358601;
	setAttr -s 3 ".wl[129].w[0:2]"  0.59020647862716125 0.40056079534320105 0.0092327260296376865;
	setAttr -s 3 ".wl[130].w[0:2]"  0.59020646982425873 0.40056080275190542 0.0092327274238358636;
	setAttr -s 3 ".wl[131].w[0:2]"  0.59020648512598306 0.4005607898736584 0.0092327250003585715;
	setAttr -s 3 ".wl[132].w[0:2]"  0.59020649763182853 0.40056077934848006 0.0092327230196914689;
	setAttr -s 3 ".wl[133].w[0:2]"  0.59020649922726176 0.40056077800573048 0.0092327227670078674;
	setAttr -s 3 ".wl[134].w[0:2]"  0.590206509543312 0.40056076932352858 0.0092327211331594775;
	setAttr -s 3 ".wl[135].w[0:2]"  0.59020650400406982 0.40056077398546974 0.0092327220104604629;
	setAttr -s 3 ".wl[136].w[0:2]"  0.59020651126087242 0.40056076787799411 0.0092327208611335185;
	setAttr -s 3 ".wl[137].w[0:2]"  0.59020651468069041 0.40056076499980431 0.0092327203195053456;
	setAttr -s 3 ".wl[138].w[0:2]"  0.59020651751137365 0.4005607626174425 0.0092327198711839083;
	setAttr -s 3 ".wl[139].w[0:2]"  0.59020652500139081 0.40056075631368809 0.0092327186849209403;
	setAttr -s 3 ".wl[140].w[0:2]"  0.50266006834160726 0.48494551322036111 0.012394418438031563;
	setAttr -s 3 ".wl[141].w[0:2]"  0.50266006916586181 0.4849455132741981 0.012394417559939981;
	setAttr -s 3 ".wl[142].w[0:2]"  0.50266006916586203 0.4849455132741981 0.012394417559939974;
	setAttr -s 3 ".wl[143].w[0:2]"  0.50266007187072903 0.48494551345086945 0.012394414678401544;
	setAttr -s 3 ".wl[144].w[0:2]"  0.50266007420628023 0.4849455136034182 0.01239441219030165;
	setAttr -s 3 ".wl[145].w[0:2]"  0.50266007490663744 0.48494551364916255 0.012394411444200027;
	setAttr -s 3 ".wl[146].w[0:2]"  0.50266007972779803 0.48494551396405949 0.012394406308142513;
	setAttr -s 3 ".wl[147].w[0:2]"  0.50266008066594581 0.48494551402533459 0.012394405308719623;
	setAttr -s 3 ".wl[148].w[0:2]"  0.50266008196488166 0.48494551411017522 0.012394403924943198;
	setAttr -s 3 ".wl[149].w[0:2]"  0.50266008378271032 0.4849455142289073 0.012394401988382445;
	setAttr -s 3 ".wl[150].w[0:2]"  0.50266008196488154 0.48494551411017534 0.012394403924943211;
	setAttr -s 3 ".wl[151].w[0:2]"  0.50266008512473859 0.48494551431656213 0.012394400558699371;
	setAttr -s 3 ".wl[152].w[0:2]"  0.50266008770723725 0.48494551448523776 0.01239439780752505;
	setAttr -s 3 ".wl[153].w[0:2]"  0.50266008803669904 0.48494551450675699 0.012394397456543995;
	setAttr -s 3 ".wl[154].w[0:2]"  0.50266009016699742 0.48494551464589686 0.012394395187105721;
	setAttr -s 3 ".wl[155].w[0:2]"  0.50266008902312576 0.48494551457118518 0.012394396405689068;
	setAttr -s 3 ".wl[156].w[0:2]"  0.50266009052167937 0.48494551466906288 0.012394394809257853;
	setAttr -s 3 ".wl[157].w[0:2]"  0.50266009122788258 0.48494551471518865 0.012394394056928729;
	setAttr -s 3 ".wl[158].w[0:2]"  0.50266009181242788 0.48494551475336822 0.01239439343420398;
	setAttr -s 3 ".wl[159].w[0:2]"  0.50266009335914064 0.48494551485439114 0.012394391786468124;
	setAttr -s 3 ".wl[160].w[0:2]"  0.47170007717022744 0.50763512144854483 0.020664801381227706;
	setAttr -s 3 ".wl[161].w[0:2]"  0.4717000770669319 0.50763512291072665 0.020664800022341546;
	setAttr -s 3 ".wl[162].w[0:2]"  0.47170007706693218 0.50763512291072632 0.02066480002234156;
	setAttr -s 3 ".wl[163].w[0:2]"  0.47170007672795794 0.50763512770901076 0.020664795563031309;
	setAttr -s 3 ".wl[164].w[0:2]"  0.47170007643526607 0.50763513185214915 0.020664791712584816;
	setAttr -s 3 ".wl[165].w[0:2]"  0.47170007634749667 0.50763513309454433 0.02066479055795898;
	setAttr -s 3 ".wl[166].w[0:2]"  0.47170007574330536 0.50763514164701595 0.020664782609678679;
	setAttr -s 3 ".wl[167].w[0:2]"  0.47170007562573563 0.5076351433112376 0.020664781063026716;
	setAttr -s 3 ".wl[168].w[0:2]"  0.4717000754629514 0.50763514561547829 0.020664778921570277;
	setAttr -s 3 ".wl[169].w[0:2]"  0.47170007523513879 0.50763514884020611 0.020664775924655161;
	setAttr -s 3 ".wl[170].w[0:2]"  0.4717000754629514 0.50763514561547829 0.020664778921570315;
	setAttr -s 3 ".wl[171].w[0:2]"  0.47170007506695366 0.50763515122089031 0.020664773712156068;
	setAttr -s 3 ".wl[172].w[0:2]"  0.47170007474331038 0.50763515580209995 0.020664769454589577;
	setAttr -s 3 ".wl[173].w[0:2]"  0.47170007470202191 0.50763515638654755 0.020664768911430539;
	setAttr -s 3 ".wl[174].w[0:2]"  0.47170007443504824 0.50763516016557952 0.020664765399372245;
	setAttr -s 3 ".wl[175].w[0:2]"  0.47170007457840107 0.50763515813641391 0.02066476728518505;
	setAttr -s 3 ".wl[176].w[0:2]"  0.47170007439059897 0.50763516079476545 0.020664764814635563;
	setAttr -s 3 ".wl[177].w[0:2]"  0.47170007430209626 0.50763516204753156 0.020664763650372245;
	setAttr -s 3 ".wl[178].w[0:2]"  0.47170007422883986 0.50763516308448264 0.02066476268667752;
	setAttr -s 3 ".wl[179].w[0:2]"  0.47170007403500203 0.50763516582826629 0.020664760136731738;
	setAttr -s 3 ".wl[180].w[0:2]"  0.36606785246509532 0.59204166369828937 0.041890483836615353;
	setAttr -s 3 ".wl[181].w[0:2]"  0.3660678491692535 0.59204166924555501 0.0418904815851915;
	setAttr -s 3 ".wl[182].w[0:2]"  0.3660678491692535 0.59204166924555501 0.0418904815851915;
	setAttr -s 3 ".wl[183].w[0:2]"  0.36606783835364187 0.59204168744942198 0.041890474196936187;
	setAttr -s 3 ".wl[184].w[0:2]"  0.36606782901476548 0.59204170316777882 0.041890467817455618;
	setAttr -s 3 ".wl[185].w[0:2]"  0.36606782621433437 0.59204170788121246 0.041890465904453271;
	setAttr -s 3 ".wl[186].w[0:2]"  0.36606780693655716 0.59204174032782697 0.041890452735615882;
	setAttr -s 3 ".wl[187].w[0:2]"  0.36606780318530219 0.59204174664159959 0.041890450173098177;
	setAttr -s 3 ".wl[188].w[0:2]"  0.36606779799140621 0.59204175538349502 0.041890446625098811;
	setAttr -s 3 ".wl[189].w[0:2]"  0.36606779072267587 0.59204176761756244 0.041890441659761607;
	setAttr -s 3 ".wl[190].w[0:2]"  0.36606779799140604 0.59204175538349513 0.041890446625098846;
	setAttr -s 3 ".wl[191].w[0:2]"  0.36606778535647033 0.59204177664947222 0.041890437994057415;
	setAttr -s 3 ".wl[192].w[0:2]"  0.36606777503014637 0.59204179402980139 0.041890430940052285;
	setAttr -s 3 ".wl[193].w[0:2]"  0.36606777371276539 0.59204179624709707 0.041890430040137566;
	setAttr -s 3 ".wl[194].w[0:2]"  0.36606776519459783 0.59204181058409999 0.041890424221302222;
	setAttr -s 3 ".wl[195].w[0:2]"  0.36606776976846023 0.59204180288579222 0.041890427345747577;
	setAttr -s 3 ".wl[196].w[0:2]"  0.36606776377637401 0.59204181297112513 0.041890423252500926;
	setAttr -s 3 ".wl[197].w[0:2]"  0.36606776095256222 0.59204181772390729 0.04189042132353045;
	setAttr -s 3 ".wl[198].w[0:2]"  0.36606775861521068 0.59204182165792407 0.041890419726865274;
	setAttr -s 3 ".wl[199].w[0:2]"  0.36606775243055378 0.59204183206737293 0.041890415502073342;
	setAttr -s 3 ".wl[200].w[0:2]"  0.23008450955288379 0.68156769967852771 0.088347790768588522;
	setAttr -s 3 ".wl[201].w[0:2]"  0.23008450428938296 0.68156770864188543 0.088347787068731601;
	setAttr -s 3 ".wl[202].w[0:2]"  0.23008450428938296 0.68156770864188543 0.088347787068731601;
	setAttr -s 3 ".wl[203].w[0:2]"  0.23008448701671677 0.68156773805597415 0.088347774927309081;
	setAttr -s 3 ".wl[204].w[0:2]"  0.23008447210241614 0.68156776345393733 0.088347764443646545;
	setAttr -s 3 ".wl[205].w[0:2]"  0.23008446763009344 0.68156777106997546 0.088347761299931035;
	setAttr -s 3 ".wl[206].w[0:2]"  0.23008443684325119 0.68156782349771161 0.088347739659037111;
	setAttr -s 3 ".wl[207].w[0:2]"  0.23008443085245289 0.68156783369960139 0.088347735447945663;
	setAttr -s 3 ".wl[208].w[0:2]"  0.23008442255773956 0.68156784782488922 0.088347729617371223;
	setAttr -s 3 ".wl[209].w[0:2]"  0.23008441094949242 0.68156786759288113 0.088347721457626427;
	setAttr -s 3 ".wl[210].w[0:2]"  0.23008442255773939 0.68156784782488933 0.088347729617371196;
	setAttr -s 3 ".wl[211].w[0:2]"  0.23008440237960012 0.68156788218677766 0.088347715433622201;
	setAttr -s 3 ".wl[212].w[0:2]"  0.23008438588834232 0.68156791027017605 0.088347703841481606;
	setAttr -s 3 ".wl[213].w[0:2]"  0.23008438378446991 0.68156791385291593 0.088347702362614217;
	setAttr -s 3 ".wl[214].w[0:2]"  0.23008437018086025 0.68156793701886087 0.088347692800278876;
	setAttr -s 3 ".wl[215].w[0:2]"  0.23008437748536981 0.68156792457981963 0.088347697934810593;
	setAttr -s 3 ".wl[216].w[0:2]"  0.2300843679159407 0.68156794087585215 0.088347691208207194;
	setAttr -s 3 ".wl[217].w[0:2]"  0.23008436340628149 0.68156794855546932 0.088347688038249161;
	setAttr -s 3 ".wl[218].w[0:2]"  0.23008435967350496 0.68156795491211264 0.088347685414382454;
	setAttr -s 3 ".wl[219].w[0:2]"  0.23008434979653941 0.68156797173185613 0.088347678471604518;
	setAttr -s 3 ".wl[220].w[0:2]"  0.12347951665299874 0.70270569563008289 0.17381478771691838;
	setAttr -s 3 ".wl[221].w[0:2]"  0.12347951217524741 0.70270570524281195 0.17381478258194052;
	setAttr -s 3 ".wl[222].w[0:2]"  0.12347951217524741 0.70270570524281195 0.17381478258194052;
	setAttr -s 3 ".wl[223].w[0:2]"  0.12347949748109167 0.70270573678787407 0.17381476573103427;
	setAttr -s 3 ".wl[224].w[0:2]"  0.12347948479323961 0.70270576402585183 0.17381475118090844;
	setAttr -s 3 ".wl[225].w[0:2]"  0.12347948098855775 0.70270577219365193 0.17381474681779027;
	setAttr -s 3 ".wl[226].w[0:2]"  0.12347945479766513 0.70270582841963736 0.17381471678269755;
	setAttr -s 3 ".wl[227].w[0:2]"  0.12347944970119118 0.70270583936062647 0.17381471093818235;
	setAttr -s 3 ".wl[228].w[0:2]"  0.12347944264473776 0.70270585450925327 0.17381470284600903;
	setAttr -s 3 ".wl[229].w[0:2]"  0.12347943276940541 0.7027058757093827 0.1738146915212119;
	setAttr -s 3 ".wl[230].w[0:2]"  0.12347944264473765 0.70270585450925316 0.17381470284600917;
	setAttr -s 3 ".wl[231].w[0:2]"  0.12347942547885342 0.70270589136056738 0.17381468316057924;
	setAttr -s 3 ".wl[232].w[0:2]"  0.12347941144946296 0.70270592147853173 0.17381466707200535;
	setAttr -s 3 ".wl[233].w[0:2]"  0.12347940965966343 0.70270592532083143 0.17381466501950521;
	setAttr -s 3 ".wl[234].w[0:2]"  0.12347939808684497 0.70270595016508564 0.17381465174806943;
	setAttr -s 3 ".wl[235].w[0:2]"  0.12347940430091341 0.70270593682486981 0.17381465887421685;
	setAttr -s 3 ".wl[236].w[0:2]"  0.12347939616004003 0.7027059543015054 0.17381464953845457;
	setAttr -s 3 ".wl[237].w[0:2]"  0.12347939232359777 0.70270596253748963 0.17381464513891262;
	setAttr -s 3 ".wl[238].w[0:2]"  0.12347938914806234 0.70270596935465446 0.17381464149728318;
	setAttr -s 3 ".wl[239].w[0:2]"  0.12347938074556342 0.70270598739294199 0.17381463186149465;
	setAttr -s 3 ".wl[240].w[0:2]"  0.059990869228771532 0.63953083577322101 0.30047829499800749;
	setAttr -s 3 ".wl[241].w[0:2]"  0.059990866352435022 0.63953084325942144 0.3004782903881435;
	setAttr -s 3 ".wl[242].w[0:2]"  0.059990866352434932 0.63953084325942156 0.3004782903881435;
	setAttr -s 3 ".wl[243].w[0:2]"  0.059990856913470968 0.63953086782608148 0.30047827526044757;
	setAttr -s 3 ".wl[244].w[0:2]"  0.059990848763280299 0.63953088903847177 0.30047826219824791;
	setAttr -s 3 ".wl[245].w[0:2]"  0.059990846319298428 0.63953089539939045 0.30047825828131125;
	setAttr -s 3 ".wl[246].w[0:2]"  0.059990829495273366 0.63953093918706094 0.30047823131766571;
	setAttr -s 3 ".wl[247].w[0:2]"  0.059990826221494223 0.63953094770768448 0.30047822607082125;
	setAttr -s 3 ".wl[248].w[0:2]"  0.059990821688699653 0.63953095950513206 0.30047821880616832;
	setAttr -s 3 ".wl[249].w[0:2]"  0.05999081534516601 0.63953097601536901 0.30047820863946489;
	setAttr -s 3 ".wl[250].w[0:2]"  0.059990821688699611 0.63953095950513195 0.30047821880616848;
	setAttr -s 3 ".wl[251].w[0:2]"  0.059990810661995943 0.63953098820419907 0.30047820113380502;
	setAttr -s 3 ".wl[252].w[0:2]"  0.05999080165005604 0.63953101165946857 0.30047818669047538;
	setAttr -s 3 ".wl[253].w[0:2]"  0.059990800500357822 0.63953101465177475 0.30047818484786742;
	setAttr -s 3 ".wl[254].w[0:2]"  0.05999079306642565 0.63953103399998512 0.30047817293358925;
	setAttr -s 3 ".wl[255].w[0:2]"  0.059990797058103507 0.63953102361089054 0.3004781793310059;
	setAttr -s 3 ".wl[256].w[0:2]"  0.059990791828720552 0.63953103722134641 0.30047817094993295;
	setAttr -s 3 ".wl[257].w[0:2]"  0.059990789364338208 0.63953104363536684 0.30047816700029489;
	setAttr -s 3 ".wl[258].w[0:2]"  0.059990787324496898 0.63953104894443935 0.30047816373106379;
	setAttr -s 3 ".wl[259].w[0:2]"  0.059990781927056286 0.63953106299229867 0.30047815508064502;
	setAttr -s 3 ".wl[260].w[0:2]"  0.028490852545508163 0.54149257382918303 0.43001657362530887;
	setAttr -s 3 ".wl[261].w[0:2]"  0.028490850826059424 0.54149257703109577 0.43001657214284478;
	setAttr -s 3 ".wl[262].w[0:2]"  0.028490850826059417 0.54149257703109566 0.43001657214284494;
	setAttr -s 3 ".wl[263].w[0:2]"  0.028490845183529775 0.54149258753846952 0.43001656727800069;
	setAttr -s 3 ".wl[264].w[0:2]"  0.028490840311417749 0.54149259661119287 0.43001656307738928;
	setAttr -s 3 ".wl[265].w[0:2]"  0.028490838850427001 0.54149259933181282 0.4300165618177601;
	setAttr -s 3 ".wl[266].w[0:2]"  0.028490828793174383 0.54149261806018001 0.43001655314664561;
	setAttr -s 3 ".wl[267].w[0:2]"  0.02849082683613843 0.54149262170452472 0.43001655145933687;
	setAttr -s 3 ".wl[268].w[0:2]"  0.028490824126474409 0.54149262675039556 0.43001654912312998;
	setAttr -s 3 ".wl[269].w[0:2]"  0.02849082033436684 0.54149263381196755 0.43001654585366561;
	setAttr -s 3 ".wl[270].w[0:2]"  0.028490824126474381 0.54149262675039556 0.43001654912313003;
	setAttr -s 3 ".wl[271].w[0:2]"  0.028490817534809879 0.54149263902523614 0.43001654343995405;
	setAttr -s 3 ".wl[272].w[0:2]"  0.028490812147553401 0.54149264905725891 0.43001653879518775;
	setAttr -s 3 ".wl[273].w[0:2]"  0.028490811460274205 0.54149265033709426 0.43001653820263147;
	setAttr -s 3 ".wl[274].w[0:2]"  0.028490807016336842 0.54149265861249229 0.43001653437117077;
	setAttr -s 3 ".wl[275].w[0:2]"  0.028490809402525668 0.54149265416898629 0.43001653642848803;
	setAttr -s 3 ".wl[276].w[0:2]"  0.028490806276447973 0.54149265999029683 0.43001653373325521;
	setAttr -s 3 ".wl[277].w[0:2]"  0.028490804803262527 0.54149266273362928 0.43001653246310823;
	setAttr -s 3 ".wl[278].w[0:2]"  0.028490803583863931 0.54149266500436577 0.43001653141177026;
	setAttr -s 3 ".wl[279].w[0:2]"  0.028490800357323046 0.54149267101275733 0.43001652862991951;
	setAttr -s 3 ".wl[280].w[0:2]"  0.015326013583830185 0.49256666438557895 0.49210732203059093;
	setAttr -s 3 ".wl[281].w[0:2]"  0.015326012515374656 0.49256666492992801 0.49210732255469736;
	setAttr -s 3 ".wl[282].w[0:2]"  0.015326012515374651 0.49256666492992823 0.49210732255469719;
	setAttr -s 3 ".wl[283].w[0:2]"  0.015326009009139342 0.49256666671626004 0.49210732427460058;
	setAttr -s 3 ".wl[284].w[0:2]"  0.015326005981637206 0.49256666825869028 0.49210732575967253;
	setAttr -s 3 ".wl[285].w[0:2]"  0.015326005073786068 0.49256666872121591 0.49210732620499797;
	setAttr -s 3 ".wl[286].w[0:2]"  0.015325998824267996 0.49256667190517617 0.49210732927055589;
	setAttr -s 3 ".wl[287].w[0:2]"  0.015325997608177312 0.49256667252474157 0.49210732986708117;
	setAttr -s 3 ".wl[288].w[0:2]"  0.01532599592440799 0.49256667338257643 0.4921073306930156;
	setAttr -s 3 ".wl[289].w[0:2]"  0.015325993568014659 0.492566674583095 0.49210733184889033;
	setAttr -s 3 ".wl[290].w[0:2]"  0.015325995924407964 0.49256667338257626 0.49210733069301582;
	setAttr -s 3 ".wl[291].w[0:2]"  0.015325991828386454 0.49256667546938832 0.49210733270222518;
	setAttr -s 3 ".wl[292].w[0:2]"  0.015325988480777146 0.49256667717490471 0.49210733434431819;
	setAttr -s 3 ".wl[293].w[0:2]"  0.015325988053705922 0.49256667739248611 0.49210733455380801;
	setAttr -s 3 ".wl[294].w[0:2]"  0.015325985292269605 0.49256667879936317 0.49210733590836725;
	setAttr -s 3 ".wl[295].w[0:2]"  0.015325986775033176 0.49256667804393522 0.4921073351810315;
	setAttr -s 3 ".wl[296].w[0:2]"  0.015325984832507055 0.49256667903359985 0.49210733613389307;
	setAttr -s 3 ".wl[297].w[0:2]"  0.015325983917078404 0.49256667949998573 0.49210733658293593;
	setAttr -s 3 ".wl[298].w[0:2]"  0.015325983159351372 0.49256667988602737 0.49210733695462133;
	setAttr -s 3 ".wl[299].w[0:2]"  0.015325981154398103 0.49256668090749678 0.49210733793810518;
	setAttr -s 3 ".wl[300].w[0:2]"  0.0012921636051554282 0.50028504395659001 0.49842279243825466;
	setAttr -s 3 ".wl[301].w[0:2]"  0.0012921634999311519 0.50028504404929552 0.49842279245077337;
	setAttr -s 3 ".wl[302].w[0:2]"  0.0012921634999311512 0.50028504404929552 0.49842279245077337;
	setAttr -s 3 ".wl[303].w[0:2]"  0.0012921631546280008 0.50028504435351773 0.49842279249185428;
	setAttr -s 3 ".wl[304].w[0:2]"  0.0012921628564717502 0.50028504461620227 0.49842279252732602;
	setAttr -s 3 ".wl[305].w[0:2]"  0.0012921627670642213 0.50028504469497304 0.49842279253796279;
	setAttr -s 3 ".wl[306].w[0:2]"  0.0012921621515955574 0.50028504523721906 0.49842279261118538;
	setAttr -s 3 ".wl[307].w[0:2]"  0.0012921620318318186 0.50028504534273477 0.49842279262543338;
	setAttr -s 3 ".wl[308].w[0:2]"  0.0012921618660098862 0.50028504548882891 0.49842279264516126;
	setAttr -s 3 ".wl[309].w[0:2]"  0.0012921616339462187 0.5002850456932838 0.49842279267277001;
	setAttr -s 3 ".wl[310].w[0:2]"  0.0012921618660098814 0.50028504548882879 0.49842279264516143;
	setAttr -s 3 ".wl[311].w[0:2]"  0.001292161462623172 0.50028504584422451 0.49842279269315232;
	setAttr -s 3 ".wl[312].w[0:2]"  0.0012921611329420389 0.5002850461346835 0.49842279273237444;
	setAttr -s 3 ".wl[313].w[0:2]"  0.0012921610908829726 0.50028504617173886 0.49842279273737816;
	setAttr -s 3 ".wl[314].w[0:2]"  0.0012921608189296714 0.50028504641133797 0.49842279276973234;
	setAttr -s 3 ".wl[315].w[0:2]"  0.0012921609649560173 0.50028504628268455 0.49842279275235946;
	setAttr -s 3 ".wl[316].w[0:2]"  0.0012921607736510882 0.50028504645122995 0.49842279277511897;
	setAttr -s 3 ".wl[317].w[0:2]"  0.0012921606834973385 0.5002850465306582 0.49842279278584445;
	setAttr -s 3 ".wl[318].w[0:2]"  0.0012921606088744516 0.50028504659640327 0.49842279279472229;
	setAttr -s 3 ".wl[319].w[0:2]"  0.0012921604114215486 0.50028504677036523 0.49842279281821322;
	setAttr ".wl[320].w[0]"  1;
	setAttr ".wl[321].w[1]"  1;
	setAttr -s 3 ".pm";
	setAttr ".pm[0]" -type "matrix" -0.5191370003804554 0 0.85469104057313194 0 0 1 0 0
		 -0.85469104057313194 0 -0.5191370003804554 0 0 0 0 1;
	setAttr ".pm[1]" -type "matrix" -0.5191370003804554 0 0.85469104057313194 0 0 1 0 0
		 -0.85469104057313194 0 -0.5191370003804554 0 -1.5777218104420236e-30 -96.314536256099558 -2.1316282072803006e-14 1;
	setAttr ".pm[2]" -type "matrix" 0.99789919399637894 0 -0.064785790273621038 0 0 1 0 0
		 0.064785790273621038 0 0.99789919399637894 0 5.2390910788811376e-14 -196.31453625609961 -3.6669434129592654e-14 1;
	setAttr ".gm" -type "matrix" 1 0 0 0 0 1 0 0
		 0 0 1 0 0 97.662383178362518 0 1;
	setAttr -s 3 ".ma";
	setAttr -s 3 ".dpf[0:2]"  4 4 4;
	setAttr -s 3 ".lw";
	setAttr -s 3 ".lw";
	setAttr ".mmi" yes;
	setAttr ".mi" 5;
	setAttr ".ucm" yes;
	setAttr ".nw" 2;
	setAttr -s 3 ".ifcl";
	setAttr -s 3 ".ifcl";
createNode tweak -n "tweak1";
createNode objectSet -n "skinCluster2Set";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "skinCluster2GroupId";
	setAttr ".ihi" 0;
createNode groupParts -n "skinCluster2GroupParts";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode objectSet -n "tweakSet1";
	setAttr ".ihi" 0;
	setAttr ".vo" yes;
createNode groupId -n "groupId4";
	setAttr ".ihi" 0;
createNode groupParts -n "groupParts4";
	setAttr ".ihi" 0;
	setAttr ".ic" -type "componentList" 1 "vtx[*]";
createNode dagPose -n "bindPose1";
	setAttr -s 3 ".wm";
	setAttr -s 3 ".xm";
	setAttr ".xm[0]" -type "matrix" "xform" 1 1 1 0 0 0 0 0
		 0 0 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 1 0 0.87153227145655809 0 0.49033814843409063 1
		 1 1 yes;
	setAttr ".xm[1]" -type "matrix" "xform" 1 1 1 0 0 0 0 2.9865722321170058e-30
		 96.314536256099558 2.1316282072803002e-14 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 1 0 0 0 1 1
		 1 1 yes;
	setAttr ".xm[2]" -type "matrix" "xform" 1 1 1 0 0 0 0 0
		 100 -8.5265128291212022e-14 0 0 0 0 0 0 0 0 0 0
		 0 0 0 0 0 0 0 0 1 0 0.88696624196095197 0 -0.46183426206991829 1
		 1 1 yes;
	setAttr -s 3 ".m";
	setAttr -s 3 ".p";
	setAttr ".bp" yes;
select -ne :time1;
	setAttr -av -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".o" 1;
	setAttr ".unw" 1;
select -ne :renderPartition;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".st";
	setAttr -cb on ".an";
	setAttr -cb on ".pt";
select -ne :renderGlobalsList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
select -ne :defaultShaderList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".s";
select -ne :postProcessList1;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -s 2 ".p";
select -ne :defaultRenderingList1;
select -ne :initialShadingGroup;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro" yes;
select -ne :initialParticleSE;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".mwc";
	setAttr -cb on ".an";
	setAttr -cb on ".il";
	setAttr -cb on ".vo";
	setAttr -cb on ".eo";
	setAttr -cb on ".fo";
	setAttr -cb on ".epo";
	setAttr -k on ".ro" yes;
select -ne :defaultResolution;
	setAttr -av -k on ".cch";
	setAttr -k on ".ihi";
	setAttr -av -k on ".nds";
	setAttr -k on ".bnm";
	setAttr -av ".w";
	setAttr -av ".h";
	setAttr -av -k on ".pa" 1;
	setAttr -av -k on ".al";
	setAttr -av ".dar";
	setAttr -k on ".ldar";
	setAttr -k on ".dpi";
	setAttr -av -k on ".off";
	setAttr -av -k on ".fld";
	setAttr -av -k on ".zsl";
	setAttr -k on ".isu";
	setAttr -k on ".pdu";
select -ne :defaultColorMgtGlobals;
	setAttr ".cme" yes;
	setAttr ".cfe" yes;
	setAttr ".cfp" -type "string" "//corp.blizzard.net/BFD/Deploy/Packages/Published/Bfd_OpenColorIO/2015-02-26.120415/Bfd_Anim/config.ocio";
	setAttr ".vtn" -type "string" "sRGB (sRGB)";
	setAttr ".wsn" -type "string" "linear";
	setAttr ".din" -type "string" "linear";
	setAttr ".otn" -type "string" "sRGB (sRGB)";
select -ne :hardwareRenderGlobals;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr ".ctrs" 256;
	setAttr ".btrs" 512;
	setAttr -k off ".fbfm";
	setAttr -k off -cb on ".ehql";
	setAttr -k off -cb on ".eams";
	setAttr -k off -cb on ".eeaa";
	setAttr -k off -cb on ".engm";
	setAttr -k off -cb on ".mes";
	setAttr -k off -cb on ".emb";
	setAttr -av -k off -cb on ".mbbf";
	setAttr -k off -cb on ".mbs";
	setAttr -k off -cb on ".trm";
	setAttr -k off -cb on ".tshc";
	setAttr -k off ".enpt";
	setAttr -k off -cb on ".clmt";
	setAttr -k off -cb on ".tcov";
	setAttr -k off -cb on ".lith";
	setAttr -k off -cb on ".sobc";
	setAttr -k off -cb on ".cuth";
	setAttr -k off -cb on ".hgcd";
	setAttr -k off -cb on ".hgci";
	setAttr -k off -cb on ".mgcs";
	setAttr -k off -cb on ".twa";
	setAttr -k off -cb on ".twz";
	setAttr -k on ".hwcc";
	setAttr -k on ".hwdp";
	setAttr -k on ".hwql";
	setAttr -k on ".hwfr";
select -ne :hardwareRenderingGlobals;
	setAttr ".otfna" -type "stringArray" 22 "NURBS Curves" "NURBS Surfaces" "Polygons" "Subdiv Surface" "Particles" "Particle Instance" "Fluids" "Strokes" "Image Planes" "UI" "Lights" "Cameras" "Locators" "Joints" "IK Handles" "Deformers" "Motion Trails" "Components" "Hair Systems" "Follicles" "Misc. UI" "Ornaments"  ;
	setAttr ".otfva" -type "Int32Array" 22 0 1 1 1 1 1
		 1 1 1 0 0 0 0 0 0 0 0 0
		 0 0 0 0 ;
	setAttr ".fprt" yes;
select -ne :defaultHardwareRenderGlobals;
	setAttr -k on ".cch";
	setAttr -cb on ".ihi";
	setAttr -k on ".nds";
	setAttr -cb on ".bnm";
	setAttr -k on ".rp";
	setAttr -k on ".cai";
	setAttr -k on ".coi";
	setAttr -cb on ".bc";
	setAttr -av -k on ".bcb";
	setAttr -av -k on ".bcg";
	setAttr -av -k on ".bcr";
	setAttr -k on ".ei";
	setAttr -k on ".ex";
	setAttr -av -k on ".es";
	setAttr -av -k on ".ef";
	setAttr -av -k on ".bf";
	setAttr -k on ".fii";
	setAttr -av -k on ".sf";
	setAttr -k on ".gr";
	setAttr -k on ".li";
	setAttr -k on ".ls";
	setAttr -k on ".mb";
	setAttr -k on ".ti";
	setAttr -k on ".txt";
	setAttr -k on ".mpr";
	setAttr -k on ".wzd";
	setAttr -k on ".if";
	setAttr ".res" -type "string" "ntsc_4d 646 485 1.333";
	setAttr -k on ".as";
	setAttr -k on ".ds";
	setAttr -k on ".lm";
	setAttr -k on ".fir";
	setAttr -k on ".aap";
	setAttr -k on ".gh";
	setAttr -cb on ".sd";
connectAttr "skinCluster1GroupId.id" "pCylinderShape1.iog.og[0].gid";
connectAttr "groupId2.id" "pCylinderShape1.iog.og[1].gid";
connectAttr "skinCluster2GroupId.id" "pCylinderShape1.iog.og[2].gid";
connectAttr "skinCluster2Set.mwc" "pCylinderShape1.iog.og[2].gco";
connectAttr "groupId4.id" "pCylinderShape1.iog.og[3].gid";
connectAttr "tweakSet1.mwc" "pCylinderShape1.iog.og[3].gco";
connectAttr "skinCluster2.og[0]" "pCylinderShape1.i";
connectAttr "tweak1.vl[0].vt[0]" "pCylinderShape1.twl";
connectAttr "polyCylinder1.out" "pCylinderShape1Orig.i";
connectAttr "joint1.s" "joint2.is";
connectAttr "joint2.s" "joint3.is";
relationship "link" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "link" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialShadingGroup.message" ":defaultLightSet.message";
relationship "shadowLink" ":lightLinker1" ":initialParticleSE.message" ":defaultLightSet.message";
connectAttr "layerManager.dli[0]" "defaultLayer.id";
connectAttr "renderLayerManager.rlmi[0]" "defaultRenderLayer.rlid";
connectAttr ":TurtleDefaultBakeLayer.idx" ":TurtleBakeLayerManager.bli[0]";
connectAttr ":TurtleRenderOptions.msg" ":TurtleDefaultBakeLayer.rset";
connectAttr "groupParts2.og" "skinCluster1GroupParts.ig";
connectAttr "skinCluster1GroupId.id" "skinCluster1GroupParts.gi";
connectAttr "pCylinderShape1Orig.w" "groupParts2.ig";
connectAttr "groupId2.id" "groupParts2.gi";
connectAttr "hyperView1.msg" "nodeEditorPanel1Info.b[0]";
connectAttr "hyperLayout1.msg" "hyperView1.hl";
connectAttr "layerManager.msg" "hyperLayout1.hyp[0].dn";
connectAttr "defaultLayer.msg" "hyperLayout1.hyp[1].dn";
connectAttr "renderLayerManager.msg" "hyperLayout1.hyp[2].dn";
connectAttr "defaultRenderLayer.msg" "hyperLayout1.hyp[3].dn";
connectAttr ":TurtleRenderOptions.msg" "hyperLayout1.hyp[4].dn";
connectAttr ":TurtleUIOptions.msg" "hyperLayout1.hyp[5].dn";
connectAttr ":TurtleBakeLayerManager.msg" "hyperLayout1.hyp[6].dn";
connectAttr ":TurtleDefaultBakeLayer.msg" "hyperLayout1.hyp[7].dn";
connectAttr "polyCylinder1.msg" "hyperLayout1.hyp[8].dn";
connectAttr "pCylinder1.msg" "hyperLayout1.hyp[9].dn";
connectAttr "pCylinderShape1.msg" "hyperLayout1.hyp[10].dn";
connectAttr "joint1.msg" "hyperLayout1.hyp[11].dn";
connectAttr "joint2.msg" "hyperLayout1.hyp[12].dn";
connectAttr "joint3.msg" "hyperLayout1.hyp[13].dn";
connectAttr "pCylinderShape1Orig.msg" "hyperLayout1.hyp[15].dn";
connectAttr "skinCluster1GroupId.msg" "hyperLayout1.hyp[18].dn";
connectAttr "skinCluster1GroupParts.msg" "hyperLayout1.hyp[19].dn";
connectAttr "groupId2.msg" "hyperLayout1.hyp[21].dn";
connectAttr "groupParts2.msg" "hyperLayout1.hyp[22].dn";
connectAttr "skinCluster2GroupParts.og" "skinCluster2.ip[0].ig";
connectAttr "skinCluster2GroupId.id" "skinCluster2.ip[0].gi";
connectAttr "bindPose1.msg" "skinCluster2.bp";
connectAttr "joint1.wm" "skinCluster2.ma[0]";
connectAttr "joint2.wm" "skinCluster2.ma[1]";
connectAttr "joint3.wm" "skinCluster2.ma[2]";
connectAttr "joint1.liw" "skinCluster2.lw[0]";
connectAttr "joint2.liw" "skinCluster2.lw[1]";
connectAttr "joint3.liw" "skinCluster2.lw[2]";
connectAttr "joint1.obcc" "skinCluster2.ifcl[0]";
connectAttr "joint2.obcc" "skinCluster2.ifcl[1]";
connectAttr "joint3.obcc" "skinCluster2.ifcl[2]";
connectAttr "groupParts4.og" "tweak1.ip[0].ig";
connectAttr "groupId4.id" "tweak1.ip[0].gi";
connectAttr "skinCluster2GroupId.msg" "skinCluster2Set.gn" -na;
connectAttr "pCylinderShape1.iog.og[2]" "skinCluster2Set.dsm" -na;
connectAttr "skinCluster2.msg" "skinCluster2Set.ub[0]";
connectAttr "tweak1.og[0]" "skinCluster2GroupParts.ig";
connectAttr "skinCluster2GroupId.id" "skinCluster2GroupParts.gi";
connectAttr "groupId4.msg" "tweakSet1.gn" -na;
connectAttr "pCylinderShape1.iog.og[3]" "tweakSet1.dsm" -na;
connectAttr "tweak1.msg" "tweakSet1.ub[0]";
connectAttr "skinCluster1GroupParts.og" "groupParts4.ig";
connectAttr "groupId4.id" "groupParts4.gi";
connectAttr "joint1.msg" "bindPose1.m[0]";
connectAttr "joint2.msg" "bindPose1.m[1]";
connectAttr "joint3.msg" "bindPose1.m[2]";
connectAttr "bindPose1.w" "bindPose1.p[0]";
connectAttr "bindPose1.m[0]" "bindPose1.p[1]";
connectAttr "bindPose1.m[1]" "bindPose1.p[2]";
connectAttr "joint1.bps" "bindPose1.wm[0]";
connectAttr "joint2.bps" "bindPose1.wm[1]";
connectAttr "joint3.bps" "bindPose1.wm[2]";
connectAttr "defaultRenderLayer.msg" ":defaultRenderingList1.r" -na;
connectAttr "pCylinderShape1.iog" ":initialShadingGroup.dsm" -na;
// End of skinnedCylinder.ma
