--[[pod_format="raw",created="2024-06-14 22:40:37",modified="2024-07-05 12:25:13",revision=2826]]
-- app.lua : application
--

-- include
include('sp.lua')
include('bg.lua')
include('color.lua')
include('chara.lua')
include('pause.lua')
include('title.lua')
include('game.lua')
include('race.lua')
include('cam.lua')
include('course.lua')
include('obj.lua')
include('car.lua')
include('rival.lua')
include('mycar.lua')
include('signal.lua')
include('rank.lua')
include('clear.lua')
include('over.lua')
include('navi.lua')
include('cockpit.lua')
include('back.lua')


-- create application instance
function app_init()

	-- setup application
	palt(0x00, false)
	palt(0x3f, true)
	
	-- instance
	if not app then
		app = {
			bp_ = 0,     -- bp_
			br_ = 0,     -- br_
			be_ = 0,     -- be_
			sx_ = 0,     -- sx_
			sy_ = 0,     -- sy_
			ox_ = 0,     -- ox_
			oy_ = 0,     -- oy_
			ow_ = 0,     -- ow_
			oh_ = 0,     -- oh_
			or_ = 0,     -- or_
			zn_ = 0,     -- zn_
			zf_ = 0,     -- zf_
			color_ = 0,  -- color_[64]
			gpage0_ = 0, 
			gpage1_ = 0, 
			gpage2_ = 0, 
			gpage3_ = 0, 
			pause_ = 0,  -- pause_
			debug_ = 0,  -- debug_
			state_ = 0,  -- state_
			proc_ = 0,   -- proc_$
			cycle_ = 0, 
			vsync_ = 0, 
			sound_ = 0, 
		}
	end
	
	-- initialize application vars
	app.bp_ = 0
	app.br_ = 0
	app.be_ = 0
	app.bl_ = 0
	app.sx_ = 0
	app.sy_ = 0
	app.ox_ = 200 + 40 -- 200
	app.oy_ = 160 + 15 -- 160
	app.ow_ = 200 + 40 -- 200
	app.oh_ = 80 + 15 -- 80
	app.or_ = 256
	app.zn_ = 2
	app.zf_ = 48
	app.color_ = nil
	app.gpage2_ = nil
	app.gpage3_ = nil
	app.pause_ = 0
	app.debug_ = 0
	app.state_ = 0
	app.proc_ = tlloop
	app.cycle_ = 0
	app.vsync_ = 2
	app.sound_ = true

	-- initialize libraries	
	spinit()
	bginit()
	
	-- initialize others
	clinit()
	chinit()
	psinit()
	tlinit()
	gminit()
	rcinit()
	cminit()
	csinit()
	obinit()
	cainit()
	rvinit()
	myinit()
	sginit()
	rkinit()
	gcinit()
	goinit()
	nvinit()
	cpinit()
	bkinit()
	
end
		
-- update
function app_update()

	-- switch speed
	if keyp('1') then
		app.vsync_ = 1
	end
	if keyp('2') then
		app.vsync_ = 2
	end

	-- update cycle
	app.cycle_ = app.cycle_ + 1
	if app.cycle_ >= app.vsync_ then
		app.cycle_ = 0
	end

	-- update button
	local b = 0b00000000
	do
		--[[
			PICOTRON:
				0 1 2 3     LEFT RIGHT UP DOWN
				4 5         Buttons: O X
				6           MENU
				7           reserved
				8 9 10 11   Secondary Stick L,R,U,D
				12 13       Buttons (not named yet!)
				14 15       SL SR	-- update proc
			SMILE BASIC:
				b00	  UP
				b01  DOWN
				b02  LEFT
				b03  RIGHT
				b04  A
				b05  B
				b06  X
				b07  Y
				b08  L
				b09  R
				b10  
				b11  ZL
				b12  ZR
		]]
		local b2b = {
			0b00000100, 
			0b00001000, 
			0b00000001, 
			0b00000010,
			0b00010000, 
			0b00100000, 
			0b01000000,  
			0b00000000, 
		}
		for i = 1, #b2b, 1 do
			if btn(i - 1) then
				b = b | b2b[i]
			end
		end
	end
	
	-- control pause
	if keyp('p') then
		app.pause_ = 1 - app.pause_
	end
	
	-- update frame
	if app.cycle_ == 0 then
	
		-- control button
		b = b | app.bl_
		app.be_ = (b ~ app.bp_) & b
		app.bp_ = b
		app.bl_ = 0
		if (app.bp_ & 0b00000100) ~= 0 then
			app.sx_ = -1
		elseif (app.bp_ & 0b00001000) ~= 0 then
			app.sx_ = 1
		else
			app.sx_ = 0
		end
		if (app.bp_ & 0b00000001) ~= 0 then
			app.sy_ = -1
		elseif (app.bp_ & 0b00000010) ~= 0 then
			app.sy_ = 1
		else
			app.sy_ = 0
		end	
		
		-- update scene
		if app.pause_ == 0 then
			app.proc_()
		end
		
		-- update pause
		psloop()
		psdraw()
		
	-- skip frame
	else
	
		-- update button
		app.bl_ = b
		
	end
		
end
		
-- draw
function app_draw()

	-- draw frame
	if app.cycle_ == 0 then
	
		-- clear screen
		-- cls(0x01)
		
		-- draw bg
		-- bgdraw()
		
		-- draw sprites
		spdraw()
		
		-- debug
		-- spr(app.gpage0_, 0, 0)
		-- spr(app.gpage1_, 0, 0)
		-- spr(app.gpage2_, 0, 0)
		-- spr(app.gpage3_, 0, 0)
	end
	
end
	