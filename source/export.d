import lua;
import lauxlib;

extern(C) export:
int open_dll(lua_State* L)
{
	lua_register(L, cast(char*)"square", &square);
	return 0;
}

//以下登録用
int square(lua_State* L)
{
	double x = luaL_checknumber(L, 1);
	lua_pushnumber(L, x * x);
	return 1;
}
