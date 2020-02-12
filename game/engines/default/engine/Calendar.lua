-- TE4 - T-Engine 4
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

--- Defines calendars for factions
-- @classmod engine.Calendar
module(..., package.seeall, class.make)

--- Default: 10
seconds_per_turn = 10

--- Default: 6 turns = 60 / `seconds_per_turn`
MINUTE = 60 / seconds_per_turn
--- Default: 360 turns = `MINUTE` * 60
HOUR = MINUTE * 60
--- Default: 8640 turns = `HOUR` * 24
DAY = HOUR * 24
--- Default: 3153600 turns = `DAY` * 365
YEAR = DAY * 365
--- Default: 2160 turns = `HOUR` * 6
DAY_START = HOUR * 6

--- Create a calendar
-- @param definition the file to load that returns a table containing calendar months
-- @param datestring a string to format the date when requested, in the format "%s %s %s %d %d", standing for, day, month, year, hour, minute
-- @param start_year the year the calendar starts at
-- @param start_day defaults to 1
-- @param start_hour defaults to 8
function _M:init(definition, datestring, start_year, start_day, start_hour)
	local data = dofile(definition)
	self.calendar = {}
	local days = 0
	for _, e in ipairs(data) do
		if not e[3] then e[3] = 0 end
		table.insert(self.calendar, { days=days, name=e[2], length=e[1], offset=e[3] })
		days = days + e[1]
	end
	assert(days == 365, "Calendar incomplete, days ends at "..days.." instead of 365")

	self.datestring = datestring
	self.start_year = start_year
	self.start_day = start_day or 1
	self.start_hour = start_hour or 8
end

--- Gets a formatted timedate string
-- @int turn 
-- @string dstr a datestring
-- @return a formatted date string
function _M:getTimeDate(turn, dstr)
	local doy, year = self:getDayOfYear(turn)
	local hour, min = self:getTimeOfDay(turn)
	return (dstr or self.datestring):tformat(tostring(self:getDayOfMonth(doy)):ordinal(), self:getMonthName(doy), tostring(year):ordinal(), hour, min)
end

--- Get what day of the year it is based on turn
-- @int turn
-- @return day_of_year
-- @return year
function _M:getDayOfYear(turn)
	local d, y
	turn = turn + self.start_hour * self.HOUR
	d = math.floor(turn / self.DAY) + (self.start_day - 1)
	y = math.floor(d / 365)
	d = math.floor(d % 365)
	return d, self.start_year + y
end

--- Current time based on turn
-- @int turn
-- @return hour
-- @return min
function _M:getTimeOfDay(turn)
	local hour, min
	turn = turn + self.start_hour * self.HOUR
	min = math.floor((turn % self.DAY) / self.MINUTE)
	hour = math.floor(min / 60)
	min = math.floor(min % 60)
	return hour, min
end

--- Gets month number based on day of year
-- @int dayofyear use `getDayOfYear`
-- @return integer between {1, numMonths}
function _M:getMonthNum(dayofyear)
	local i = #self.calendar

	-- Find the period name
	while ((i > 1) and (dayofyear < self.calendar[i].days)) do
		i = i - 1
	end

	return i
end

--- Returns the name of the month using the day
-- @int dayofyear use `getDayOfYear`
-- @return month.name
function _M:getMonthName(dayofyear)
	local month = self:getMonthNum(dayofyear)
	return self.calendar[month].name
end

--- Day of the month using day of year
-- @int dayofyear getDayOfYear
-- @return integer between {1, numDaysInMonth}
function _M:getDayOfMonth(dayofyear)
	local month = self:getMonthNum(dayofyear)
	return dayofyear - self.calendar[month].days + 1 + self.calendar[month].offset
end

--- How long the month is using day of year
-- @int dayofyear getDayOfYear
-- @return month.length
function _M:getMonthLength(dayofyear)
	local month = self:getMonthNum(dayofyear)
	return self.calendar[month].length
end
