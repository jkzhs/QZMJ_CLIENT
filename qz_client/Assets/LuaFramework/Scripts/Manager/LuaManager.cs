using UnityEngine;
using System.Collections;
using System;
using LuaInterface;

namespace LuaFramework {
    public class LuaManager : Manager {
        private LuaState lua;
        private LuaLoader loader;
        private LuaLooper loop = null;
        public bool IsLoading = false;
        // Use this for initialization
        void Awake()
        {
            loader = new LuaLoader();
            lua = new LuaState();
            this.OpenLibs();
            lua.LuaSetTop(0);

            LuaBinder.Bind(lua);
            DelegateFactory.Init(); 
            LuaCoroutine.Register(lua, this);
            IsLoading = true;
        }

        public void InitStart() {
            InitLuaPath();
            InitLuaBundle();
            this.lua.Start();    //启动LUAVM
            this.StartMain();
            this.StartLooper();
        }

        void StartLooper() {
            loop = gameObject.AddComponent<LuaLooper>();
            loop.luaState = lua;
        }

        //cjson 比较特殊，只new了一个table，没有注册库，这里注册一下
        protected void OpenCJson() {
            lua.LuaGetField(LuaIndexes.LUA_REGISTRYINDEX, "_LOADED");
            lua.OpenLibs(LuaDLL.luaopen_cjson);
            lua.LuaSetField(-2, "cjson");

            lua.OpenLibs(LuaDLL.luaopen_cjson_safe);
            lua.LuaSetField(-2, "cjson.safe");
        }

        void StartMain() {
            lua.DoFile("main_game.lua");
            /*LuaFunction main = lua.GetFunction("Main");
            main.Call();
            main.Dispose();
            main = null;    */
        }
        /// <summary>
        /// 初始化加载第三方库
        /// </summary>
		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
		static int LuaOpen_Socket_Core(IntPtr L)
		{        
			return LuaDLL.luaopen_socket_core(L);
		}

		[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
		static int LuaOpen_Mime_Core(IntPtr L)
		{
			return LuaDLL.luaopen_mime_core(L);
		}
        void OpenLibs() {
            lua.OpenLibs(LuaDLL.luaopen_pb);      
            lua.OpenLibs(LuaDLL.luaopen_sproto_core);
            lua.OpenLibs(LuaDLL.luaopen_protobuf_c);
            lua.OpenLibs(LuaDLL.luaopen_lpeg);
            lua.OpenLibs(LuaDLL.luaopen_bit);
//            lua.OpenLibs(LuaDLL.luaopen_socket_core);
			lua.OpenLibs(LuaDLL.luaopen_crypt);

			lua.BeginPreLoad();
			lua.RegFunction("socket.core", LuaOpen_Socket_Core);
			lua.RegFunction("mime.core", LuaOpen_Mime_Core);                     
			lua.EndPreLoad(); 

            this.OpenCJson();
        }

        /// <summary>
        /// 初始化Lua代码加载路径
        /// </summary>
        void InitLuaPath() {
            if (AppConst.DebugMode) {
                string rootPath = AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "/Lua");
                lua.AddSearchPath(rootPath + "/ToLua/Lua");
            } else {
				// by wsp
				// 读文件模式这里加入自定义目录的地址
				/*string rootPath = AppConst.FrameworkRoot;
                lua.AddSearchPath(rootPath + "/Lua");
                lua.AddSearchPath(rootPath + "/ToLua/Lua");
				lua.AddSearchPath(rootPath + "/game/src");*/
                lua.AddSearchPath(Util.DataPath + "game/src");
                lua.AddSearchPath(Util.DataPath + "lua");
            }
        }

        /// <summary>
        /// 初始化LuaBundle
        /// </summary>
        void InitLuaBundle() {
            if (loader.beZip) {
                loader.AddBundle("game.unity3d", "game/");
                loader.AddBundle("game_src.unity3d", "game/");
                loader.AddBundle("game_src_app_common.unity3d", "game/");
                loader.AddBundle("game_src_app_common_queue.unity3d", "game/");
                loader.AddBundle("game_src_app_conf_mgr.unity3d", "game/");
                loader.AddBundle("game_src_app_etc.unity3d", "game/");
                loader.AddBundle("game_src_app_etc_ox.unity3d", "game/");
                loader.AddBundle("game_src_app_mgr.unity3d", "game/");
                loader.AddBundle("game_src_app_net.unity3d", "game/");
                loader.AddBundle("game_src_app_service.unity3d", "game/");
                loader.AddBundle("game_src_controller.unity3d", "game/");
                loader.AddBundle("game_src_easy.unity3d", "game/");
                loader.AddBundle("game_src_easy_components.unity3d", "game/");
                loader.AddBundle("game_src_easy_net.unity3d", "game/");
                loader.AddBundle("game_src_easy_scene.unity3d", "game/");
                loader.AddBundle("game_src_lib.unity3d", "game/");
                loader.AddBundle("game_src_logic.unity3d", "game/");
                loader.AddBundle("game_src_platform.unity3d", "game/");
                loader.AddBundle("game_src_sys.unity3d", "game/");
                loader.AddBundle("game_src_unity.unity3d", "game/");
                loader.AddBundle("game_src_view.unity3d", "game/");

                loader.AddBundle("lua.unity3d","lua/");
                loader.AddBundle("lua_cjson.unity3d", "lua/");
                loader.AddBundle("lua_jit.unity3d", "lua/");
                loader.AddBundle("lua_lpeg.unity3d", "lua/");
                loader.AddBundle("lua_misc.unity3d", "lua/");
                loader.AddBundle("lua_socket.unity3d", "lua/");
                loader.AddBundle("lua_system.unity3d", "lua/");
                loader.AddBundle("lua_system_reflection.unity3d", "lua/");
                loader.AddBundle("lua_unityengine.unity3d", "lua/");

                loader.AddBundle("lua_protobuf.unity3d", "lua/");
                loader.AddBundle("lua_3rd_cjson.unity3d", "lua/");
                loader.AddBundle("lua_3rd_luabitop.unity3d", "lua/");
                loader.AddBundle("lua_3rd_pbc.unity3d", "lua/");
                loader.AddBundle("lua_3rd_pblua.unity3d", "lua/");
                loader.AddBundle("lua_3rd_sproto.unity3d", "lua/");
            }
        }

        public object[] DoFile(string filename) {
            return lua.DoFile(filename);
        }

        // Update is called once per frame
        public object[] CallFunction(string funcName, params object[] args) {
            LuaFunction func = lua.GetFunction(funcName);
            if (func != null) {
                return func.LazyCall(args);
            }
            return null;
        }

        public void LuaGC() {
            if (lua != null)
            {
                lua.LuaGC(LuaGCOptions.LUA_GCCOLLECT);
            }
        }

        public void Close() {
            loop.Destroy();
            loop = null;
            lua.Dispose();
            lua = null;
            loader = null;
        }
    }
}