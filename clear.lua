--[[pod_format="raw",created="2024-06-24 13:24:52",modified="2024-06-29 12:02:35",revision=112]]
-- clear.lua : game clear
--

-- include


-- initialize game clear
function gcinit()

	-- instance
	if not clear then
		clear = {
			n_ = 0,   -- gcn_
			t_ = 0,   -- gct_
			spr_ = 0, -- gcspr_
		}
	end
	
	-- initialize vars
	clear.n_ = 32
	clear.spr_ = 464

end

-- reset game clear
function gcrset()
	clear.t_ = -96
	local n = clear.spr_
	for i = 0, clear.n_ - 2, 1 do
		local f = 0
		if rnd(4) == 0 then
			f = 1
		end
		spchr(n, 0, 144 + (f) * 8, 80, 7, 0x00)
		spofs(n, rnd(272 + 80) + 64, rnd(208 + 30) + 16, -128 - i)
		sphome(n, 40, 3)
		sprot(n, rnd(60) - 30)
		spscale(n, 4, 4)
		-- spcolor(n, app.color_[(rnd(2) * 0x10 + 0x20 + rnd(13)) + 1])
		spcolor(n, rnd(31) + 1)
		n = n + 1
	end
	spchr(n, car.chr_[5 + 1][0 + 1], car.chr_[5 + 1][1 + 1] + (7 * 16), 16, 12, 0x08)
	spofs(n, 200 + 40, 120 + 15, -192)
	sphome(n, 8, 6)
	spscale(n, 8, 8)
end

-- loop game over
function gcloop()
	if race.stg_ == race.stn_ then
		clear.t_ = clear.t_ + race.clr_
	end
end

-- draw game over
function gcdraw()
	for i = 0, clear.n_ - 1, 1 do
		local n = clear.spr_ + i
		if clear.t_ > i * 2 then
			spshow(n)
		else
			sphide(n)
		end
	end
end
