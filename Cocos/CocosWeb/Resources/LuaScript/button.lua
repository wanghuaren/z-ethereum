--[[
控件名               GetBaseType返回
   Sprite（精灵）              Sprite
ParticleSystemQuad（粒子）    Particle
 TMXTiledMap（地图）          GameMap
   ComAudio（声音）            SimpleAudio
    Node（节点）                Node
   Button（按钮）               Button
  CheckBox（复选框）             CheckBox
  ImageView（图片）              ImageView
  TextBMFont（FNT 字体）      TextBMFont
  LoadingBar（进度条）         LoadingBar
  Slider（滑动条）              Slider
  Text（文本）                    Text
  TextField（输入框）           TextField
  ScrollView（滚动容器）         ScrollView
  ListView（列表容器）         ListView
  PageView（翻页容器）         PageView
 Particle3D（3D 粒子）         Particle3D
   Sprite3D（模型）              Sprite3D                                        
 UserCamera（摄像机）         UserCamera
 ]]
 local container = {}
function container.CreateCustomNode()
	require "cocos.init"
    local rootNode = ccui.Button:create()
	rootNode:loadTextureNormal("button/btn.png",0)
	rootNode:loadTexturePressed("button/btn2.png",0)
	rootNode:loadTextureDisabled("button/btn2.png",0)
	rootNode:setTitleText("按钮")
	
	local onEnter=function()
		rootNode:setTitleFontName("Msyh.ttf")
		rootNode:setTitleFontSize(40)
		rootNode:setContentSize(cc.size(150,60))
		rootNode:setScale9Enabled(true)
		rootNode:setCapInsets(cc.rect(15,11,34,13))
	end
	
	local function sceneEventHandler(eventType)
		if eventType=="enter" then
			onEnter()
		end
    end  
	rootNode:registerScriptHandler(sceneEventHandler)
    return rootNode
end


-- 返回该插件所扩展的基础类型。
function container.GetBaseType()
    return 'Button'
end

-- 返回这个包含 CreateCustomNode 和 GetBaseType 方法的表。
return container