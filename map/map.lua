gt_map=Class{}

function gt_map:pixel_to_map(x, y) --convert pixel cords to map cords.
	return math.floor(x/self.tileset.tile_width), math.floor(y/self.tileset.tile_height) 
end

function gt_map:map_to_screen(x, y) --convert map cords to screen cords.
	local x, y=self:map_to_pixel(x, y)
	return self:pixel_to_screen(x, y)
end

function gt_map:pixel_to_screen(x, y) --convert offset map pixel cords to screen cords.
	return x-self.camera.x, y-self.camera.y
end

function gt_map:map_to_pixel(x, y) --convert map cords to pixel cords.
	return x*self.tileset.tile_width, y*self.tileset.tile_height
end

function gt_map:init(map_table)
	self.name=map_table.name
	self.camera=map_table.camera
	self.height=map_table.height
	self.width=map_table.width
	self.tileset=map_table.tileset
	self.plugin_directory=map_table.plugin_directory
	self.layers={}
	self.objects={}	
	if(map_table.values==nil) then self.values={} else self.values=map_table.values end
end

function gt_map:save_table()
	local l={}
	l.name=self.name
	l.type=self.type
	l.x=self.x
	l.y=self.y
	l.camera=self.camera:save_table()
	l.tileset=self.tileset:save_table()	
	l.height=self.height
	l.width=self.width
	l.objects={}
	for i,v in ipairs(self.objects) do
		table.insert(l.objects, v:save_table())
	end
	l.layers={}
	for i,v in ipairs(self.layers) do
		table.insert(l.layers, v:save_table())
	end	
	return l
end

function gt_map:set_value(value, set)
	self.values[value]=set
end

function gt_map:get_value(value, set)
	return self.values[value]
end

function gt_map:get_camera()
	return self.camera
end

function gt_map:set_camera(camera)
	self.camera=camera
end

function gt_map:get_layer(id)
	return self.layers[id]
end

function gt_map:set_layer(id, layer)
	self.layers[id]=layer
end

function gt_map:move(x, y)
	self.camera:move(x, y)
	for i, v in self:get_layers() do
		v:move(x, y)
	end
end

function gt_map:scroll(x, y)
	self.camera:scroll(x, y)
	for i, v in self:get_layers() do
		v:scroll(x, y)
	end
end

function gt_map:add_layer(v)
			if(v.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/layers/" .. v.type .. ".lua")) then
				local layer_class=love.filesystem.load(self.plugin_directory .. "/layers/" .. v.type .. ".lua")()
				table.insert(self.layers, layer_class(v))
			else
				table.insert(self.layers, gt_layer(v))			
			end
end

function gt_map:add_object(object)
			if(object.type~=nil) and (love.filesystem.exists(self.plugin_directory .. "/objects/" .. object.type .. ".lua")) then
				local object_class=love.filesystem.load(self.plugin_directory .. "/objects/" .. object.type .. ".lua")()
				table.insert(self.objects, object_class(object))
			else
				table.insert(self.objects, gt_object(object))			
			end	
end

function gt_map:raise_object(object)
	if(object.layer<#self.layers) then
		object.layer=object.layer+1
	end
end

function gt_map:lower_object(object)
	if(object.layer>1) then
		object.layer=object.layer-1
	end
end

function gt_map:raise_layer(layer)
	
end

function gt_map:lower_layer(layer)

end

function gt_map:get_objects()
	return ipairs(self.objects)
end

function gt_map:set_objects(objects)
	self.objects=objects
end

function gt_map:get_layers()
	return ipairs(self.layers)
end

function gt_map:object_draw(layer)
	for i, o in ipairs(self.objects) do
		if(o.layer==layer) and (not o.hidden) then o:draw(self:get_layer(layer)) end 
	end
end

function gt_map:update(dt)
	for l, i in self:get_layers() do
		i:update(dt)
	end
	for l, i in self:get_objects() do
		i:update(self:get_layer(i.layer), dt)
	end
end

function gt_map:draw()
	for l, i in self:get_layers() do
		i:draw()
		self:object_draw(l)
	end
end