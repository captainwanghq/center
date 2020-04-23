local Toast = {}

function Toast:show(params)
	local msg = params.msg

	local node = display.newNode():addTo(params.node)
    local sp =  display.newSprite("store_item.png",{ rect = cc.rect(0, 0, 104, 104) ,capInsets =cc.rect(30, 30, 44, 44)}):addTo(node)
    local tip = cc.Label:create(msg,fontFilePath,36):setColor(cc.c3b(138,80,0)):addTo(node)
    local size = tip:getContentSize()
    local width = 200
    if size.width > 200 then 
		width = size.width +20
    end
    node:setContentSize(width,100)
    sp:setContentSize(width,100)
    local function callback()
		node:removeSelf()
	end
	node:move(display.cx,display.cy)
	node:setScale(0)
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.2,1),cc.FadeIn:create(1),cc.CallFunc:create(callback))
    node:runAction(seq)
end

function Toast:tip(params)
    -- body
    local msg = params.msg
    local draw = cc.DrawNode:create():addTo(params.node)
   -- draw:drawRect(cc.p(-params.width/2,-params.height/2),cc.p(params.width/2,params.height/2),cc.c4f(0.8,0,0,0.8))
   -- draw:drawRect(cc.p(-params.width/2-1,-params.height/2-1),cc.p(params.width/2+1,params.height/2+1),cc.c4f(0.9,0,0,0.9))
  --  draw:drawRect(cc.p(-params.width/2-2,-params.height/2-2),cc.p(params.width/2+2,params.height/2+2),cc.c4f(1,0,0,1))
  --  draw:drawSolidRect(cc.p(-params.width/2-2,-params.height/2-2),cc.p(params.width/2+2,params.height/2+2),cc.c4f(0.6,0,0,0.7))
    local function callback()
        draw:removeSelf()
    end
    local tip = cc.Label:create(msg,fontFilePath,36):setColor(cc.c3b(255,0,0)):addTo(draw)
    draw:move(display.cx,display.top-200)
    draw:setScale(0)
    local seq = cc.Sequence:create(cc.ScaleTo:create(0.2,1),cc.FadeIn:create(1),cc.CallFunc:create(callback))
    draw:runAction(seq)

end

return Toast