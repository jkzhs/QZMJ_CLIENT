using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System;
using LuaInterface;
using UObject = UnityEngine.Object;

namespace LuaFramework {
    public class ResourceManager : Manager {
        private Hashtable AltasList = new Hashtable();
        private Hashtable bundleList = new Hashtable();
        private Hashtable AssetList = new Hashtable();
        /// <summary>
        /// ��ʼ��
        /// </summary>
        public void initialize(Action func) {
            if (func != null) func();
        }

        public Vector2 getRandomUnitCircle()
        {
            return UnityEngine.Random.insideUnitCircle;
        }

        /// <summary>
        /// �����ز�
        /// </summary>
        public AssetBundle LoadBundle(string name) {
            if(bundleList[name] == null) {
                string uri = Util.DataPath + "game/AssetBounld/" + name.ToLower() + AppConst.ExtName;
                AssetBundle bundle = AssetBundle.LoadFromFile(uri);
                if (bundle != null) 
                {
                    bundleList.Add(name, bundle);
                }
            }
            return (AssetBundle)bundleList[name];
        }

        public UIAtlas LoadUrlAssetAltas(string name)
        {
            if(AltasList[name] == null) {
                string uri = Util.DataPath + "game/AssetBounld/" + name.ToLower() + AppConst.ExtName;
                AssetBundle value = AssetBundle.LoadFromFile(uri);
                if (value != null)
                {
                    GameObject ob = GameObject.Instantiate(LoadBundleAsset(value, name));
                    AltasList.Add(name, ob);
                }else
                {
                    return null;
                }
            }
            GameObject o = (GameObject)AltasList[name];
            UIAtlas altas = o.GetComponent<UIAtlas>();
            return altas;
        }

        public GameObject LoadBundleAsset(AssetBundle bundle,string name) {
            if(AssetList[name] == null) {
                GameObject asset = null;
                #if UNITY_5
                    asset = bundle.LoadAsset(name, typeof(GameObject)) as GameObject;
                #else
                    asset = bundle.Load(name, typeof(GameObject)) as GameObject;
                #endif
                AssetList.Add(name, asset);
            }
            GameObject obj = (GameObject)AssetList[name];
            return obj;
        }

        public void addAltas(Transform curTran,string atlasname)
        {
            UISprite[] sp = curTran.GetComponentsInChildren<UISprite>(true);
            UIAtlas atlas = LoadUrlAssetAltas(atlasname);
            for (int j = 0; j < sp.Length; j++)
            {
                UISprite sprite = sp[j];
                sprite.atlas = atlas;
            }
        }

        public void clearBundle(string name){
            bundleList.Remove(name);
            AssetList.Remove(name);
        }

		//载入音效资源
		public void LoadAudioClip(string abName, Action<UObject> func) {
			abName = abName.ToLower();
			AssetBundle bundle = LoadBundle(abName);
            if (bundle == null)
            {
                return;
            }
			AudioClip prefab = null;
			#if UNITY_5
			prefab = bundle.LoadAsset(abName, typeof(AudioClip)) as AudioClip;
#else
			prefab = bundle.Load(name, typeof(GameObject)) as GameObject;
#endif
            if (func != null) {
				func(prefab);
			}
		}

