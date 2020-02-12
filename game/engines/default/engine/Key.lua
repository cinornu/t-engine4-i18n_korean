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

--- Basic keypress handler
-- The engine calls receiveKey when a key is pressed
-- @classmod engine.Key
module(..., package.seeall, class.make)

--- Init
function _M:init()
	self.status = {}
end

--- Check if we are disabled
function _M:isEnabled()
	if not self.disable_until then return true end
	if core.game.getTime() < self.disable_until then 
		if game.log then game.log("#LIGHT_RED#Keyboard input temporarily disabled.") end
		return false
	else
		self.disable_until = nil
		return true
	end
end

--- Called when a key is pressed
-- @number sym a number representing the key, see all the _FOO fields
-- @param[type=boolean] ctrl is the control key pressed?
-- @param[type=boolean] shift is the shit key pressed?
-- @param[type=boolean] alt is the alt key pressed?
-- @param[type=boolean] meta is the meta key pressed?
-- @param unicode the unicode representation of the key, if possible
-- @param[type=boolean] isup true if the key was released, false if pressed
-- @string key the unicode representation of the key pressed (without accounting for modifiers)
function _M:receiveKey(sym, ctrl, shift, alt, meta, unicode, isup, key)
	if not self:isEnabled() then return end
	self:handleStatus(sym, ctrl, shift, alt, meta, unicode, isup)
end

--- Called when a key is pressed, gives raw codes
-- @param[type=boolean] isup false if pressed, true if released
-- @number scancode
-- @number sym a number representing the key, see all the _FOO fields
-- @param unicode the unicode representation of the key, if possible
-- @param[type=boolean] ctrl is the control key pressed?
-- @param[type=boolean] shift is the shit key pressed?
-- @param[type=boolean] alt is the alt key pressed?
-- @param[type=boolean] meta is the meta key pressed?
function _M:receiveKeyRaw(isup, scancode, sym, unicode, ctrl, shift, alt, meta)
end

--- Called when a gamepad key is pressed
-- @param button the id
-- @param[type=boolean] isup false if pressed, true if released
function _M:receiveJoyButton(button, isup)
	-- print("==joy button", button, isup)
end

--- Maintain the self.status table, which can be used to know if a key is currently pressed
-- @number sym a number representing the key, see all the _FOO fields
-- @param[type=boolean] ctrl is the control key pressed?
-- @param[type=boolean] shift is the shit key pressed?
-- @param[type=boolean] alt is the alt key pressed?
-- @param[type=boolean] meta is the meta key pressed?
-- @param unicode the unicode representation of the key, if possible
-- @param[type=boolean] isup false if pressed, true if released
function _M:handleStatus(sym, ctrl, shift, alt, meta, unicode, isup)
	self.status[sym] = not isup
end

--- Setup as the current game keyhandler
function _M:setCurrent()
	core.key.set_current_handler(self)
--	if game then game.key = self end
	_M.current = self
end

-- This regex takes the fields below, and adds doc comments for all of them
-- You'll need to remove the comments below before you use the regex though
-- Regex: /(_*[\S]*)\s*=\s*(-?[\d]*)/g
-- Subst: --- @field $1 $2 \n$1 = $2
-- A lazy solution to remove the comments would be to use the following:
-- Regex: /(?:(_*[\S]*)\s*(=)\s*(-?[\d]*))|(--- @field\s+_+[\S]*\s+-?[\d]*)/g
-- Subst: $1 $2 $3

--- @field _UNKNOWN 0 
_UNKNOWN = 0
--- @field _a 4 
_a = 4
--- @field _b 5 
_b = 5
--- @field _c 6 
_c = 6
--- @field _d 7 
_d = 7
--- @field _e 8 
_e = 8
--- @field _f 9 
_f = 9
--- @field _g 10 
_g = 10
--- @field _h 11 
_h = 11
--- @field _i 12 
_i = 12
--- @field _j 13 
_j = 13
--- @field _k 14 
_k = 14
--- @field _l 15 
_l = 15
--- @field _m 16 
_m = 16
--- @field _n 17 
_n = 17
--- @field _o 18 
_o = 18
--- @field _p 19 
_p = 19
--- @field _q 20 
_q = 20
--- @field _r 21 
_r = 21
--- @field _s 22 
_s = 22
--- @field _t 23 
_t = 23
--- @field _u 24 
_u = 24
--- @field _v 25 
_v = 25
--- @field _w 26 
_w = 26
--- @field _x 27 
_x = 27
--- @field _y 28 
_y = 28
--- @field _z 29 
_z = 29

