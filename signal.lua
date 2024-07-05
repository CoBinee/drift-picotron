--[[pod_format="raw",created="2024-06-23 22:25:39",modified="2024-07-02 21:46:05",revision=155]]
-- signal.lua : signal
--

-- include


-- initialize signal
function sginit()

	-- instance
	if not signal then
		signal = {
			x_ = 0,   -- sgx_
			y_ = 0,   -- sgy_
			h_ = 0,   -- sgh_
			spr_ = 0, -- sgspr_
			test = 0, 
		}
	end
	
	-- initialize vars
	signal.x_ = 200 + 40 -- 200
	signal.y_ = 64 + 15 -- 64
	signal.h_ = 80 + 15 -- 80
	signal.spr_ = 440
end

-- reset signal
function sgrset()
	local n = signal.spr_
	spchr(n, 48, 96, 32, 8, 0x00)
	sphome(n, 16, 3)
	spscale(n, 4, 4)
	n = n + 1
	for i = 0, 3, 1 do
		local f = 0
		if i == 3 then
			f = 1
		end
		spchr(n, 48 + (f) * 5, 104, 5, 5, 0x00)
		sphome(n, 2, 2)
		spscale(n, 4, 4)
		n = n + 1
	end
end

-- loop signal
function sgloop()
	local t = abs(race.tim_)
	if race.tim_ <= 0 then
		if (t % 16) < app.vsync_ then
			if (t // 16) == 0 then
				sfx(20)
			else
				sfx(19)
			end
		end
	end
end

-- draw signal
function sgdraw()
	local n = signal.spr_
	local t = min(32, max(0, race.tim_))
	local x = signal.x_
	local y = signal.y_ - signal.h_ * (1 - cos((t * math.pi / 64) / (2 * math.pi)))
	local s = 3 - (max(0, -race.tim_ + 15) // 16)
	spofs(n, x, y, -64)
	spshow(n)
	n = n + 1
	for i = 0, 3, 1 do
		if i <= s then
			spofs(n, x - 44 + i * 28, y, -72)
			spshow(n)
		else
			sphide(n)
		end
		n = n + 1
	end
end
