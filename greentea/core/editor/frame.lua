gt_frame=Class{}

function gt_frame:init(x, y, w, h, col, outline)
	self.x=x
	self.y=y
	self.width=w
	self.height=h
	self.col=col
	self.hidden=false
	self.outline=outline
end

function gt_frame:draw()
			if(self.hidden) then return end
		   love.graphics.setLineStyle("rough")

		   love.graphics.setColor(self.col.r/255, self.col.g/255, self.col.b/255, self.col.alpha/100)
		   love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		   		   
		   love.graphics.setColor(self.outline.r/255, self.outline.g/255, self.outline.b/255, self.outline.alpha/100)

		   -- RIGHT HAND SIDE
		   love.graphics.line(self.x+self.width, self.y+1, self.x+self.width, self.y+self.height-1)
		   -- TOP
		   love.graphics.line(self.x+1, self.y, self.x+self.width-1, self.y)
		   --BOTTOM
		   love.graphics.line(self.x+1, self.y+self.height, self.x+self.width-1, self.y+self.height)
		   -- LEFT HAND SIDE
		   love.graphics.line(self.x, self.y+1, self.x, self.y+self.height-1)
	   
			love.graphics.setPointSize(3)
		   --pixel top left hand side
		   love.graphics.points(self.x+.5, self.y+.5)
		   --pixel top right hand side
		   love.graphics.points(self.x+((self.width)-.5), self.y+.5)
		   --pixel bottom right hand side
		   love.graphics.points(self.x+.5, self.y+(self.height)-0.5)
		   --pixel top bottom hand left side
		   love.graphics.points(self.x+((self.width)-.5), self.y+(self.height)-0.5)		   

		   love.graphics.setLineStyle("smooth")
		   love.graphics.setColor(255/255, 255/255, 255/255, 100/100)	
end