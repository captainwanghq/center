local CommonView = class("CommonView",cc.load("mvc").ViewBase)

function CommonView:ctor(root)
    -- body
    self.rootView = root
    if self.onCreate then self:onCreate() end
    return self
end

return CommonView