--[[pod_format="raw",created="2024-06-22 22:22:19",modified="2024-06-29 12:05:24",revision=444]]
-- course.lua : course
--

-- include


-- initialize course
function csinit()

	-- instance
	if not course then
		course = {
			n_,   -- csn_
			idx_, -- csidx_
			pos_, -- cspos_[3,256,3]
			vec_, -- csvec_[3,256,3]
			dst_, -- csdst_[256,2]
			dsl_, -- csdsl_
			crv_, -- cscrv_[256]
			inc_, -- csinc_[256]
			sdi_, -- cssdi_
			sdo_, -- cssdo_
			sdl_, -- cssdl_
			fal_, -- csfal_
			spr_, -- csspr_
			spn_, -- csspn_
			sln_, -- cssln_
			slt_, -- csslt_[32]
			slp_, -- csslp_[32,3]
			sla_, -- cssla_[32,3]
			slh_, -- csslh_[32]
			sld_, -- cssld_[32]
			slw_, -- csslw_[32]
			slc_, -- csslc_
			arg_, -- csarg_[8]
			ret_, -- csret_[8]
		}
	end

	-- initialize vars
	course.n_ = 0
	course.sdi_ = 0.875
	course.sdo_ = 1.125
	course.sdl_ = 1.5
	course.fal_ = 0.25
	course.spr_ = 0
	course.spn_ = 256
	
	-- initialize arrays
	course.pos_ = {}
	for i = 1, 3, 1 do
		course.pos_[i] = {}
		for j = 1, 256, 1 do
			course.pos_[i][j] = {}
			for k = 1, 3, 1 do
				course.pos_[i][j][k] = 0
			end
		end
	end
	course.vec_ = {}
	for i = 1, 3, 1 do
		course.vec_[i] = {}
		for j = 1, 256, 1 do
			course.vec_[i][j] = {}
			for k = 1, 3, 1 do
				course.vec_[i][j][k] = 0
			end
		end
	end
	course.dst_ = {}
	for i = 1, 256, 1 do
		course.dst_[i] = {}
		for j = 1, 2, 1 do
			course.dst_[i][j] = 0
		end
	end
	course.crv_ = {}
	for i = 1, 256, 1 do
		course.crv_[i] = 0
	end
	course.inc_ = {}
	for i = 1, 256, 1 do
		course.inc_[i] = 0
	end	
	course.slt_ = {}
	for i = 1, 32, 1 do
		course.slt_[i] = 0
	end
	course.slp_ = {}
	for i = 1, 32, 1 do
		course.slp_[i] = {}
		for j = 1, 3, 1 do
			course.slp_[i][j] = 0
		end
	end
	course.sla_ = {}
	for i = 1, 32, 1 do
		course.sla_[i] = {}
		for j = 1, 3, 1 do
			course.sla_[i][j] = 0
		end
	end	
	course.slh_ = {}
	for i = 1, 32, 1 do
		course.slh_[i] = 0
	end	
	course.sld_ = {}
	for i = 1, 32, 1 do
		course.sld_[i] = 0
	end
	course.slw_ = {}
	for i = 1, 32, 1 do
		course.slw_[i] = 0
	end	
	course.arg_ = {}
	for i = 1, 8, 1 do
		course.arg_[i] = 0
	end
	course.ret_ = {}
	for i = 1, 8, 1 do
		course.ret_[i] = 0
	end
end

