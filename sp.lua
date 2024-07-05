--[[pod_format="raw",created="2024-06-20 12:23:50",modified="2024-06-30 06:28:09",revision=1342]]
-- sp.lua : sprite library
--

-- include


-- initialize sprite
function spinit()
	if not sp then
		sp = {}
	end
	sprset()
end

-- reset sprite
function sprset()
	for i = 1, 512, 1 do
		sp[i] = {}
		sp[i].chr_u = 0
		sp[i].chr_v = 0
		sp[i].chr_w = 16
		sp[i].chr_h = 16
		sp[i].chr_a = 0x00
		sp[i].ofs_x = 0
		sp[i].ofs_y = 0
		sp[i].ofs_z = 0
		sp[i].home_x = 0
		sp[i].home_y = 0
		sp[i].scale_x = 1
		sp[i].scale_y = 1
		sp[i].rot = 0
		sp[i].color = 0x07
		sp[i].page = app.gpage2_
		sp[i].show = false
	end
end

-- set sprite character
function spchr(n, u, v, w, h, a)
	n = n + 1
	sp[n].chr_u = u
	sp[n].chr_v = v
	sp[n].chr_w = w
	sp[n].chr_h = h
	sp[n].chr_a = a
end

-- set sprite offset
function spofs(n, x, y, z)
	n = n + 1
	sp[n].ofs_x = x
	sp[n].ofs_y = y
	sp[n].ofs_z = z
end

-- set sprite home
function sphome(n, x, y)
	n = n + 1
	sp[n].home_x = x
	sp[n].home_y = y
end

-- set sprite scale
function spscale(n, x, y)
	n = n + 1
	sp[n].scale_x = x
	sp[n].scale_y = y
end

-- set sprite rotate
function sprot(n, r)
	n = n + 1
	sp[n].rot = r / 360
end

-- set sprite color
function spcolor(n, c)
	n = n + 1
	sp[n].color = c
end

-- set sprite page
function sppage(n, p)
	n = n + 1
	sp[n].page = p
end

-- show sprite
function spshow(n)
	n = n + 1
	sp[n].show = true
end

-- hide sprite
function sphide(n)
	n = n + 1
	sp[n].show = false
end

-- draw scale sprite
function spsspr(sprite, u, v, w, h, x, y, offset_x, offset_y, scale_x, scale_y, a)
	local flip_x = false
	if (a & 0b00001000) ~= 0 then
		flip_x = true
	end
	sspr(
		sprite, 
		u, 
		v, 
		w, 
		h, 
		x - offset_x * scale_x, 
		y - offset_y * scale_y, 
		w * scale_x, 
		h * scale_y, 
		flip_x
	)
end

