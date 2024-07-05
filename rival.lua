--[[pod_format="raw",created="2024-06-23 08:42:44",modified="2024-07-03 12:19:12",revision=426]]
-- rival.lua : rival car
--

-- include


-- initialize rival car
function rvinit()

	-- instance
	if not rival then
		rival = {
			n_ = 0,   -- rvn_
			i_ = 0,   -- rvi_
			dst_ = 0, -- rvdst_[7]
			lpc_ = 0, -- rvlpc_[7]
			lpd_ = 0, -- rvlpd_[7]
			lpi_ = 0, -- rvlpi_[7]
			sde_ = 0, -- rvsde_[7]
			rnk_ = 0, -- rvrnk_[7,2]
			mov_ = 0, -- rvmov_[7,2]
			spd_ = 0, -- rvspd_[7]
			spa_ = 0, -- rvspa_[7]
			hdl_ = 0, -- rvhdl_[7]
			hds_ = 0, -- rvhds_[7]
			hdp_ = 0, -- rvhdp_
			pos_ = 0, -- rvpos_[7,3]
			spr_ = 0, -- rvspr_
			smk_ = 0, -- rvsmk_[7]
		}
	end
	
	-- initialize vars
	rival.n_ = 7
	rival.hdp_ = 1 / 32
	rival.spr_ = 384
	
	-- initialize arrays
	rival.dst_ = {}
	for i = 1, 7, 1 do
		rival.dst_[i] = 0
	end
	rival.lpc_ = {}
	for i = 1, 7, 1 do
		rival.lpc_[i] = 0
	end
	rival.lpd_ = {}
	for i = 1, 7, 1 do
		rival.lpd_[i] = 0
	end	
	rival.lpi_ = {}
	for i = 1, 7, 1 do
		rival.lpi_[i] = 0
	end
	rival.sde_ = {}
	for i = 1, 7, 1 do
		rival.sde_[i] = 0
	end	
	rival.rnk_ = {}
	for i = 1, 7, 1 do
		rival.rnk_[i] = {}
		for j = 1, 2, 1 do
			rival.rnk_[i][j] = 0
		end
	end	
	rival.mov_ = {}
	for i = 1, 7, 1 do
		rival.mov_[i] = {}
		rival.mov_[i][1] = 0
		rival.mov_[i][2] = 15 / 32 - (i - 1) / 32
	end
	rival.spd_ = {}
	for i = 1, 7, 1 do
		rival.spd_[i] = 0
	end	
	rival.spa_ = {}
	for i = 1, 7, 1 do
		rival.spa_[i] = 1 / 256
	end
	rival.hdl_ = {}
	for i = 1, 7, 1 do
		rival.hdl_[i] = 0
	end
	rival.hds_ = {}
	for i = 1, 7, 1 do
		rival.hds_[i] = 0
	end	
	rival.pos_ = {}
	for i = 1, 7, 1 do
		rival.pos_[i] = {}
		for j = 1, 3, 1 do
			rival.pos_[i][j] = 0
		end
	end
	rival.smk_ = {}
	for i = 1, 7, 1 do
		rival.smk_[i] = 0
	end
end

-- reset rival car
function rvrset()
	for i = 0, rival.n_ - 1, 1 do
		rival.dst_[i + 1] = course.dsl_ - (2 * i + 0.5)
		rival.lpc_[i + 1] = 0
		rival.lpd_[i + 1] = rival.dst_[i + 1]
		course.arg_[0 + 1] = rival.lpd_[i + 1]
		csdidx()
		rival.lpi_[i + 1] = course.ret_[0 + 1]
		rival.sde_[i + 1] = 0.375 * ((i & 1) * 2 - 1)
		rival.mov_[i + 1][0 + 1] = rival.mov_[i + 1][1 + 1]
		rival.spd_[i + 1] = 0
		rival.hdl_[i + 1] = 0
		rival.hds_[i + 1] = rival.sde_[i + 1]
		rival.smk_[i + 1] = 0
		local n = rival.spr_ + i * 2
		spchr(n + 0, 128, i * 16, 16, 12, 0x00)
		sphome(n + 0, 8, 12)
		spchr(n + 1, 0, 32, 16, 4, 0x00)
		sphome(n + 1, 8, 1)
	end
