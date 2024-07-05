--[[pod_format="raw",created="2024-06-28 13:18:45",modified="2024-06-29 11:29:22",revision=216]]
-- navi.lua : navi map
--

-- include


-- initialize navi map
function nvinit()

	-- instance
	if not navi then
		navi = {
			x_ = 0,   -- nvx_
			y_ = 0,   -- nvy_
			w_ = 0,   -- nvw_
			h_ = 0,   -- nvh_
			spr_ = 0, -- nvspr_
			bg_ = 0, 
		}
	end
	
	-- initialize vars
	navi.spr_ = 400
	navi.bg_ = 510
	
end

-- reset navi map
function nvrset()
	for v = 256, 511, 1 do
		for u = 0, 255, 1 do
			app.gpage2_:set(u, v, 0x3f)
		end
	end
	local l = 0
	local r = 0
	local t = 0
	local b = 0
	for i = 0, 1, 1 do
		for j = 0, course.n_ - 1, 1 do
			if i == 0 or (i == 1 and course.pos_[0 + 1][j + 1][1 + 1] > 0) then
				local c = app.color_[(0x0f - 0x08 * i) + 1]
				local x = math.floor(course.pos_[0 + 1][j + 1][0 + 1] + 0.5)
				local y = math.floor(course.pos_[0 + 1][j + 1][2 + 1] + 0.5)
				for v = 383 - y, 385 - y, 1 do
					for u = 127 + x, 129 + x, 1 do
						app.gpage2_:set(u, v, c)
					end
				end
				l = min(l, x)
				r = max(r, x)
				t = min(t, y)
				b = max(b, y)
			end
		end
	end
	do
		local x0 = 128 + math.floor(course.pos_[1 + 1][0 + 1][0 + 1] + 0.5)
		local y0 = 384 - math.floor(course.pos_[1 + 1][0 + 1][2 + 1] + 0.5)
		local x1 = 128 + math.floor(course.pos_[2 + 1][0 + 1][0 + 1] + 0.5)
		local y1 = 384 - math.floor(course.pos_[2 + 1][0 + 1][2 + 1] + 0.5)
		local c = app.color_[0x28 + 1]
		for y = y0, y1, 1 do
			for x = x0, x1, 1 do
				app.gpage2_:set(x, y, c)
			end
		end
	end
	navi.x_ = 384 - r * 2 + 80
	navi.y_ = 16 + b * 2
	spchr(navi.bg_, 0, 256, 256, 256, 0x00)
	sphome(navi.bg_, 128, 128)
	spofs(navi.bg_, navi.x_, navi.y_, -40)
	spscale(navi.bg_, 2, 2)
	for i = 0, car.n_ - 1, 1 do
		local n = navi.spr_ + i
		spchr(n, 6 * i + 6, 8, 6, 7, 0x00)
		sphome(n, 3, 3)
		spscale(n, 2, 2)
	end
end

-- loop navi map
function nvloop()

end

-- draw navi map
function nvdraw()
	spshow(navi.bg_)
	for i = 0, car.n_ - 1, 1 do
		local r = rank.car_[i + 1]
		local x, y, z
		if r < rival.n_ then
			x = navi.x_ + math.floor(rival.pos_[r + 1][0 + 1] + 0.5) * 2
			y = navi.y_ - math.floor(rival.pos_[r + 1][2 + 1] + 0.5) * 2
			z = i - 48
		else
			x = navi.x_ + math.floor(mycar.pos_[0 + 1] + 0.5) * 2
			y = navi.y_ - math.floor(mycar.pos_[2 + 1] + 0.5) * 2
			z = -56
		end
		local n = navi.spr_ + i
		spofs(n, x, y, z)
		spcolor(n, car.clr_[r + 1])
		spshow(n)
	end
end

