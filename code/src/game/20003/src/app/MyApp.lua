require "app.core.ButtonEx"
require "app.core.CAButton"
require "app.data.Localization"
local MyApp = class("MyApp", cc.load("mvc").AppBase)


local director = cc.Director:getInstance()
local view = director:getOpenGLView()
view:setFrameSize(540,960)
display.setAutoScale({
    width = 720,
    height = 1280,
    autoscale = "FIXED_HEIGHT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            -- iPad 768*1024(1536*2048) is 4:3 screen
            return {autoscale = "FIXED_WIDTH"}
        end
    end
})

function MyApp:onCreate()
    math.randomseed(os.time())
    self.configs_.defaultSceneName = "ChooseLevel"
end

return MyApp
