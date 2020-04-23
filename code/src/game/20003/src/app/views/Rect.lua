local Rect = class("Rect", function()
    return display.newNode()
end)

function Rect:ctor(params)
	local width = params.width
	local height = params.height
	local color = params.color
	local draw = cc.DrawNode:create():addTo(self)
	self.width = width
	self.height = height
	self.color = color
	draw:drawRect(cc.p(0,0),cc.p(width,height),cc.c4f(0.8,0.8,0.8,0.8))
	draw:drawRect(cc.p(-1,-1),cc.p(width+1,height+1),cc.c4f(0.9,0.9,0.9,0.9))
	draw:drawRect(cc.p(-2,-2),cc.p(width+2,height+2),color)
	draw:drawSolidRect(cc.p(0,0),cc.p(width,height),cc.c4f(0,0,0,0.8))
end
function Rect:center()
	self:setPosition(cc.p(display.cx-self.width/2,display.cy-self.height/2))
end
return Rect