﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class VoiceChatPlayerWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(VoiceChatPlayer), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("StartRecording", StartRecording);
		L.RegFunction("StopRecording", StopRecording);
		L.RegFunction("addCacheDataByte", addCacheDataByte);
		L.RegFunction("PlayRecording", PlayRecording);
		L.RegFunction("Stop", Stop);
		L.RegFunction("getSendAllData", getSendAllData);
		L.RegFunction("OnNewSample", OnNewSample);
		L.RegFunction("VoiceAuth", VoiceAuth);
		L.RegFunction("SaveVoice", SaveVoice);
		L.RegFunction("LoadVoice", LoadVoice);
		L.RegFunction("DeleteVoice", DeleteVoice);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegConstant("compressLen", 150);
		L.RegVar("onSendVoice", get_onSendVoice, set_onSendVoice);
		L.RegVar("onCommitVoice", get_onCommitVoice, set_onCommitVoice);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartRecording(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			obj.StartRecording();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StopRecording(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			obj.StopRecording();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int addCacheDataByte(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			byte[] arg0 = ToLua.CheckByteBuffer(L, 2);
			obj.addCacheDataByte(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PlayRecording(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.PlayRecording(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Stop(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			obj.Stop();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getSendAllData(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			obj.getSendAllData();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnNewSample(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			VoiceChatPlayer obj = (VoiceChatPlayer)ToLua.CheckObject<VoiceChatPlayer>(L, 1);
			VoiceChat.VoiceChatPacket arg0 = StackTraits<VoiceChat.VoiceChatPacket>.Check(L, 2);
			obj.OnNewSample(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int VoiceAuth(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 0);
			bool o = VoiceChatPlayer.VoiceAuth();
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SaveVoice(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 3);
			string arg0 = ToLua.CheckString(L, 1);
			byte[] arg1 = ToLua.CheckByteBuffer(L, 2);
			bool arg2 = LuaDLL.luaL_checkboolean(L, 3);
			VoiceChatPlayer.SaveVoice(arg0, arg1, arg2);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadVoice(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			byte[] o = VoiceChatPlayer.LoadVoice(arg0);
			ToLua.Push(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DeleteVoice(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			string arg0 = ToLua.CheckString(L, 1);
			VoiceChatPlayer.DeleteVoice(arg0);
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
	static int get_onSendVoice(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)o;
			System.Action<int,byte[]> ret = obj.onSendVoice;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onSendVoice on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onCommitVoice(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)o;
			System.Action ret = obj.onCommitVoice;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onCommitVoice on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onSendVoice(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)o;
			System.Action<int,byte[]> arg0 = (System.Action<int,byte[]>)ToLua.CheckDelegate<System.Action<int,byte[]>>(L, 2);
			obj.onSendVoice = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onSendVoice on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onCommitVoice(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			VoiceChatPlayer obj = (VoiceChatPlayer)o;
			System.Action arg0 = (System.Action)ToLua.CheckDelegate<System.Action>(L, 2);
			obj.onCommitVoice = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index onCommitVoice on a nil value");
		}
	}
}

