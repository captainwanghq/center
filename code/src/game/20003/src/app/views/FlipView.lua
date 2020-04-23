local Levels = import("..data.Levels")
local Dot = import(".Dot")
local Rect = import(".Rect")
local SettingView = import(".SettingView")
local rectWidth=120
local FlipView = class("FlipView", cc.load("mvc").ViewBase)
local  CACircleButton = import("..core.CACircleButton")
local Localization = import("..data.Localization")
local LevelsManager = import("..manager.LevelsManager")
function FlipView:randomDot()

    for i = 1,100 do
        math.randomseed(os.time())
        local x = math.random(0,display.width)
        local y = math.random(0,display.height)
        local dot = cc.DrawNode:create()
        dot:drawDot(cc.p(x,y),10,cc.c4f(1,0,1,1))
        self:addChild(dot)
    end
end

function FlipView:enterGame(params)
    self.level = params.level
    self:newLevel(self.level)

    self:recordInfo()
    return self
end

function FlipView:onCreate( ... )
	-- body
	  self.level = 1
     local bg = cc.DrawNode:create():addTo(self)
    bg:drawRect(cc.p(0,0),cc.p(display.width,display.height),cc.c4f(0,0,0,1))
    
  	self.touchLayer =  cc.Layer:create()
  	self.touchLayer:onTouch(handler(self,self.onTouch))
  	self:addChild(self.touchLayer)

    local bg = cc.DrawNode:create()
    bg:drawSolidRect(cc.p(0,0),cc.p(display.width,display.height),cc.c4f(0,0,0,0.4))
    self:addChild(bg)


    CACircleButton:create({width=60,height=60}):move(display.right-80,display.top-40):onTouch(handler(self,self.resetLevel)):setText(Localization.getString("reset")):setTextFontSize(18):addTo(self)

    CACircleButton:create({width=60,height=60}):move(display.left+80,display.top-40):onTouch(handler(self,self.toMain)):setText(Localization.getString("back")):setTextFontSize(18):addTo(self)

    CACircleButton:create({width=60,height=60}):move(display.right-80,display.top+140):onTouch(handler(self,self.resetLevel)):setText("Last"):setTextFontSize(18):addTo(self)

    CACircleButton:create({width=60,height=60}):move(display.left+80,display.top+140):onTouch(handler(self,self.toMain)):setText("Next"):setTextFontSize(18):addTo(self)
    return self
end

function FlipView:resetLevel( ... )
  -- body
   self:newLevel(self.level)
end

function FlipView:toMain( ... )
  -- body
    self:getApp():enterScene("ChooseLevel","Fade", 1, display.COLOR_BLACK)
end
function FlipView:newLevel(level)
	-- body

  if self.gameNode then self.gameNode:removeAllChildren() self.gameNode = nil  end
  self.gameNode = display.newNode():addTo(self)
  self.gameNode:setLocalZOrder(-1)
  self.steps = 0
  self.record =  LevelsManager:getRecord()[self.level]
  self.dotTable = {}
  local levelData = clone(Levels.get(level))
  self.levelData = levelData
  self.rows = levelData.rows
  self.cols = levelData.cols
  local offsetx = display.cx - rectWidth*self.cols/2
  local offsety = display.cy -rectWidth*self.rows/2 
  local gridDraw = cc.DrawNode:create()
  for i=1,self.rows do 
	for j=1,self.cols do 
		gridDraw:drawRect(cc.p(j*rectWidth-rectWidth+offsetx,i*rectWidth-rectWidth+offsety),cc.p(j*rectWidth+offsetx,i*rectWidth+offsety),cc.c4f(0.5,1,0.5,1))
		if levelData.grid[i][j]~="X" then 
			local dot = Dot.new(levelData.grid[i][j],i,j)
			dot:move((j*rectWidth-rectWidth+offsetx+j*rectWidth+offsetx)/2,(i*rectWidth-rectWidth+offsety+i*rectWidth+offsety)/2)
			table.insert(self.dotTable,dot)
			self.gameNode:addChild(dot)
		end
	end
  end 
  self.gameNode:addChild(gridDraw)
end

function FlipView:findNeighbor( x,y )
	-- body
	for k,v in pairs(self.dotTable) do
		local i,j = v:getXY()
		if i == x and j == y then
			return v
		end
	end
end

function FlipView:recordInfo( ... )
	-- body
	  local lb_level = cc.Label:create(string.format(Localization.getString("level"),self.level),fontFilePath,40)
  	lb_level:move(display.cx,display.top-40)
  	self.lb_level = lb_level
	  self:addChild(lb_level)

	  local lb_step = cc.Label:create(string.format(Localization.getString("step"),self.steps),fontFilePath,32)
	  local y = display.cy+rectWidth*self.rows/2
	  lb_step:move(display.cx,display.top-180)
	  self.lb_step = lb_step
	  self:addChild(lb_step)

    local lb_record = cc.Label:create(string.format(Localization.getString("record"),  self.record.steps),fontFilePath,32):addTo(self)
    lb_record:setVisible(self.record.steps~=0)
    local y = display.cy+rectWidth*self.rows/2
    lb_record:move(display.cx,display.top-120)
    self.lb_record = lb_record
end

function FlipView:updateInfo( ... )
	-- body
	if self.lb_level then self.lb_level:setString(string.format(Localization.getString("level"),self.level)) end
	if self.lb_step then self.lb_step:setString(string.format(Localization.getString("step"),self.steps)) end
  if self.lb_record then self.lb_record:setString(string.format(Localization.getString("record"),self.record.steps))  self.lb_record:setVisible(self.record.steps~=0) end
end
function FlipView:flipNeighbor( x,y )
	-- body
	local  dot = self:findNeighbor(x,y)
	if dot then dot:flipping() end
end

function FlipView:flipping(dot,x,y)
	-- body
	dot:flipping()
	self:flipNeighbor(x-1,y)
	self:flipNeighbor(x+1,y)
	self:flipNeighbor(x,y-1)
	self:flipNeighbor(x,y+1)
end

function FlipView:onTouch(event)
	-- body
	  if event.name ~= "began" then return end
	  for k,v in pairs(self.dotTable) do 
	  	 local x,y = v:checkTouch(event.x,event.y)
	  	 if x and y then
	  	 	self:flipping(v,x,y)
	  	 	self.steps = self.steps +1 
	  		self:updateInfo()
	  	 end
	  end
	  
	 
      local pass = true
      for k,v in pairs(self.dotTable) do
            local nodeType = v:getType()
            if nodeType == 0 then
                pass = false
                break
            end
      end
     if pass then
        LevelsManager:addRecord({level = self.level,steps=self.steps,pass = 0})
        self:NextLevel()
        return 
     end

      local pass = true
      for k,v in pairs(self.dotTable) do
            local nodeType = v:getType()
            if nodeType ==1 then
                pass = false
                break
            end
      end
     if pass then
        LevelsManager:addRecord({level = self.level,steps=self.steps,pass = 0})
        self:NextLevel()
        return 
     end
end

function FlipView:start( ... )
	-- body
	 self:scheduleUpdate(handler(self, self.step))
    return self
end

function FlipView:NextLevel()
    local function callback()
        self.level = self.level + 1
        self:newLevel(self.level)
        self:updateInfo()
    end
    SettingView:create(self):show(self.steps,callback):addTo(self)
end


function FlipView:step( ... )
	-- body
end
return FlipView