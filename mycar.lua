--[[pod_format="raw",created="2024-06-23 09:46:53",modified="2024-07-02 23:04:35",revision=562]]
-- mycar.lua : my car
--

-- include


-- initialize my car
function myinit()

	-- instance
	if not mycar then
		mycar = {
			dst_ = 0,   -- mydst_
			lpc_ = 0,   -- mylpc_
			lpd_ = 0,   -- mylpd_
			lpi_ = 0,   -- mylpi_
			sde_ = 0,   -- mysde_
			rnk_ = nil, -- myrnk_[6]
			tim_ = nil, -- mytim_[6]
			mov_ = 0,   -- mymov_
			spd_ = 0,   -- myspd_
			spa_ = 0,   -- myspa_
			acl_ = 0,   -- myacl_
			aca_ = 0,   -- myaca_
			acb_ = 0,   -- myacb_
			acf_ = 0,   -- myacf_
			hdl_ = 0,   -- myhdl_
			hdp_ = 0,   -- myhdp_
			crv_ = 0,   -- mycrv_
			hit_ = 0,   -- myhit_
			hip_ = 0,   -- myhip_
			hir_ = 0,   -- myhir_
			yps_ = 0,   -- myyps_
			ypt_ = 0,   -- myypt_
			cmd_ = nil, -- mycmd_[2]
			cmh_ = nil, -- mycmh_[2]
			cms_ = nil, -- mycms_[2]
			cmm_ = 0,   -- mycmm_
			pos_ = nil, -- mypos_[3]
			poy_ = 0,   -- mypoy_
			vec_ = nil, -- myvec_[3]
			roz_ = 0,   -- myroz_
			ndg_ = 0,   -- myndg_
			spr_ = 0,   -- myspr_
			chr_ = 0,   -- mychr_
			smk_ = 0,   -- mysmk_
			smc_ = 0,   -- mysmc_
			tmp_ = nil, -- mytmp_[8]
			prc_ = nil, -- myprc_$
			prm_ = 0,   -- myprm_
		}
	end

	-- initialize vars
	mycar.mov_ = 1 / 2
	mycar.spa_ = 1 / 256
	mycar.aca_ = 1 / 32
	mycar.acb_ = 1 / 48
	mycar.acf_ = 1 / 96
	mycar.hdp_ = 1 / 8
	mycar.crv_ = mycar.hdp_ / 6
	mycar.hip_ = 1 / 6
	mycar.cmm_ = 1 / 64
	mycar.spr_ = rival.spr_ + 2 * rival.n_
	
	-- initialize arrays
	mycar.rnk_ = {}
	for i = 1, 6, 1 do
		mycar.rnk_[i] = 0
	end
	mycar.tim_ = {}
	for i = 1, 6, 1 do
		mycar.tim_[i] = 0
	end
	mycar.cmd_ = {}
	mycar.cmd_[1] = 0
	mycar.cmd_[2] = 0.25
	mycar.cmh_ = {}
	mycar.cmh_[1] = 0
	mycar.cmh_[2] = 0.3125
	mycar.cms_ = {}
	mycar.cms_[1] = 0
	mycar.cms_[2] = 0
	mycar.pos_ = {}
	for i = 1, 3, 1 do
		mycar.pos_[i] = 0
	end
	mycar.vec_ = {}
	for i = 1, 3, 1 do
		mycar.vec_[i] = 0
	end	
	mycar.tmp_ = {}
	for i = 1, 8, 1 do
		mycar.tmp_[i] = 0
	end	
end

-- reset my car
function myrset()
	mycar.dst_ = course.dsl_ - (2 * 7 + 0.5)
	mycar.lpc_ = 0
	mycar.lpd_ = mycar.dst_
	course.arg_[0 + 1] = mycar.lpd_
	csdidx()
	mycar.lpi_ = course.ret_[0 + 1]
	mycar.sde_ = 0.375
	mycar.ndg_ = 0
	local n = mycar.spr_
	spchr(n + 0, 128, 112, 16, 12, 0x00)
	sphome(n + 0, 8, 6)
	spchr(n + 1, 0, 32, 16, 4, 0x00)
	sphome(n + 1, 8, -5)
	mycar.prc_ = mystrt
	mycar.prm_ = 0