--- @field _1 30 
_1 = 30
--- @field _2 31 
_2 = 31
--- @field _3 32 
_3 = 32
--- @field _4 33 
_4 = 33
--- @field _5 34 
_5 = 34
--- @field _6 35 
_6 = 35
--- @field _7 36 
_7 = 36
--- @field _8 37 
_8 = 37
--- @field _9 38 
_9 = 38
--- @field _0 39 
_0 = 39

--- @field _RETURN 40 
_RETURN = 40
--- @field _ESCAPE 41 
_ESCAPE = 41
--- @field _BACKSPACE 42 
_BACKSPACE = 42
--- @field _TAB 43 
_TAB = 43
--- @field _SPACE 44 
_SPACE = 44

--- @field _MINUS 45 
_MINUS = 45
--- @field _EQUALS 46 
_EQUALS = 46
--- @field _LEFTBRACKET 47 
_LEFTBRACKET = 47
--- @field _RIGHTBRACKET 48 
_RIGHTBRACKET = 48
--- @field _BACKSLASH 49 
_BACKSLASH = 49
--- @field _NONUSHASH 50 
_NONUSHASH = 50
--- @field _SEMICOLON 51 
_SEMICOLON = 51
--- @field _APOSTROPHE 52 
_APOSTROPHE = 52
--- @field _GRAVE 53 
_GRAVE = 53
--- @field _COMMA 54 
_COMMA = 54
--- @field _PERIOD 55 
_PERIOD = 55
--- @field _SLASH 56 
_SLASH = 56

--- @field _CAPSLOCK 57 
_CAPSLOCK = 57

--- @field _F1 58 
_F1 = 58
--- @field _F2 59 
_F2 = 59
--- @field _F3 60 
_F3 = 60
--- @field _F4 61 
_F4 = 61
--- @field _F5 62 
_F5 = 62
--- @field _F6 63 
_F6 = 63
--- @field _F7 64 
_F7 = 64
--- @field _F8 65 
_F8 = 65
--- @field _F9 66 
_F9 = 66
--- @field _F10 67 
_F10 = 67
--- @field _F11 68 
_F11 = 68
--- @field _F12 69 
_F12 = 69

--- @field _PRINTSCREEN 70 
_PRINTSCREEN = 70
--- @field _SCROLLLOCK 71 
_SCROLLLOCK = 71
--- @field _PAUSE 72 
_PAUSE = 72
--- @field _INSERT 73 
_INSERT = 73
--- @field _HOME 74 
_HOME = 74
--- @field _PAGEUP 75 
_PAGEUP = 75
--- @field _DELETE 76 
_DELETE = 76
--- @field _END 77 
_END = 77
--- @field _PAGEDOWN 78 
_PAGEDOWN = 78
--- @field _RIGHT 79 
_RIGHT = 79
--- @field _LEFT 80 
_LEFT = 80
--- @field _DOWN 81 
_DOWN = 81
--- @field _UP 82 
_UP = 82

--- @field _NUMLOCKCLEAR 83 
_NUMLOCKCLEAR = 83
--- @field _KP_DIVIDE 84 
_KP_DIVIDE = 84
--- @field _KP_MULTIPLY 85 
_KP_MULTIPLY = 85
--- @field _KP_MINUS 86 
_KP_MINUS = 86
--- @field _KP_PLUS 87 
_KP_PLUS = 87
--- @field _KP_ENTER 88 
_KP_ENTER = 88
--- @field _KP_1 89 
_KP_1 = 89
--- @field _KP_2 90 
_KP_2 = 90
--- @field _KP_3 91 
_KP_3 = 91
--- @field _KP_4 92 
_KP_4 = 92
--- @field _KP_5 93 
_KP_5 = 93
--- @field _KP_6 94 
_KP_6 = 94
--- @field _KP_7 95 
_KP_7 = 95
--- @field _KP_8 96 
_KP_8 = 96
--- @field _KP_9 97 
_KP_9 = 97
--- @field _KP_0 98 
_KP_0 = 98
--- @field _KP_PERIOD 99 
_KP_PERIOD = 99

