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
#ifdef DISCORD_TE4

#include "display.h"
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include "auxiliar.h"
#include "physfs.h"
#include "core_lua.h"
#include "types.h"
#include "main.h"
#include "getself.h"
#include "te4web.h"
#include "web-external.h"
#include "discord-rpc/include/discord-rpc-dynlib.h"

#include <time.h>

/*
 * Grab stuff from the dynlib
 */
static bool discord_loaded = FALSE;

static void discord_load() {
	if (discord_loaded) return;

	char *libname = NULL;
	const char *self = get_self_executable(g_argc, g_argv);
#if defined(SELFEXE_LINUX) || defined(SELFEXE_BSD)
#if defined(TE4_RELPATH64)
	const char *name = "lib64/libdiscord-rpc.so";
	char *lib = malloc(strlen(self) + strlen(name) + 1);
	strcpy(lib, self);
	strcpy(strrchr(lib, '/') + 1, name);
	libname = lib;
	void *dynlib = SDL_LoadObject(lib);
#elif defined(TE4_RELPATH32)
	const char *name = "lib/libdiscord-rpc.so";
	char *lib = malloc(strlen(self) + strlen(name) + 1);
	strcpy(lib, self);
	strcpy(strrchr(lib, '/') + 1, name);
	libname = lib;
	void *dynlib = SDL_LoadObject(lib);
#else
	const char *name = "libdiscord-rpc.so";
	char *lib = malloc(strlen(self) + strlen(name) + 1);
	strcpy(lib, self);
	strcpy(strrchr(lib, '/') + 1, name);
	libname = lib;
	void *dynlib = SDL_LoadObject(lib);
#endif
#elif defined(SELFEXE_WINDOWS)
	const char *name = "discord-rpc.dll";
	char *lib = malloc(strlen(self) + strlen(name) + 1);
	strcpy(lib, self);
	strcpy(strrchr(lib, '\\') + 1, name);
	libname = lib;
	void *dynlib = SDL_LoadObject(lib);
#elif defined(SELFEXE_MACOSX)
	const char *name = "libdiscord-rpc.dylib";
	char *lib = malloc(strlen(self) + strlen(name) + 1);
	strcpy(lib, self);
	strcpy(lib+strlen(self), name);
	libname = lib;
	void *dynlib = SDL_LoadObject(lib);
#else
	void *dynlib = NULL;
#endif
	printf("Loading discord rpc: library(%s) => %s\n", libname ? libname : "--", dynlib ? "loaded" : SDL_GetError());
	if (!dynlib) return;

	discord_loaded = TRUE;
	Discord_Initialize = (void (*)(const char* applicationId, DiscordEventHandlers* handlers, int autoRegister, const char* optionalSteamId)) SDL_LoadFunction(dynlib, "Discord_Initialize");
	Discord_Shutdown = (void (*)(void)) SDL_LoadFunction(dynlib, "Discord_Shutdown");
	Discord_RunCallbacks = (void (*)(void)) SDL_LoadFunction(dynlib, "Discord_RunCallbacks");
	Discord_UpdatePresence = (void (*)(const DiscordRichPresence* presence)) SDL_LoadFunction(dynlib, "Discord_UpdatePresence");
}


static const char* APPLICATION_ID = "378483863044882443";

static time_t start_time;

static int lua_discord_update(lua_State *L)
{
	if (!lua_istable(L, 1)) {
		lua_pushstring(L, "Table required");
		lua_error(L);
		return 0;		
	}

	DiscordRichPresence discordPresence;
	memset(&discordPresence, 0, sizeof(discordPresence));

	lua_pushliteral(L, "state");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.state = lua_tostring(L, -1);
	lua_pop(L, 1);

	lua_pushliteral(L, "details");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.details = lua_tostring(L, -1);
	lua_pop(L, 1);

	lua_pushliteral(L, "large_image");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.largeImageKey = lua_tostring(L, -1);
	lua_pop(L, 1);

	lua_pushliteral(L, "small_image");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.smallImageKey = lua_tostring(L, -1);
	lua_pop(L, 1);

	lua_pushliteral(L, "large_image_text");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.largeImageText = lua_tostring(L, -1);
	lua_pop(L, 1);

	lua_pushliteral(L, "small_image_text");
	lua_gettable(L, -2);
	if (lua_isstring(L, -1)) discordPresence.smallImageText = lua_tostring(L, -1);
	lua_pop(L, 1);

	discordPresence.startTimestamp = start_time;

	printf("[Discord] updating state: \"%s\" / \"%s\" / %s / %s\n", discordPresence.state ? discordPresence.state : "--", discordPresence.details ? discordPresence.details : "--", discordPresence.largeImageKey ? discordPresence.largeImageKey : "--", discordPresence.smallImageKey ? discordPresence.smallImageKey : "--");

	// discordPresence.endTimestamp = time(0) + 5 * 60;
	// discordPresence.partyId = "party1234";
	// discordPresence.partySize = 1;
	// discordPresence.partyMax = 6;
	// discordPresence.instance = 0;
	Discord_UpdatePresence(&discordPresence);
	return 0;
}

static void handleDiscordReady() {
	printf("Discord: ready\n");
}

static void handleDiscordDisconnected(int errcode, const char* message) {
	printf("Discord: disconnected (%d: %s)\n", errcode, message);
}

static void handleDiscordError(int errcode, const char* message) {
	printf("Discord: error (%d: %s)\n", errcode, message);
}

static int lua_discord_init(lua_State *L) {
	DiscordEventHandlers handlers;
	memset(&handlers, 0, sizeof(handlers));
	handlers.ready = handleDiscordReady;
	handlers.disconnected = handleDiscordDisconnected;
	handlers.errored = handleDiscordError;
	handlers.joinGame = NULL;
	handlers.spectateGame = NULL;
	handlers.joinRequest = NULL;
	Discord_Initialize(APPLICATION_ID, &handlers, 1, "259680");
	return 0;
}

static const struct luaL_Reg discordlib[] = {
	{"init", lua_discord_init},
	{"updatePresence", lua_discord_update},
	{NULL, NULL},
};

int luaopen_discord(lua_State *L) {
	discord_load();
	if (!discord_loaded) return 0;

	start_time = time(0);
	luaL_openlib(L, "core.discord", discordlib, 0);

	lua_settop(L, 0);
	return 1;
}

void te4_discord_update() {
	if (!discord_loaded) return;
	Discord_RunCallbacks();
}

#endif
