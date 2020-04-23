
local PlayScene = class("PlayScene", cc.load("mvc").ViewBase)
local FlipView = import(".FlipView")
function PlayScene:onCreate()
    -- create game view and add it to stage
end

function PlayScene:start(params)
    -- body
  --[[
     self.gameView_ = GameView:create()
    :addEventListener(GameView.events.GAMEOVER_EVENT,handler(self,self.gameOver))
    :enterGame(params)
    :start()
    :addTo(self)
	]]
	self.flipView = FlipView:create():enterGame(params)
	:addTo(self)
end

function PlayScene:gameOver()
    -- body
     self:getApp():enterScene("MainScene")
end

return PlayScene
