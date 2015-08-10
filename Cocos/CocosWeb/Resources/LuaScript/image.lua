local container = {}
function container.CreateCustomNode()
	require "cocos.init"
    local rootNode = ccui.ImageView:create()
	rootNode:loadTexture("image/scenebg.png",0)
	
	local onEnter=function()
		rootNode:ignoreContentAdaptWithSize(false)
		rootNode:setAnchorPoint(0,0)
		rootNode:setScale9Enabled(false)
		rootNode:setContentSize(cc.size(640,960))
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
    return 'ImageView'
end

-- 返回这个包含 CreateCustomNode 和 GetBaseType 方法的表。
return container