-- make course
function csmake()
	csread()
	cstabl()
	course.n_ = course.spn_
	csspln()
	local x = course.pos_[0 + 1][1 + 1][0 + 1] - course.pos_[0 + 1][0 + 1][0 + 1]
	local y = course.pos_[0 + 1][1 + 1][1 + 1] - course.pos_[0 + 1][0 + 1][1 + 1]
	local z = course.pos_[0 + 1][1 + 1][2 + 1] - course.pos_[0 + 1][0 + 1][2 + 1]
	course.n_ = math.floor(course.spn_ * sqrt(x * x + y * y + z * z))
	if course.n_>course.spn_ then
		assert(false, "csmake error - could not make course.")
	end
	csspln()
	for i = 0, course.n_ - 1, 1 do
		local j = (i + 1) % course.n_
		course.vec_[0 + 1][i + 1][0 + 1] = course.pos_[0 + 1][j + 1][0 + 1] - course.pos_[0 + 1][i + 1][0 + 1]
		course.vec_[0 + 1][i + 1][1 + 1] = course.pos_[0 + 1][j + 1][1 + 1] - course.pos_[0 + 1][i + 1][1 + 1]
		course.vec_[0 + 1][i + 1][2 + 1] = course.pos_[0 + 1][j + 1][2 + 1] - course.pos_[0 + 1][i + 1][2 + 1]
	end
	for i = 0, course.n_ - 1, 1 do
		local j = (i + course.n_ - 1) % course.n_
		local x = course.vec_[0 + 1][i + 1][0 + 1] + course.vec_[0 + 1][j + 1][0 + 1]
		local z = course.vec_[0 + 1][i + 1][2 + 1] + course.vec_[0 + 1][j + 1][2 + 1]
		local n = sqrt(x * x + z * z)
		x = x / n
		z = z / n
		course.pos_[1 + 1][i + 1][0 + 1] = course.pos_[0 + 1][i + 1][0 + 1] - z
		course.pos_[1 + 1][i + 1][1 + 1] = course.pos_[0 + 1][i + 1][1 + 1]
		course.pos_[1 + 1][i + 1][2 + 1] = course.pos_[0 + 1][i + 1][2 + 1] + x
		course.pos_[2 + 1][i + 1][0 + 1] = course.pos_[0 + 1][i + 1][0 + 1] + z
		course.pos_[2 + 1][i + 1][1 + 1] = course.pos_[0 + 1][i + 1][1 + 1]
		course.pos_[2 + 1][i + 1][2 + 1] = course.pos_[0 + 1][i + 1][2 + 1] - x
	end
	for i = 0, course.n_ - 1, 1 do
		local j = (i + 1) % course.n_
		course.vec_[1 + 1][i + 1][0 + 1] = course.pos_[1 + 1][j + 1][0 + 1]-course.pos_[1 + 1][i + 1][0 + 1]
		course.vec_[1 + 1][i + 1][1 + 1] = course.pos_[1 + 1][j + 1][1 + 1]-course.pos_[1 + 1][i + 1][1 + 1]
		course.vec_[1 + 1][i + 1][2 + 1] = course.pos_[1 + 1][j + 1][2 + 1]-course.pos_[1 + 1][i + 1][2 + 1]
		course.vec_[2 + 1][i + 1][0 + 1] = course.pos_[2 + 1][j + 1][0 + 1]-course.pos_[2 + 1][i + 1][0 + 1]
		course.vec_[2 + 1][i + 1][1 + 1] = course.pos_[2 + 1][j + 1][1 + 1]-course.pos_[2 + 1][i + 1][1 + 1]
		course.vec_[2 + 1][i + 1][2 + 1] = course.pos_[2 + 1][j + 1][2 + 1]-course.pos_[2 + 1][i + 1][2 + 1]
		local x = course.vec_[0 + 1][i + 1][0 + 1]
		local y = course.vec_[0 + 1][i + 1][1 + 1]
		local z = course.vec_[0 + 1][i + 1][2 + 1]
		course.dst_[i + 1][0 + 1] = sqrt(x * x + z * z)
		course.dst_[i + 1][1 + 1] = course.dst_[i + 1][0 + 1]
		if  i > 0 then
			course.dst_[i + 1][1 + 1] = course.dst_[i + 1][1 + 1] + course.dst_[(i - 1) + 1][1 + 1]
		end
	end
	course.dsl_ = course.dst_[(course.n_ - 1) + 1][1 + 1]
	for i = 0, course.n_ - 1, 1 do
		local j = (i + course.n_ - 1) % course.n_
		local u = course.vec_[0 + 1][i + 1][0 + 1]
		local v = course.vec_[0 + 1][i + 1][2 + 1]
		local s = course.vec_[0 + 1][j + 1][0 + 1]
		local t = course.vec_[0 + 1][j + 1][2 + 1]
		local c = (u * s + v * t) / (sqrt(u * u + v * v) * sqrt(s * s + t * t))
		c = min(1, max(-1, c))
		course.crv_[i + 1] = math.deg(math.acos(c)) * -sgn(s * v - t * u)
	end
	for i = 0, course.n_ - 1, 1 do
		local j = (i + 1) % course.n_
		local u = course.pos_[0 + 1][j + 1][0 + 1] - course.pos_[0 + 1][i + 1][0 + 1]
		local v = course.pos_[0 + 1][j + 1][1 + 1] - course.pos_[0 + 1][i + 1][1 + 1]
		local w = course.pos_[0 + 1][j + 1][2 + 1] - course.pos_[0 + 1][i + 1][2 + 1]
		course.inc_[i + 1] = v / sqrt(u * u + w * w)
	end
	for n = course.spr_, course.spr_ + course.spn_ - 1, 1 do
		spchr(n, 0, 128, 64, 8, 0x00)
		sphome(n, 32, 0)
	end