end

-- loop my car
function myloop()
	mycar.prc_()
end

-- start my car
function mystrt()
	if mycar.prm_ == 0 then
		mycar.spd_ = 0
		mycar.acl_ = 0
		mycar.hdl_ = 0
		mycar.hit_ = 0
		mycar.poy_ = 0
		mycar.roz_ = 0
		mycar.tmp_[0 + 1] = 96
		mycar.tmp_[1 + 1] = -8 / sqrt(8 * 8 + 48 * 48)
		mycar.chr_ = 0
		mycar.smk_ = 0
		mycar.smc_ = 0
		app.zf_ = 128
		mycar.prm_ = mycar.prm_ + 1
	end
	mymove()
	if mycar.tmp_[0 + 1] > 0 then
		mycar.tmp_[0 + 1] = mycar.tmp_[0 + 1] - 1
	end
	local t = mycar.tmp_[0 + 1] / 96
	mycar.cmd_[0 + 1] = (48 - mycar.cmd_[1 + 1]) * t + mycar.cmd_[1 + 1]
	mycar.cmh_[0 + 1] = (8 - mycar.cmh_[1 + 1]) * t + mycar.cmh_[1 + 1]
	mycar.cms_[0 + 1] = (mycar.tmp_[1 + 1] - mycar.cms_[1 + 1]) * t + mycar.cms_[1 + 1]
	local x = mycar.vec_[0 + 1]
	local z = mycar.vec_[2 + 1]
	local a = (math.pi * mycar.tmp_[0 + 1] + 32) / 32
	local s = sin(a / (2 * math.pi))
	local c = cos(a / (2 * math.pi))
	mycar.vec_[0 + 1] = x * c - z * s
	mycar.vec_[2 + 1] = x * s + z * c
	mycamr()
	if mycar.tmp_[0 + 1] == 0 then
		app.zf_ = 48
		race.str_ = 1
		mycar.prc_ = mydriv
		mycar.prm_ = 0
	end
end

-- restart my car
function myrest()
	if mycar.prm_ == 0 then
		if abs(mycar.sde_) < course.sdi_ then
			mycar.sde_ = mycar.sde_
		else
			mycar.sde_ = 0
		end
		mycar.hdl_ = 0
		mycar.hit_ = 0
		mycar.poy_ = 0
		mycar.roz_ = 0
		mycar.cmd_[0 + 1] = 0.5
		mycar.cmh_[0 + 1] = 0.75
		mycar.cms_[0 + 1] = 0
		mycar.chr_ = 0
		mycar.smc_ = 0
		mycar.prm_ = mycar.prm_ + 1
	end
	mymove()
	mycar.cmd_[0 + 1] = mycar.cmd_[0 + 1] - (0.5 - mycar.cmd_[1 + 1]) / 16
	mycar.cmh_[0 + 1] = mycar.cmh_[0 + 1] - (0.75 - mycar.cmh_[1 + 1]) / 16
	mycar.cmd_[0 + 1] = max(mycar.cmd_[1 + 1], mycar.cmd_[0 + 1])
	mycar.cmh_[0 + 1] = max(mycar.cmh_[1 + 1], mycar.cmh_[0 + 1])
	mycamr()
	mycar.smk_ = 0
	if mycar.cmd_[0 + 1] == mycar.cmd_[1 + 1] then
		mycar.prc_ = mydriv
		mycar.prm_ = 0
	end
end

-- drive my car
function mydriv()
	if mycar.prm_ == 0 then
		mycar.cmd_[0 + 1] = mycar.cmd_[1 + 1]
		mycar.cmh_[0 + 1] = mycar.cmh_[1 + 1]
		mycar.ndg_ = 96
		mycar.prm_ = mycar.prm_ + 1
	end
	if app.debug_ ~= 0 then
		mycar.acl_ = min(1, mycar.acl_ + mycar.aca_) * race.flg_
		mycar.spd_ = min(1, mycar.spd_ + mycar.spa_ * mycar.acl_)
		mydrivauto()
	else
		if race.flg_ ~= 0 then
			mydrivctrl()
		else
			mydrivauto()
		end
	end
	if abs(mycar.hdl_) > 0.75 then
		sfx(21)
	end
