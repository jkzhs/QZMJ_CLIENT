using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using System.Runtime.InteropServices;

namespace LuaFramework {
    public class GameManager : Manager {
        protected static bool initialize = false;
        private List<string> downloadFiles = new List<string>();
        string Str;
        Vector2 v2;
        bool IsShow;
        public float fpsMeasuringDelta = 0.2f;
		public LuaFunction luaf_login_sdk_cb;
		public LuaFunction luaf_pay_cb;

        private float timePassed;
        private int m_FrameCount = 0;
        private float m_FPS = 0.0f;

        /// <summary>
        /// 初始化游戏管理器
        /// </summary>
        void Awake() {
            initialize = false;
            showLoadAnim();
            if (AppFacade.Instance.IsUpdate)
            {
                startUp();
            }else
            {
                Init();
            }
            /*Str = "";
            v2 = Vector2.zero;
            IsShow = true;
            timePassed = 0.0f;*/
        }

        public void startUp()
        {
            StartCoroutine(getUpdateVersion());
        }
        /*void OnEnable()
        {
#if UNITY_5
            Application.logMessageReceived += logCallBack;
#else
            Application.RegisterLogCallback(HandleLog);
#endif
        }

        void logCallBack(string logString, string stackTrace, LogType type)
        {
            IsShow = true;
            if (type == LogType.Log)
            {
            }
            else if (type == LogType.Error || type == LogType.Exception)
            {
                Str += logString + "\n" + stackTrace + "\n";
            }
            else
            {
            }
        }

        void OnGUI()
        {
            if (IsShow)
            {
                v2 = GUILayout.BeginScrollView(v2, GUILayout.MinWidth(Screen.width - 5), GUILayout.MaxHeight(400));
                GUILayout.TextArea(Str, GUILayout.MinWidth(Screen.width - 100));
                GUILayout.EndScrollView();
            }
            GUIStyle bb = new GUIStyle();
            bb.normal.background = null;    //这是设置背景填充的
            bb.normal.textColor = new Color(1.0f, 0.5f, 0.0f);   //设置字体颜色的
            bb.fontSize = 20;       //当然，这是字体大小

            //居中显示FPS
            GUI.Label(new Rect(Screen.width - 200, Screen.height - 20, 200, 200), "Version:" + Application.version + " FPS: " + m_FPS, bb);
        }*/
        private ArrayList assetKey = new ArrayList();
        private Hashtable updateAsset = new Hashtable();
        IEnumerator UpdateResourceCount()
        {
            if (!AppFacade.Instance.IsUpdate)
            {
                ResManager.initialize(OnResourceInited);
                yield break;
            }
            string dataPath = Util.DataPath;  //数据目录
            string url = AppConst.WebUrl + "ios/v" + dirVersion + "/";

            if (Application.platform == RuntimePlatform.Android)
            {
                url = AppConst.WebUrl + "android/v" + dirVersion + "/";
            }
            else if (Application.platform == RuntimePlatform.IPhonePlayer)
            {
                url = AppConst.WebUrl + "ios/v" + dirVersion + "/";
            }
            else if (Application.platform == RuntimePlatform.OSXEditor)
            {
                url = AppConst.WebUrl + "ios/v" + dirVersion + "/";
            }
            else if (Application.platform == RuntimePlatform.WindowsEditor)
            {
                url = AppConst.WebUrl + "android/v" + dirVersion + "/";
            }
            if (url == "")
            {
                yield break;
            }
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string listUrl = url + "files.txt?v=" + random;
            WWW www = new WWW(listUrl); yield return www;
            if (www.error != null)
            {
                OnUpdateFailed(string.Empty);
                yield break;
            }
            if (!Directory.Exists(dataPath))
            {
                Directory.CreateDirectory(dataPath);
            }
            File.WriteAllBytes(dataPath + "files.txt", www.bytes);
            long downlen = 0;
            string filesText = www.text;
            string[] files = filesText.Split('\n');
            for (int i = 0; i < files.Length; i++)
            {
                if (string.IsNullOrEmpty(files[i])) continue;
                string[] keyValue = files[i].Split('|');
                string f = keyValue[0];
                string localfile = (dataPath + f).Trim();
                string path = Path.GetDirectoryName(localfile);
                if (!Directory.Exists(path))
                {
                    Directory.CreateDirectory(path);
                }
                string fileUrl = url + keyValue[0] + "?v=" + random;
                bool canUpdate = !File.Exists(localfile);
                if (!canUpdate)
                {
                    string remoteMd5 = keyValue[1].Trim();
                    string localMd5 = Util.md5file(localfile);
                    canUpdate = !remoteMd5.Equals(localMd5);
                    if (canUpdate)
                    {
                        File.Delete(localfile);
                    }
                }
                if (canUpdate)
                {
                    downlen += long.Parse(keyValue[2]);
                    assetKey.Add(localfile);
                    updateAsset.Add(localfile, fileUrl);
                }
            }
            yield return new WaitForEndOfFrame();
            // 数据网络
            if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
            {
                if (downlen > 1024)
                {
                    _loadassets.showDownSize(CountSize(downlen));
                }
                else
                {
                    StartCoroutine(StartUpdateResource());
                }
            }

            // 无线
            if (Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
            {
                StartCoroutine(StartUpdateResource());                
            }
        }

        public void StartLoadUpdate()
        {
            StartCoroutine(StartUpdateResource());
        }

        public static long GetFileSize(string sFullName)
        {
            long ISize = 0;
            if (File.Exists(sFullName))
            {
                ISize = new FileInfo(sFullName).Length;
            }
            return ISize;
        }

        public static string CountSize(long Size)
        {
            string m_strSize = "";
            long FactSize = 0;
            FactSize = Size;
            if (FactSize < 1024.00)
                m_strSize = FactSize.ToString("F2") + " Byte";
            else if (FactSize >= 1024.00 && FactSize < 1048576)
                m_strSize = (FactSize / 1024.00).ToString("F2") + " K";
            else if (FactSize >= 1048576 && FactSize < 1073741824)
                m_strSize = (FactSize / 1024.00 / 1024.00).ToString("F2") + " M";
            else if (FactSize >= 1073741824)
                m_strSize = (FactSize / 1024.00 / 1024.00 / 1024.00).ToString("F2") + " G";
            return m_strSize;
        }

        /// <summary>
        /// 初始化
        /// </summary>
        void Init()
        {
            DontDestroyOnLoad(gameObject);  //防止销毁自己
            // OnResourceInited();
            CheckExtractResource(); //释放资源
            Screen.sleepTimeout = SleepTimeout.NeverSleep;
            Application.targetFrameRate = AppConst.GameFrameRate;
        }

        static private void AdaptiveUI()
        {
            int ManualWidth = 1280;
            int ManualHeight = 720;
            UIRoot uiRoot = GameObject.FindObjectOfType<UIRoot>();
            if (uiRoot != null)
            {
                if (System.Convert.ToSingle(Screen.height) / Screen.width > System.Convert.ToSingle(ManualHeight) / ManualWidth)
                    //uiRoot.manualHeight = Mathf.RoundToInt(System.Convert.ToSingle(ManualWidth) / Screen.width * Screen.height);
                    uiRoot.manualHeight = Mathf.RoundToInt(System.Convert.ToSingle(ManualWidth) / Screen.width * Screen.height);
                else
                    uiRoot.manualHeight = ManualHeight;
            }
        }

        private LoadAssets _loadassets;
        private void showLoadAnim ()
        {
            GameObject gameObj = GameObject.Find("UILoadAssets");
            if (gameObj == null)
            {
                GameObject showObj = (GameObject)Resources.Load("UILoadAssets");
                gameObj = (GameObject)Instantiate(showObj);
            }
            _loadassets = gameObj.GetComponent<LoadAssets>();
            _loadassets.init(this);
        }

        // 结束加载和更新程序
        public void  startAnimEnd()
        {
            if (_loadassets != null)
            {
                _loadassets.clear();
                Destroy(_loadassets.MyGameObj);
                _loadassets = null;
            }
        }

        void Update()
        {
            if (_loadassets != null)
            {
                _loadassets.timeEvent();
            }
            if (Input.GetKey(KeyCode.Backspace))
            {
                IsShow = !IsShow;
             }
            m_FrameCount = m_FrameCount + 1;
            timePassed = timePassed + Time.deltaTime;

            if (timePassed > fpsMeasuringDelta)
            {
                m_FPS = m_FrameCount / timePassed;

                timePassed = 0.0f;
                m_FrameCount = 0;
            }
            if (initialize)
            {
                LuaManager.CallFunction("main_game.timeEvent");
            }
        }

        private string dirVersion = "0";
        IEnumerator getUpdateVersion()
        {
            dirVersion = Application.version;
			WWW www = new WWW(AppConst.WebUrlVersion); yield return www;

            if (www.error != null)
            {
                _loadassets.updateAnimaPos(1, 1, "获取版本失败，请检测网络。");
                _loadassets.showBigVersion("获取版本失败，请检测网络。",1);
                yield break;
            }

            dirVersion = www.text;
            float version = float.Parse(dirVersion);
            float nowversion =  float.Parse(Application.version);
            int yy = (int)version;
            string temp = PlayerPrefs.GetString("Version");
            if(temp == ""){
                temp = "0";
            }
            float ver = float.Parse(temp);
            if (version > nowversion && 0 == (version - (float)yy))
            {
                _loadassets.showBigVersion("检测到新版本，请到官网重新下包。",2);
            }else
            {
                if (version - nowversion > 1)
                {
                    _loadassets.showBigVersion("检测到新版本，请到官网重新下包。", 2);
                }else
                {
                    if (ver < nowversion && version > nowversion)
                    {
                        if (Directory.Exists(Util.DataPath)) Directory.Delete(Util.DataPath, true);
                    }
                    PlayerPrefs.SetString("Version", dirVersion);
                    Init();
                }
            }
        }

        /// <summary>
        /// 释放资源
        /// </summary>
        public void CheckExtractResource() {
            bool isExists = Directory.Exists(Util.DataPath) && Directory.Exists(Util.DataPath + "game/") &&
              Directory.Exists(Util.DataPath + "lua/") && File.Exists(Util.DataPath + "files.txt");
            if (isExists || AppConst.DebugMode) {
                //StartCoroutine(OnUpdateResource());
                StartCoroutine(UpdateResourceCount());
                //ResManager.initialize(OnResourceInited);
                return;   //文件已经解压过了，自己可添加检查文件列表逻辑
            }
            StartCoroutine(OnExtractResource());    //启动释放协成
        }

        IEnumerator OnExtractResource() {
            string dataPath = Util.DataPath;  //数据目录
            string resPath = Util.AppContentPath(); //游戏包资源目录
            if (Directory.Exists(dataPath)) Directory.Delete(dataPath, true);
            Directory.CreateDirectory(dataPath);

            string infile = resPath + "files.txt";
            string outfile = dataPath + "files.txt";
            if (File.Exists(outfile)) File.Delete(outfile);

            string message = "正在解包文件:>files.txt";
            //Debug.Log(message + "++++++++++++++++" + infile);
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

            if (Application.platform == RuntimePlatform.Android) {
                WWW www = new WWW(infile);
                yield return www;

                if (www.isDone) {
                    File.WriteAllBytes(outfile, www.bytes);
                }
                yield return 0;
            } else File.Copy(infile, outfile, true);
            yield return new WaitForEndOfFrame();

            //释放所有文件到数据目录
            string[] files = File.ReadAllLines(outfile);
            int len = files.Length;
            int num = 1;
            foreach (var file in files) {
                string[] fs = file.Split('|');
                infile = resPath + fs[0];  //
                outfile = dataPath + fs[0];

                message = "正在解包文件:>" + fs[0];
                //Debug.Log(outfile+"正在解包文件:>" + infile);
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

                string dir = Path.GetDirectoryName(outfile);
                if (!Directory.Exists(dir)) Directory.CreateDirectory(dir);

                if (Application.platform == RuntimePlatform.Android) {
                    WWW www = new WWW(infile);
                    yield return www;

                    if (www.isDone) {
                        File.WriteAllBytes(outfile, www.bytes);
                    }
                    yield return 0;
                } else {
                    if (File.Exists(outfile)) {
                        File.Delete(outfile);
                    }
                    File.Copy(infile, outfile, true);
                }
                _loadassets.updateAnimaPos(len, num, "正在解包资源，过程不会消耗流量");
                num = num + 1;
                yield return new WaitForEndOfFrame();
            }
            message = "解包完成!!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);

            yield return new WaitForSeconds(0.1f);
            //message = string.Empty;
            //ResManager.initialize(OnResourceInited);
            //StartCoroutine(OnUpdateResource());
            StartCoroutine(UpdateResourceCount());
        }

        public void resertUpdate()
        {
            StartCoroutine(UpdateResourceCount());
        }

        public int loadIndex = 0;
        public int loadCount = 0;
        /*public void StartUpdateRes(string dir)
        {
            initialize = false;
            showLoadAnim();
            StartCoroutine(OnUpdateResource(dir));
        }*/

        /// <summary>
        /// 启动更新下载，这里只是个思路演示，此处可启动线程下载更新
        /// </summary>
        /*IEnumerator OnUpdateResource()
        {
            downloadFiles.Clear();

            if (!AppFacade.Instance.IsUpdate)
            {
                ResManager.initialize(OnResourceInited);
                yield break;
            }
            string dataPath = Util.DataPath;  //数据目录
			string url = AppConst.WebUrl + "ios/v" + dirVersion + "/";

			if (Application.platform == RuntimePlatform.Android) {
				url = AppConst.WebUrl + "android/v" + dirVersion + "/";
			} else if (Application.platform == RuntimePlatform.IPhonePlayer) {
				url = AppConst.WebUrl + "ios/v" + dirVersion + "/";
			} else if(Application.platform == RuntimePlatform.OSXEditor){
				url = AppConst.WebUrl + "ios/v" + dirVersion + "/";
			} else if(Application.platform == RuntimePlatform.WindowsEditor){
				url = AppConst.WebUrl + "android/v" + dirVersion + "/";
			}
            if (url == "")
            {
                yield break;
            }
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string listUrl = url + "files.txt?v=" + random;
            WWW www = new WWW(listUrl); yield return www;
            if (www.error != null) {
                OnUpdateFailed(string.Empty);
                yield break;
            }
            if (!Directory.Exists(dataPath)) {
                Directory.CreateDirectory(dataPath);
            }
            File.WriteAllBytes(dataPath + "files.txt", www.bytes);

            string filesText = www.text;
            string[] files = filesText.Split('\n');
            string message = string.Empty;
            loadCount = files.Length;
            loadIndex = 1;

            for (int i = 0; i < loadCount; i++)
            {
                if (string.IsNullOrEmpty(files[i])) continue;
                string[] keyValue = files[i].Split('|');
                string f = keyValue[0];
                string localfile = (dataPath + f).Trim();
                string path = Path.GetDirectoryName(localfile);
                if (!Directory.Exists(path)) {
                    Directory.CreateDirectory(path);
                }
                string fileUrl = url + keyValue[0] + "?v=" + random;
                bool canUpdate = !File.Exists(localfile);
                if (!canUpdate) {
                    string remoteMd5 = keyValue[1].Trim();
                    string localMd5 = Util.md5file(localfile);
                    canUpdate = !remoteMd5.Equals(localMd5);
                    if (canUpdate)
                    {
                        File.Delete(localfile);
                    }
                    else
                    {
                        updateLoadPos("正在比对资源...");
                    }
                }
                if (canUpdate) {   //本地缺少文件
                    message = "downloading>>" + fileUrl;
                    facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                    //这里都是资源文件，用线程下载
                    BeginDownload(fileUrl, localfile);
                    while (!(IsDownOK(localfile))) { yield return new WaitForEndOfFrame(); }
                }
            }
            yield return new WaitForEndOfFrame();
            message = "更新完成!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            ResManager.initialize(OnResourceInited);
        }*/

        IEnumerator StartUpdateResource()
        {
            string message = string.Empty;
            int len = assetKey.Count;
            loadCount = len;
            loadIndex = 1;
            downsize = 0; 
            for (int i = 0; i < len; i++)
            {
                string localfile = (string)assetKey[i];
                string fileUrl = (string)updateAsset[localfile];
                message = "downloading>>" + fileUrl;
                facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                BeginDownload(fileUrl, localfile);
                while (!(IsDownOK(localfile))) { yield return new WaitForEndOfFrame(); }
            }
            message = "更新完成!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            ResManager.initialize(OnResourceInited);
        }

        public string getApplicationVer()
        {
            return dirVersion;
        }

        public void openLogin()
        {
            LuaManager.DoFile("View.lua");
            LuaManager.CallFunction("View:start");
        }
        long downsize = 0;
        public void updateLoadPos(string str)
        {
            _loadassets.updateAnimaPos(loadCount, loadIndex, str);
            loadIndex = loadIndex + 1;
        }
        /// <summary>
        /// 是否下载完成
        /// </summary>
        bool IsDownOK(string file) {
            bool complete = downloadFiles.Contains(file);
            if (complete)
            {
                long filesize = GetFileSize(file);
                downsize = downsize + filesize;
                string size = CountSize(downsize);
                _loadassets.showStateInit("已下载游戏资源 " + size);
                updateLoadPos("检测到新资源，正在下载资源...");
            }
            return complete;
        }

        /// <summary>
        /// 线程下载
        /// </summary>
        void BeginDownload(string url, string file) {     //线程下载
            object[] param = new object[2] {url, file};

            ThreadEvent ev = new ThreadEvent();
            ev.Key = NotiConst.UPDATE_DOWNLOAD;
            ev.evParams.AddRange(param);
            ThreadManager.AddEvent(ev, OnThreadCompleted);   //线程下载
        }

        /// <summary>
        /// 线程完成
        /// </summary>
        /// <param name="data"></param>
        void OnThreadCompleted(NotiData data) {
            switch (data.evName) {
                case NotiConst.UPDATE_EXTRACT:  //解压一个完成

                break;
                case NotiConst.UPDATE_DOWNLOAD: //下载一个完成
                    downloadFiles.Add(data.evParam.ToString());
                break;
            }
        }

        void OnUpdateFailed(string file) {
            string message = "更新失败!>" + file;
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            _loadassets.updateAnimaPos(1, 1, "更新失败!!!");
            _loadassets.showBigVersion("更新失败!!!",3);
        }

        IEnumerator InitStartPanel()
        {
            yield return SoundManager.initialize && LuaManager.IsLoading;
            if (SoundManager.initialize && LuaManager.IsLoading)
            {
                LuaManager.InitStart();
                initialize = true;
            }
        }
        /// <summary>
        /// 资源初始化结束
        /// </summary>
        public void OnResourceInited() {
            //startAnimEnd();
            //PlayerPrefs.SetFloat("Version", float.Parse(Application.version));
            StartCoroutine(InitStartPanel());
            //LuaManager.InitStart();
//            LuaManager.DoFile("Logic/Game");            //加载游戏
//            LuaManager.DoFile("Logic/Network");         //加载网络
//            NetManager.OnInit();                        //初始化网络
//            Util.CallMethod("Game", "OnInitOK");          //初始化完成
            //initialize = true;                          //初始化完
//            //类对象池测试
//            var classObjPool = ObjPoolManager.CreatePool<TestObjectClass>(OnPoolGetElement, OnPoolPushElement);
//            //方法1
//            //objPool.Release(new TestObjectClass("abcd", 100, 200f));
//            //var testObj1 = objPool.Get();
//
//            //方法2
//            ObjPoolManager.Release<TestObjectClass>(new TestObjectClass("abcd", 100, 200f));
//            var testObj1 = ObjPoolManager.Get<TestObjectClass>();
//
//            Debugger.Log("TestObjectClass--->>>" + testObj1.ToString());
//
//            //游戏对象池测试
//            var prefab = Resources.Load("TestGameObjectPrefab", typeof(GameObject)) as GameObject;
//            var gameObjPool = ObjPoolManager.CreatePool("TestGameObject", 5, 10, prefab);
//
//            var gameObj = Instantiate(prefab) as GameObject;
//            gameObj.name = "TestGameObject_01";
//            gameObj.transform.localScale = Vector3.one;
//            gameObj.transform.localPosition = Vector3.zero;
//
//            ObjPoolManager.Release("TestGameObject", gameObj);
//            var backObj = ObjPoolManager.Get("TestGameObject");
//            backObj.transform.SetParent(null);
//
//            Debug.Log("TestGameObject--->>>" + backObj);
        }

        /// <summary>
        /// 当从池子里面获取时
        /// </summary>
        /// <param name="obj"></param>
        /*void OnPoolGetElement(TestObjectClass obj) {
            Debug.Log("OnPoolGetElement--->>>" + obj);
        }*/

        /// <summary>
        /// 当放回池子里面时
        /// </summary>
        /// <param name="obj"></param>
        /*void OnPoolPushElement(TestObjectClass obj) {
            Debug.Log("OnPoolPushElement--->>>" + obj);
        }*/
		[DllImport("__Internal")]
		private static extern void loginsdk ();

		[DllImport("__Internal")]
		private static extern void sharemsg(int ntype,string _title,string _desc,string _url,string _filePath);

		[DllImport("__Internal")]
		private static extern bool isWXAppInstalled();

		[DllImport("__Internal")]
		private static extern bool isWXAppSupportApi();

		// 支付
		[DllImport("__Internal")]
		private static extern void c_pay (string url,int type,string referer_url);


//		[DllImport("__Internal")]
//		private static extern void shareimg(string filePath);

		public void login_sdk(LuaFunction func = null) {
			luaf_login_sdk_cb = func;
			loginsdk ();
		}

		void login_sdk_cb(string str){
//			Debug.Log ("33333: " + str);
			if (luaf_login_sdk_cb != null) luaf_login_sdk_cb.Call(str);
		}

		public void pay(string url,int ntype,string referer_url,LuaFunction func = null){
			luaf_pay_cb = func;
			c_pay (url,ntype,referer_url);
		}
		void pay_cb(string str){
			//			Debug.Log ("33333: " + str);
			if (luaf_pay_cb != null) luaf_pay_cb.Call(str);
		}

		public void share_msg(int ntype,string _title,string _desc,string _url,string _filePath){
			sharemsg (ntype,_title,_desc,_url,_filePath);
		}

		public bool is_WXAppInstalled(){
			return isWXAppInstalled();
		}

		public bool is_WXAppSupportApi(){
			return isWXAppSupportApi();
		}
//		public void share_img(string filePath){
//			shareimg (filePath);
//		}

        /// <summary>
        /// 析构函数
        /// </summary>
        void OnDestroy() {
            /*if (NetManager != null) {
                NetManager.Unload();
            }*/
            //Application.logMessageReceived -= logCallBack;
            startAnimEnd();
            if (LuaManager != null) {
                LuaManager.Close();
            }
            //Debug.Log("~GameManager was destroyed");
        }
    }
}