﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class LuaFramework_GameManagerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(LuaFramework.GameManager), typeof(Manager));
		L.RegFunction("startUp", startUp);
		L.RegFunction("StartLoadUpdate", StartLoadUpdate);
		L.RegFunction("GetFileSize", GetFileSize);
		L.RegFunction("CountSize", CountSize);
		L.RegFunction("startAnimEnd", startAnimEnd);
		L.RegFunction("CheckExtractResource", CheckExtractResource);
		L.RegFunction("resertUpdate", resertUpdate);
		L.RegFunction("getApplicationVer", getApplicationVer);
		L.RegFunction("openLogin", openLogin);
		L.RegFunction("updateLoadPos", updateLoadPos);
		L.RegFunction("OnResourceInited", OnResourceInited);
		L.RegFunction("login_sdk", login_sdk);
		L.RegFunction("pay", pay);
		L.RegFunction("share_msg", share_msg);
		L.RegFunction("is_WXAppInstalled", is_WXAppInstalled);
		L.RegFunction("is_WXAppSupportApi", is_WXAppSupportApi);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("fpsMeasuringDelta", get_fpsMeasuringDelta, set_fpsMeasuringDelta);
		L.RegVar("luaf_login_sdk_cb", get_luaf_login_sdk_cb, set_luaf_login_sdk_cb);
		L.RegVar("luaf_pay_cb", get_luaf_pay_cb, set_luaf_pay_cb);
		L.RegVar("loadIndex", get_loadIndex, set_loadIndex);
		L.RegVar("loadCount", get_loadCount, set_loadCount);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int startUp(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.startUp();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartLoadUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.StartLoadUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetFileSize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			long o = LuaFramework.GameManager.GetFileSize(arg0);
			LuaDLL.tolua_pushint64(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CountSize(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			long arg0 = LuaDLL.tolua_checkint64(L, 1);
			string o = LuaFramework.GameManager.CountSize(arg0);
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int startAnimEnd(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.startAnimEnd();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckExtractResource(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.CheckExtractResource();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int resertUpdate(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.resertUpdate();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getApplicationVer(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			string o = obj.getApplicationVer();
			LuaDLL.lua_pushstring(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int openLogin(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.openLogin();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int updateLoadPos(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			obj.updateLoadPos(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnResourceInited(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			obj.OnResourceInited();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int login_sdk(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			obj.login_sdk(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int pay(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 5);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			string arg0 = ToLua.CheckString(L, 2);
			int arg1 = (int)LuaDLL.luaL_checknumber(L, 3);
			string arg2 = ToLua.CheckString(L, 4);
			LuaFunction arg3 = ToLua.CheckLuaFunction(L, 5);
			obj.pay(arg0, arg1, arg2, arg3);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int share_msg(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 6);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			string arg1 = ToLua.CheckString(L, 3);
			string arg2 = ToLua.CheckString(L, 4);
			string arg3 = ToLua.CheckString(L, 5);
			string arg4 = ToLua.CheckString(L, 6);
			obj.share_msg(arg0, arg1, arg2, arg3, arg4);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int is_WXAppInstalled(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			bool o = obj.is_WXAppInstalled();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int is_WXAppSupportApi(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)ToLua.CheckObject<LuaFramework.GameManager>(L, 1);
			bool o = obj.is_WXAppSupportApi();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
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
	static int get_fpsMeasuringDelta(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			float ret = obj.fpsMeasuringDelta;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fpsMeasuringDelta on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_luaf_login_sdk_cb(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			LuaInterface.LuaFunction ret = obj.luaf_login_sdk_cb;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index luaf_login_sdk_cb on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_luaf_pay_cb(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			LuaInterface.LuaFunction ret = obj.luaf_pay_cb;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index luaf_pay_cb on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loadIndex(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			int ret = obj.loadIndex;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loadIndex on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loadCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			int ret = obj.loadCount;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loadCount on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fpsMeasuringDelta(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.fpsMeasuringDelta = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index fpsMeasuringDelta on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_luaf_login_sdk_cb(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			obj.luaf_login_sdk_cb = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index luaf_login_sdk_cb on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_luaf_pay_cb(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			obj.luaf_pay_cb = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index luaf_pay_cb on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loadIndex(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.loadIndex = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loadIndex on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loadCount(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			LuaFramework.GameManager obj = (LuaFramework.GameManager)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.loadCount = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loadCount on a nil value");
		}
	}
}
