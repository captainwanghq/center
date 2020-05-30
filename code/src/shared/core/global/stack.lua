local stack =  class("stack")

function stack:ctor( ... )
	-- body
	self.wrap = {}
	self.size = 0
end
function stack:push(element)
	self.size = self.size +1
	self.wrap[self.size] = element
end

function stack:pop()
	-- body
	local element = self:get_top()
	if element then 
		self.size = self.size -1
	end
	return element
end

function stack:get_top()
	-- body
	if self:is_empty() then return end
	return self.wrap[self.size] 
end

function stack:is_empty( ... )
	-- body
	return self.size == 0 
end

function stack:clear( ... )
	-- body
	self.wrap = {}
	self.size = 0
end

return stack