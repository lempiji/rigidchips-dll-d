/*
** $Id: lua.h,v 1.175c 2003/03/18 12:31:39 roberto Exp $
** Lua - An Extensible Extension Language
** Tecgraf: Computer Graphics Technology Group, PUC-Rio, Brazil
** http://www.lua.org	mailto:info@lua.org
** See Copyright Notice at the end of this file
*/
module lua;

import core.stdc.stdarg;

enum LUA_VERSION = "Lua 5.0.3";
enum LUA_COPYRIGHT = "Copyright (C) 1994-2006 Tecgraf, PUC-Rio";
enum LUA_AUTHORS = "R. Ierusalimschy, L. H. de Figueiredo & W. Celes";



/* option for multiple returns in `lua_pcall' and `lua_call' */
enum LUA_MULTRET = -1;

/*
** pseudo-indices
*/
enum LUA_REGISTRYINDEX = -10000;
enum LUA_GLOBALSINDEX = -10001;
alias lua_upvalueindex = (i) => (LUA_GLOBALSINDEX-(i));


/* error codes for `lua_load' and `lua_pcall' */
enum LUA_ERRRUN = 1;
enum LUA_ERRFILE = 2;
enum LUA_ERRSYNTAX = 3;
enum LUA_ERRMEM = 4;
enum LUA_ERRERR = 5;

//C    typedef struct lua_State lua_State;
extern struct lua_State;

extern (C):

alias lua_CFunction = int function(lua_State *L);


/*
** functions that read/write blocks when loading/dumping Lua chunks
*/
alias lua_Chunkreader = char* function(lua_State* L, void* ud, int* sz);
alias lua_Chunkwriter = int function(lua_State *L, void *p, int sz, void* ud);


/*
** basic types
*/
enum
{
    LUA_TNONE = -1,
    LUA_TNIL = 0,
    LUA_TBOOLEAN = 1,
    LUA_TLIGHTUSERDATA = 2,
    LUA_TNUMBER = 3,
    LUA_TSTRING = 4,
    LUA_TTABLE = 5,
    LUA_TFUNCTION = 6,
    LUA_TUSERDATA = 7,
    LUA_TTHREAD = 8,
}

/* minimum Lua stack available to a C function */
enum LUA_MINSTACK = 20;


/* type of numbers in Lua */
alias double lua_Number;


/*
** state manipulation
*/
lua_State* lua_open();
void  lua_close(lua_State* L);
lua_State * lua_newthread(lua_State* L);

lua_CFunction  lua_atpanic(lua_State* L, lua_CFunction panicf);


/*
** basic stack manipulation
*/
int lua_gettop(lua_State* L);
void lua_settop(lua_State* L, int idx);
void lua_pushvalue(lua_State* L, int idx);
void lua_remove(lua_State* L, int idx);
void lua_insert(lua_State* L, int idx);
void lua_replace(lua_State* L, int idx);
int lua_checkstack(lua_State* L, int sz);

void lua_xmove(lua_State* from, lua_State* to, int n);


/*
** access functions (stack -> C)
*/
int lua_isnumber(lua_State* L, int idx);
int lua_isstring(lua_State* L, int idx);
int lua_iscfunction(lua_State* L, int idx);
int lua_isuserdata(lua_State* L, int idx);
int lua_type(lua_State* L, int idx);
char* lua_typename(lua_State* L, int tp);

int lua_equal(lua_State* L, int idx1, int idx2);
int lua_rawequal(lua_State* L, int idx1, int idx2);
int lua_lessthan(lua_State* L, int idx1, int idx2);

lua_Number lua_tonumber(lua_State* L, int idx);
int lua_toboolean(lua_State* L, int idx);
char* lua_tostring(lua_State* L, int idx);
int lua_strlen (lua_State* L, int idx);
lua_CFunction lua_tocfunction(lua_State* L, int idx);
void* lua_touserdata(lua_State* L, int idx);
lua_State* lua_tothread(lua_State* L, int idx);
void* lua_topointer(lua_State* L, int idx);


