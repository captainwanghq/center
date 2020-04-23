local CAButton = class("CAButton",cc.Node)
function CAButton:ctor(params)
	self.params = params
	if self.onCreate then self:onCreate(params) end
	self.text = cc.Label:create("",fontFilePath,28):move(0,0):addTo(self)
	self.text:setLocalZOrder(1)
	self:swallowTouches()
end

function CAButton:setText(msg)
	if self.text then 
		self.text:setString(msg)
	end
	return self
end

function CAButton:setTextColor(color)
	if self.text then 
		self.text:setColor(color)
	end
	return self
end

function CAButton:containPoint(pos)
	local ret = false
	if pos.x > -self.params.width/2  and pos.x <self.params.width/2 and pos.y>-self.params.height/2 and pos.y<self.params.height/2 then
		ret = true
	end
	return ret
end

function CAButton:onTouchBegan(touch,event)
	local pos = self:convertToNodeSpace(touch:getLocation()) 
    local ret =  self:containPoint(pos)
	if ret then 
		self:setTextColor(display.COLOR_BLACK)
	else
		self:setTextColor(display.COLOR_WHITE)
	end
	self.selected:setVisible(ret)
	return ret
end

function CAButton:onTouchMoved(touch,event)
  	local pos = self:convertToNodeSpace(touch:getLocation()) 
	local ret  = self:containPoint(pos)
	if ret then 
		self:setTextColor(display.COLOR_BLACK)
	else
		self:setTextColor(display.COLOR_WHITE)
	end
	self.selected:setVisible(ret)
end

function CAButton:setTextFontSize( size )
	-- body
	if self.text then 
		self.text:setSystemFontSize(size)
	end
	return self
end
function CAButton:onTouchEnded(touch,event)
   local pos =  self:convertToNodeSpace(touch:getLocation()) 
   local ret  = self:containPoint(pos)
   self.selected:setVisible(false)
   self:setTextColor(display.COLOR_WHITE)
   if ret  then
		if  self.callback then self.callback(self.callbackparams)   end
   end
end

function CAButton:onTouchCancelled(touch,event)
  
end

function CAButton:onTouch(callback,params)
	self.callback = callback
	self.callbackparams = params
	return self
end

function CAButton:swallowTouches()
	-- body
	local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(false)
    listener:registerScriptHandler(handler(self,self.onTouchBegan),cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(handler(self,self.onTouchMoved),cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(handler(self,self.onTouchEnded),cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(handler(self,self.onTouchCancelled),cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return CAButton