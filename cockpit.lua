--[[pod_format="raw",created="2024-06-28 12:47:24",modified="2024-06-30 05:12:04",revision=67]]
-- cockpit.lua : cockpit
--

-- include


-- initialize cockpit
function cpinit()

	-- instance
	if not cockpit then
		cockpit = {
			n_ = 0,   -- cpn_
			rnk_ = 0, -- cprnk_
			spr_ = 0, -- cpspr_
		}
	end
	
	-- initialize vars
	cockpit.n_ = 0
	cockpit.spr_ = 408

end

-- reset cockpit
function cprset()
	cockpit.rnk_ = 0
	local n = cockpit.spr_
	spchr(n, 0, 40, 48, 8, 0x00)
	spofs(n, 0, 216 + 30, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	for i = 0, 2, 1 do
		spchr(n, 0, 8, 6, 7, 0x00)
		spofs(n, (2 - i) * 15 + 8, 209 + 30, -32)
		sphome(n, 0, 0)
		spscale(n, 3, 3)
		n = n + 1
	end
	spchr(n, 48, 40, 48, 8, 0x00)
	spofs(n, 304 + 80, 216 + 30, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 96, 40, 7, 8, 0x00)
	spofs(n, 336 + 80, 216 + 30, -32)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 0, 48, 30, 8, 0x00)
	spofs(n, 304 + 80, 200 + 30, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 0, 8, 6, 7, 0x00)
	spofs(n, 360 + 80, 212 + 30, -96)
	sphome(n, 6, 7)
	spscale(n, 5, 5)
	spcolor(n, app.color_[0x28 + 1])
	n = n + 1
	spchr(n, 30, 48, 18, 8, 0x00)
	spofs(n, 364 + 80, 200 + 30, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 0, 56, 64, 8, 0x00)
	spofs(n, 16, 16, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	for i = 1, race.stn_, 1 do
		spchr(n, 64, 56, 7, 8, 0x00)
		spofs(n, 72 + (i - 1) * 14, 16, -32)
		sphome(n, 0, 0)
		spscale(n, 2, 2)
		n = n + 1
	end
	spchr(n, 96, 56, 20, 8, 0x00)
	spofs(n, 16, 32, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 42, 0, 6, 7, 0x00)
	spofs(n, 92, 32, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	spchr(n, 12, 0, 6, 7, 0x00)
	spofs(n, 122, 32, -24)
	sphome(n, 0, 0)
	spscale(n, 2, 2)
	n = n + 1
	for i = 0, 5, 1 do
		local f0 = 0
		if i > 1 then
			f0 = 1
		end
		local f1 = 0
		if 	i > 3 then
			f1 = 1
		end
		spchr(n, 0, 8, 6, 7, 0x00)
		spofs(n, 142 - (i + (f0) + (f1)) * 10, 32, -32)
		sphome(n, 0, 0)
		spscale(n, 2, 2)
		n = n + 1
	end
	cockpit.n_ = n - cockpit.spr_
end

-- loop cockpit
function cploop()
	if cockpit.rnk_ < 32 then
		cockpit.rnk_ = cockpit.rnk_ + race.clr_
	end
end

-- draw cockpit
function cpdraw()
	local n = cockpit.spr_
	spshow(n)
	n = n + 1
	local s = math.floor(mycar.spd_ * 244)
	local i = 0
	repeat
		local u = s % 10
		s = s // 10
		spchr(n, u * 6, 8, 6, 7, 0x01)
		spshow(n)
		n = n + 1
		i = i + 1
	until s == 0
	while i < 3 do
		sphide(n)
		n = n + 1
		i = i + 1
	end
	spshow(n)
	n = n + 1
	s = min(4, max(1, mycar.lpc_)) - 1
	spchr(n, 96 + 7 * s, 40, 7, 8, 0x01)
	spofs(n, 336 + 14 * s + 80, 216 + 30, -32)
	spshow(n)
	n = n + 1
	s = 5 + 19 * (cockpit.rnk_ / 32)
	local t = mycar.rnk_[race.stg_ + 1] + 1
	spshow(n)
	n = n + 1
	spchr(n, t * 6, 8, 6, 7, 0x01)
	spscale(n, s, s)
	spshow(n)
	n = n + 1
	s = min(4, t) - 1
	spchr(n, 30 + s * 18, 48, 18, 8, 0x01)
	spshow(n)
	n = n + 1
	spshow(n)
	n = n + 1
	for i = 1, race.stg_ - 1, 1 do
		spchr(n, 64 + mycar.rnk_[i + 1] * 7, 56, 7, 8, 0x01)
		spshow(n)
		n = n + 1
	end
	spchr(n, 85, 56, 8, 8, 0x01)
	spshow(n)
	n = n + 1
	for i = race.stg_ + 1, race.stn_, 1 do
		sphide(n)
		n = n + 1
	end
	spshow(n)
	n = n + 1
	spshow(n)
	n = n + 1
	spshow(n)
	n = n + 1
	s = max(0, race.tim_)
	t = (s % 60) * 100 // 60
	s = s // 60
	spchr(n + 0, (t % 10) * 6, 8, 6, 7, 0x01)
	spchr(n + 1, (t // 10) * 6, 8, 6, 7, 0x01)
	t = s % 60
	s = s // 60
	spchr(n + 2, (t % 10) * 6, 8, 6, 7, 0x01)
	spchr(n + 3, (t // 10) * 6, 8, 6, 7, 0x01)
	spchr(n + 4, (s % 10) * 6, 8, 6, 7, 0x01)
	spchr(n + 5, (s // 10) * 6, 8, 6, 7, 0x01)
	spshow(n + 0)
	spshow(n + 1)
	spshow(n + 2)
	spshow(n + 3)
	spshow(n + 4)
	spshow(n + 5)
	n = n + 6
end