end

-- loop rival car
function rvloop()
	for i = 0, rival.n_ - 1, 1 do
		rival.spd_[i + 1] = rival.spd_[i + 1] + rival.spa_[i + 1] * race.flg_
		rival.spd_[i + 1] = min(1, rival.spd_[i + 1])
		local m = rival.mov_[i + 1][0 + 1] * rival.spd_[i + 1]
		rival.dst_[i + 1] = rival.dst_[i + 1] + m
		rival.lpd_[i + 1] = rival.lpd_[i + 1] + m
		if rival.lpd_[i + 1] >= course.dsl_ then
			if rival.lpc_[i + 1] <= race.lop_ then
				rival.lpc_[i + 1] = rival.lpc_[i + 1] + 1
				rival.lpd_[i + 1] = rival.lpd_[i + 1] - course.dsl_
			else
				rival.dst_[i + 1] = rival.dst_[i + 1] - course.dsl_
				rival.lpd_[i + 1] = rival.lpd_[i + 1] - course.dsl_
			end
		end
		if rival.hdl_[i + 1] <= 0 then
			local d = rival.hds_[i + 1] - rival.sde_[i + 1]
			rival.sde_[i + 1] = rival.sde_[i + 1] + min(rival.hdp_, max(-rival.hdp_, d))
			if rival.sde_[i + 1] == rival.hds_[i + 1] then
				rival.hdl_[i + 1] = 384 + math.floor(rnd(384))
				rival.hds_[i + 1] = 0.5 * rnd() * sgn(-rival.sde_[i + 1])
				local s = rnd() * (1 / 24) * sgn(rival.rnk_[i + 1][1 + 1])
				rival.mov_[i + 1][0 + 1] = rival.mov_[i + 1][1 + 1] + s
			end
		else
			rival.hdl_[i + 1] = rival.hdl_[i + 1] - 1
		end
		course.arg_[0 + 1] = rival.lpd_[i + 1]
		course.arg_[1 + 1] = rival.sde_[i + 1]
		csdxyz()
		rival.lpi_[i + 1] = course.ret_[0 + 1]
		rival.pos_[i + 1][0 + 1] = course.ret_[1 + 1]
		rival.pos_[i + 1][1 + 1] = course.ret_[2 + 1]
		rival.pos_[i + 1][2 + 1] = course.ret_[3 + 1]
		local s = rival.lpi_[i + 1] & 1
		if rival.spd_[i + 1] > 0 then
			rival.smk_[i + 1] = s
		else
			rival.smk_[i + 1] = s
		end	
	end
end

-- draw rival car
function rvdraw()
	for i = 0, rival.n_ - 1, 1 do
		local n = rival.spr_ + i * 2
		local u = rival.pos_[i + 1][0 + 1] - cam.ox_
		local v = rival.pos_[i + 1][1 + 1] - cam.oy_
		local w = rival.pos_[i + 1][2 + 1] - cam.oz_
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
			if x > -(64 + 40) and x < (464 + 40) and y > -(64 + 15) and  y < (304 + 15) then
				u = car.chr_[0 + 1][0 + 1]
				v = car.chr_[0 + 1][1 + 1] + i * 16
				local a = car.chr_[0 + 1][2 + 1]
				z = min(1024, z * 16)
				s = s * car.szw_ / 16
				spchr(n + 0, u, v, 16, 12, 0x01 + a)
				spofs(n + 0, x, y, z)
				sprot(n + 0, cam.ra_)
				spscale(n + 0, s, s)
				spshow(n + 0)
				spchr(n + 1, rival.smk_[i + 1] * 16, 32, 16, 4, 0x01)
				spofs(n + 1, x, y, z - 1)
				sprot(n + 1, cam.ra_)
				spscale(n + 1, s, s)
				spshow(n + 1)
			else
				sphide(n + 0)
				sphide(n + 1)
			end
		else
			sphide(n + 0)
			sphide(n + 1)
		end
	end
end