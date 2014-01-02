local object_tool=Class{}
object_tool:include(gt_widget)

function object_tool:init(editor, x, y, id)
	gt_widget.init(self, editor, x, y, id, "place an object")
	self.hover=gt_frame(0, 0, editor.sys.map.tileset.tile_width, editor.sys.map.tileset.tile_height, {r=216, g=194, b=92, alpha=100}, {r=133, g=120, b=57, alpha=175})
	self.working_layer=1
	self.tile={width=editor.sys.map.tileset.tile_width, height=editor.sys.map.tileset.tile_height, draw=false, scale=editor.sys.scale}
	self:add_button(editor, "objectdrop.png")
end

function object_tool:mouse_pressed(editor)
	if(editor.focus:get()~=self.id) then editor:lose_focus() editor:gain_focus(self.id) self.button.active=true end
	gt_widget.mouse_pressed(self, editor)
return editor
end

function object_tool:map_pressed(editor)
	local mapx,mapy=editor.mouse.map.x, editor.mouse.map.y
	local tileset=editor.sys.map.layers[editor.selected.layer].tileset
	if(editor.mouse.pressed=="l") then
			if(not editor.selected.tiles.use) then
				editor.sys.map:set_tile(editor.selected.tile, editor.selected.layer, mapx, mapy)
			else
				local ox,oy=editor.selected.tiles.x, editor.selected.tiles.y
				local x, y=1,1
				local center=editor:get_center_screen()
				local grid=tileset:select_grid_layout(center.x, center.y+editor.selected.modal.y)			
				
				while y<=editor.selected.tiles.h do
					while x<=editor.selected.tiles.w do
							if(grid.tile_map[y+oy][x+ox]~=nil) then 
								editor.sys.map:set_tile(grid.tile_map[y+oy][x+ox], editor.selected.layer, mapx+x, mapy+y) 
							else
								editor.sys.map:set_tile(1, editor.selected.layer, mapx+x, mapy+y)
							end
							x=x+1
					end
					x=1
					y=y+1
				end
			end
	else
		editor.selected.tile=editor.sys.map:get_tile(editor.selected.layer, mapx, mapy)
		editor.selected.tiles.use=false
	end
return editor
end

function object_tool:map_hover(editor)
	if(editor.focus:get()==self.id) then  self.tile.draw=true else self.tile.draw=false end
return editor
end

function object_tool:draw(editor)
	if(self.tile.draw) then 
		self.hover.x=editor.mouse.hover.x
		self.hover.y=editor.mouse.hover.y
		self.hover:draw()	
	end
	gt_widget.draw(self, editor)
end

return object_tool