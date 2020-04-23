local Button = ccui.Button

function Button:onTouch(callback,params)
    local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
     
        elseif eventType == ccui.TouchEventType.moved then
         
        elseif eventType == ccui.TouchEventType.ended then
            callback(sender,params)
        elseif eventType == ccui.TouchEventType.canceled then
            
        end
    end
    self:addTouchEventListener(touchEvent)  
end

function Button:setText(text,fontName,fontsize,color)
	if text then self:setTitleText(text) end
	if fontName  then self:setTitleFontName(fontName) end
	if fontsize then self:setTitleFontSize(fontsize) end
	if color then self:setTitleColor(color) end
end




local Label = cc.Label

function Label:create(txt,fontName,size)
    -- body
    if cc.FileUtils:getInstance():isFileExist(fontName) then
            local lb = cc.Label:createWithTTF(txt,fontName,size)
        --    lb:setTextColor(cc.c4b(255, 255, 255, 255))
          --  lb:enableOutline(cc.c4b(0, 0, 0, 255), 2)
        --    lb:enableShadow(cc.c4b(0, 0, 0, 255))
      --      lb:enableGlow(cc.c4b(255, 255, 0, 255))
        return lb
    else
            local lb = cc.Label:createWithSystemFont(txt,fontName,size)
           -- lb:setTextColor(cc.c4b(255, 0, 0, 255))
           -- lb:enableOutline(cc.c4b(255, 255, 255, 255), 2)
            --lb:enableShadow(cc.c4b(0, 0, 0, 255),cc.size(-2,2))
            --lb:setTextColor( cc.c4b(0, 255, 0, 255) )
            --lb:enableGlow(cc.c4b(255, 255, 0, 255))
        return lb
    end
end