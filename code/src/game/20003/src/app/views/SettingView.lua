local Rect = import(".Rect")
local SettingView = class("SettingView",import("..core.GrayView"))
local Localization = import("..data.Localization")

local  CARectButton = import("..core.CARectButton")
function SettingView:onCreate()
	-- body
end

function SettingView:show(step,callback)
        local mountNode = self.mountNode
        local  frame = Rect.new({width= 480,height = 360,color = cc.c4f(1,1,1,1)})
        frame:center()
        mountNode:addChild(frame)

        local lb_title = cc.Label:create(Localization.getString("nice"),fontFilePath,40)
        lb_title:setPosition(display.cx,display.cy+140)
        mountNode:addChild(lb_title)
        local lb_title = cc.Label:create(string.format(Localization.getString("passlevel"),step),fontFilePath,24)
        lb_title:setPosition(display.cx,display.cy+70)
        mountNode:addChild(lb_title)
        local function closeView() self:closeView() end
        local function nextLevel() callback() closeView() end
    --    CAButton:create({width=40,height=40}):setText("X"):move(display.cx+220,display.cy+160):onTouch(closeView):addTo(mountNode)
        CARectButton:create({width=400,height=60}):setText(Localization.getString("nextlevel")):move(display.cx,display.cy-30):onTouch(nextLevel):addTo(mountNode)
        CARectButton:create({width=400,height=60}):setText(Localization.getString("share")):move(display.cx,display.cy-120):addTo(mountNode)
        return self
end

function SettingView:closeView()
	-- body
	self:removeSelf()
end
return SettingView