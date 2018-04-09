﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class MicroPhoneInputWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(MicroPhoneInput), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("InitPhone", InitPhone);
		L.RegFunction("StartRecord", StartRecord);
		L.RegFunction("StopRecord", StopRecord);
		L.RegFunction("GetClipData", GetClipData);
		L.RegFunction("CompressBytes", CompressBytes);
		L.RegFunction("Decompress", Decompress);
		L.RegFunction("ByteToInt", ByteToInt);
		L.RegFunction("PlayClipData", PlayClipData);
		L.RegFunction("PlayRecord", PlayRecord);
		L.RegFunction("GetAveragedVolume", GetAveragedVolume);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("m_instance", get_m_instance, set_m_instance);
		L.RegVar("audio", get_audio, set_audio);
		L.RegVar("sensitivity", get_sensitivity, set_sensitivity);
		L.RegVar("loudness", get_loudness, set_loudness);
		L.RegVar("Device", get_Device, set_Device);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitPhone(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			obj.InitPhone();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartRecord(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			obj.StartRecord();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopRecord(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			obj.StopRecord();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClipData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			byte[] o = obj.GetClipData();
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CompressBytes(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			byte[] o = MicroPhoneInput.CompressBytes(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Decompress(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 1);
			byte[] o = MicroPhoneInput.Decompress(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ByteToInt(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			short[] o = obj.ByteToInt(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayClipData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			short[] arg0 = ToLua.CheckNumberArray<short>(L, 2);
			obj.PlayClipData(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayRecord(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			obj.PlayRecord();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetAveragedVolume(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 1);
			float o = obj.GetAveragedVolume();
			LuaDLL.lua_pushnumber(L, o);
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
	static int get_m_instance(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			MicroPhoneInput ret = obj.m_instance;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index m_instance on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_audio(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			UnityEngine.AudioSource ret = obj.audio;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index audio on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sensitivity(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			float ret = obj.sensitivity;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index sensitivity on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loudness(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			float ret = obj.loudness;
			LuaDLL.lua_pushnumber(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loudness on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Device(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			string ret = obj.Device;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Device on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_m_instance(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			MicroPhoneInput arg0 = (MicroPhoneInput)ToLua.CheckObject<MicroPhoneInput>(L, 2);
			obj.m_instance = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index m_instance on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_audio(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			UnityEngine.AudioSource arg0 = (UnityEngine.AudioSource)ToLua.CheckObject(L, 2, typeof(UnityEngine.AudioSource));
			obj.audio = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index audio on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_sensitivity(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.sensitivity = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index sensitivity on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loudness(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			float arg0 = (float)LuaDLL.luaL_checknumber(L, 2);
			obj.loudness = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loudness on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Device(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			MicroPhoneInput obj = (MicroPhoneInput)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.Device = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index Device on a nil value");
		}
	}
}

