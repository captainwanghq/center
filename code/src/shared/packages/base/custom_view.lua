local custom_view = class("custom_view", cc.load("mvc").ViewBase)

function custom_view:on(event_name,func,parms)
	self.event_list = self.event_list or {}
	local handle = cs.ui_event:on(event_name,func,parms)
	self.event_list[event_name] = handle
	return handle
end

function custom_view:emit(event)
	-- body
	return cs.ui_event:emit(event)
end

function custom_view:onEnter()
	-- body
	self.event_list = self.event_list or {}
end
function custom_view:onExit()
	-- body
	if next(self.event_list or {}) then 
		for _,handle in pairs(self.event_list) do 
			 cs.ui_event:removeEventListener(handle)
		end
		self.event_list = {}
	end
end
return custom_view