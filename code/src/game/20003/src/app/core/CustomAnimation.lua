local CustomAnimation = class("CustomAnimation",cc.Node)
local index = 1
local frameFeq = 45
function CustomAnimation:ctor()
	self.defalut = display.newSprite():addTo(self)
 	self:scheduleUpdate(handler(self, self.step))
    return self
end

function CustomAnimation:step(dt)
	-- body tx_sd_01
	if self.sp then 
		print("-")
		local texture = display.loadImage(string.format("ani/bianse%d.png",frameFeq%3))
	    local frame = display.newSpriteFrame(texture,cc.rect(0, 0, 120,120))
		self.sp:setSpriteFrame(frame)
		frameFeq = frameFeq -1
	end
	return self
end

function CustomAnimation:createAni(src,des)
	-- body
end

function CustomAnimation:playAni(target)
	-- body
	self.sp = target
end

function CustomAnimation:stop()
	-- body
	self:unscheduleUpdate()
    return self
end
return CustomAnimation
