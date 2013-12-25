local multi_tile=Class{}
multi_tile:include(gt_widget)

function multi_tile:init(editor, x, y, id)
	editor.window_color.alpha=150
	editor.frame_color.alpha=190			
	gt_widget.init(self, editor, x, y, id, "pick a tile or group of tiles to use")
	self.modal=gt_transition("slideleft", 0, 0, editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight(), editor.window_color, editor.frame_color, editor)
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.weight=3
	self.working_layer=editor.selected.layer
	self:add_button(editor, "tilepick.png")
	self.select={}
	self.old_mouse=nil
	self.select.selected={}
	self.select.start=false
end

function multi_tile:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor.focus:gain(self.id) end
	gt_widget.mouse_pressed(self, editor)
	local center=editor:get_center_screen()
	local w, h=editor.sys.map.tileset.image:getWidth()+(editor.sys.map.tileset.tile_width*4), editor.sys.map.tileset.image:getHeight()
	local x, y=center.x-(w/2), center.y-(h/2)
	self.modal=gt_transition("slidedown", x, y, w, h, editor.window_color, editor.frame_color, editor)	
	self.modal:open()
return editor
end

function multi_tile:update(dt, editor)
	self.modal:update(dt)
	return editor
end

function multi_tile:get_singular_tile(editor)
	local hx, hy=0,0
	mouse=editor.mouse
	mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
	mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)
	local center=editor:get_center_screen()
	local grid=editor.sys.map.tileset:select_grid_layout(center.x, (center.y+self.modal.y)-(editor.sys.map.tileset.image:getHeight()/2))
	for i, v in ipairs(grid.hover_check) do
				if(editor:check_hover(mouse, v)) then
					editor.selected.tile=v.id
					editor.selected.tiles.use=false
					self.hover.x=v.x
					self.hover.y=v.y
				end
	end
end

function multi_tile:get_multiple_tiles(editor)
	local tile_height, tile_width=editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height	
	local center=editor:get_center_screen()
	local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)	editor.selected.tiles={}
	local x=math.floor((self.hover.x-grid.x)/tile_width)-1
	local y=math.floor((self.hover.y-grid.y)/tile_height)
	local w=math.floor(self.hover.width/tile_width)
	local h=math.floor(self.hover.height/tile_height)
	if(w==0) and (h==0) then
		self:get_singular_tile(editor)
	else
		editor.selected.tiles={x=x, y=y, w=w, h=h, use=true}	
	end
	return editor
end

function multi_tile:map_pressed(editor)
	if(not self.select.start) then
			self.select.start=true
			local hx, hy=0,0
			local mouse=editor.mouse
			mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
			editor.mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)
			local center=editor:get_center_screen()
			local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)	
			editor.selected.modal=self.modal
			for i, v in ipairs(grid.hover_check) do
						if(editor:check_hover(mouse, v)) then
							self.hover.x=v.x
							self.hover.y=v.y
							self.old_mouse={x=v.x, y=v.y}
						end
			end
	end
return editor
end

function multi_tile:map_hover(editor)
	if(self.select.start) then
			if(editor.mouse.holding==0) then
				self.select.start=false
				self:get_multiple_tiles(editor)
				self.old_mouse=nil
				self.hover.width=editor.sys.map.tileset.tile_width
				self.hover.height=editor.sys.map.tileset.tile_height
				editor.focus:lose() 
				self.button.active=false	
				self.modal:close()
			end
	end
					local hx, hy=0,0
					local mouse=editor.mouse	
					mouse.x=editor.mouse.x-(editor.sys.map.tileset.tile_width*2)
					mouse.y=editor.mouse.y-(editor.sys.map.tileset.tile_height*2)	
					local center=editor:get_center_screen()
					local grid=editor.sys.map.tileset:select_grid_layout(center.x, center.y+self.modal.y)
					for i, v in ipairs(grid.hover_check) do
								if(editor:check_hover(mouse, v)) then
									self.hover.x=v.x
									self.hover.y=v.y
									if(self.old_mouse~=nil) then
										self.hover.x=self.old_mouse.x
										self.hover.y=self.old_mouse.y
										self.hover.width=v.x-self.old_mouse.x
										self.hover.height=v.y-self.old_mouse.y
									end
								end
					end
return editor
end

function multi_tile:draw(editor)
	local center=editor:get_center_screen()
	self.modal:draw()
	if(self.modal.opened or self.modal.opening or self.modal.closing) then 
		editor.sys.map.tileset:select_grid(center.x, center.y+self.modal.y) 	
		if(self.modal.opened) then self.hover:draw() end
	end
	gt_widget.draw(self, editor)
	love.graphics.print(self.modal.y .. "  " .. (center.y+self.modal.y), 100, 200)
end

return multi_tile