end

-- control drive my car
function mydrivctrl()
	local s = 0
	if mycar.spd_ > 0 then
		s = max(0.375, mycar.spd_)
	end
	local h = mycar.hdp_ * app.sx_ * s * s
	local c = mycar.crv_ * -course.crv_[mycar.lpi_ + 1] * mycar.spd_ * mycar.spd_
	if h == 0 then
		mycar.hdl_ = mycar.hdl_ - min(mycar.hdp_, max(-mycar.hdp_, mycar.hdl_))
	else
		if mycar.hdl_ * h > 0 then
			mycar.hdl_ = min(1, max(-1, mycar.hdl_ * (1) + h))
		else
			mycar.hdl_ = min(1, max(-1, mycar.hdl_ * (0) + h))		
		end
	end
	mycar.sde_ = min(course.sdl_, max(-course.sdl_, mycar.sde_ + h + c))
	if (app.bp_ & 16) ~= 0 then
		mycar.acl_ = min(1, mycar.acl_ + mycar.aca_)
		mycar.spd_ = min(1, mycar.spd_ + mycar.spa_ * mycar.acl_)
	else
		mycar.acl_ = max(0, mycar.acl_ - mycar.aca_)
		mycar.spd_ = max(0, mycar.spd_ - mycar.acb_)
	end
	if abs(mycar.sde_) > course.sdi_ and mycar.spd_ > 0.5 then
		mycar.spd_ = max(0, mycar.spd_ - mycar.acb_)
	end
	mymove()
	mycamr()
	if mycar.ndg_ > 0 then
		mycar.ndg_ = mycar.ndg_ - 1
	end
	mycar.chr_ = ceil(abs(mycar.hdl_ * 2)) * sgn(mycar.hdl_)
	mycar.chr_ =mycar.chr_
	if mycar.chr_ < 0 then
		mycar.chr_ = mycar.chr_ + 16
	end
	mycar.smk_ = (mycar.lpi_ & 1)
	if abs(mycar.hdl_) >= 1 then
		mycar.smk_ = mycar.smk_ + 1
	end
	if mycar.spd_ > 0 then
		mycar.smk_ = mycar.smk_
	else
		mycar.smk_ = 0
	end
	if abs(mycar.sde_) > course.sdo_ and mycar.pos_[1 + 1] > course.fal_ then
		mycar.prc_ = myfall
		mycar.prm_ = 0
	else
		if mycar.ndg_ == 0 then
			mychit()
			if mycar.hit_ ~= 0 then
				mycar.prc_ = mycrsh
				mycar.prm_ = 0
			end
		end
	end
end

-- auto drive my car
function mydrivauto()
	mycar.hdl_ = mycar.hdl_ - min(mycar.hdp_, max(-mycar.hdp_, mycar.hdl_))
	mymove()
	mycamr()
	local h = 0
	if abs(course.crv_[mycar.lpi_ + 1]) > 1 then
		h = sgn(course.crv_[mycar.lpi_ + 1])
	end
	mycar.chr_ = h
	if h < 0 then
		mycar.chr_ = mycar.chr_ + 16
	end
	mycar.smk_ = mycar.lpi_ & 1
	if mycar.spd_ > 0 then
		mycar.smk_ = mycar.smk_
	else
		mycar.smk_ = 0
	end
end

