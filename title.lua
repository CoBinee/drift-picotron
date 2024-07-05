--[[pod_format="raw",created="2024-06-21 12:44:06",modified="2024-07-02 21:43:16",revision=683]]
-- title.lua : title
--

-- include


-- initialize title
function tlinit()

	-- instance
	if not title then
		title = {
			n_ = 0,   -- tln_
			s_ = 0,   -- tls_$[2]
			pos_ = 0, -- tlpos_[512, 3]
			rot_ = 0, -- tlrot_[3]
			sin_ = 0, -- tlsin_[3]
			cos_ = 0, -- tlcos_[3]
			blk_ = 0, 
			bgn_ = 0, 
		}
	end
	
	-- initialize vars
	app.gpage1_ = userdata('u8', 30, 17)
	
	-- initialize arrays
	title.s_ = {}
	title.s_[1] = "PICOT"
	title.s_[2] = "DRIFT"
	title.pos_ = {}
	for i = 1, 512, 1 do
		title.pos_[i] = {}
		for j = 1, 3, 1 do
			title.pos_[i][j] = 0
		end
	end
	title.rot_ = {}
	for i = 1, 3, 1 do
		title.rot_[i] = 0
	end
	title.sin_ = {}
	for i = 1, 3, 1 do
		title.sin_[i] = 0
	end
	title.cos_ = {}
	for i = 1, 3, 1 do
		title.cos_[i] = 0
	end
	
	-- set bg
	local c0 = app.color_[0x01 + 1]
	for y = 0, 16, 1 do
		for x = 0, 29, 1 do
			app.gpage1_:set(x, y, c0)
		end
	end
	local c1 = app.color_[0x20 + 1]
	for y = 4, 12, 1 do
		for x = 4, 25, 1 do
			app.gpage1_:set(x, y, c1)
		end
	end	
end

-- loop title
function tlloop()
	if app.state_ == 0 then
		tlloop0()
	elseif app.state_ == 1 then
		tlloop1()
	elseif app.state_ == 2 then
		tlloop2()
	elseif app.state_ == 3 then
		tlloop3()
	end
	if app.state_ >= 2 then
		tldraw()
	end
end

-- loop title 0: init
function tlloop0()
	title.blk_ = 0
	title.bgn_ = 0
	sprset()
	psrset()
	app.state_ = 1
end

-- loop title 1: load
function tlloop1()
	local n = 0
	local h = 2 * 6 - 1
	for i = 1, 2, 1 do
		local l = #title.s_[i]
		local w = l * 5 - 1
		for j = 1, l, 1 do
  			local a = string.byte(title.s_[i], j) - 0x20
			local x = -w / 2 + (j - 1) * 5
			local y = -h / 2 + (i - 1) * 6
			for v = 0, 4, 1 do
				for u = 0, 3, 1 do
					local s = (a % 16) * 6 + 1 + u
					local t = (a // 16) * 8 + 1 + v
					local c = app.gpage2_:get(s, t)
					if c == app.color_[0x20 + 1] then
						spchr(n, car.chr_[8 + 1][0 + 1], car.chr_[8 + 1][1 + 1] + 7 * 16, 16, 12, 0x00)
						sphome(n, 8, 6)
						title.pos_[n + 1][1] = x + u
						title.pos_[n + 1][2] = y + v
						title.pos_[n + 1][3] = 0
						n = n + 1
					end
				end
			end
		end
	end
	title.n_ = n
	for i = 1, 3, 1 do
		title.rot_[i] = 0
	end
	spchr(n, 0, 0, 30, 17, 0x00)
	spofs(n, 0, 0, 1024)
	sphome(n, 0, 0)
	spscale(n, 16, 16)
	sppage(n, app.gpage1_)
	n = n + 1
	spchr(n, 0, 176, 61, 7, 0x00)
	spofs(n, 240, 176, -64)
	sphome(n, 30, 3)
	spscale(n, 4, 4)
	spcolor(n, 0x18)
	app.state_ = 2
end

-- loop title 2: loop
function tlloop2()
	if (app.be_ & (16 | 128)) ~= 0 then
		sfx(18)
		if (app.be_ & 128) ~= 0 then
			app.debug_ = 1
		else
			app.debug_ = 0
		end
		app.state_ = 3
 	end
 	tlrotate()
	title.blk_ = title.blk_ + 1 * app.vsync_
end

-- loop title 2: start
function tlloop3()
	tlrotate()
	title.bgn_ = title.bgn_ + 1
	if title.bgn_ > 90 / app.vsync_ then
		app.state_ = 0
 		app.proc_ = gmloop
 	end
	title.blk_ = title.blk_ + 8 * app.vsync_
end

-- rotate title
function tlrotate()
	title.rot_[1] = (title.rot_[1] + 4 * app.vsync_) % 360
	title.rot_[2] = (title.rot_[2] + 2 * app.vsync_) % 360
	title.rot_[3] = (title.rot_[3] + 1 * app.vsync_) % 360
	for i = 1, 3, 1 do
		local a = title.rot_[i] / 360
		title.sin_[i] = sin(a)
		title.cos_[i] = cos(a)
	end
end
	
-- draw title
function tldraw()
	for n = 0, title.n_ - 1, 1 do
		local x = title.pos_[n + 1][1]
		local y = title.pos_[n + 1][2]
		local z = title.pos_[n + 1][3]
		local u = x
		local v = y * title.cos_[1] - z * title.sin_[1]
		local w = y * title.sin_[1] + z * title.cos_[1]
		x = u * title.cos_[2] - w * title.sin_[2]
 		y = v
 		z = u * title.sin_[2] + w * title.cos_[2]
 		u = x * title.cos_[3] - y * title.sin_[3]
		v = x * title.sin_[3] + y * title.cos_[3]
		w = z + 36
		if w >= app.zn_ then
			local s = app.or_ / (w / 2)
			x = (u * s + 200) + 40
			y = (v * s + 120) + 15
			s = s / 12
			spofs(n, x, y, min(1024, w * 16))
			spscale(n, s, s)
			sprot(n, 1 / 360)
			spshow(n)
		else
			sphide(n)
		end
	end
	local n = title.n_
	spshow(n)
	n = n + 1
	if (title.blk_ & 0b00100000) == 0 then
		spshow(n)
	else
		sphide(n)
	end
end