-- draw scale & rotate sprite
function sprspr(sprite, u, v, w, h, x, y, offset_x, offset_y, scale_x, scale_y, rotate, a)

	-- [1] - [2]
	--  |     |
	-- [3] - [4]
	
	-- calc uv vectors
	local uv = {
		{
			u = u, 
			v = v, 
		}, 
		{
			u = u + w - 1, 
			v = v, 
		}, 
		{
			u = u, 
			v = v + h - 1, 
		}, 
		{
			u = u + w - 1, 
			v = v + h - 1, 
		}, 
	}
	if (a & 0b00001000) ~= 0 then
		uv[1].u, uv[2].u = uv[2].u, uv[1].u
		uv[3].u, uv[4].u = uv[4].u, uv[3].u
	end
		
	-- calc xy vectors
	local sin_r = sin(rotate)
	local cos_r = cos(rotate)
	local x0 = -offset_x
	local y0 = -offset_y
	local x1 = x0 + w
	local y1 = y0 + h
	local x0 = x0 * scale_x
	local y0 = y0 * scale_y
	local x1 = x1 * scale_x - 1
	local y1 = y1 * scale_y - 1
	local xy = {
		{
			x = ceil((x0 * cos_r - y0 * sin_r) + x), 
			y = ceil((x0 * sin_r + y0 * cos_r) + y), 
		}, 
		{
			x = ceil((x1 * cos_r - y0 * sin_r) + x), 
			y = ceil((x1 * sin_r + y0 * cos_r) + y), 
		}, 
		{
			x = ceil((x0 * cos_r - y1 * sin_r) + x), 
			y = ceil((x0 * sin_r + y1 * cos_r) + y), 
		}, 
		{
			x = ceil((x1 * cos_r - y1 * sin_r) + x), 
			y = ceil((x1 * sin_r + y1 * cos_r) + y), 
		}, 
	}
	
	-- calc index
	local id = {}
	if xy[1].y <= xy[2].y then
		if xy[1].y < xy[3].y then
			id = {1, 2, 3, 4, }
		elseif xy[3].y < xy[4].y then
			id = {3, 1, 4, 2, }
		else
			id = {4, 3, 2, 1, }
		end
	else
		if xy[2].y <= xy[4].y then
			id = {2, 4, 1, 3, }
		else
			id = {4, 3, 2, 1, }
		end
	end
		
	-- draw sprite
	if xy[id[1]].y == xy[id[2]].y then
		local lu = uv[id[3]].u - uv[id[1]].u
		local lv = uv[id[3]].v - uv[id[1]].v
		local ru = uv[id[4]].u - uv[id[2]].u
		local rv = uv[id[4]].v - uv[id[2]].v
		local d = xy[id[3]].y - xy[id[1]].y
		for i = 0, d, 1 do
			local x0 = xy[id[1]].x
			local x1 = xy[id[4]].x
			local y = xy[id[1]].y + i
			if x0 < 480 and x1 >= 0 and y >= 0 and y < 270 then
				local t = i / d
				tline3d(
					sprite, 
					x0, -- xy[id[1]].x, 
					y,  -- xy[id[1]].y + i, 
					x1, -- xy[id[4]].x, 
					y,  -- xy[id[1]].y + i, 
					lu * t + uv[id[1]].u, 
					lv * t + uv[id[1]].v, 
					ru * t + uv[id[2]].u, 
					rv * t + uv[id[2]].v, 
					1, 
					1
				)
			end
		end
	else
		local ls = id[1]
		local le = id[3]
		local lu = uv[le].u - uv[ls].u
		local lv = uv[le].v - uv[ls].v
		local lx = xy[le].x - xy[ls].x
		local ly = xy[le].y - xy[ls].y
		local li = 0
		local rs = id[1]
		local re = id[2]
		local ru = uv[re].u - uv[rs].u
		local rv = uv[re].v - uv[rs].v
		local rx = xy[re].x - xy[rs].x
		local ry = xy[re].y - xy[rs].y
		local ri = 0
		local d = xy[id[4]].y - xy[id[1]].y
		for i = 0, d, 1 do
			local lt = li / ly
			local rt = ri / ry
			local x0 = lx * lt + xy[ls].x
			local x1 = rx * rt + xy[rs].x
			local y = li + xy[ls].y --ly * lt + xy[ls].y
			if x0 < 480 and x1 >= 0 and y >= 0 and y < 270 then
				tline3d(
					sprite, 
					x0, -- lx * lt + xy[ls].x, 
					y,  -- ly * lt + xy[ls].y, 
					x1, -- rx * rt + xy[rs].x, 
					y,  -- ry * rt + xy[rs].y, 
					lu * lt + uv[ls].u, 
					lv * lt + uv[ls].v, 
					ru * rt + uv[rs].u, 
					rv * rt + uv[rs].v, 
					1, 
					1
				)
			end
			li = li + 1
			if li > ly then
				ls = id[3]
				le = id[4]
				lu = uv[le].u - uv[ls].u
				lv = uv[le].v - uv[ls].v
				lx = xy[le].x - xy[ls].x
				ly = xy[le].y - xy[ls].y
				li = 0
			end
			ri = ri + 1
			if ri > ry then
				rs = id[2]
				re = id[4]
				ru = uv[re].u - uv[rs].u
				rv = uv[re].v - uv[rs].v
				rx = xy[re].x - xy[rs].x
				ry = xy[re].y - xy[rs].y
				ri = 0
			end
		end
	end
end

-- sort sprite
local function spqsort(t, first, last)
	if first > last then
		return
	end
	local p = first
	for i = first + 1, last, 1 do
		if sp[t[i]].ofs_z > sp[t[first]].ofs_z then
			p = p + 1
			t[p], t[i] = t[i], t[p]
    	end
    end
    t[p], t[first] = t[first], t[p]
    spqsort(t, first, p - 1)
    spqsort(t, p + 1, last)
end	

-- draw sprite
function spdraw()
	local order = {}
	for i = 1, 512, 1 do
		if sp[i].show then
			add(order, i)
		end
	end
	spqsort(order, 1, #order)
	for i = 1, #order, 1 do
		local n = order[i]
		if sp[n].color ~= 0x07 then
			pal(0x07, sp[n].color)
		end
		if sp[n].rot == 0 then
			spsspr(
				sp[n].page, 
				sp[n].chr_u, 
				sp[n].chr_v, 
				sp[n].chr_w, 
				sp[n].chr_h, 
				sp[n].ofs_x, 
				sp[n].ofs_y, 
				sp[n].home_x, 
				sp[n].home_y, 
				sp[n].scale_x, 
				sp[n].scale_y, 
				sp[n].chr_a
			)
		else
			sprspr(
				sp[n].page, 
				sp[n].chr_u, 
				sp[n].chr_v, 
				sp[n].chr_w, 
				sp[n].chr_h, 
				sp[n].ofs_x, 
				sp[n].ofs_y, 
				sp[n].home_x, 
				sp[n].home_y, 
				sp[n].scale_x, 
				sp[n].scale_y, 
				sp[n].rot, 
				sp[n].chr_a
			)
		end
		if sp[n].color ~= 0x07 then
			pal(0x07, 0x07)
		end
	end
end