-- crash my car
function mycrsh()
	if mycar.prm_ == 0 then
		mycar.hit_ = max(mycar.spa_, mycar.spd_ / 8) * mycar.hit_
		mycar.hip_ = mycar.hit_ /32
		mycar.hir_ = 0
		sfx(23)
		mycar.prm_ = mycar.prm_ + 1
	end
	mycar.hdl_ = mycar.hdl_ - min(mycar.hdp_, max(-mycar.hdp_, mycar.hdl_))
	mycar.acl_ = max(0, mycar.acl_ - mycar.aca_)
	mycar.spd_ = max(0, mycar.spd_ - mycar.acb_)
	local d = min(abs(mycar.hip_), abs(mycar.hit_)) * sgn(mycar.hit_)
	mycar.hit_ = mycar.hit_ - d
	mycar.sde_ = min(course.sdl_, max(-course.sdl_, mycar.sde_ + mycar.hit_))
	mycar.hir_ = mycar.hir_ + sgn(mycar.hdl_)
	if mycar.hdl_ == 0 then
		mycar.hir_ = mycar.hir_ + 1
	end
	mycar.chr_ = mycar.hir_ & 0x0e
	mymove()
	mycamr()
	mycar.smc_ = mycar.smc_ + 1
	mycar.smk_ = 1 
	if (mycar.smc_ & 4) > 0 then
		mycar.smk_ = mycar.smk_ + 1
	end
	if abs(mycar.sde_) > course.sdo_ and mycar.pos_[1 + 1] > course.fal_ then
		mycar.prc_ = myfall
		mycar.prm_ = 0
	else
		if mycar.hit_ == 0 then
			if abs(mycar.sde_) > course.sdo_ then
				mycar.prc_ = myrest
				mycar.prm_ = 0
			else
				mycar.prc_ = mydriv
				mycar.prm_ = 0
			end
		end
	end
end

-- fall my car
function myfall()
	if mycar.prm_ == 0 then
		mycar.yps_ = mycar.pos_[1 + 1]
		mycar.ypt_ = 0
		mycar.prm_ = mycar.prm_ + 1
	end
	mycar.hdl_ = mycar.hdl_ - min(mycar.hdp_, max(-mycar.hdp_, mycar.hdl_))
	mycar.acl_ = max(0, mycar.acl_ - mycar.aca_)
	mycar.spd_ = max(0, mycar.spd_ - mycar.acf_)
	mycar.ypt_ = mycar.ypt_ + 1
	if mycar.ypt_ > 16 then
		mycar.ypt_ = mycar.ypt_ + 1
	end
	local a = -(min(16, mycar.ypt_) * math.pi / 32)
	mycar.poy_ = mycar.yps_ * abs(cos(a / (2 * math.pi)))
	mycar.roz_ = -(360 * mycar.ypt_ * sgn(mycar.sde_) / 32)
	if mycar.ypt_ <= 32 then
		mycar.roz_ = mycar.roz_
	else
		mycar.roz_ = 0
	end
	mymove()
	mycamr()
	mycar.smc_ = mycar.smc_ + 1
	mycar.smk_ = 0
	if mycar.ypt_ > 16 then
		mycar.smk_ = mycar.smk_ + 1
		if (mycar.smc_ & 4) > 0 then
			mycar.smk_ = mycar.smk_ + 1
		end
	end
	if mycar.ypt_ == 16 then
		sfx(22)
	end
	if mycar.ypt_ > 80 then
		mycar.prc_ = myrest
		mycar.prm_ = 0
	end
end

-- move my car
function mymove()
	local m = mycar.mov_ * mycar.spd_
	mycar.dst_ = mycar.dst_ + m
	mycar.lpd_ = mycar.lpd_ + m
	if mycar.lpd_ >= course.dsl_ then
		if mycar.lpc_ <= race.lop_ then
			mycar.lpc_ = mycar.lpc_ + 1
			mycar.lpd_ = mycar.lpd_ - course.dsl_
		else
			mycar.dst_ = mycar.dst_ - course.dsl_
			mycar.lpd_ = mycar.lpd_ - course.dsl_
		end
	end
	course.arg_[0 + 1] = mycar.lpd_
	course.arg_[1 + 1] = mycar.sde_
	csdxyz()
	mycar.lpi_ = course.ret_[0 + 1]
	mycar.pos_[0 + 1] = course.ret_[1 + 1]
	if mycar.poy_ == 0 then
		mycar.pos_[1 + 1] = course.ret_[2 + 1] + mycar.poy_
	else
		mycar.pos_[1 + 1] = mycar.poy_
	end
	mycar.pos_[2 + 1] = course.ret_[3 + 1]
	mycar.vec_[0 + 1] = course.ret_[4 + 1]
	mycar.vec_[1 + 1] = course.ret_[5 + 1]
	mycar.vec_[2 + 1] = course.ret_[6 + 1]
	if mycar.poy_ == 0 then
		mycar.cms_[1 + 1] = course.ret_[5 + 1]
	else
		mycar.cms_[1 + 1] = 0
	end
	local s = mycar.cms_[1 + 1] - mycar.cms_[0 + 1]
	if abs(s) <= mycar.cmm_ then
		mycar.cms_[0 + 1] = mycar.cms_[1 + 1]
	else
		mycar.cms_[0 + 1] = mycar.cms_[0 + 1] + mycar.cmm_ * sgn(s)
	end
