/*
	TE4 - T-Engine 4
	Copyright (C) 2009 - 2018 Nicolas Casalini

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Nicolas Casalini "DarkGod"
	darkgod@te4.org
*/

#ifndef _WFC_LUA_H_
#define _WFC_LUA_H_
#include "tSDL.h"

#include "wfc.hpp"
#include "overlapping_wfc.hpp"

struct WFCOverlapping {
	unsigned int n;
	unsigned int symmetry;
	bool periodic_out;
	bool periodic_in;
	bool has_foundation;

	Array2D<char> sample;
	Array2D<char> output;

	WFCOverlapping(int n, int symmetry, bool periodic_out, bool periodic_in, bool has_foundation, int sample_w, int sample_h, int output_w, int output_h) :
		n(n), symmetry(symmetry), periodic_out(periodic_out), periodic_in(periodic_in), has_foundation(has_foundation), sample(sample_h, sample_w), output(output_h, output_w)
	{}
};

enum class WFCAsyncMode { OVERLAPPING, TILED };
struct WFCAsync {
	WFCAsyncMode mode = WFCAsyncMode::OVERLAPPING;
	WFCOverlapping *overlapping_config = nullptr;
	SDL_Thread *thread;
};

#endif
