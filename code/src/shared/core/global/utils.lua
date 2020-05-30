local wrap_handler = class("wrap_handler")

function wrap_handler:init(cb,...)
	-- body
	self.cb = cb
	self.args = {...}
end

function wrap_handler:exec(... )
	-- body
	local cb = self.cb
	if cb then 
		local args = self.args
		table.insert(args,...)
		cb(unpack(args))
	end
end

utils = utils or {}

function utils.gen_wrap_handler(cb,...)
	local h = wrap_handler.new()
	h:init(cb,...)
	return h
end