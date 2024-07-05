--[[pod_format="raw",created="2024-06-20 12:09:45",modified="2024-06-30 06:28:09",revision=169]]
-- pause.lua : pause
--

-- include


-- initialize color table
function psinit()

	-- instance
	if not pause then
		pause = {
			spr_ = 0, -- psspr_
		}
	end
	
	-- initialize vars
	pause.spr_ = 511
	
	-- set sprite
	psrset()
	
end

-- reset pause
function psrset()
	local n = pause.spr_	
	spchr(n, 0, 168, 26, 7, 0x00)
	spofs(n, 200 + 40, 120 + 15, -256)
	sphome(n, 13, 3)
	spscale(n, 2, 2)	
end

-- loop pause
function psloop()

end

-- draw pause
function psdraw()
	local n = pause.spr_
	if app.pause_ == 1 then
		spshow(n)
	else
		sphide(n)
	end
end

