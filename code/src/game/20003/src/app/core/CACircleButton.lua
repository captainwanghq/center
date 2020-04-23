local  CAButton = import(".CAButton")
local CACircleButton = class("CACircleButton",CAButton)
function CACircleButton:onCreate(params)
    local draw = cc.DrawNode:create()
	draw:drawCircle(cc.p(0,0),params.width/2,1,360,false ,1,1,cc.c4f(1,1,1,1))
	self.frame=draw
	self:addChild(draw)
	local selected = cc.DrawNode:create()
	selected:drawSolidCircle(cc.p(0,0),params.width/2,1,360 ,1,1,cc.c4f(1,1,1,1))
	self.selected = selected
	selected:setVisible(false)
	self:addChild(selected)
	self.params = params
end

function CACircleButton:setFrameColor(color)
	self.color = color
	local params = self.params
--[[	if self.text then 
		self.text:setColor(color)
	end
]]
	if self.frame then 
	  self.frame:clear()
	  self.frame:drawCircle(cc.p(0,0),params.width/2,1,360,false ,1,1,color)
	end
	if self.selected then 
		self.selected:clear()
		self.selected:drawSolidCircle(cc.p(0,0),params.width/2,1,360 ,1,1,color)
	end

	return self
end


function CACircleButton:containPoint(pos)
	local ret = false
	local distance = ccpDistance(pos,cc.p(0,0))
	if distance < self.params.width/2 then
		ret = true
	end
	return ret
end

return CACircleButton