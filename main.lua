--[[
Made by jordan4ibanez on 5/14/2018 as a test of simplicity


What is happening here?

x and y are the objects position (top left corner)

sx and sy are the objects width and height

fixed decides if the object will have gravity applied

ix and iy are the inertial values (horizontal/vertical)

]]--


local gravity = 9.28

local g_func = {} --custom game function table

--this holds all collision objects
local object_table = {
{x=10,y=0,sx=50,sy=50,fixed=false,ix=0,iy=0}, --x,y quards | sx,sy width and height | fixed is if it moves (true is don't) | iy ix is inertia
{x=10,y=400,sx=500,sy=50,fixed=true,ix=0,iy=0}, 
}

function love.draw()
	for item = 1,table.getn(object_table) do

		local ti = object_table[item]
		
		--differentiate colors for debugging purposes
		if ti.fixed == true then
			love.graphics.setColor(255,0,0)
		else
			love.graphics.setColor(255,255,255)
		end
		
		love.graphics.rectangle( "fill", ti.x, ti.y, ti.sx, ti.sy )
	end
	
end


function love.update(dt)
	--apply inertial gravity to object
	for item = 1,table.getn(object_table) do
		local ti = object_table[item]
		--only apply collision/inertia to non-fixed objects
		if ti.fixed == false then
			ti.iy = ti.iy + (dt*10) -- original
			ti.y = ti.y + ti.iy
			ti.x = ti.x + ti.ix
			
			--max out object's gravity velocity
			if ti.iy > gravity then
				ti.iy = gravity
			end
			g_func.collision(item)
		end
	end
end

--simple collision detection with other objects
function g_func.collision(item)
	local ti = object_table[item]
	for index = 1,table.getn(object_table) do
		--do not collide with self
		if index ~= item then
			local it = object_table[index]
				
		
			--detect collision
			if (ti.x < it.x + it.sx  and
			    ti.x + ti.sx > it.x  and
			    ti.y < it.y + it.sy  and
			    ti.sy + ti.y > it.y) then
			   
			   --position correction	
				
				--check the distances
				local comparey = ti.y-it.y
				local comparex = ti.x-it.x
				
				print("collision detected! Distance x = "..comparex.." Distance y = "..comparey)
				
				--y correction
				--do math.abs and find which one has less distance and do that axis
				if math.abs(comparex) < math.abs(comparey) and comparex ~= 0 then
					if comparex < 0 then
						ti.x = ti.x - (comparex+ti.sx) --new pos is posy - (y point distance + object height)
					elseif comparex > 0 then
						ti.x = ti.x + (ti.sx-comparex) --new pos is posy + (object height - y point distance)
					end
				else
					if comparey < 0 then
						ti.y = ti.y - (comparey+ti.sy) --new pos is posy - (y point distance + object height)
					elseif comparey > 0 then
						ti.y = ti.y + (ti.sy-comparey) --new pos is posy + (object height - y point distance)
					end
				end
			end
		end
	end
end
