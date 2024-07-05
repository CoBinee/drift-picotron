--[[pod_format="raw",created="2024-06-22 13:02:22",modified="2024-06-30 05:12:07",revision=250]]
-- race.lua : race
--

-- include


-- initialize race
function rcinit()

	-- instance
	if not race then
		race = {
			stg_ = 0, -- rcstg_
			stn_ = 0, -- rcstn_
			lop_ = 0, -- rclop_
			tim_ = 0, -- rctim_
			rnk_ = 0, -- rcrnk_[8]
			myc_ = 0, -- rcmyc_
			str_ = 0, -- rcstr_
			clr_ = 0, -- rcclr_
			ovr_ = 0, -- rcovr_
			flg_ = 0, -- rcflg_
		}
	end
	
	-- initialize vars
	race.stn_ = 5
	race.lop_ = 4
	
	-- initialize arrays
	race.rnk_ = {}
	for i = 1, 8, 1 do
		race.rnk_[i] = 0
	end
end

-- reset race
function rcrset()
	race.tim_ = -63
	for i = 0, 7, 1 do
		race.rnk_[i + 1] = -1
	end
	race.myc_ = -1
	race.str_ = 0
	race.clr_ = 0
	race.ovr_ = 0
	race.flg_ = 0
end

-- loop race
function rcloop()
	if race.myc_ < 0 then
		for i = 0, 7, 1 do
			if race.rnk_[i + 1] == 7 then
				race.myc_ = i
			end
		end
	end
	if race.tim_ < 60 * 60 * 60 - 1 and race.myc_ < 0 then
		race.tim_ = race.tim_ + race.str_ * app.vsync_
		if race.tim_ > 60 * 60 * 60 - 1 then
			race.tim_ = 60 * 60 * 60 - 1
		end
	end
	if race.myc_ >= 0 and race.myc_ <= 2 then
		race.clr_ = 1
	else
		race.clr_ = 0
	end
	if race.rnk_[2 + 1] >= 0 and (race.myc_ < 0 or race.myc_ > 2) then
		race.ovr_ = 1
	else
		race.ovr_ = 0
	end
	if race.tim_ >= 0 and race.str_ ~= 0 and (race.clr_ + race.ovr_ == 0) then
		race.flg_ = 1
	else
		race.flg_ = 0
	end
end

-- draw race
function rcdraw()

end