end

-- read course data
function csread()

	-- data
	local data = {
		{
			 10,  0,   0, 
			 10,  0,   1, 
			 10,  0,  31, 
			 10,  0,  32, 
			  0,  4,  42, 
			-10,  4,  32, 
			-10,  4,  31, 
			-10,  1,  16, 
			-10,  2,   1, 
			-10,  2,   0, 
			-10,  2,  -1, 
			-10,  0, -31, 
			-10,  0, -32, 
			  0,  0, -42, 
			 10,  0, -32, 
			 10,  0, -31, 
			 10,  0,  -1, 
			 10,  0,   0, 
			 -1, -1,  -1, 
		}, 
		{
			  8,  0,  24, 
			  9,  0,  24, 
			 15,  0,  24, 
			 16,  0,  24, 
			 28,  0,  12, 
			 16,  0,   0, 
			 15,  0,   0, 
			 10,  1,   0, 
			  0,  2,   0, 
			-10,  1,   0, 
			-15,  0,   0, 
			-16,  0,   0, 
			-28,  0, -12, 
			-16,  0, -24, 
			-15,  0, -24, 
			  0,  0, -24, 
			 11,  0, -24, 
			 12,  0, -24, 
			 20,  0, -16, 
			 18,  0, -10, 
			  0,  0,   0, 
			-18,  0,  10, 
			-20,  0,  16, 
			-12,  0,  24, 
			 -8,  0,  24, 
			  0,  0,  24, 
			  7,  0,  24, 
			  8,  0,  24, 
			 -1, -1,  -1, 
		}, 
		{
			  0,  0,   5, 
			  0,  0,   6, 
			  0,  0,   7, 
			  0,  0,  26, 
			  0,  0,  27, 
			  0,  0,  28, 
			 10,  1,  38, 
			 20,  2,  28, 
			 20,  2,  27, 
			 10,  2,  12, 
			  0,  2,   0, 
			  0,  2,  -8, 
			-16,  2, -29, 
			-16,  2, -30, 
			 -6,  1, -40, 
			  4,  0, -30, 
			  4,  0, -29, 
			  0,  0, -11, 
			  0,  0, -10, 
			  0,  0,  -9, 
			  0,  0,   3, 
			  0,  0,   4, 
			  0,  0,   5, 
			 -1, -1,  -1, 
		}, 
		{
			 -9,  0,   8, 
			 -9,  0,   9, 
			 -9,  0,  31, 
			 -9,  0,  32, 
			  0,  0,  41, 
			  9,  0,  32, 
			  9,  0,  31, 
			  9,  0,  16, 
			  9,  3,   1, 
			  9,  3,   0, 
			  9,  3,  -1, 
			  9,  1, -21, 
			  9,  1, -22, 
			 -9,  2, -41, 
			 -9,  2, -42, 
			  0,  1, -51, 
			  9,  0, -42, 
			  9,  0, -41, 
			  0,  0, -32, 
			 -9,  0, -22, 
			 -9,  0, -21, 
			 -9,  0,   0, 
			 -9,  0,   7, 
			 -9,  0,   8, 
			 -1, -1,  -1, 
		}, 
		{
			 24,  0,   8, 
			 24,  0,   9, 
			 24,  0,  15, 
			 24,  0,  16, 
			 16,  0,  24, 
			  8,  0,  16, 
			  8,  0,  15, 
			  8,  3,   4, 
			  8,  0,  -7, 
			  8,  0,  -8, 
			 -8,  0, -24, 
			-24,  0,  -8, 
			-24,  0,  -7, 
			-24,  2,   4, 
			-24,  0,  15, 
			-24,  0,  16, 
			-16,  0,  24, 
			 -8,  0,  16, 
			 -8,  0,  15, 
			 -8,  3,   0, 
			 -8,  2,  -7, 
			 -8,  2,  -8, 
			  8,  1, -24, 
			 24,  0,  -8, 
			 24,  0,  -7, 
			 24,  0,   0, 
			 24,  0,   7, 
			 24,  0,   8, 
			 -1, -1,  -1, 
		}, 
	}
	
	-- read
	course.sln_ = 0
	local i = 1
	repeat
		course.slp_[course.sln_ + 1][0 + 1] = data[race.stg_][i + 0]
		course.slp_[course.sln_ + 1][1 + 1] = data[race.stg_][i + 1]
		course.slp_[course.sln_ + 1][2 + 1] = data[race.stg_][i + 2]
		i = i + 3
		course.sln_ = course.sln_ + 1
	until course.slp_[(course.sln_ - 1) + 1][1 + 1] < 0
	course.sln_ = course.sln_ - 2
