local stack = require("core.global.stack")

local link_list = class("link_list")

function link_list:ctor()
	self.pool  = stack.new()
	self._head = nil
	self._tail = nil
end

function link_list:spawn_node( _key,_data )
	-- body
	local node = self.pool:pop()
	if node then 
		node.key = _key
		node.data = _data
		node.next_node = nil
	else
		node = {key =_key,data = _data,next_node = nil}
	end
	return node
end

function link_list:get_head( ... )
	-- body
	return self._head
end

function link_list:get_tail( ... )
	-- body
	return self._tail
end

function link_list:append(key,data)
	-- body
	local node = self:spawn_node(key,data)
	if self._tail then 
		self._tail.next_node = node
		self._tail = node
	else
		 self._tail = node
		 self._head = self._tail
	end
	return node.key
end

function link_list:remove(key)
	-- body
	if not key then return end

	if not self._head then return end

	local prev
	local curr = self._head
	while curr and curr.key ~= key do 
		prev = curr
		curr = curr.next_node
	end 
	if not curr then return end

	if not prev then 
		 self._head = curr.next_node
		 if not curr.next_node then 
		 	self._tail = nil
		 end
	else 
		prev.next_node = curr.next_node
		if not curr.next_node then 
			self._tail = prev
		end
	end
	self.pool:push(curr)
	return curr
end

return link_list