--[[pod_format="raw",created="2024-06-22 10:30:42",modified="2024-06-29 12:01:03",revision=134]]
-- car.lua : car
--

-- include


-- initialize car
function cainit()

	-- instance
	if not car then
		car = {
			n_ = 0,   -- can_
			szw_ = 0, -- caszw_
			szh_ = 0, -- caszh_
			clr_ = 0, -- caclr_[8]
			chr_ = 0, -- cachr_[16,3]
		}
	end
	
	-- data
	local data = {
	-- 0x24, 0x21, 0x29, 0x27, 0x2c, 0x38, 0x09, 0x05, 
		0x24, 0x21, 0x29, 0x27, 0x3c, 0x38, 0x09, 0x05, 
		128 + 0, 0, 0x00, 
		144 + 1, 0, 0x00, 
		160 + 2, 0, 0x00, 
		160 + 2, 0, 0x00, 
		176 + 3, 0, 0x00, 
		192 + 4, 0, 0x00, 
		192 + 4, 0, 0x00, 
		192 + 4, 0, 0x00, 
		208 + 5, 0, 0x00, 
		192 + 4, 0, 0x08, 
		192 + 4, 0, 0x08, 
		192 + 4, 0, 0x08, 
		176 + 3, 0, 0x08, 
		160 + 2, 0, 0x08, 
		160 + 2, 0, 0x08, 
		144 + 1, 0, 0x08, 
	}
	
	-- initialize vars
	car.n_ = 8
	car.szw_ = 0.375
	car.szh_ = car.szw_ * 0.75
	
	-- initialize arrays
	car.clr_ = {}
	for i = 1, 8, 1 do
		car.clr_[i] = 0
	end
	car.chr_ = {}
	for i = 1, 16, 1 do
		car.chr_[i] = {}
		for j = 1, 3, 1 do
			car.chr_[i][j] = 0
		end
	end
	
	-- copy car sprite
	local d = 1
	for i = 1, 8, 1 do
		local c = data[d]
		d = d + 1
		car.clr_[i] = app.color_[c + 1]
	end
	for i = 1, 16, 1 do
		for j = 1, 3, 1 do
			local c = data[d]
			d = d + 1
			car.chr_[i][j] = c
		end
	end
	for i = 2, 8, 1 do
		local r = car.clr_[i]
		for y = 0, 15, 1 do
			for x = 0, 17 * 6 - 1, 1 do
				local c = app.gpage2_:get(128 + x, y)
				if c == car.clr_[1] then
					c = r
				end
				app.gpage2_:set(128 + x, (i - 1) * 16 + y, c)
			end
		end
	end
end
