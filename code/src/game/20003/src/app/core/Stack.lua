local Stack = {}
Stack.wrap = {}
Stack.size = 0
function Stack:Push(element)
	Stack.size = Stack.size +1
	Stack.wrap[Stack.size] = element
end

function Stack:Pop()
	-- body
	if Stack:isEmpty() then return end
	Stack.size = Stack.size -1
end

function Stack:GetTop()
	-- body
	if Stack:isEmpty() then return end
	return Stack.wrap[Stack.size] 
end

function Stack:isEmpty( ... )
	-- body
	return Stack.size == 0 
end

function Stack:Clear( ... )
	-- body
	Stack.wrap = {}
	Stack.size = 0
end
return Stack