--[[
Made by jordan4ibanez on 5/14/2018 as a test of simplicity


What is happening here?

x and y are the objects position (top left corner)

sx and sy are the objects width and height

fixed decides if the object will have gravity applied

ix and iy are the inertial values (horizontal/vertical)

lx and ly are the last position

]]--

--do inertial cancelation (slowdown)


local gravity = 9.28

local g_func = {} --custom game function table

g_func.min_size = 10

--this holds all collision objects
local object_table = {
{x=10,y=0,sx=50,sy=50,fixed=false,ix=0,iy=0,lx=0,ly=0}, --x,y quards | sx,sy width and height | fixed is if it moves (true is don't) | iy ix is inertia | lx and ly are last pos
{x=100,y=400,sx=500,sy=50,fixed=true,ix=0,iy=0,lx=0,ly=0}, 
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
	g_func.movement(dt,1)


	--apply inertial gravity to object
	for item = 1,table.getn(object_table) do
		local ti = object_table[item]
		--only apply collision/inertia to non-fixed objects
		if ti.fixed == false then
			--ti.iy = ti.iy + (dt*10) -- gravity
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

--movement
function g_func.movement(dt,item)
	local ti = object_table[item]
	
	--y axis
	if love.keyboard.isDown( 'down' ) then
		ti.iy = ti.iy + (dt*10)
	end
	if love.keyboard.isDown( 'up' ) then
		ti.iy = ti.iy - (dt*10)
	end
	--x axis
	if love.keyboard.isDown( 'right' ) then
		ti.ix = ti.ix + (dt*10)
	end
	if love.keyboard.isDown( 'left' ) then
		ti.ix = ti.ix - (dt*10)
	end
end

--simple collision detection with other objects
function g_func.collision(item)
	local ti = object_table[item]
	--points storage
	local ti_table = {}
	ti_table.top    = ti.y
	ti_table.bottom = ti.y+ti.sy
	ti_table.left   = ti.x
	ti_table.right  = ti.x+ti.sx
	local forcedx = nil
	--local item_center = {ti.x+(ti.sx/2),ti.y+(ti.sy/2)} --get center of main object
	for index = 1,table.getn(object_table) do
		--do not collide with self
		if index ~= item then
			local it = object_table[index]
			local it_table = {}
				
			--local index_center = {it.x+(it.sx/2),it.y+(it.sy/2)} --get center of indexed object
		
			--detect collision
			if (ti.x < it.x + it.sx  and
			    ti.x + ti.sx > it.x  and
			    ti.y < it.y + it.sy  and
			    ti.sy + ti.y > it.y) then
			  	
			  	
			  	it_table.top = it.y
				it_table.bottom = it.y+it.sy
				it_table.left = it.x
				it_table.right = it.x+it.sx
				
				--top == right bottom == left
				
				if ti.lx > it_table.right or ti.lx + ti.sx < it_table.left then
					if it_table.right < ti_table.left or it_table.left > ti_table.right then
						if math.abs(it_table.right - ti_table.left) > math.abs(it_table.left - ti_table.right) then
							print("test")
							ti.x = it_table.left
							forcedx = ti.lx
							end
						if math.abs(it_table.right - ti_table.left) < math.abs(it_table.left - ti_table.right) then
							print("test")
							ti.x = it_table.right-ti.sx
							forcedx = ti.lx
						end
					end
				else
					if it_table.top < ti_table.bottom or it_table.bottom > ti_table.top then
						if math.abs(it_table.top - ti_table.bottom) > math.abs(it_table.bottom - ti_table.top) then
							ti.y = it_table.bottom
							end
						if math.abs(it_table.top - ti_table.bottom) < math.abs(it_table.bottom - ti_table.top) then
							ti.y = it_table.top-ti.sy
						end
					end
				end
				
				
				
				
				--old points
				--[[
					if old points are above axis then do
					
				]]--
				
				
				
				
				
				
				
				
				
				
								
				
				
				
				--[[
				--ALPHA TEST 2 (closer, but corner problems)
				--find values
				--local x_less = item_center[1] < it.x
				--local x_more = item_center[1] > it.x + it.sx
				
				--local y_less = item_center[2] < it.y
				--local y_more = item_center[2] > it.y + it.sy
				
				
				--prefer y to x collision correction
				if y_less or y_more then
					print("Y IS dominate")
					print("Y IS dominate")
				else
					print("X IS MORE DOMINATE")
				end
				
				if y_less or y_more then
					if comparey < 0 then
						ti.y = ti.y - (comparey+ti.sy) --new pos is posy - (y point distance + object height)
					elseif comparey > 0 then
						ti.y = ti.y + (ti.sy-comparey) --new pos is posy + (object height - y point distance)
					end
				else
					if comparex < 0 then
						ti.x = ti.x - (comparex+ti.sx) --new pos is posy - (y point distance + object height)
						--love.quit()
					elseif comparex > 0 then
						ti.x = ti.x + (it.sx-comparex) --new pos is posy + (object height - y point distance)
						--love.quit()
					end
				end
				]]-- 
					
				--[[
				--ALPHA TEST OF COLLISION CORRECTION
				--do math.abs and find which one has less distance and do that axis
				--if math.abs(comparex) < math.abs(comparey) and comparex ~= 0 then
					if comparex < 0 then
						ti.x = ti.x - (comparex+ti.sx) --new pos is posy - (y point distance + object height)
						--love.quit()
					elseif comparex > 0 then
						ti.x = ti.x + (it.sx-comparex) --new pos is posy + (object height - y point distance)
						--love.quit()
					end
				--else
					if comparey < 0 then
						ti.y = ti.y - (comparey+ti.sy) --new pos is posy - (y point distance + object height)
					elseif comparey > 0 then
						ti.y = ti.y + (ti.sy-comparey) --new pos is posy + (object height - y point distance)
					end
				--end
				]]--
			end
		end
	end
	ti.lx = ti.x
	ti.ly = ti.y
	--print(forcedx)
	if forcedx then
		print("Forcedx")
		ti.lx = ti.forcedx
	else
		--print("forcedx is not a number")
	end
end
