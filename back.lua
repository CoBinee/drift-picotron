--[[pod_format="raw",created="2024-06-29 12:13:08",modified="2024-06-30 01:02:09",revision=494]]
-- back.lua - back ground
--

-- include


-- initialize back ground
function bkinit()

	-- instance
	if not back then
		back = {
			spr_ = 0, 
		}
	end
	
	-- initialize vars
	back.spr_ = 509
	app.gpage0_ = userdata('u8', 1024, 1024)
	
	-- data
	local data = {
		"1111111111111111", 
		"1234111234111234", 
		"5555615555615556", 
		"7787777887778777", 
	}
	
	-- set bg
	local i = 1
	for y = 28, 31, 1 do
		local s = data[i]
		i = i + 1
		for x = 0, 15, 1 do
			local c = tonumber(s[x + 1])
			bkbgput(x + 0, y, c)
			bkbgput(x + 16, y, c)
			bkbgput(x + 32, y, c)
			bkbgput(x + 48, y, c)
		end
	end
	local c0 = app.color_[0x22 + 1]
	for y = 0 * 16, 28 * 16 - 1, 1 do
		for x = 0 * 16, 64 * 16 - 1, 1 do
			app.gpage0_:set(x, y, c0)
		end
	end	
	local c1 = app.color_[0x37 + 1]
	for y = 32 * 16, 64 * 16 - 1, 1 do
		for x = 0 * 16, 64 * 16 - 1, 1 do
			app.gpage0_:set(x, y, c1)
		end
	end	
	
end

-- reset back ground
function bkrset()

end

-- loop back ground
function bkloop()

end

-- draw back ground
function bkdraw()
	local n = back.spr_
	local x = 0
	local y = -cam.oy_ * cam.oc_ + 128 * cam.os_
	local z = cam.oy_ * cam.os_ + 128 * cam.oc_
	local s = app.or_ / (z / 2)
	local a = (math.atan(cam.vx_, cam.vz_))
	local r = 280
	local u = ((512) - 256 * a / math.pi) - (x * s + r)
	local v = (512) - (y * s + r)
	spchr(n, u, v, r * 2, r * 2, 0x01)
	spofs(n, app.ox_, app.oy_, 1024)
	sphome(n, r, r)
	spscale(n, 1, 1)
	sprot(n, cam.ra_)
	sppage(n, app.gpage0_)
	spshow(n)
	--[[
	sprspr(
		app.gpage0_, 
		u, 
		v, 
		r * 2, 
		r * 2, 
		app.ox_, 
		app.oy_, 
		r, 
		r, 
		1, 
		1, 
		cam.ra_ / 360, 
		0x00
	)
	]]
end

-- put bg
function bkbgput(x, y, c)
	local u = (c % 32) * 16
	local v = (c // 32) * 16
	x = x * 16
	y = y * 16
	for j = 0, 15, 1 do
		for i = 0, 15, 1 do
			local p = app.gpage3_:get(u + i, v + j)
			app.gpage0_:set(x + i, y + j, p)
		end
	end
end

-- fill bg
function bkbgfill(x0, y0, x1, y1, c)
	for y = y0, y1, 1 do
		for x = x0, x1, 1 do
			bkbgput(x, y, c)
		end
	end
end

-- copy bg
function bkbgcopy(sx, sy, ex, ey, dx, dy)
	sx = sx * 16
	sy = sy * 16
	ex = ex * 16 + 15
	ey = ey * 16 + 15
	dx = dx * 16
	dy = dy * 16
	for y = sy, ey, 1 do
		for x = sx, ex, 1 do
			local p = app.gpage0_:get(x, y)
			app.gpage0_:set(dx + x - sx, dy + y - sy, p)
		end
	end
end
