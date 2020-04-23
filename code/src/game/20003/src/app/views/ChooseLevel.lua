local LevelsManager = import("..manager.LevelsManager")
local Levels = import("..data.Levels")
local ChooseLevel = class("ChooseLevel",cc.load("mvc").ViewBase)
local Localization = import("..data.Localization")
local Toast = import("app.core.Toast")

local  CACircleButton = import("..core.CACircleButton")

function ChooseLevel:onCreate()
	-- body
    print("ChooseLevel:onCreate")
    local bg = cc.DrawNode:create():addTo(self)
    bg:drawRect(cc.p(0,0),cc.p(display.width,display.height),cc.c4f(0,0,0,1))
    local lb_choose = cc.Label:create(Localization.getString("chooselevel"),fontFilePath,40):move(display.cx,display.top-40):addTo(self)

    local pageView = ccui.PageView:create()
    pageView:setTouchEnabled(true)
    pageView:setContentSize(cc.size(display.width,800))
    pageView:setPosition(cc.p(0, display.cy-400))
    self:addChild(pageView)
    local pages = math.ceil(Levels.numLevels()/25)
    for j = 1 , pages do
        local layout = ccui.Layout:create()
        local records = LevelsManager:getRecord()
        local index = 0
        for i = 0, 24 do 
            index = i%25
                local x = index%5
                local y = math.floor(index/5)
                local level = (i+1)+(j-1)*25
                local btn = CACircleButton:create({width=80,height=80})
                :setText(""..level)
                :move(x*100+50+display.cx-250,y*100+50+display.cy-400)
               -- :move(x*100+50-100*2.5+display.cx,y*100+display.cy-100*2.5+50)
                :onTouch(function(params)
                            self:enterToGame(params)
                         end
                        ,{level = level})
                :addTo(layout)
                
                if records[level] then 
                    if records[level].pass==1 then 
                        btn:setFrameColor(cc.c4f(1,1,0,1))
                    elseif records[level].pass == 0 then 
                        btn:setFrameColor(cc.c4f(0,0.6,0,1))
                     else
                        btn:setFrameColor(cc.c4f(1,0,0,1))
                    end
                else 
                    btn:setFrameColor(cc.c4f(1,0,0,1))
                end
        end
        pageView:addPage(layout)

    end 

    local indicators = cc.DrawNode:create():addTo(self)
    for i=0,pages-1 do  
        local curpage = pageView:getCurrentPageIndex() 
        local color  = cc.c4f(0,0.6,0,1)
        if curpage == i then 
            color = cc.c4f(1,0,0,1)
        end
        local pos = cc.p(i*30+display.cx-pages*30/2+15,240)
        indicators:drawDot(pos,10,color)
    end
  
    local function pageViewEvent(sender, eventType)
        if eventType == ccui.PageViewEventType.turning then
        local curpage = pageView:getCurrentPageIndex() 
        indicators:clear()
        for i=0,pages-1 do  
            local color  = cc.c4f(0,0.6,0,1)
            if curpage == i then 
                color = cc.c4f(1,0,0,1)
            end
                local pos = cc.p(i*30+display.cx-pages*30/2+15,240)
                indicators:drawDot(pos,10,color)
            end
        end
    end 

    pageView:addEventListener(pageViewEvent)
end

function ChooseLevel:enterToGame( params)
    -- body
     local level = params.level
    local records = LevelsManager:getRecord()
    if records[level] and records[level].pass then 
        self:getApp():enterScene("PlayScene","Fade", 1, display.COLOR_BLACK):start(params)
    else
        Toast:tip({width=200,height =60,node = self,msg = Localization.getString("unlock")})
    end
end

return ChooseLevel