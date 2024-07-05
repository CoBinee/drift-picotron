--[[pod_format="raw",created="2024-06-24 12:34:33",modified="2024-06-29 12:01:04",revision=76]]
-- rank.lua : rank
--

-- include


-- initialize rank
function rkinit()

	-- instance
	if not rank then
		rank = {
			car_ = 0, -- rkcar_[8],
			dst_ = 0, -- rkdst_[8]
			spr_ = 0, -- rkspr_
		}
	end

	-- initialize vars
	rank.spr_ = 448
	
	-- initialize arrays
	rank.car_ = {}
	for i = 1, 8, 1 do
		rank.car_[i] = 0
	end
	rank.dst_ = {}
	for i = 1, 8, 1 do
		rank.dst_[i] = 0
	end
end

-- reset rank
function rkrset()
	local n = rank.spr_
	for i = 0, 2, 1 do
		spchr(n, 0, 48, 30, 8, 0x00)
		spofs(n, 200 + 40, 64 + i * 48 + 15, -64)
		sphome(n, 0, 0)
		spscale(n, 2, 2)
		n = n + 1
		spchr(n, (i + 1) * 6, 8, 6, 7, 0x00)
		spofs(n, 256 + 40, 76 + i * 48 + 15, -72)
		sphome(n, 6, 7)
		spscale(n, 5, 5)
		spcolor(n, app.color_[0x28 + 1])
		n = n + 1
		spchr(n, 30 + i * 18, 48, 18, 8, 0x00)
		spofs(n, 260 + 40, 64 + i * 48 + 15, -64)
		sphome(n, 0, 0)
		spscale(n, 2, 2)
		n = n + 1
		spchr(n, car.chr_[8 + 1][0 + 1], car.chr_[8 + 1][1 + 1], 16, 12, 0x00)
		spofs(n, 160 + 40, 56 + i * 48 + 15, -72)
		sphome(n, 8, 6)
		spscale(n, 4, 4)
		n = n + 1
	end
end

-- sort ranks
local function rkqsort(first, last)
	if first > last then
		return
	end
	local p = first
	for i = first + 1, last, 1 do
		if rank.dst_[i] > rank.dst_[first] then
			p = p + 1
			rank.dst_[p], rank.dst_[i] = rank.dst_[i], rank.dst_[p]
			rank.car_[p], rank.car_[i] = rank.car_[i], rank.car_[p]
    	end
    end
    rank.dst_[p], rank.dst_[first] = rank.dst_[first], rank.dst_[p]
    rank.car_[p], rank.car_[first] = rank.car_[first], rank.car_[p]
    rkqsort(first, p - 1)
    rkqsort(p + 1, last)
end	

-- loop rank
function rkloop()
	for i = 0, rival.n_ - 1, 1 do
		rank.car_[i + 1] = i
		rank.dst_[i + 1] = rival.dst_[i + 1]
	end
	rank.car_[rival.n_ + 1] = rival.n_
	rank.dst_[rival.n_ + 1] = mycar.dst_
	for i = 0, car.n_ - 1, 1 do
		local j = race.rnk_[i + 1]
		if j >= 0 then
			rank.dst_[j + 1] = rank.dst_[j + 1] + (car.n_ - i) * 10 * course.dsl_
		end
	end
	rkqsort(1, #rank.dst_)
	for i = 0, car.n_ - 1, 1 do
		local j = rank.car_[i + 1]
		if j < rival.n_ then
			rival.rnk_[j + 1][0 + 1] = i
			if race.rnk_[i + 1] < 0 and rival.lpc_[j + 1] > race.lop_ then
				race.rnk_[i + 1] = j
			end
		else
			if mycar.rnk_[race.stg_ + 1] > i then
				local p = sgn(rival.sde_[rank.car_[(i + 1) + 1] + 1] - mycar.sde_)
				--beep 44,0,48,32*p+32
			end
			mycar.rnk_[race.stg_ + 1] = i
			if race.rnk_[i + 1] < 0 and mycar.lpc_ > race.lop_ then
				race.rnk_[i + 1] = j
			end
		end
	end
	for i = 0, rival.n_ - 1, 1 do
		rival.rnk_[i + 1][1 + 1] = rival.rnk_[i + 1][0 + 1] - mycar.rnk_[race.stg_ + 1]
	end
end

-- draw rank
function rkdraw()
	local n =rank.spr_
	for i = 0, 2, 1 do
		local j = race.rnk_[i + 1]
		if j >= 0 then
			spchr(n + 3, car.chr_[8 + 1][0 + 1], car.chr_[8 + 1][1 + 1] + j * 16, 16, 12, 0x01)
			spshow(n + 0)
			spshow(n + 1)
			spshow(n + 2)
			spshow(n + 3)
		else
			sphide(n + 0)
			sphide(n + 1)
			sphide(n + 2)
			sphide(n + 3)
		end
		n = n + 4
	end
end
