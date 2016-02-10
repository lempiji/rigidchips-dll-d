/*
** $Id: lauxlib.h,v 1.60 2003/04/03 13:35:34 roberto Exp $
** Auxiliary functions for building Lua libraries
** See Copyright Notice in lua.h
*/
module lauxlib;

import core.stdc.stdio : BUFSIZ;
import lua;

extern (C):

struct luaL_reg {
  char* name;
  lua_CFunction func;
}


void luaL_openlib(lua_State* L, char* libname, luaL_reg* l, int nup);
int luaL_getmetafield(lua_State* L, int obj, char* e);
int luaL_callmeta(lua_State* L, int obj, char* e);
int luaL_typerror(lua_State* L, int narg, char* tname);
int luaL_argerror(lua_State* L, int numarg, char* extramsg);
char* luaL_checklstring(lua_State* L, int numArg, size_t* l);
char* luaL_optlstring(lua_State* L, int numArg, char* def, size_t* l);
lua_Number luaL_checknumber(lua_State* L, int numArg);
lua_Number luaL_optnumber(lua_State* L, int nArg, lua_Number def);

void luaL_checkstack(lua_State* L, int sz, char* msg);
void luaL_checktype(lua_State* L, int narg, int t);
void luaL_checkany(lua_State* L, int narg);

int   luaL_newmetatable(lua_State* L, char* tname);
void  luaL_getmetatable(lua_State* L, char* tname);
void* luaL_checkudata(lua_State* L, int ud, char* tname);

void luaL_where(lua_State* L, int lvl);
int luaL_error(lua_State* L, char* fmt, ...);

int luaL_findstring(char* st, char** lst);

int luaL_ref(lua_State* L, int t);
void luaL_unref(lua_State* L, int t, int ref_);

int luaL_getn(lua_State* L, int t);
void luaL_setn(lua_State* L, int t, int n);

int luaL_loadfile(lua_State* L, char* filename);
int luaL_loadbuffer(lua_State* L, char* buff, int sz, char* name);


/*
** ===============================================================
** some useful macros
** ===============================================================
*/

alias luaL_argcheck = (L, cond, numarg, extramsg) { if(!(cond)) luaL_argerror(L, numarg, extramsg); };

alias luaL_checkstring = (L,n) => (luaL_checklstring(L, (n), null));
alias luaL_optstring = (L,n,d) => (luaL_optlstring(L, (n), (d), null));
alias luaL_checkint = (L,n) => (cast(int)luaL_checknumber(L, n));
alias luaL_checklong = (L,n) => (cast(long)luaL_checknumber(L, n));
alias luaL_optint = (L,n,d) => (cast(int)luaL_optnumber(L, n, cast(lua_Number)(d)));
alias luaL_optlong = (L,n,d) => (cast(long)luaL_optnumber(L, n, cast(lua_Number)(d)));


/*
** {======================================================
** Generic Buffer manipulation
** =======================================================
*/

alias LUAL_BUFFERSIZE = BUFSIZ;

struct luaL_Buffer {
    char* p;			/* current position in buffer */
    int lvl;  /* number of strings in the stack (level) */
    lua_State* L;
    char[LUAL_BUFFERSIZE] buffer;
};

alias luaL_putchar = (B,c) => (cast(void)(B.p < (B.buffer+LUAL_BUFFERSIZE) || luaL_prepbuffer(B)), (B.p++ = cast(char)(c)));

alias luaL_addsize = (B, n) => (B.p += (n));

void luaL_buffinit(lua_State* L, luaL_Buffer* B);
char* luaL_prepbuffer(luaL_Buffer* B);
void luaL_addlstring(luaL_Buffer* B, char* s, size_t l);
void luaL_addstring(luaL_Buffer* B, char* s);
void luaL_addvalue(luaL_Buffer* B);
void luaL_pushresult(luaL_Buffer* B);


/* }====================================================== */



/*
** Compatibility macros and functions
*/

int   lua_dofile(lua_State* L, char* filename);
int   lua_dostring(lua_State* L, char* str);
int   lua_dobuffer(lua_State* L, char* buff, size_t sz, char* n);

alias luaL_check_lstr = luaL_checklstring;
alias luaL_opt_lstr = luaL_optlstring;
alias luaL_check_number = luaL_checknumber;
alias luaL_opt_number = luaL_optnumber;
alias luaL_arg_check = luaL_argcheck;
alias luaL_check_string = luaL_checkstring;
alias luaL_opt_string = luaL_optstring;
alias luaL_check_int = luaL_checkint;
alias luaL_check_long = luaL_checklong;
alias luaL_opt_int = luaL_optint;
alias luaL_opt_long = luaL_optlong;
