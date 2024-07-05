--[[pod_format="raw",created="2024-06-22 14:02:45",modified="2024-06-24 22:24:50",revision=73]]
-- cam.lua : camera
--

-- include


-- initialize camera
function cminit()

	-- instance
	if not cam then
		cam = {
			ox_ = 0, -- cmox_
			oy_ = 0, -- cmoy_
			oz_ = 0, -- cmoz_
			os_ = 0, -- cmos_
			oc_ = 0, -- cmoc_
			vx_ = 0, -- cmvx_
			vy_ = 0, -- cmvy_
			vz_ = 0, -- cmvz_
			rx_ = 0, -- cmrx_
			ry_ = 0, -- cmry_
			ra_ = 0, -- cmra_
			rs_ = 0, -- cmrs_
			rc_ = 0, -- cmrc_
		}
	end
	
	-- initialize vars
	
end
