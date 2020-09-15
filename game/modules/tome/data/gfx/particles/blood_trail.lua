-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

-- Make the 2 main forks

local sizeratio = 64 / engine.Map.tile_w

local dir = dir
local dist = (range or 1) * engine.Map.tile_w

local life = 32
local points = {}
points[#points+1] = {size=4, x=0, y=0, prev=-1, angle=0, vel=0}
for i = 1, 16 do
	local x = rng.range(-2, 2) / sizeratio
	local y = -dist / 16 * i
	-- local si = math.sqrt(i) * 0.8
	local size
	if i <= 4 then size = 16 - i * 3
	else size = points[#points].size * 0.92
	end
	points[#points+1] = {angle=-math.pi/2, vel=y/life/sizeratio * ((grab and 1) or -1), size=(i==16) and 1 or size, x=x, y=y, prev=#points-1}
end
local nbp = #points

return { engine=core.particles.ENGINE_LINES, system_rotation=dir, generator = function()
	local p = table.remove(points, 1)
	if not p then return nil end

	return {
		life = life, trail=p.prev,
		size = p.size, sizev = 0, sizea = 0,

		x = p.x, xv = 0, xa = 0,
		y = p.y, yv = 0, ya = 0,
		dir = p.angle, dirv = 0, dira = 0,
		vel = p.vel, velv = 0, vela = 0,

		r = 1, rv = 0, ra = 0,
		g = 1, gv = 0, ga = 0,
		b = 1, bv = 0, ba = 0,
		a = 0.5, av = 0, aa = -1/(life^2)*2,
	}
end, },
function(self)
	if nbp > 0 then
		nbp = nbp - self.ps:emit(nbp)
	end
end,
nbp, "particles_images/"..img
