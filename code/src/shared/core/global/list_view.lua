local list_view = class("list_view")
function list_view:ctor(params)
	self.gap_x = params.gap_x or 0
	self.gap_y = params.gap_y or 0
	self.padding_left = params.padding_left or 0
	self.padding_right = params.padding_right or 0
	self.padding_top = params.padding_top or 0
	self.padding_bottom = params.padding_bottom or 0
	self.row = params.row or 1
	self.col = params.col or 1
	self.width = params.width 
	self.height = params.height
	self.item_tpl = params.item_tpl
	self.item_width = params.item_tpl.width
	self.item_height= params.item_tpl.height
end

function list_view:set_data( ... )
	-- body
end

function list_view:insert_data(idx,data )
	-- body
end

function list_view:remove_data(idx,count )
	-- body
end

function list_view:append_data( data )
	-- body

end

function list_view:get_item( idx )
	-- body
end

function list_view:get_data( idx )
	-- body
end

function list_view:find_item( ... )
	-- body
end

function list_view:find_index( ... )
	-- body
end

function list_view:layout_items(startpos)
	-- body
end

function list_view:adjust_content( ... )
	-- body
end

function list_view:set_content_size()

end

function list_view:index_from_offset( offset )


end

function list_view:render( ... )
	-- body
	local posy = self.content.y 
	if posy < 0 then 
		posy = 0
	else if posy > self.content_height - self.height then 
		posy = self.content_height - self.height
	end

	local viewport_start = -posy

	local viewport_stop = viewport_start - self.height

end

return list_view