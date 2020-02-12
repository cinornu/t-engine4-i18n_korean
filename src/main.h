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
#ifndef _MAIN_H_
#define _MAIN_H_

#include "runner/core.h"

#if defined(SELFEXE_LINUX)
#define _te4_export
#elif defined(SELFEXE_WINDOWS)
#define _te4_export __declspec(dllexport)
#elif defined(SELFEXE_MACOSX)
#define _te4_export
#else
#define _te4_export
#endif

extern int resizeWindow(int width, int height);

/**
 * Will the requested do_resize call require a new window?
 */
extern bool resizeNeedsNewWindow(int w, int h, bool fullscreen, bool borderless);

/**
 * Move the window.  Handles both windowed and fullscreen window moves.
 */
void do_move(int w, int h);

/**
 * Handle a resolution change request.
 *
 * The three window modes supported are windowed, borderless windowed,
 * and fullscreen.  These three modes are mutually exclusive, with the
 * fullscreen flag taking priority over the borderless flag.
 */
extern void do_resize(int w, int h, bool fullscreen, bool borderless, float zoom);

typedef enum {
	redraw_type_normal,
	redraw_type_user_screenshot,
	redraw_type_savefile_screenshot
} redraw_type_t;

extern void redraw_now(redraw_type_t rtype);
extern redraw_type_t get_current_redraw_type(void);

extern void setupRealtime(float freq);
extern void setupDisplayTimer(int fps);
extern int docall (lua_State *L, int narg, int nret);
extern bool no_steam;
extern bool no_connectivity;
extern bool safe_mode;
extern bool fbo_active;
extern bool multitexture_active;
extern long total_keyframes;
extern bool anims_paused;
extern int frame_tick_paused_time;
extern int cur_frame_tick;
extern int g_argc;
extern char **g_argv;
extern char *override_home;
extern float screen_zoom;
extern bool forbid_idle_mode;

/* Error handling */
struct lua_err_type_s {
	char *err_msg;
	char *file;
	int line;
	char *func;
	struct lua_err_type_s *next;
};
typedef struct lua_err_type_s lua_err_type;
extern lua_err_type *last_lua_error_head, *last_lua_error_tail;
extern void del_lua_error();
extern core_boot_type *core_def;

extern void physfs_reset_dir_allowed(lua_State *L);
extern bool physfs_check_allow_path_read(lua_State *L, const char *path);
extern bool physfs_check_allow_path_write(lua_State *L, const char *path);

#ifdef STEAM_TE4
#include "steam-te4.h"
#endif

#endif

