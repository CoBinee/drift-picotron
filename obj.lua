--[[pod_format="raw",created="2024-06-23 02:25:45",modified="2024-06-29 12:06:07",revision=64]]
-- obj.lua : object
--

-- include


-- initialize object
function obinit()

	-- instance
	if not obj then
		obj = {
			n_ = 0,   -- n_
			typ_ = 0, -- typ_[128]
			pos_ = 0, -- pos_[128,3]
			hit_ = 0, -- hit_[256,3]
			sde_ = 0, -- sde_
			spr_ = 0, -- spr_
			spn_ = 0, -- spn_
			siz_ = 0, -- siz_
		}
	end
	
	-- initialize vars
	obj.sde_ = 1.5
	obj.spr_ = course.spn_
	obj.spn_ = 384 - course.spn_
	obj.siz_ = 1
	
	-- initialize arrays
	obj.typ_ = {}
	for i = 1, 128, 1 do
		obj.typ_[i] = 0
	end
	obj.pos_ = {}
	for i = 1, 128, 1 do
		obj.pos_[i] = {}
		for j = 1, 3, 1 do
			obj.pos_[i][j] = 0
		end
	end
	obj.hit_ = {}
	for i = 1, 256, 1 do
		obj.hit_[i] = {}
		for j = 1, 3, 1 do
			obj.hit_[i][j] = 0
		end
	end
end

-- make object
function obmake()
	obj.n_ = 0
	for i = 0, 255, 1 do
		obj.hit_[i + 1][0 + 1] = 0
		obj.hit_[i + 1][1 + 1] = 0
		obj.hit_[i + 1][2 + 1] = 0
	end
	obj.typ_[obj.n_ + 1] = 3
	obj.pos_[obj.n_ + 1][0 + 1] = course.pos_[0 + 1][0 + 1][0 + 1]
	obj.pos_[obj.n_ + 1][1 + 1] = course.pos_[0 + 1][0 + 1][1 + 1]
	obj.pos_[obj.n_ + 1][2 + 1] = course.pos_[0 + 1][0 + 1][2 + 1]
	local n = obj.spr_ + obj.n_
	spchr(n, 0, 96, 48, 32, 0x00)
	sphome(n, 24, 31)
	obj.n_ = obj.n_ + 1
	for s = 1, 2, 1 do
		local x = course.pos_[s + 1][0 + 1][0 + 1] - course.pos_[0 + 1][0 + 1][0 + 1]
		local y = course.pos_[s + 1][0 + 1][1 + 1] - course.pos_[0 + 1][0 + 1][1 + 1]
		local z = course.pos_[s + 1][0 + 1][2 + 1] - course.pos_[0 + 1][0 + 1][2 + 1]
		obj.typ_[obj.n_ + 1] = 1
		obj.pos_[obj.n_ + 1][0 + 1] = course.pos_[0 + 1][0 + 1][0 + 1] + x * obj.sde_
		obj.pos_[obj.n_ + 1][1 + 1] = course.pos_[0 + 1][0 + 1][1 + 1] + y * obj.sde_
		obj.pos_[obj.n_ + 1][2 + 1] = course.pos_[0 + 1][0 + 1][2 + 1] + z * obj.sde_
		obj.hit_[0 + 1][s + 1] = 1
		n = obj.spr_ + obj.n_
		spchr(n, 24 * obj.typ_[obj.n_ + 1], 64, 24, 32, (s - 1) << 3)
		sphome(n, 12, 31)
		obj.n_ = obj.n_ + 1
	end
	local c = 0
	local a = 0
	for i = 1, course.n_ - 1, 1 do
		if (i % 2) == 0 then
			local j = (i + 2) % course.n_
			if abs(course.crv_[j + 1]) > 0.5 then
				if course.pos_[0 + 1][i + 1][1 + 1] < course.fal_ then
					if a == 0 then
						c = 3
						a = 1
						if course.crv_[j + 1] < 0 then
							a = a + 1
						end
					end
				end
			else
				if c == 0 then
					a = 0
				end
			end
			local t = -1
			if c > 0 then
				t = 2
				s = a
				c = c - 1
			else
				if course.pos_[0 + 1][i + 1][1 + 1] < course.fal_ then
					t = 0
					s = 1
					if (i % 4) == 0 then
						s = s + 1
					end
				end
			end
			if t >= 0 then
				local x = course.pos_[s + 1][i + 1][0 + 1] - course.pos_[0 + 1][i + 1][0 + 1]
				local z = course.pos_[s + 1][i + 1][2 + 1] - course.pos_[0 + 1][i + 1][2 + 1]
				obj.typ_[obj.n_ + 1] = t
				obj.pos_[obj.n_ + 1][0 + 1] = course.pos_[0 + 1][i + 1][0 + 1] + x * obj.sde_
				obj.pos_[obj.n_ + 1][1 + 1] = 0
				obj.pos_[obj.n_ + 1][2 + 1] = course.pos_[0 + 1][i + 1][2 + 1] + z * obj.sde_
				obj.hit_[i + 1][s + 1] = 1
				n = obj.spr_ + obj.n_
				spchr(n, 24 * obj.typ_[obj.n_ + 1], 64, 24, 32, (s - 1) << 3)
				sphome(n, 12, 31)
				obj.n_ = obj.n_ + 1
			end
		end
	end
	for n = obj.spr_ + obj.n_, obj.spr_ + obj.spn_ - 1, 1 do
		sphide(n)
	end
end

-- loop object
function obloop()

end

-- draw object
function obdraw()
	for i = 0, obj.n_ - 1, 1 do
		local n = obj.spr_ + i
		local u = obj.pos_[i + 1][0 + 1] - cam.ox_
		local v = obj.pos_[i + 1][1 + 1] - cam.oy_
		local w = obj.pos_[i + 1][2 + 1] - cam.oz_
		local x = u * cam.vz_ - w * cam.vx_
		local v = -v
		local w = u * cam.vx_ + w * cam.vz_
		local y = v * cam.oc_ + w * cam.os_
		local z = -v * cam.os_ + w * cam.oc_
		if z >= app.zn_ and z <= app.zf_ then
			local s = app.or_ / (z / 2)
			u = x * s + app.ox_ - cam.rx_
			v = y * s + app.oy_ - cam.ry_
			x = u * cam.rc_ - v * cam.rs_ + cam.rx_
			y = u * cam.rs_ + v * cam.rc_ + cam.ry_
			if x > -(64 + 40) and x < (464 + 40) and y > -(64 + 15) and y < (304 + 15) then
				s = s * obj.siz_ / 24
				spofs(n, x, y, min(1024, z * 16))
				sprot(n, cam.ra_)
				spscale(n, s, s)
				spshow(n)
			else
				sphide(n)
			end
		else
			sphide(n)
		end
	end
end