--- @field _NONUSBACKSLASH 100 
_NONUSBACKSLASH = 100
--- @field _APPLICATION 101 
_APPLICATION = 101
--- @field _POWER 102 
_POWER = 102
--- @field _KP_EQUALS 103 
_KP_EQUALS = 103
--- @field _F13 104 
_F13 = 104
--- @field _F14 105 
_F14 = 105
--- @field _F15 106 
_F15 = 106
--- @field _F16 107 
_F16 = 107
--- @field _F17 108 
_F17 = 108
--- @field _F18 109 
_F18 = 109
--- @field _F19 110 
_F19 = 110
--- @field _F20 111 
_F20 = 111
--- @field _F21 112 
_F21 = 112
--- @field _F22 113 
_F22 = 113
--- @field _F23 114 
_F23 = 114
--- @field _F24 115 
_F24 = 115
--- @field _EXECUTE 116 
_EXECUTE = 116
--- @field _HELP 117 
_HELP = 117
--- @field _MENU 118 
_MENU = 118
--- @field _SELECT 119 
_SELECT = 119
--- @field _STOP 120 
_STOP = 120
--- @field _AGAIN 121 
_AGAIN = 121
--- @field _UNDO 122 
_UNDO = 122
--- @field _CUT 123 
_CUT = 123
--- @field _COPY 124 
_COPY = 124
--- @field _PASTE 125 
_PASTE = 125
--- @field _FIND 126 
_FIND = 126
--- @field _MUTE 127 
_MUTE = 127
--- @field _VOLUMEUP 128 
_VOLUMEUP = 128
--- @field _VOLUMEDOWN 129 
_VOLUMEDOWN = 129
--- @field _KP_COMMA 133 
_KP_COMMA = 133
--- @field _KP_EQUALSAS400 134 
_KP_EQUALSAS400 = 134

--- @field _INTERNATIONAL1 135 
_INTERNATIONAL1 = 135
--- @field _INTERNATIONAL2 136 
_INTERNATIONAL2 = 136
--- @field _INTERNATIONAL3 137 
_INTERNATIONAL3 = 137
--- @field _INTERNATIONAL4 138 
_INTERNATIONAL4 = 138
--- @field _INTERNATIONAL5 139 
_INTERNATIONAL5 = 139
--- @field _INTERNATIONAL6 140 
_INTERNATIONAL6 = 140
--- @field _INTERNATIONAL7 141 
_INTERNATIONAL7 = 141
--- @field _INTERNATIONAL8 142 
_INTERNATIONAL8 = 142
--- @field _INTERNATIONAL9 143 
_INTERNATIONAL9 = 143
--- @field _LANG1 144 
_LANG1 = 144
--- @field _LANG2 145 
_LANG2 = 145
--- @field _LANG3 146 
_LANG3 = 146
--- @field _LANG4 147 
_LANG4 = 147
--- @field _LANG5 148 
_LANG5 = 148
--- @field _LANG6 149 
_LANG6 = 149
--- @field _LANG7 150 
_LANG7 = 150
--- @field _LANG8 151 
_LANG8 = 151
--- @field _LANG9 152 
_LANG9 = 152

--- @field _ALTERASE 153 
_ALTERASE = 153
--- @field _SYSREQ 154 
_SYSREQ = 154
--- @field _CANCEL 155 
_CANCEL = 155
--- @field _CLEAR 156 
_CLEAR = 156
--- @field _PRIOR 157 
_PRIOR = 157
--- @field _RETURN2 158 
_RETURN2 = 158
--- @field _SEPARATOR 159 
_SEPARATOR = 159
--- @field _OUT 160 
_OUT = 160
--- @field _OPER 161 
_OPER = 161
--- @field _CLEARAGAIN 162 
_CLEARAGAIN = 162
--- @field _CRSEL 163 
_CRSEL = 163
--- @field _EXSEL 164 
_EXSEL = 164

