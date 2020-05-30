
local timer_handler = class("timer_handler")

function timer_handler:init(interval,delay,repeate,elapsed,times,is_update,cb,tag,target)
	-- body
	self.interval = interval
	self.delay = delay
	self.repeate = repeate
	self.elapsed = elapsed
	self.times  = times
	self.is_update = is_update
	self.cb = cb
	self.tag = tag
	self.target = target
	self.has_target = target ~= nil
end

function timer_handler:is_valid( ... )
	-- body
	 if  tolua.isnull(self.target) == true then 
	 	return false
	 else

	 	return true
	 end

	return self.has_target 
end

local g_timer = class("g_timer")
local stack = require("core.global.stack")
local link_list = require("core.global.link_list")
function g_timer:ctor()
	self.key = 0
	self.iter_list = link_list.new()
	self.pending_list = link_list.new()
	self.pool  = stack.new()
end

function g_timer:add(interval ,delay ,repeate ,cb ,is_update, tag,target)
	-- body
	local th = self.pool:pop()
	if not th then 
		th = timer_handler.new()
	end
	th:init(interval,delay,repeate,0,0,is_update,cb,tag,target)
	self.key = self.key + 1
	return self.pending_list:append(self.key,th)
end

function g_timer:remove( key )
	-- body
	if not self:_remove_iter(key) then
		self:_remove_pending(key)
	end
end

function g_timer:_remove_iter( key )
	-- body
	local node = self.iter_list:remove(key)
	if node then 
		self.pool:push(node.data)
		node.data = nil
		return true
	end
	return false
end

function g_timer:_remove_pending(key)
	-- body
	local node = self.pending_list:remove(key)
	if node then 
		self.pool:push(node.data)
		node.data = nil
		return true
	end
	return false
end

function g_timer:loop( interval,cb,tag,target )
	-- body
	return self:add(interval,0,0,cb,false,tag,target)
end

function g_timer:loop_times(interval,repeate,cb,tag,target )
	-- body
	return self:add(interval,0,repeate,cb,false,tag,target)
end

function g_timer:frame_loop( cb,tag,target )
	-- body
	return self:add(1/60,0,0,cb,false,tag,target)
end

function g_timer:add_updater(cb,tag,target)
	-- body
	return self:add(0,0,0,cb,true,tag,target)
end


function g_timer:run( dt )
	-- body
	local node = self.iter_list:get_head()
	while node do 
		local handler = node.data
		repeat 
			if  not handler  or  handler:is_valid() == false then 
				local next_node = node.next_node
				self:_remove_iter(node.key)
				node = next_node
				break
			end
		until true

		local repeate = handler.repeate
		local delay = handler.delay
		local interval = handler.interval
		local times = handler.times
		local elapsed = handler.elapsed
		local cb = handler.cb

		repeat
			if handler.is_update then 
				local next_node = node.next_node
				if cb and cb.exec then 
				 cb:exec(dt)
				end
				node = next_node
				break
			end
		until true


		repeat
			if repeate~=0 and times >= repeate then 
				local next_node = node.next_node
				local ret = self:_remove_iter(node.key)
				node = next_node
				break
			end
		until true


		if elapsed >= delay + interval then 
			if node then 
				local next_node = node.next_node
				handler.times = handler.times + 1
				handler.elapsed = delay
				if cb and cb.exec then 
				 cb:exec(dt)
				end
				node = next_node
			end
		else
			handler.elapsed  = handler.elapsed + dt
			if node then 
				node = node.next_node
			end
		end
	end

	node = self.pending_list:get_head()
	while node do 
		local key = node.key
		local th = node.data
		node = node.next_node
		self.pending_list:remove(key)
		self.iter_list:append(key,th)
	end
end

function g_timer:start( ... )
	-- body
	if not self.schedule_id then 
		self.schedule_id = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,self.run),1/60,false)
	end
end

function g_timer:stop( ... )
	-- body
	if self.schedule_id then
		 cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedule_id)
		 self.schedule_id = nil
	end
end
return g_timer