        public void share(int flag, string desc, string files, string url, string title)
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("share2weixin", flag, desc, files, url, title);
            }
        }

        public void weiLogin()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("weiLogin");
            }
        }

        public void WxPayH5(string url,string web)
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("WxPayH5", url, web);
            }
        }

        public void h5Pay(string url)
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("h5Pay", url);
            }
        }

        public void getIpAddress()
        {
            if (Application.platform == RuntimePlatform.Android)
            {
                AndroidJavaClass jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
                AndroidJavaObject jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
                jo.Call("getIpAddress");
            }
        }

        public void FromAndroidData(string ip)
        {
            LuaManager.DoFile("controller/BankCtrl");
            Util.CallMethod("BankCtrl", "getIpAddress", ip);
        }

        public void WeChatCallBack(string response)
        {
            LuaManager.DoFile("controller/LoginCtrl");
            Util.CallMethod("LoginCtrl", "wechatLogin", response);
        }

        public void InputEventDeleate(UIInput input, LuaFunction func = null)
        {
                EventDelegate.Add(input.onSubmit, delegate()
                {
                    if (func != null) func.Call();
                });
        }

        public void TweenPosEventDeleate(TweenPosition tp , LuaFunction func = null)
        {
            EventDelegate.Add(tp.onFinished, delegate ()
            {
                if (func != null) func.Call();
            });
        }

        private List<string> downloadFiles = new List<string>();
        public int loadIndex = 0;
        public int loadCount = 0;
        IEnumerator OnUpdateResource(string url)
        {
            downloadFiles.Clear();
            string dataPath = Util.DataPath;  //数据目录
            if (url == "")
            {
                yield break;
            }
            string random = DateTime.Now.ToString("yyyymmddhhmmss");
            string listUrl = url + "files.txt?v=" + random;
            //Debug.LogWarning("LoadUpdate---->>>" + listUrl);
            //Debug.Log("LoadUpdate---->>>" + listUrl);
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

            string filesText = www.text;
            //Debug.Log(dataPath + "filesText---->>>" + filesText);
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
                //Debug.Log("localfile---->>>" + f);
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
                    else
                    {
                        //updateLoadPos("正在比对资源...");
                    }
                }
                if (canUpdate)
                {   //本地缺少文件
                    message = "downloading>>" + fileUrl;
                    facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
                    BeginDownload(fileUrl, localfile);
                    while (!(IsDownOK(localfile))) { yield return new WaitForEndOfFrame(); }
                }
            }
            yield return new WaitForEndOfFrame();
            message = "更新完成!!";
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            //ResManager.initialize(OnResourceInited);
        }

        bool IsDownOK(string file)
        {
            bool complete = downloadFiles.Contains(file);
            if (complete)
            {
                //updateLoadPos("检测到新资源，正在下载资源...");
            }
            return complete;
        }

        /// <summary>
        /// 线程下载
        /// </summary>
        void BeginDownload(string url, string file)
        {     //线程下载
            object[] param = new object[2] { url, file };

            ThreadEvent ev = new ThreadEvent();
            ev.Key = NotiConst.UPDATE_DOWNLOAD;
            ev.evParams.AddRange(param);
            ThreadManager.AddEvent(ev, OnThreadCompleted);   //线程下载
        }

        /// <summary>
        /// 线程完成
        /// </summary>
        /// <param name="data"></param>
        void OnThreadCompleted(NotiData data)
        {
            switch (data.evName)
            {
                case NotiConst.UPDATE_EXTRACT:  //解压一个完成

                    break;
                case NotiConst.UPDATE_DOWNLOAD: //下载一个完成
                    downloadFiles.Add(data.evParam.ToString());
                    break;
            }
        }

        void OnUpdateFailed(string file)
        {
            string message = "更新失败!>" + file;
            facade.SendMessageCommand(NotiConst.UPDATE_MESSAGE, message);
            //_loadassets.updateAnimaPos(1, 1, "更新失败!!!");
            //_loadassets.showBigVersion("更新失败!!!", 3);
        }

        /// <summary>
        /// ������Դ
        /// </summary>
        void OnDestroy() {
            for (int i = 0; i < AltasList.Count;i++ )
            {
                GameObject alt = (GameObject)AltasList[i];
                Destroy(alt);
            }
            for (int i = 0; i < AssetList.Count; i++)
            {
                GameObject o = (GameObject)AssetList[i];
                Destroy(o);
            }
            AltasList = null;
            AssetList = null;
            bundleList = null;
           
            //Debug.Log("~ResourceManager was destroy!");
        }
    }
}