end

-- make course table
function cstabl()
	local n = course.sln_
	course.slt_[0 + 1] = 0
	for i = 1, n, 1 do
		local x = course.slp_[i + 1][0 + 1] - course.slp_[(i - 1) + 1][0 + 1]
		local y = course.slp_[i + 1][1 + 1] - course.slp_[(i - 1) + 1][1 + 1]
		local z = course.slp_[i + 1][2 + 1] - course.slp_[(i - 1) + 1][2 + 1]
		course.slt_[i + 1] = course.slt_[(i - 1) + 1] + sqrt(x * x + y * y + z * z)
	end
	for i = 1, n, 1 do
		course.slt_[i + 1] = course.slt_[i + 1] / course.slt_[n + 1]
	end
	for p = 0, 2, 1 do
		for i = 0, n - 1, 1 do
			course.slh_[i + 1] = course.slt_[(i + 1) + 1] - course.slt_[i + 1]
			course.slw_[i + 1] = course.slp_[(i + 1) + 1][p + 1] - course.slp_[i + 1][p + 1]
			course.slw_[i + 1] = course.slw_[i + 1] / course.slh_[i + 1]
		end
		course.slw_[n + 1] = course.slw_[0 + 1]
		for i = 1, n - 1, 1 do
			course.sld_[i + 1] = 2 * (course.slt_[(i + 1) + 1] - course.slt_[(i - 1) + 1])
		end
		course.sld_[n + 1] = 2 * (course.slh_[(n - 1) + 1] + course.slh_[0 + 1])
		for i = 1, n, 1 do
			course.sla_[i + 1][p + 1] = course.slw_[i + 1] - course.slw_[(i - 1) + 1]
		end
		course.slw_[1 + 1] = course.slh_[0 + 1]
		course.slw_[(n - 1) + 1] = course.slh_[(n - 1) + 1]
		course.slw_[n + 1] = course.sld_[n + 1]
		for i = 2, n - 2, 1 do
			course.slw_[i + 1] = 0
		end
		for i = 1, n - 1, 1 do
			local t = course.slw_[i + 1] / course.sld_[i + 1]
			course.sla_[(i + 1)][p + 1] = course.sla_[(i + 1)][p + 1] - course.sla_[i + 1][p + 1] * t
			course.sld_[(i + 1) + 1] = course.sld_[(i + 1) + 1] - course.slh_[i + 1] * t
			course.slw_[(i + 1) + 1] = course.slw_[(i + 1) + 1] - course.slw_[i + 1] * t
		end
		course.slw_[0 + 1] = course.slw_[n + 1]
		course.sla_[0 + 1][p + 1] = course.sla_[n + 1][p + 1]
		for i = n - 2, 0, -1 do
			local t = course.slh_[i + 1] / course.sld_[(i + 1) + 1]
			course.sla_[i + 1][p + 1] = course.sla_[i + 1][p + 1] - course.sla_[(i + 1) + 1][p + 1] * t
			course.slw_[i + 1] = course.slw_[i + 1] - course.slw_[(i + 1) + 1] * t
		end
		local t = course.sla_[0 + 1][p + 1] / course.slw_[0 + 1]
		course.sla_[0 + 1][p + 1] = t
		course.sla_[n + 1][p + 1] = t
		for i = 1, n - 1, 1 do
			course.sla_[i + 1][p + 1] = course.sla_[i + 1][p + 1] - course.slw_[i + 1] * t
			course.sla_[i + 1][p + 1] = course.sla_[i + 1][p + 1] / course.sld_[i + 1]
		end
	end
end