/*
** push functions (C -> stack)
*/
void lua_pushnil(lua_State* L);
void lua_pushnumber(lua_State* L, lua_Number n);
void lua_pushlstring(lua_State* L, char* s, int l);
void lua_pushstring(lua_State* L, char* s);
char* lua_pushvfstring(lua_State* L, char* fmt, va_list argp);

char* lua_pushfstring (lua_State* L, char *fmt, ...);
void  lua_pushcclosure (lua_State *L, lua_CFunction fn, int n);
void  lua_pushboolean (lua_State *L, int b);
void  lua_pushlightuserdata (lua_State *L, void *p);


/*
** get functions (Lua -> stack)
*/
void  lua_gettable (lua_State* L, int idx);
void  lua_rawget (lua_State* L, int idx);
void  lua_rawgeti (lua_State* L, int idx, int n);
void  lua_newtable (lua_State* L);
void* lua_newuserdata (lua_State* L, int sz);
int   lua_getmetatable (lua_State* L, int objindex);
void  lua_getfenv (lua_State* L, int idx);


/*
** set functions (stack -> Lua)
*/
void  lua_settable (lua_State* L, int idx);
void  lua_rawset (lua_State* L, int idx);
void  lua_rawseti (lua_State* L, int idx, int n);
int   lua_setmetatable (lua_State* L, int objindex);
int   lua_setfenv (lua_State* L, int idx);


/*
** `load' and `call' functions (load and run Lua code)
*/
void  lua_call (lua_State* L, int nargs, int nresults);
int   lua_pcall (lua_State* L, int nargs, int nresults, int errfunc);
int lua_cpcall (lua_State* L, lua_CFunction func, void* ud);
int   lua_load (lua_State* L, lua_Chunkreader reader, void* dt, char* chunkname);

int lua_dump (lua_State* L, lua_Chunkwriter writer, void* data);


/*
** coroutine functions
*/
int  lua_yield (lua_State* L, int nresults);
int  lua_resume (lua_State* L, int narg);

/*
** garbage-collection functions
*/
int   lua_getgcthreshold (lua_State* L);
int   lua_getgccount (lua_State* L);
void  lua_setgcthreshold (lua_State* L, int newthreshold);

/*
** miscellaneous functions
*/

char* lua_version ();

int   lua_error (lua_State* L);

int   lua_next (lua_State* L, int idx);

void  lua_concat (lua_State* L, int n);



/*
** ===============================================================
** some useful macros
** ===============================================================
*/

alias lua_boxpointer = (L,u) => (*cast(void**)(lua_newuserdata(L, (void*).sizeof)) = (u));

alias lua_unboxpointer = (L,i) => (*cast(void**)(lua_touserdata(L, i)));

alias lua_pop = (L,n) => lua_settop(L, -(n)-1);

alias lua_register = (L, n, f) => (lua_pushstring(L, n), lua_pushcfunction(L, f), lua_settable(L, LUA_GLOBALSINDEX));

alias lua_pushcfunction = (L,f) => lua_pushcclosure(L, f, 0);

alias lua_isfunction = (L,n) => (lua_type(L,n) == LUA_TFUNCTION);
alias lua_istable = (L,n) => (lua_type(L,n) == LUA_TTABLE);
alias lua_islightuserdata = (L,n) => (lua_type(L,n) == LUA_TLIGHTUSERDATA);
alias lua_isnil = (L,n) => (lua_type(L,n) == LUA_TNIL);
alias lua_isboolean = (L,n) => (lua_type(L,n) == LUA_TBOOLEAN);
alias lua_isnone = (L,n) => (lua_type(L,n) == LUA_TNONE);
alias lua_isnoneornil = (L, n) => (lua_type(L,n) <= 0);

alias lua_pushliteral = (L, s) => lua_pushlstring(L, "".ptr, (typeof(s).sizeof / chat.sizeof)-1);



