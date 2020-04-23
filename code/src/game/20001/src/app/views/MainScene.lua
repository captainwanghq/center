
local MainScene = class("MainScene",cc.load("base").custom_view)

function MainScene:onCreate()
    -- add background image
    -- display.newSprite("bird.jpg")
    --     :move(display.center)
    --     :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("game bird", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
  
end

function MainScene:onEnter( ... )
    -- body
         lanuch_module("game.20002")

end

return MainScene
