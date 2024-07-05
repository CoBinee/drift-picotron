--[[pod_format="raw",created="2024-06-24 13:33:16",modified="2024-06-29 10:23:47",revision=86]]
-- over.lua : game over
--

-- include


-- initialize game over
function goinit()

	-- instance
	if not over then
		over = {
			t_ = 0,   -- got_
			spr_ = 0, -- gospr_
		}
	end
	
	-- initialize vars
	over.spr_=496

end

-- reset game over
function gorset()
	over.t_ = -48
	local n = over.spr_
	spchr(n, 0, 160, 42, 7, 0x00)
	spofs(n, 200 + 40, 120 + 15, -128)
	sphome(n, 21, 3)
	spscale(n, 8, 8)
	spcolor(n, app.color_[0x16 + 1])
end

-- loop game over
function goloop()
	if over.t_ < 32 then
		over.t_ = over.t_ + race.ovr_
	end
end

-- draw game over
function godraw()
	local n = over.spr_
	if race.ovr_ ~= 0 and over.t_ > 0 then
		local y = (120 + 15) - (160 + 15) * (1 + sin((math.pi * over.t_ / 64) / (2 * math.pi)))
		spofs(n, 200 + 40, y, -128)
		spshow(n)
	else
		sphide(n)
	end
end

