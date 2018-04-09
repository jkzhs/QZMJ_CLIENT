﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_SoundManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.SoundManager), typeof(Manager));
		L.RegFunction("PlayBackSound", PlayBackSound);
		L.RegFunction("StopBackSound", StopBackSound);
		L.RegFunction("PauseBackSound", PauseBackSound);
		L.RegFunction("PlayMusic", PlayMusic);
		L.RegFunction("PlaySound", PlaySound);
		L.RegFunction("setBackSoundVolmn", setBackSoundVolmn);
		L.RegFunction("setSoundVolmn", setSoundVolmn);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("initialize", get_initialize, set_initialize);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayBackSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.PlayBackSound(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopBackSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			obj.StopBackSound();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PauseBackSound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			obj.PauseBackSound();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayMusic(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			obj.PlayMusic();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlaySound(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.PlaySound(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setBackSoundVolmn(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.setBackSoundVolmn(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int setSoundVolmn(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)ToLua.CheckObject<LuaFramework.SoundManager>(L, 1);
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.setSoundVolmn(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_initialize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)o;
			bool ret = obj.initialize;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialize on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_initialize(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.SoundManager obj = (LuaFramework.SoundManager)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.initialize = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index initialize on a nil value");
		}
	}
}

