local g_event = class("g_event")

function g_event:ctor()
	cc.bind(self,"event")
end

function g_event:on( eventName, listener, tag)
	-- body
	local target,handle = self:addEventListener(eventName, listener, tag)
	return handle
end

function g_event:emit( event )
	-- body
	return self:dispatchEvent(event)
end

return g_event