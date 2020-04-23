
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()


    cc.Label:createWithSystemFont("game fish", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

end

function MainScene:onEnter( ... )
    -- body
        print("game.fish")

end
return MainScene
