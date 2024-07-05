--[[pod_format="raw",created="2024-06-21 20:55:07",modified="2024-06-24 21:39:02",revision=412]]
-- bg.lua : bg library
--

-- include


-- initialize bg
function bginit()
	if not bg then
		bg = {
			screen_w = 0, 
			screen_h = 0, 
			ofs_x = 0, 
			ofs_y = 0, 
			ofs_z = 0, 
			home_x = 0, 
			home_y = 0, 
			scale_x = 1, 
			scale_y = 1, 
			rot = 0, 
			show = false, 
		}
	end
end

-- set bg screen size
function bgscreen(layer, w, h)
	bg.screen_w = w
	bg.screen_h = h
end

-- set bg offset
function bgofs(layer, x, y, z)
	bg.ofs_x = x
	bg.ofs_y = y
	bg.ofs_z = z
end

-- set bg home
function bghome(layer, x, y)
	bg.home_x = x
	bg.home_y = y
end

-- set bg scale
function bgscale(layer, x, y)
	bg.scale_x = x
	bg.scale_y = y
end

-- set bg rotate
function bgrot(layer, r)
	bg.rot = r
end

-- put bg character
function bgput(layer, x, y, c)
	mset(x, y, c)
end

-- fill bg character
function bgfill(layer, x0, y0, x1, y1, c)
	for y = y0, y1, 1 do
		for x = x0, x1, 1 do
			mset(x, y, c)
		end
	end
end

-- show bg
function bgshow(layer)
	bg.show = true
end

-- hide bg
function bghide(layer)
	bg.show = false
end

-- draw bg
function bgdraw()
	if bg.show then
		map(0, 0, bg.ofs_x - bg.home_x, bg.ofs_y - bg.home_y)
	end
end
