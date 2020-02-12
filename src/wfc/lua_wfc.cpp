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

extern "C" {
#include "lauxlib.h"
#include "lualib.h"
#include "auxiliar.h"
#include "lua_wfc_external.h"
#include "SFMT.h"
}
#include "stdlib.h"
#include "string.h"
#include "lua_wfc.hpp"

static WFCOverlapping *parse_config_overlapping(lua_State *L) {
	// Iterate the sample lines to find max size
	int sample_w = 9999;
	int sample_h = lua_objlen(L, 1);
	for (int y = 0; y < sample_h; y++) {
		lua_rawgeti(L, 1, y + 1);
		size_t len;
		unsigned char *line = (unsigned char*)strdup(luaL_checklstring(L, -1, &len));
		if (len < sample_w) sample_w = len;
		lua_pop(L, 1);
	}

	WFCOverlapping *config = new WFCOverlapping(
		luaL_checknumber(L, 4), // n
		luaL_checknumber(L, 5), // symmetry
		lua_toboolean(L, 6), // periodic_out
		lua_toboolean(L, 7), // periodic_in
		lua_toboolean(L, 8), // has_foundation
		sample_w, sample_h,
		luaL_checknumber(L, 2), // output.w
		luaL_checknumber(L, 3) // output.h
	);

	// Iterate the sample lines to import them
	for (int y = 0; y < sample_h; y++) {
		lua_rawgeti(L, 1, y + 1);
		size_t len;
		unsigned char *line = (unsigned char*)strdup(luaL_checklstring(L, -1, &len));
		for (int x = 0; x < len; x++) {
			config->sample.get(y, x) = line[x];
		}

		lua_pop(L, 1);
	}
	return config;
}

static void free_config_overlapping(WFCOverlapping *config) {
	delete config;
}

static void generate_table_from_output(lua_State *L, WFCOverlapping *config) {
	lua_newtable(L);
	printf("===========RESULT\n");
	char *buf = new char[config->output.width+1];
	for (int y = 0; y < config->output.height; y++) {
		for (int x = 0; x < config->output.width; x++) {
			printf("%c", config->output.get(y, x));
			buf[x] = config->output.get(y, x);
		}
		buf[config->output.width] = '\0';
		printf("\n");
		
		lua_pushlstring(L, buf, config->output.width);
		lua_rawseti(L, -2, y + 1);
	}
	delete[] buf;
	printf("===========\n");
}

static bool wfc_generate_overlapping(WFCOverlapping *config) {
	OverlappingWFCOptions options = {config->periodic_in, config->periodic_out, config->output.height, config->output.width, config->symmetry, config->has_foundation, config->n};
	OverlappingWFC<char> wfc(config->sample, options, gen_rand32());
	nonstd::optional<Array2D<char>> success = wfc.run();
	if (success.has_value()) {
		config->output.import(success.value());
		return true;
	} else {
		return false;
	}
}

static int lua_wfc_overlapping(lua_State *L) {
	WFCOverlapping *config = parse_config_overlapping(L);

	if (wfc_generate_overlapping(config)) {
		generate_table_from_output(L, config);
	} else {
		lua_pushnil(L);
	}

	// Cleanup
	free_config_overlapping(config);

	return 1;
}

static int thread_generate_overlapping(void *ptr) {
	WFCOverlapping *config = (WFCOverlapping*)ptr;
	if (wfc_generate_overlapping(config)) {
		return 1;
	} else {
		return 0;
	}
}

static int lua_wfc_overlapping_async(lua_State *L) {
	WFCOverlapping *config = parse_config_overlapping(L);

	SDL_Thread *thread = SDL_CreateThread(thread_generate_overlapping, "particles", config);

	WFCAsync *async = (WFCAsync*)lua_newuserdata(L, sizeof(WFCAsync));
	auxiliar_setclass(L, "wfc{async}", -1);
	async->mode = WFCAsyncMode::OVERLAPPING;
	async->overlapping_config = config;
	async->thread = thread;
	return 1;
}

static int lua_wfc_wait_all_async(lua_State *L) {
	return 0;
}

static int lua_wfc_wait_async(lua_State *L) {
	WFCAsync *async = (WFCAsync*)auxiliar_checkclass(L, "wfc{async}", 1);
	
	int ret;
	SDL_WaitThread(async->thread, &ret);
	
	if (async->mode == WFCAsyncMode::OVERLAPPING) {
		if (ret == 1) {
			generate_table_from_output(L, async->overlapping_config);
		} else {
			lua_pushnil(L);
		}
		// Cleanup
		free_config_overlapping(async->overlapping_config);
	}

	return 1;
}

static const struct luaL_Reg async_reg[] =
{
	{"wait", lua_wfc_wait_async},
	{NULL, NULL},
};

static const struct luaL_Reg wfclib[] =
{
	{"asyncOverlapping", lua_wfc_overlapping_async},
	{"asyncWaitAll", lua_wfc_wait_all_async},
	{"overlapping", lua_wfc_overlapping},
	{NULL, NULL},
};

int luaopen_wfc(lua_State *L) {
	auxiliar_newclass(L, "wfc{async}", async_reg);
	luaL_openlib(L, "core.generator.wfc", wfclib, 0);
	lua_settop(L, 0);
	return 1;
}
