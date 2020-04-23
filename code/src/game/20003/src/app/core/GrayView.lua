local GrayView = class("GrayView",cc.load("mvc").ViewBase)

function GrayView:ctor(root)
    -- body
    local view = display.newLayer(cc.c4b(0,0,0,0)):addTo(self)
    self.rootView = root
    self:swallowTouches()
    self:setLocalZOrder(11)
    local node = display.newNode():addTo(self)
    node:setAnchorPoint(0.5,0.5)
    node:setPosition(display.cx,display.cy)
    node:setContentSize(cc.size(display.width,display.height))
    self.mountNode = node
    if self.EnterAction then self:EnterAction() end
    if self.onCreate then self:onCreate() end
    return self
end

function GrayView:EnterAction()
    -- body
    local scale = cc.ScaleTo:create(0.3,1)
    self.mountNode:setScale(0)
    self.mountNode:runAction(scale)
end

function GrayView:onTouchBegan(touch,event)
    return true
end

function GrayView:onTouchMoved(touch,event)
   
end

function GrayView:onTouchEnded(touch,event)
  
end

function GrayView:onTouchCancelled(touch,event)
   
end
function GrayView:swallowTouches()
	-- body
	local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(self.onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(self.onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(self.onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    listener:registerScriptHandler(self.onTouchCancelled,cc.Handler.EVENT_TOUCH_CANCELLED )
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

return GrayView