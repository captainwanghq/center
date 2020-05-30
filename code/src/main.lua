cc.FileUtils:getInstance():setPopupNotify(false)
require "config"
require "preload"
require "env"
require "cocos.init"
require "core.init"
require "hook"
DEBUG = 1
if not CC_DISABLE_GLOBAL then
    cc.disable_global()
end


local function main()
    lanuch_module(CS_FIRST_GAME)
    
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