/*
** compatibility macros and functions
*/


int lua_pushupvalues (lua_State* L);

alias lua_getregistry = (L) => lua_pushvalue(L, LUA_REGISTRYINDEX);
alias lua_setglobal = (L,s) => (lua_pushstring(L, s), lua_insert(L, -2), lua_settable(L, LUA_GLOBALSINDEX));

alias lua_getglobal = (L,s) => (lua_pushstring(L, s), lua_gettable(L, LUA_GLOBALSINDEX));


/* compatibility with ref system */

/* pre-defined references */
enum
{
    LUA_NOREF = -2,
    LUA_REFNIL = -1,
}

alias lua_ref = (L,lock) => ((lock) ? luaL_ref(L, LUA_REGISTRYINDEX) : (lua_pushstring(L, cast(char*)"unlocked references are obsolete"), lua_error(L), 0));
alias lua_unref = (L,ref_) => luaL_unref(L, LUA_REGISTRYINDEX, (ref_));
alias lua_getref = (L,ref_) => lua_rawgeti(L, LUA_REGISTRYINDEX, ref_);


/*
** {======================================================================
** useful definitions for Lua kernel and libraries
** =======================================================================
*/

/* formats for Lua numbers */
enum LUA_NUMBER_SCAN = "%lf";
enum LUA_NUMBER_FMT = "%.14g";

/* }====================================================================== */


/*
** {======================================================================
** Debug API
** =======================================================================
*/


/*
** Event codes
*/
enum
{
    LUA_HOOKCALL = 0,
    LUA_HOOKRET = 1,
    LUA_HOOKLINE = 2,
    LUA_HOOKCOUNT = 3,
    LUA_HOOKTAILRET = 4,
}


/*
** Event masks
*/
enum
{
    LUA_MASKCALL = (1 << LUA_HOOKCALL),
    LUA_MASKRET = (1 << LUA_HOOKRET),
    LUA_MASKLINE = (1 << LUA_HOOKLINE),
    LUA_MASKCOUNT = (1 << LUA_HOOKCOUNT),
}

//typedef struct lua_Debug lua_Debug;  /* activation record */

alias lua_Hook = void function(lua_State* L, lua_Debug* ar);


int lua_getstack (lua_State* L, int level, lua_Debug* ar);
int lua_getinfo (lua_State* L, char* what, lua_Debug* ar);
char* lua_getlocal (lua_State* L, lua_Debug* ar, int n);
char* lua_setlocal (lua_State* L, lua_Debug* ar, int n);
char* lua_getupvalue (lua_State* L, int funcindex, int n);
char* lua_setupvalue (lua_State* L, int funcindex, int n);

int lua_sethook (lua_State* L, lua_Hook func, int mask, int count);
lua_Hook lua_gethook (lua_State* L);
int lua_gethookmask (lua_State* L);
int lua_gethookcount (lua_State* L);


enum LUA_IDSIZE = 60;

struct lua_Debug {
    int event;
    char* name;	/* (n) */
    char* namewhat;	/* (n) `global', `local', `field', `method' */
    char* what;	/* (S) `Lua', `C', `main', `tail' */
    char* source;	/* (S) */
    int currentline;	/* (l) */
    int nups;		/* (u) number of upvalues */
    int linedefined;	/* (S) */
    char[LUA_IDSIZE] short_src; /* (S) */
    /* private part */
    int i_ci;  /* active function */
};

/* }====================================================================== */


/******************************************************************************
* Copyright (C) 1994-2006 Tecgraf, PUC-Rio.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining
* a copy of this software and associated documentation files (the
* "Software"), to deal in the Software without restriction, including
* without limitation the rights to use, copy, modify, merge, publish,
* distribute, sublicense, and/or sell copies of the Software, and to
* permit persons to whom the Software is furnished to do so, subject to
* the following conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
* IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
* CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
* TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
* SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
******************************************************************************/
