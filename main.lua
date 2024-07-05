--[[pod_format="raw",created="2024-06-14 21:49:24",modified="2024-07-05 12:07:58",revision=2462]]
-- main.lua : entry point
--

-- include
include("app.lua")


-- called once when the program starts
function _init()

	-- initialize application
	app_init()
	
end

-- called at 60fps
function _update()

	-- update application
	app_update()
	
end

-- called whenever a frame is drawn
function _draw()

	-- draw application
	app_draw()
	
end


