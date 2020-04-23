local rectWidth=120
local Levels = import("..data.Levels")
local res = {"red.png","blue.png","green.png"}
local Dot = class("Coin", function()
        return display.newNode()
end)
-- ccDrawSolidCircle(center, radius, angle, segments,scaleX,scaleY)
function Dot:ctor(nodeType,x,y)
    -- body
    self.nodeType = nodeType
    local color = cc.c4f(1,0,0,1)
    if nodeType == Levels.NODE_IS_BLACK then 
        color = cc.c4f(0,0,1,1)
    end
    --local sp = display.newSprite("circle.png"):addTo(self)
    --sp:setScale(0.6)   
    --self.dot = sp
    self.radius = 30
    self.x = x
    self.y = y
    self.dot = cc.DrawNode:create():addTo(self)
    self.dot:drawSolidCircle(cc.p(0,0),self.radius,1,360,1,1,color)
end

function Dot:checkTouch(x,y)
    -- body
    local posx,posy = self:getPosition()
    if cc.pGetLength(cc.p(x-posx,y-posy)) < self.radius then 
        return self.x ,self.y
    end
end


function Dot:getXY( ... )
    -- body
    return self.x,self.y
end
function Dot:move(x,y)
    -- body
    self:setPosition(x,y)
end

function Dot:getType()
    return self.nodeType
end

function Dot:flipping()
    if self.dot then 
        if self.nodeType == Levels.NODE_IS_BLACK then 
            self.nodeType =  Levels.NODE_IS_WHITE 
        elseif self.nodeType == Levels.NODE_IS_WHITE then 
            self.nodeType = Levels.NODE_IS_BLACK
        end

        local color = cc.c4f(1,0,0,1)
            if self.nodeType == Levels.NODE_IS_BLACK then 
            color = cc.c4f(0,0,1,1)
         end

        if self.dot then
            self.dot:runAction(transition.sequence({
                cc.ScaleTo:create(0.15, 1.2),
                cc.ScaleTo:create(0.1, 1),
                cc.CallFunc:create(function()
            self.dot:clear()
            self.dot:drawSolidCircle(cc.p(0,0),self.radius,1,360,1,1,color)
            local actions = {}
            local scale =1.2
            local time = 0.04
            for i = 1, 5 do
                actions[#actions + 1] = cc.ScaleTo:create(time, scale, 1)
                actions[#actions + 1] = cc.ScaleTo:create(time, 1, scale)
                scale = scale * 0.95
                time = time * 0.8
            end
                actions[#actions + 1] = cc.ScaleTo:create(0, 1, 1)
                self.dot:runAction(transition.sequence(actions))
             end)
            }))   
        end
    end
end

return Dot