-- get course spline
function csspln()
	for c = 0, course.n_ - 1, 1 do
		local t = c / course.n_
		for p = 0, 2, 1 do
			local r = course.slt_[course.sln_ + 1] - course.slt_[0 + 1]
			while t > course.slt_[course.sln_ + 1] do
				t = t - r
			end
			while t < course.slt_[0 + 1] do
				t = t + r
			end
			local i = 0
			local j = course.sln_
			while i < j do
				local k = (i + j) // 2
				if course.slt_[k + 1] < t then
					i = k + 1
				else
					j = k
				end
			end
			if i > 0 then
				i = i - 1
			end
			local h = course.slt_[(i + 1) + 1] - course.slt_[i + 1]
			local d = t - course.slt_[i + 1]
			local u = (course.sla_[(i + 1) + 1][p + 1] - course.sla_[i + 1][p + 1]) * d / h
			u = (u + course.sla_[i + 1][p + 1] * 3) * d
			local v = (course.slp_[(i + 1) + 1][p + 1] - course.slp_[i + 1][p + 1]) / h
			v = v - (course.sla_[i + 1][p + 1] * 2 + course.sla_[(i + 1) + 1][p + 1]) * h
			local w = (u + v) * d + course.slp_[i + 1][p + 1]
			course.pos_[0 + 1][c + 1][p + 1] = w
		end
	end
	for i = 0, course.n_ - 1, 1 do
		if course.pos_[0 + 1][i + 1][1 + 1] < 0.075 then
			course.pos_[0 + 1][i + 1][1 + 1] = 0
		end
	end
end

-- get course index from distance
--     course.arg_[1]=distance
--     course.ret_[1]=index
function csdidx()
	local i = math.floor(course.arg_[0 + 1] / (course.dsl_ / course.n_))
	course.ret_[0 + 1] = min(course.n_ - 1, i)
end

-- get course xyz from distance
--     course.arg_[1] = distance
--     course.arg_[2] = lr position
--     course.ret_[1] = index
--     course.ret_[2..4] = pos x,y,z
--     course.ret_[5..7] = vec x,y,z
function csdxyz()
	csdidx()
	local d = course.arg_[0 + 1]
	local i = min(course.n_ - 1, math.floor(d / (course.dsl_ / course.n_)))
	course.ret_[0 + 1] = i
	if i > 0 then
		d = d - course.dst_[(i - 1) + 1][1 + 1]
	end
	local t = d / course.dst_[i + 1][0 + 1]
	for j = 0, 2, 1 do
		local u = course.pos_[1 + 1][i + 1][j + 1] + course.vec_[1 + 1][i + 1][j + 1] * t
		local v = course.pos_[2 + 1][i + 1][j + 1] + course.vec_[2 + 1][i + 1][j + 1] * t
		course.ret_[(1 + j) + 1] = ((u + v) + (v - u) * course.arg_[1 + 1]) / 2
		course.ret_[(4 + j) + 1] = v - u
	end
	local x = course.ret_[4 + 1]
	local z = course.ret_[6 + 1]
	local n = sqrt(x * x + z * z)
	course.ret_[4 + 1] = -z / n
	course.ret_[5 + 1] = course.inc_[i + 1]
	course.ret_[6 + 1] = x / n
end

-- loop course
function csloop()

end

-- draw course
function csdraw()
	local n = course.spr_
	local i = (course.idx_ + course.n_) % course.n_
	local m = i + course.n_
	while i < m do
		local j = i % course.n_
		local u = course.pos_[0 + 1][j + 1][0 + 1] - cam.ox_
		local v = course.pos_[0 + 1][j + 1][1 + 1] - cam.oy_
		local w = course.pos_[0 + 1][j + 1][2 + 1] - cam.oz_
		local x = u * cam.vz_ - w * cam.vx_
		v = -v
		w = u * cam.vx_ + w * cam.vz_
		local y = v * cam.oc_ + w * cam.os_
		local z = -v * cam.os_ + w * cam.oc_
		if z >= app.zn_ and z <= app.zf_ then
			local s = app.or_ / (z / 2)
			u = x * s + app.ox_ - cam.rx_
			v = y * s + app.oy_ - cam.ry_
			x = u * cam.rc_ - v * cam.rs_ + cam.rx_
			y = u * cam.rs_ + v * cam.rc_ + cam.ry_
			if x > -(64 + 40) and x < (464 + 40) and y > -(64 + 15) and y < (304 + 15) then
				s = s / 32
				v = 128
				if course.pos_[0 + 1][j + 1][1 + 1] > 0 then
					v = v + 8
				end
				spchr(n, 0, v, 64, 8, 0x01)
				spofs(n, x, y, min(1024, z * 16))
				sprot(n, cam.ra_)
				spscale(n, s, s)
				spshow(n)
				n = n + 1
			end
		end
		i = i + 1
	end
	while n < course.spr_ + course.spn_ - 1 do
		sphide(n)
		n = n + 1
	end
end
