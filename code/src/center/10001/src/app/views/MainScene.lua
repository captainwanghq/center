local test = require("app.views.test")
local MainScene = class("MainScene", cc.load("base").custom_view)

function MainScene:onCreate()
    cc.Label:createWithSystemFont("Game Center", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
end

function MainScene:onEnter( ... )
    -- body
    --lanuch_module("game.20001")
    local handle  = self:on("event1",handler(self,self.test),"0014")
    local handle  = self:on("event1",handler(self,self.test),"0015")
    local event={}
    event.name = "event1"
    event.pars = {msg="ttf1"}
    self:emit(event)
    lanuch_module("game.20003")
end

function MainScene:test( event )
    -- body
    event.name = string.lower(tostring(event.name))
    print(event.pars.msg,event.name,event.tag)
end
return MainScene