end

-- camera my car
function mycamr()
	course.idx_ = mycar.lpi_ - (app.zn_)
	cam.os_ = mycar.cms_[0 + 1]
	cam.oc_ = 1 / sqrt(1 + cam.os_ * cam.os_)
	local d = app.zn_ + mycar.cmd_[0 + 1]
	local h = mycar.cmh_[0 + 1] - d * cam.os_
	cam.ox_ = mycar.pos_[0 + 1] - d * mycar.vec_[0 + 1]
	cam.oy_ = mycar.pos_[1 + 1] + h
	cam.oz_ = mycar.pos_[2 + 1] - d * mycar.vec_[2 + 1]
	cam.vx_ = mycar.vec_[0 + 1]
	cam.vy_ = mycar.vec_[1 + 1]
	cam.vz_ = mycar.vec_[2 + 1]
	local u = course.ret_[1 + 1] - cam.ox_
	local v = course.ret_[2 + 1] - cam.oy_
	local w = course.ret_[3 + 1] - cam.oz_
	local x = u * cam.vz_ - w * cam.vx_
	local y = -v
	local z = u * cam.vx_ + w * cam.vz_
	local s = app.or_ / (z / 2)
	cam.rx_ = x * s + app.ox_
	cam.ry_ = y * s + app.oy_
	cam.ra_ = -(15 * min(1, abs(mycar.hdl_)) * sgn(mycar.hdl_))
	cam.rs_ = sin((cam.ra_ * math.pi /180) / (2 * math.pi))
	cam.rc_ = cos((cam.ra_ * math.pi /180) / (2 * math.pi))
end

-- check hit my car
function mychit()
	local w = car.szw_ * 0.5
	for i = 0, rival.n_ - 1, 1 do
		local x = mycar.sde_ - rival.sde_[i + 1]
		local z = mycar.lpd_ - rival.lpd_[i + 1]
		if abs(x) < w and z <= 0 and z >- car.szw_ then
			if x == 0 then
				mycar.hit_ = sgn(x + (1))
			else
				mycar.hit_ = sgn(x + (0))
			end	
			break
		end
	end
	if mycar.hit_ == 0 then
		if abs(mycar.sde_) >= obj.sde_ - car.szw_ / 2 then
			local f = 0
			if mycar.sde_ > 0 then
				f = 1
			end
			if obj.hit_[mycar.lpi_ + 1][1 + (f) + 1] > 0 then
				mycar.hit_ = sgn(-mycar.sde_)
			end
		end
	end
end

-- draw my car
function mydraw()
	local n = mycar.spr_
	local u = mycar.pos_[0 + 1] - cam.ox_
	local v = mycar.pos_[1 + 1] - cam.oy_ + car.szh_ / 2
	local w = mycar.pos_[2 + 1] - cam.oz_
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
			u = car.chr_[mycar.chr_ + 1][0 + 1]
			v = car.chr_[mycar.chr_ + 1][1 + 1] + 112
			local a = car.chr_[mycar.chr_ + 1][2 + 1]
			z = min(1024, z * 16)
			s = s * car.szw_ / 16
			spchr(n + 0, u, v, 16, 12, 0x01 + a)
			spofs(n + 0, x, y, z)
			sprot(n + 0, mycar.roz_ + cam.ra_)
			spscale(n + 0, s, s)
			spshow(n + 0)
			spchr(n + 1, mycar.smk_ * 16, 32, 16, 4, 0x01)
			spofs(n + 1, x, y, z - 1)
			sprot(n + 1, mycar.roz_ + cam.ra_)
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