--- @field _KP_00 176 
_KP_00 = 176
--- @field _KP_000 177 
_KP_000 = 177
--- @field _THOUSANDSSEPARATOR 178 
_THOUSANDSSEPARATOR = 178
--- @field _DECIMALSEPARATOR 179 
_DECIMALSEPARATOR = 179
--- @field _CURRENCYUNIT 180 
_CURRENCYUNIT = 180
--- @field _CURRENCYSUBUNIT 181 
_CURRENCYSUBUNIT = 181
--- @field _KP_LEFTPAREN 182 
_KP_LEFTPAREN = 182
--- @field _KP_RIGHTPAREN 183 
_KP_RIGHTPAREN = 183
--- @field _KP_LEFTBRACE 184 
_KP_LEFTBRACE = 184
--- @field _KP_RIGHTBRACE 185 
_KP_RIGHTBRACE = 185
--- @field _KP_TAB 186 
_KP_TAB = 186
--- @field _KP_BACKSPACE 187 
_KP_BACKSPACE = 187
--- @field _KP_A 188 
_KP_A = 188
--- @field _KP_B 189 
_KP_B = 189
--- @field _KP_C 190 
_KP_C = 190
--- @field _KP_D 191 
_KP_D = 191
--- @field _KP_E 192 
_KP_E = 192
--- @field _KP_F 193 
_KP_F = 193
--- @field _KP_XOR 194 
_KP_XOR = 194
--- @field _KP_POWER 195 
_KP_POWER = 195
--- @field _KP_PERCENT 196 
_KP_PERCENT = 196
--- @field _KP_LESS 197 
_KP_LESS = 197
--- @field _KP_GREATER 198 
_KP_GREATER = 198
--- @field _KP_AMPERSAND 199 
_KP_AMPERSAND = 199
--- @field _KP_DBLAMPERSAND 200 
_KP_DBLAMPERSAND = 200
--- @field _KP_VERTICALBAR 201 
_KP_VERTICALBAR = 201
--- @field _KP_DBLVERTICALBAR 202 
_KP_DBLVERTICALBAR = 202
--- @field _KP_COLON 203 
_KP_COLON = 203
--- @field _KP_HASH 204 
_KP_HASH = 204
--- @field _KP_SPACE 205 
_KP_SPACE = 205
--- @field _KP_AT 206 
_KP_AT = 206
--- @field _KP_EXCLAM 207 
_KP_EXCLAM = 207
--- @field _KP_MEMSTORE 208 
_KP_MEMSTORE = 208
--- @field _KP_MEMRECALL 209 
_KP_MEMRECALL = 209
--- @field _KP_MEMCLEAR 210 
_KP_MEMCLEAR = 210
--- @field _KP_MEMADD 211 
_KP_MEMADD = 211
--- @field _KP_MEMSUBTRACT 212 
_KP_MEMSUBTRACT = 212
--- @field _KP_MEMMULTIPLY 213 
_KP_MEMMULTIPLY = 213
--- @field _KP_MEMDIVIDE 214 
_KP_MEMDIVIDE = 214
--- @field _KP_PLUSMINUS 215 
_KP_PLUSMINUS = 215
--- @field _KP_CLEAR 216 
_KP_CLEAR = 216
--- @field _KP_CLEARENTRY 217 
_KP_CLEARENTRY = 217
--- @field _KP_BINARY 218 
_KP_BINARY = 218
--- @field _KP_OCTAL 219 
_KP_OCTAL = 219
--- @field _KP_DECIMAL 220 
_KP_DECIMAL = 220
--- @field _KP_HEXADECIMAL 221 
_KP_HEXADECIMAL = 221

--- @field _LCTRL 224 
_LCTRL = 224
--- @field _LSHIFT 225 
_LSHIFT = 225
--- @field _LALT 226 
_LALT = 226
--- @field _LGUI 227 
_LGUI = 227
--- @field _RCTRL 228 
_RCTRL = 228
--- @field _RSHIFT 229 
_RSHIFT = 229
--- @field _RALT 230 
_RALT = 230
--- @field _RGUI 231 
_RGUI = 231
--- @field _MODE 257 
_MODE = 257
--- @field _AUDIONEXT 258 
_AUDIONEXT = 258
--- @field _AUDIOPREV 259 
_AUDIOPREV = 259
--- @field _AUDIOSTOP 260 
_AUDIOSTOP = 260
--- @field _AUDIOPLAY 261 
_AUDIOPLAY = 261
--- @field _AUDIOMUTE 262 
_AUDIOMUTE = 262
--- @field _MEDIASELECT 263 
_MEDIASELECT = 263
--- @field _WWW 264 
_WWW = 264
--- @field _MAIL 265 
_MAIL = 265
--- @field _CALCULATOR 266 
_CALCULATOR = 266
--- @field _COMPUTER 267 
_COMPUTER = 267
--- @field _AC_SEARCH 268 
_AC_SEARCH = 268
--- @field _AC_HOME 269 
_AC_HOME = 269
--- @field _AC_BACK 270 
_AC_BACK = 270
--- @field _AC_FORWARD 271 
_AC_FORWARD = 271
--- @field _AC_STOP 272 
_AC_STOP = 272
--- @field _AC_REFRESH 273 
_AC_REFRESH = 273
--- @field _AC_BOOKMARKS 274 
_AC_BOOKMARKS = 274
--- @field _BRIGHTNESSDOWN 275 
_BRIGHTNESSDOWN = 275
--- @field _BRIGHTNESSUP 276 
_BRIGHTNESSUP = 276
--- @field _DISPLAYSWITCH 277 
_DISPLAYSWITCH = 277
--- @field _KBDILLUMTOGGLE 278 
_KBDILLUMTOGGLE = 278
--- @field _KBDILLUMDOWN 279 
_KBDILLUMDOWN = 279
--- @field _KBDILLUMUP 280 
_KBDILLUMUP = 280
--- @field _EJECT 281 
_EJECT = 281
--- @field _SLEEP 282 
_SLEEP = 282

--- @field __DEFAULT -10000 
__DEFAULT = -10000
--- @field __TEXTINPUT -10001 
__TEXTINPUT = -10001

-- Reverse sym calc
_M.sym_to_name = {}
for k, e in pairs(_M) do
	if type(k) == "string" and type(e) == "number" then
		_M.sym_to_name[e] = k
	end
end
