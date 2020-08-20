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

require "engine.class"
local DeathDialog = require "mod.dialogs.DeathDialog"
local Textzone = require "engine.ui.Textzone"
local Shader = require "engine.Shader"

module(..., package.seeall, class.inherit(DeathDialog))

function _M:init(actor)
	DeathDialog.init(self, actor)
end

function _M:printRanking()
	local scores = world.arena.scores
	if not scores[1].name then
		return _t"#LIGHT_GREEN#No high scores. This should not happen."
	else
		local text = ""
		local tmp = ""
		local line = function (txt, col) return " "..col..txt.."\n" end
		local i = 1
		while(scores[i] and scores[i].name) do
			p = scores[i]
			tmp = ("%s (%s %s %s)\n Score %d[%s]) - Wave: %d"):tformat((p.name or _t"unknown"):capitalize(), p.sex or _t"unknown", p.race or _t"unknown", p.class or _t"unknown", p.score or _t"unknown", p.perk or _t"unknown", p.wave or -1)
			if p.name == world.arena.lastScore.name and p.score == world.arena.lastScore.score and p.wave == world.arena.lastScore.wave and p.perk == world.arena.lastScore.perk then
				text = text..line(tmp, "#YELLOW#")
			else
				text = text..line(tmp, "#LIGHT_BLUE#")
			end
			i = i + 1
		end
		return text
	end
end

function _M:setupDescription()
	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=self:printRanking()}
	self.c_desc:setTextShadow(1)
	self.c_desc:setShadowShader(Shader.default.textoutline and Shader.default.textoutline.shad, 1.2)
end
