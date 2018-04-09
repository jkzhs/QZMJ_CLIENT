using UnityEngine;
//using System;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework {
    public class AppConst {
        public const bool DebugMode = false;                        //调试模式-用于内部测试

        /// <summary>
        /// 如果想删掉框架自带的例子，那这个例子模式必须要
        /// 关闭，否则会出现一些错误。
        /// </summary>
        public const bool ExampleMode = true;                       //例子模式
        /// <summary>
        /// 如果开启更新模式，前提必须启动框架自带服务器端。
        /// 否则就需要自己将StreamingAssets里面的所有内容
        /// 复制到自己的Webserver上面，并修改下面的WebUrl。
        /// </summary>
        public const bool UpdateMode = true;                      //更新模式-默认关闭
        public const bool LuaByteMode = false;                     //Lua字节码模式-默认关闭
		public const bool LuaBundleMode = false;                   //Lua代码AssetBundle模式-默认关闭

        public const int TimerInterval = 1;
        public const int GameFrameRate = 30;                       //游戏帧频

        public const string AppName = "LuaFramework";               //应用程序名称
        public const string LuaTempDir = "Lua/";                    //临时目录
        public const string ExtName = ".unity3d";                   //资源扩展名
        public const string AppPrefix = AppName + "_";              //应用程序前缀

        // 拜手

		//版本包下载地址"http://121.43.166.110/ud/pack/"
        public const string WebUrl = "http://121.43.166.110/ud/pack/";      
		//下载网页
		public const string WebUrlDown = "http://www.vtv365.com/ud/down/";
		//版本号下载地址
        public const string WebUrlVersionCommon = "http://121.43.166.110/ud/version/";
        public const string WebUrlVersionAndroid = "http://121.43.166.110/ud/version/index_android.html";

        public static string UserId = string.Empty;                 //用户ID
        public static int SocketPort = 0;                           //Socket服务器端口
        public static string SocketAddress = string.Empty;          //Socket服务器地址

		// 参数配置
		public static string login_secret = "vDAXDcRbGXUn3pDI"; //登陆密匙

        public static string WebUrlVersion
        {
            get
            {
				string url = WebUrlVersionCommon;
                if (Application.platform == RuntimePlatform.Android)
                {
					url = WebUrlVersionAndroid;
                }
                else if (Application.platform == RuntimePlatform.IPhonePlayer)
                {
					url = WebUrlVersionCommon;
                }
                else if (Application.platform == RuntimePlatform.OSXEditor)
                {
					url = WebUrlVersionCommon;
                }
                else if (Application.platform == RuntimePlatform.WindowsEditor)
                {
					url = WebUrlVersionAndroid;
                }
                return url;
            }
        }

        public static string FrameworkRoot {
            get {
                return Application.dataPath + "/" + AppName;
            }
        }
    }
}