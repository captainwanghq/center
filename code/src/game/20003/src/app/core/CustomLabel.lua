local CustomLabel = class("CustomAnimation",cc.Node)

function CustomLabel:ctor()
	self.tableFileName = {}
    return self
end

function CustomLabel:updateText( ... )
	-- body
	local offset = 0
	local s = 0
	local node = display.newNode():addTo(self)
	for i=1,#self.tableFileName do 
		local sp = display.newSprite(self.tableFileName[i])
		local w = sp:getContentSize().width
		local h = sp:getContentSize().height
		sp:move(offset+w/2,0)
		offset = offset+w 
		s = s+w 
		node:addChild(sp)
	end
	node:move(-s/2,0)
end

function CustomLabel:setText(num,fontname)
	-- body

	local stxt = tostring(num)
	for i=1,#stxt do 
		local n = string.sub(stxt,i,i)
		local fn = string.format("number/"..fontname.."_%d.png",n)
		self.tableFileName[i] = fn
	end
	self:updateText()
	return self
end


return CustomLabel 