--[[pod_format="raw",created="2024-06-24 13:40:56",modified="2024-07-03 14:12:01",revision=1630]]
-- game.lua : game
--

-- include


-- initialize game
function gminit()
	
	-- instance
	if not game then
		game = {
			t_ = 0, -- gmt_
		}
	end
	
end

-- loop game
function gmloop()
	if app.state_ == 0 then
		gmloop0()
	elseif app.state_ == 1 then
		gmloop1()
	elseif app.state_ == 2 then
		gmloop2()
	end
	if app.state_ >= 2 then
		rcloop()
		csloop()
		obloop()
		rvloop()
		myloop()
		sgloop()
		rkloop()
		gcloop()
		goloop()
		nvloop()
		cploop()
		bkloop()
		rcdraw()
		csdraw()
		obdraw()
		rvdraw()
		mydraw()
		sgdraw()
		rkdraw()
		gcdraw()
		godraw()
		nvdraw()
		cpdraw()
		bkdraw()
	end
end

-- loop game 0: init
function gmloop0()
	race.stg_ = 1
	sprset()
	psrset()
	app.state_ = 1
end

-- loop game 1: load
function gmloop1()
	rcrset()
	csmake()
	obmake()
	rvrset()
	myrset()
	sgrset()
	rkrset()
	gcrset()
	gorset()
	nvrset()
	cprset()
	bkrset()
	if app.sound_ then
		music(0)
	end
	game.t_ = 0
	app.state_ = 2
end

-- loop game 2: drive
function gmloop2()
	if race.clr_ + race.ovr_ > 0 then
		if race.clr_ > 0 then
			if game.t_ == 0 then
				music(-1)
				if race.stg_ == race.stn_ then
					if app.sound_ then
						music(4)
					end
				else
					if app.sound_ then
						music(5)
					end
				end
			end
		else
			if game.t_ == 0 then
				if app.sound_ then
					music(6)
				end
			end
		end
		game.t_ = game.t_ + 1
		local t = 256
		if race.stg_ == race.stn_ then
			t = t + 256 * race.clr_
		end
		if (game.t_ > 32 and (app.be_ & 16) ~= 0) or game.t_ > t then
			music(-1)
			if race.clr_ ~= 0 then
				if race.stg_ < race.stn_ then
					race.stg_ = race.stg_ + 1
					app.state_ = 1
				else
					app.proc_ = tlloop
					app.state_ = 0
				end
			else
				app.proc_ = tlloop
				app.state_ = 0
			end
		end
	end
end

