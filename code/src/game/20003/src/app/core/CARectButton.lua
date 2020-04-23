
local  CAButton = import(".CAButton")
local CARectButton = class("CARectButton",CAButton)
function CARectButton:onCreate(params)
    local draw = cc.DrawNode:create()
	draw:drawRect(cc.p(-params.width/2,-params.height/2),cc.p(params.width/2,params.height/2),cc.c4f(0.8,0.8,0.8,0.8))
	draw:drawRect(cc.p(-params.width/2-1,-params.height/2-1),cc.p(params.width/2+1,params.height/2+1),cc.c4f(0.9,0.9,0.9,0.9))
	draw:drawRect(cc.p(-params.width/2-2,-params.height/2-2),cc.p(params.width/2+2,params.height/2+2),cc.c4f(1,1,1,1))
	self:addChild(draw)
	local selected = cc.DrawNode:create()
	selected:drawSolidRect(cc.p(-params.width/2-2,-params.height/2-2),cc.p(params.width/2+2,params.height/2+2),cc.c4f(1,1,1,1))
	self.selected = selected
	selected:setVisible(false)
	self:addChild(selected)
	self.params = params
end

return CARectButton