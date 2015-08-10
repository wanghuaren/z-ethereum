--[[
一个简单的示例，新建一个精灵，并在精灵上放置了一个文本。
当调用 CreateCustomNode 时，会生成这个精灵并返回。
]]
-- 新建一个 table，包含 CreateCustomNode 和 GetBaseType 方法。
local container = {}

-- 新建根节点 Node，目前这个方法的名字为固定的，必须为 CreateCustomNode。
-- 方法的最后一句必须是一个 return 语句，把新建的结点返回。

function container.CreateCustomNode()
	require "cocos.init"
    local rootNode = ccui.TextField:create('input please','',10)
	
    local img = ccui.ImageView:create('txtInput/txtBG.png') -- 图片资源位于本文件所在目录
	img:setScale9Enabled(true)
	img:setCapInsets(cc.rect(10,10,135,24))
	img:setAnchorPoint(0,1)
	img:setName('img')
	img:retain()              -- 保留，以回避垃圾回收。
	
    rootNode:addChild(img,-1)
	
	local onEnter=function()
		rootNode:setAnchorPoint(0,1)
		
		local size=rootNode:getContentSize()
		size.height=70;
		rootNode:setFontSize(size.height)
		rootNode:setTextColor(cc.c4b(51,153,204,255))
		rootNode:setContentSize(size)
		
		size.width=size.width+4
		size.height=size.height+4
		img:setContentSize(size)
		img:setPosition(-2,size.height-2)
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
    return 'TextField'
end

-- 返回这个包含 CreateCustomNode 和 GetBaseType 方法的表。
return container