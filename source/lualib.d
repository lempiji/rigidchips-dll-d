// ----------------------------------------------------------
// v0.91
// http://www.neuropolis.org/project/lua_from_d/
// Converted from lua.h by lunakid@neuropolis.org
// Thanks to Shinichiro Hamaji for bug-fixes!
//
module lualib;

import lua;

const char* LUA_COLIBNAME   = "coroutine";
const char* LUA_TABLIBNAME  = "table";
const char* LUA_IOLIBNAME   = "io";
const char* LUA_OSLIBNAME   = "os";
const char* LUA_STRLIBNAME  = "string";
const char* LUA_MATHLIBNAME = "math";
const char* LUA_DBLIBNAME   = "debug";

extern (C)
{
int	luaopen_base(lua_State* L);
int	luaopen_io(lua_State* L);
int	luaopen_table(lua_State* L);
int	luaopen_string(lua_State* L);
int	luaopen_math(lua_State* L);
int	luaopen_debug(lua_State* L);
int	luaopen_loadlib(lua_State* L);
}

/* compatibility code */
alias	luaopen_base    lua_baselibopen;
alias	luaopen_table   lua_tablibopen;
alias	luaopen_io      lua_iolibopen;
alias	luaopen_string  lua_strlibopen;
alias	luaopen_math    lua_mathlibopen;
alias	luaopen_debug   lua_dblibopen;
