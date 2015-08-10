require "cocos/init.lua"


local dicNode={}
local dicAnima={}

local function main()
 
end

xpcall(main, __G__TRACKBACK__)

function getNode(_sceneName)
    if dicNode[_sceneName]==nil then
       dicNode[_sceneName]=createScene(_sceneName) 
    end 
    return dicNode[_sceneName]
end
function createScene(_sceneName)
    local _scene=require(_sceneName):create()
    return _scene.root
end

function getAnima(_sceneName)
    if dicAnima[_sceneName]==nil then
       dicAnima[_sceneName]=createAnima(_sceneName) 
    end 
    return dicAnima[_sceneName]
end
function createAnima(_sceneName)
    local _scene=require(_sceneName):create()
    return _scene.animation
end

