using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using LuaFramework;

public class Packager {
    public static string platform = string.Empty;
    static List<string> paths = new List<string>();
    static List<string> files = new List<string>();

    ///-----------------------------------------------------------
    static string[] exts = { ".txt", ".xml", ".lua", ".assetbundle", ".json" };
    static bool CanCopy(string ext) {   //能不能复制
        foreach (string e in exts) {
            if (ext.Equals(e)) return true;
        }
        return false;
    }

    /// <summary>
    /// 载入素材
    /// </summary>
    static UnityEngine.Object LoadAsset(string file) {
        if (file.EndsWith(".lua")) file += ".txt";
        return AssetDatabase.LoadMainAssetAtPath("Assets/LuaFramework/game/" + file);
    }

    [MenuItem("LuaFramework/Build iPhone Resource", false, 98)]
    public static void BuildiPhoneResource() {
        BuildTarget target;
#if UNITY_5
        target = BuildTarget.iOS;
#else
        target = BuildTarget.iPhone;
#endif
        BuildAssetResource(target);
    }

    [MenuItem("LuaFramework/Build SoundPrefab Resource", false, 99)]
    public static void BuildUserSoundPrefabResource()
    {
        BuildSoundPrefabResource(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build ChoicePrefab Resource", false, 100)]
    public static void BuildUserAssertPrefabResource()
    {
        BuildChoicePrefabResource(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build Resource/All Prefab", false, 101)]
    public static void BuildPrefabResource()
    {
        BuildPrefabResource(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build Resource/All Lua", false, 101)]
    public static void BuildLuaResource()
    {
        BuildLuaResource(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build Android Resource", false, 102)]
    public static void BuildAndroidResource() {
        BuildAssetResource(BuildTarget.Android);
    }

    [MenuItem("LuaFramework/Build Windows Resource", false, 103)]
    public static void BuildWindowsResource() {
        BuildAssetResource(BuildTarget.StandaloneWindows);
    }

	[MenuItem("LuaFramework/Build iPhone Prefab Resource", false, 104)]
	public static void BuildiPhonePrefabResource() {
		BuildAsset(BuildTarget.iOS);
	}

    [MenuItem("LuaFramework/Set Sprite Atlas Null",false,105)]
    public static void SetSpriteAtlas(){
        GameObject[] chooses = Selection.gameObjects;
        foreach (GameObject go in chooses)
        {
            UISprite[] sprites = go.GetComponentsInChildren<UISprite>(true);

            bool isChange = false;
            for (int i = 0; i < sprites.Length; ++i)
            {
                if (sprites[i].atlas != null)
                {
                    UnityEngine.Debug.Log(go.name + " -- " + sprites[i].cachedGameObject.name + " -- " + sprites[i].atlas.name);
                    sprites[i].atlas = null;
                    isChange = true;
                }
            }

            if (isChange)
            {
                UnityEditor.EditorUtility.SetDirty(go);
            }
        }
        AssetDatabase.Refresh();
    }

    static Hashtable allAtals = new Hashtable();
    private static List<string> AllSpriteAtals = new List<string>{
        "GameLobby",
        "JoinRoom",
        "Loading",
        "Login",
        "Niuniu",
        "Room",
        "Rule",
        "Setting",
        "Tip",
        "Bank",
        "Dealer",
        "ShierzhiRoom",
        "GameScore",
        "PaiGow",
        "PlayerList",
        "SendInvitation",
        "Support",
        "Sanshui",
        "SetRoom",
        "Shop",
        "People",
        "Mail",
        "Customer",
        "Chat",
        "YaoLeZi",
        "MaJiang",
    };

    [MenuItem("LuaFramework/Get All Sprite Atlas", false, 105)]
    public static void GetAllSpriteAtals()
    {
        UnityEngine.Debug.Log(allAtals.Count);
        if (allAtals.Count > 0) 
        {
            return;
        }
        int len = AllSpriteAtals.Count;
        for (int i = 0; i < len; i++)
        {
            string name = AllSpriteAtals[i];
            string uri = Application.streamingAssetsPath + "/game/AssetBounld/" + name.ToLower() + AppConst.ExtName;
            AssetBundle value = AssetBundle.LoadFromFile(uri);
            if (value != null)
            {
                UnityEngine.Debug.Log("UIAtlas" + name);
                GameObject ob = value.LoadAsset(name, typeof(GameObject)) as GameObject;
                var altas = ob.GetComponent<UIAtlas>();
                allAtals.Add(name, altas);
                value.Unload(false);
            }
        }
        UnityEngine.Debug.Log("Complete");
    }

    [MenuItem("LuaFramework/Get Sprite To Atlas", false, 106)]
    public static void getSpriteToAtals()
    {
        GameObject[] chooses = Selection.gameObjects;
        foreach (GameObject go in chooses)
        {
            UISprite[] sprites = go.GetComponentsInChildren<UISprite>(true);
            UnityEngine.Debug.Log(go.name.Replace("Panel", ""));
            UIAtlas atlas = (UIAtlas)allAtals[go.name.Replace("Panel", "")];
            bool isChange = false;
            for (int i = 0; i < sprites.Length; ++i)
            {
                if (sprites[i].atlas == null)
                {
                    UnityEngine.Debug.Log(go.name + " -- " + atlas);
                    sprites[i].atlas = atlas;
                    isChange = true;
                }
            }

            if (isChange)
            {
                UnityEditor.EditorUtility.SetDirty(go);
            }
        }
        AssetDatabase.Refresh();
    }

    public static void BuildSoundPrefabResource(BuildTarget target)
    {
        if (File.Exists("c:/luaframework/files.txt")) File.Delete("c:/luaframework/files.txt");
        AssetDatabase.Refresh();

        Object mainAsset = null;
        string assetfile = string.Empty;
        BuildAssetBundleOptions options = BuildAssetBundleOptions.UncompressedAssetBundle |
                                          BuildAssetBundleOptions.CollectDependencies |
                                          BuildAssetBundleOptions.DeterministicAssetBundle;
        string assetPath = AppDataPath + "/StreamingAssets/game/AssetBounld/";
        string prefabPaths = AppDataPath + "/LuaFramework/game/saveassert/Sound";
        paths.Clear(); files.Clear();
        string luaDataPath = prefabPaths.ToLower();
        Recursive(luaDataPath);
        foreach (string f in files)
        {
             if (!f.EndsWith(".mp3")) continue;
             string head = AppDataPath + "/luaframework/game/";
             string asseturl = f.Replace(head, "");
             string BounldName = f.Remove(0, f.LastIndexOf("/") + 1);
             string assetBounldName = BounldName.Remove(BounldName.LastIndexOf("."));
             if (Directory.Exists("c:/luaframework/game/AssetBounld/" + assetBounldName.ToLower() + ".unity3d"))
             {
                 Directory.Delete("c:/luaframework/game/AssetBounld/" + assetBounldName.ToLower() + ".unity3d", true);
             }
             string streamPath = Application.streamingAssetsPath + "/game/AssetBounld/" + assetBounldName.ToLower() + ".unity3d";
             if (Directory.Exists(streamPath))
             {
                 Directory.Delete(streamPath, true);
             }
             mainAsset = LoadAsset(asseturl);
             UnityEngine.Debug.Log(assetBounldName);
             assetfile = assetPath + assetBounldName.ToLower() + AppConst.ExtName;
             BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
        }

        BuildFileIndex();
        AssetDatabase.Refresh();
    }

    public static void BuildChoicePrefabResource(BuildTarget target)
    {
        if (File.Exists("c:/luaframework/files.txt")) File.Delete("c:/luaframework/files.txt");       
        GameObject[] chooses = Selection.gameObjects;
        foreach (GameObject go in chooses)
        {
            if (Directory.Exists("c:/luaframework/game/AssetBounld/" + go.name.ToLower() + ".unity3d"))
            {
                Directory.Delete("c:/luaframework/game/AssetBounld/" + go.name.ToLower() + ".unity3d", true);
            }

            string streamPath = Application.streamingAssetsPath + "/game/AssetBounld/" + go.name.ToLower() + ".unity3d";
            if (Directory.Exists(streamPath))
            {
                Directory.Delete(streamPath, true);
            }
        }
        AssetDatabase.Refresh();

        Object mainAsset = null;
        string assetfile = string.Empty;
        BuildAssetBundleOptions options = BuildAssetBundleOptions.UncompressedAssetBundle |
                                          BuildAssetBundleOptions.CollectDependencies |
                                          BuildAssetBundleOptions.DeterministicAssetBundle;
        string assetPath = AppDataPath + "/StreamingAssets/game/AssetBounld/";
        string[] prefabPaths = { AppDataPath + "/LuaFramework/game/saveassert",
                              AppDataPath + "/LuaFramework/game/userassert" };
        foreach (GameObject go in chooses)
        {
            assetfile = assetPath + go.name.ToLower() + AppConst.ExtName;
            for (int i = 0; i < prefabPaths.Length; i++)
            {
                paths.Clear(); files.Clear();
                string luaDataPath = prefabPaths[i].ToLower();
                Recursive(luaDataPath);
                foreach (string f in files)
                {
                    if (!f.EndsWith(".prefab") && !f.EndsWith(".mp3")) continue;
                    string head = AppDataPath + "/luaframework/game/";
                    string asseturl = f.Replace(head, "");
                    string BounldName = f.Remove(0, f.LastIndexOf("/") + 1);
                    string assetBounldName = BounldName.Remove(BounldName.LastIndexOf("."));
                    if (go.name == assetBounldName)
                    {
                        UnityEngine.Debug.Log(go.name + " " + assetBounldName);
                        mainAsset = LoadAsset(asseturl);
                        BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
                    }
                }
            }
        }

        BuildFileIndex();
        AssetDatabase.Refresh();
    }

    public static void BuildPrefabResource(BuildTarget target)
    {
        if (Directory.Exists("c:/luaframework/game/AssetBounld/"))
        {
            Directory.Delete("c:/luaframework/game/AssetBounld/", true);
        }
        string streamPath = Application.streamingAssetsPath + "/game/AssetBounld/";
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        AssetDatabase.Refresh();

        if (AppConst.ExampleMode)
        {
            HandleExampleBundle(target);
        }

        BuildFileIndex();
        AssetDatabase.Refresh();
    }

    public static void BuildLuaResource(BuildTarget target)
    {
        if (Directory.Exists(Util.DataPath))
        {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath + "/game/src/";
        if (Directory.Exists(streamPath))
        {
            Directory.Delete(streamPath, true);
        }
        string sluaPath = Application.streamingAssetsPath + "/lua/";
        if (Directory.Exists(sluaPath))
        {
            Directory.Delete(sluaPath, true);
        }
        string files = Application.streamingAssetsPath + "/files.txt";
        if (File.Exists(files)) File.Delete(files); 
        AssetDatabase.Refresh();
        string luaPath = AppDataPath + "/StreamingAssets/lua/";
        string[] luaPaths = { AppDataPath + "/LuaFramework/lua/", 
                              AppDataPath + "/LuaFramework/Tolua/Lua/"};
        HandleLuaFile(luaPath, luaPaths);
        luaPath = AppDataPath + "/StreamingAssets/game/src/";
        string[] gamePaths = { AppDataPath + "/LuaFramework/game/src/" };
        HandleLuaFile(luaPath, gamePaths);
        BuildFileIndex();
        AssetDatabase.Refresh();
    }

    /// <summary>
    /// 生成绑定素材
    /// </summary>
    public static void BuildAssetResource(BuildTarget target) {
        if (Directory.Exists(Util.DataPath)) {
            Directory.Delete(Util.DataPath, true);
        }
        string streamPath = Application.streamingAssetsPath;
        if (Directory.Exists(streamPath)) {
            Directory.Delete(streamPath, true);
        }
        AssetDatabase.Refresh();

        if (AppConst.ExampleMode) {
            HandleExampleBundle(target);
        }
        if (AppConst.LuaBundleMode) {
            HandleBundle();
        } else {
            string luaPath = AppDataPath + "/StreamingAssets/lua/";
            string[] luaPaths = { AppDataPath + "/LuaFramework/lua/", 
                              AppDataPath + "/LuaFramework/Tolua/Lua/"};
            HandleLuaFile(luaPath,luaPaths);
            luaPath = AppDataPath + "/StreamingAssets/game/src/";
            string[] gamePaths = { AppDataPath + "/LuaFramework/game/src/" };
            HandleLuaFile(luaPath,gamePaths);
        }
        BuildFileIndex();
        AssetDatabase.Refresh();
    }

	public static void BuildAsset(BuildTarget target) {

		if (AppConst.ExampleMode) {
			HandleExampleBundle(target);
		}

		BuildFileIndex();

		AssetDatabase.Refresh();
	}

    static void HandleBundle() {
        BuildLuaBundles();
        string luaPath = AppDataPath + "/StreamingAssets/lua/";
        string[] luaPaths = { AppDataPath + "/LuaFramework/lua/", 
                              AppDataPath + "/LuaFramework/Tolua/Lua/",
			// by wsp
			// 打包加入自定义目录
			AppDataPath + "/LuaFramework/game/src"
		};

        for (int i = 0; i < luaPaths.Length; i++) {
            paths.Clear(); files.Clear();
            string luaDataPath = luaPaths[i].ToLower();
            Recursive(luaDataPath);
            foreach (string f in files) {
                if (f.EndsWith(".meta") || f.EndsWith(".lua")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string path = Path.GetDirectoryName(luaPath + newfile);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                string destfile = path + "/" + Path.GetFileName(f);
                File.Copy(f, destfile, true);
            }
        }
    }

    static void ClearAllLuaFiles() {
        string osPath = Application.streamingAssetsPath + "/" + LuaConst.osDir;

        if (Directory.Exists(osPath)) {
            string[] files = Directory.GetFiles(osPath, "Lua*.unity3d");

            for (int i = 0; i < files.Length; i++) {
                File.Delete(files[i]);
            }
        }

        string path = osPath + "/Lua";

        if (Directory.Exists(path)) {
            Directory.Delete(path, true);
        }

        path = Application.dataPath + "/Resources/Lua";

        if (Directory.Exists(path)) {
            Directory.Delete(path, true);
        }

        path = Application.persistentDataPath + "/" + LuaConst.osDir + "/Lua";

        if (Directory.Exists(path)) {
            Directory.Delete(path, true);
        }
    }

    static void CreateStreamDir(string dir) {
        dir = Application.streamingAssetsPath + "/" + dir;

        if (!File.Exists(dir)) {
            Directory.CreateDirectory(dir);
        }
    }

    static void CopyLuaBytesFiles(string sourceDir, string destDir, bool appendext = true) {
        if (!Directory.Exists(sourceDir)) {
            return;
        }

        string[] files = Directory.GetFiles(sourceDir, "*.lua", SearchOption.AllDirectories);
        int len = sourceDir.Length;

        if (sourceDir[len - 1] == '/' || sourceDir[len - 1] == '\\') {
            --len;
        }

        for (int i = 0; i < files.Length; i++) {
            string str = files[i].Remove(0, len);
            string dest = destDir + str;
            if (appendext) dest += ".bytes";
            string dir = Path.GetDirectoryName(dest);
            Directory.CreateDirectory(dir);

            if (AppConst.LuaByteMode) {
                Packager.EncodeLuaFile(files[i], dest);
            } else {
                File.Copy(files[i], dest, true);
            }
        }

    }

    static void BuildLuaBundles() {
        ClearAllLuaFiles();
        CreateStreamDir("lua/");
        CreateStreamDir(AppConst.LuaTempDir);
        CreateStreamDir("game/");

        string dir = Application.persistentDataPath;
        if (!File.Exists(dir)) {
            Directory.CreateDirectory(dir);
        }

        string streamDir = Application.dataPath + "/" + AppConst.LuaTempDir;
        CopyLuaBytesFiles(CustomSettings.luaDir, streamDir);
        CopyLuaBytesFiles(CustomSettings.FrameworkPath + "/ToLua/Lua", streamDir);

        string gameDir = Application.dataPath + "/game/";
        CopyLuaBytesFiles(CustomSettings.FrameworkPath + "/game", gameDir);

        AssetDatabase.Refresh();

        string[] gamedirs = Directory.GetDirectories(gameDir, "*", SearchOption.AllDirectories);
        for (int i = 0; i < gamedirs.Length; i++) {
            string str = gamedirs[i].Remove(0, gameDir.Length);
            BuildLuaBundle(str,"game");
        }

        string[] dirs = Directory.GetDirectories(streamDir, "*", SearchOption.AllDirectories);

        for (int i = 0; i < dirs.Length; i++) {
            string str = dirs[i].Remove(0, streamDir.Length);
            BuildLuaBundle(str,"Lua");
        }

        BuildLuaBundle(null,"lua");
        BuildLuaBundle(null, "game");
        Directory.Delete(streamDir, true);
        Directory.Delete(gameDir, true);
        AssetDatabase.Refresh();
    }

    static void BuildLuaBundle(string dir,string form) {
        BuildAssetBundleOptions options = BuildAssetBundleOptions.CollectDependencies | BuildAssetBundleOptions.CompleteAssets |
                                          BuildAssetBundleOptions.DeterministicAssetBundle | BuildAssetBundleOptions.UncompressedAssetBundle;
        string path = "Assets/" + form + "/" + dir;
        string[] files = Directory.GetFiles(path, "*.lua.bytes");
        List<Object> list = new List<Object>();
        string bundleName = "lua.unity3d";
        if (form == "game")
        {
            bundleName = "game.unity3d";
        }
        string temp = form;
        if (dir != null) {
            /*if(form == "game") {
                temp = "game";
            }*/
            dir = dir.Replace('\\', '_').Replace('/', '_');
            bundleName = temp.ToLower() + "_" + dir.ToLower() + AppConst.ExtName;
        }
        for (int i = 0; i < files.Length; i++) {
            Object obj = AssetDatabase.LoadMainAssetAtPath(files[i]);
            list.Add(obj);
        }

        if (files.Length > 0) {
            if(form != "")
            {
                form = form + "/";
            }
            string output = Application.streamingAssetsPath + "/"+ form + bundleName;
            if (File.Exists(output)) {
                File.Delete(output);
            }
            BuildPipeline.BuildAssetBundle(null, list.ToArray(), output, options, EditorUserBuildSettings.activeBuildTarget);
            AssetDatabase.Refresh();
        }
    }

    static void HandleExampleBundle(BuildTarget target) {
        Object mainAsset = null;        //主素材名，单个
        Object[] addis = null;     //附加素材名，多个
        string assetfile = string.Empty;  //素材文件名

        BuildAssetBundleOptions options = BuildAssetBundleOptions.UncompressedAssetBundle |
                                          BuildAssetBundleOptions.CollectDependencies |
                                          BuildAssetBundleOptions.DeterministicAssetBundle;
        string dataPath = Util.DataPath;
        if (Directory.Exists(dataPath)) {
            Directory.Delete(dataPath, true);
        }
        string assetPath = AppDataPath + "/StreamingAssets/game/AssetBounld/";
        if (Directory.Exists(dataPath)) {
            Directory.Delete(assetPath, true);
        }
        if (!Directory.Exists(assetPath)) Directory.CreateDirectory(assetPath);

        string[] prefabPaths = { AppDataPath + "/LuaFramework/game/saveassert",
                              AppDataPath + "/LuaFramework/game/userassert" };

        for (int i = 0; i < prefabPaths.Length; i++) {
            paths.Clear(); files.Clear();
            string luaDataPath = prefabPaths[i].ToLower();
            Recursive(luaDataPath);
            foreach (string f in files) {
                if (!f.EndsWith(".prefab") && !f.EndsWith(".mp3")) continue;
                string head = AppDataPath + "/luaframework/game/";
                string asseturl = f.Replace (head, "");
                mainAsset = LoadAsset(asseturl);
                string BounldName = asseturl.Remove(0,asseturl.LastIndexOf("/") + 1);
                string assetBounldName = BounldName.Remove(BounldName.LastIndexOf("."));
				assetfile = assetPath + assetBounldName.ToLower() + AppConst.ExtName;
                BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
            } 
        }
        ///-----------------------------生成共享的关联性素材绑定-------------------------------------
        // BuildPipeline.PushAssetDependencies();

        // assetfile = assetPath + "shared" + AppConst.ExtName;
        // mainAsset = LoadAsset("Shared/Atlas/Dialog.prefab");
        // BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);

        ///------------------------------生成PromptPanel素材绑定-----------------------------------
        // BuildPipeline.PushAssetDependencies();
        // mainAsset = LoadAsset("Prompt/Prefabs/PromptPanel.prefab");
        // addis = new Object[1];
        // addis[0] = LoadAsset("Prompt/Prefabs/PromptItem.prefab");
        // assetfile = assetPath + "prompt" + AppConst.ExtName;
        // BuildPipeline.BuildAssetBundle(mainAsset, addis, assetfile, options, target);
        // BuildPipeline.PopAssetDependencies();

        ///------------------------------生成MessagePanel素材绑定-----------------------------------
        // BuildPipeline.PushAssetDependencies();
        // mainAsset = LoadAsset("Message/Prefabs/MessagePanel.prefab");
        // assetfile = assetPath + "message" + AppConst.ExtName;
        // BuildPipeline.BuildAssetBundle(mainAsset, null, assetfile, options, target);
        // BuildPipeline.PopAssetDependencies();

        // ///-------------------------------刷新---------------------------------------
        // BuildPipeline.PopAssetDependencies();
    }

    /// <summary>
    /// 处理Lua文件
    /// </summary>
    static void HandleLuaFile(string copydir,string[] luaPaths) {
        string luaPath = copydir;//AppDataPath + "/StreamingAssets/lua/";

        //----------复制Lua文件----------------
        if (!Directory.Exists(luaPath)) {
            Directory.CreateDirectory(luaPath); 
        }
        // string[] luaPaths = resPath;

        for (int i = 0; i < luaPaths.Length; i++) {
            paths.Clear(); files.Clear();
            string luaDataPath = luaPaths[i].ToLower();
            Recursive(luaDataPath);
            int n = 0;
            foreach (string f in files) {
                if (f.EndsWith(".meta")) continue;
                string newfile = f.Replace(luaDataPath, "");
                string newpath = luaPath + newfile;
                string path = Path.GetDirectoryName(newpath);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);

                if (File.Exists(newpath)) {
                    File.Delete(newpath);
                }
                if (AppConst.LuaByteMode) {
                    EncodeLuaFile(f, newpath);
                } else {
                    File.Copy(f, newpath, true);
                }
                UpdateProgress(n++, files.Count, newpath);
            } 
        }
        EditorUtility.ClearProgressBar();
        AssetDatabase.Refresh();
    }

    static void BuildFileIndex() {
        string resPath = AppDataPath + "/StreamingAssets/";
        ///----------------------创建文件列表-----------------------
        string newFilePath = resPath + "/files.txt";
        if (File.Exists(newFilePath)) File.Delete(newFilePath);

        paths.Clear(); files.Clear();
        Recursive(resPath);

        FileStream fs = new FileStream(newFilePath, FileMode.CreateNew);
        StreamWriter sw = new StreamWriter(fs);
        for (int i = 0; i < files.Count; i++) {
            string file = files[i];
            string ext = Path.GetExtension(file);
            if (file.EndsWith(".meta") || file.Contains(".DS_Store")) continue;

            string md5 = Util.md5file(file);
            string value = file.Replace(resPath, string.Empty);
            FileInfo fileinfo = new FileInfo(file);
            sw.WriteLine(value + "|" + md5 + "|" + fileinfo.Length);
        }
        sw.Close(); fs.Close();
    }

    /// <summary>
    /// 数据目录
    /// </summary>
    static string AppDataPath {
        get { return Application.dataPath.ToLower(); }
    }

    /// <summary>
    /// 遍历目录及其子目录
    /// </summary>
    static void Recursive(string path) {
        string[] names = Directory.GetFiles(path);
        string[] dirs = Directory.GetDirectories(path);
        foreach (string filename in names) {
            string ext = Path.GetExtension(filename);
            if (ext.Equals(".meta")) continue;
            files.Add(filename.Replace('\\', '/'));
        }
        foreach (string dir in dirs) {
            string md = dir.Replace('\\', '/');
            //string ss = AppDataPath + "/luaframework/game/saveassert/Sanshui"; 
            //string us = AppDataPath + "/luaframework/game/userassert/Sanshui";md != ss && md != us && 
            string nu = AppDataPath + "/luaframework/game/userassert/Notice";
            string ns = AppDataPath + "/luaframework/game/saveassert/Notice"; 
            string test = AppDataPath + "/luaframework/game/userassert/Test";
            if (md != test && nu != md && md != ns)
            {
                paths.Add(md);
                Recursive(md);
            }
            //paths.Add(dir.Replace('\\', '/'));
            //Recursive(dir);
        }
    }
		
	static void CopyProtobuf(){
		string src = CustomSettings.FrameworkPath + "/Lua/3rd/pbc/packets.pb";
		string des = AppDataPath + "/StreamingAssets/lua/3rd/pbc/packets.pb";
		string luaframework_des = Util.DataPath + "lua/3rd/pbc/packets.pb";
		File.Copy(src, des, true);
		File.Copy(src, luaframework_des, true);
	}

    static void UpdateProgress(int progress, int progressMax, string desc) {
        string title = "Processing...[" + progress + " - " + progressMax + "]";
        float value = (float)progress / (float)progressMax;
        EditorUtility.DisplayProgressBar(title, desc, value);
    }

    public static void EncodeLuaFile(string srcFile, string outFile) {
        if (!srcFile.ToLower().EndsWith(".lua")) {
            File.Copy(srcFile, outFile, true);
            return;
        }
        bool isWin = true; 
        string luaexe = string.Empty;
        string args = string.Empty;
        string exedir = string.Empty;
        string currDir = Directory.GetCurrentDirectory();
        if (Application.platform == RuntimePlatform.WindowsEditor) {
            isWin = true;
            luaexe = "luajit.exe";
            args = "-b " + srcFile + " " + outFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luajit/";
        } else if (Application.platform == RuntimePlatform.OSXEditor) {
            isWin = false;
            luaexe = "./luac";
            args = "-o " + outFile + " " + srcFile;
            exedir = AppDataPath.Replace("assets", "") + "LuaEncoder/luavm/";
        }
        Directory.SetCurrentDirectory(exedir);
        ProcessStartInfo info = new ProcessStartInfo();
        info.FileName = luaexe;
        info.Arguments = args;
        info.WindowStyle = ProcessWindowStyle.Hidden;
        info.UseShellExecute = isWin;
        info.ErrorDialog = true;
        Util.Log(info.FileName + " " + info.Arguments);

        Process pro = Process.Start(info);
        pro.WaitForExit();
        Directory.SetCurrentDirectory(currDir);
    }

    [MenuItem("LuaFramework/Build Protobuf-lua-gen File")]
    public static void BuildProtobufFile() {
        if (!AppConst.ExampleMode) {
            UnityEngine.Debug.LogError("若使用编码Protobuf-lua-gen功能，需要自己配置外部环境！！");
            return;
        }
        string dir = AppDataPath + "/Lua/3rd/pblua";
        paths.Clear(); files.Clear(); Recursive(dir);

        string protoc = "d:/protobuf-2.4.1/src/protoc.exe";
        string protoc_gen_dir = "\"d:/protoc-gen-lua/plugin/protoc-gen-lua.bat\"";

        foreach (string f in files) {
            string name = Path.GetFileName(f);
            string ext = Path.GetExtension(f);
            if (!ext.Equals(".proto")) continue;

            ProcessStartInfo info = new ProcessStartInfo();
            info.FileName = protoc;
            info.Arguments = " --lua_out=./ --plugin=protoc-gen-lua=" + protoc_gen_dir + " " + name;
            info.WindowStyle = ProcessWindowStyle.Hidden;
            info.UseShellExecute = true;
            info.WorkingDirectory = dir;
            info.ErrorDialog = true;
            Util.Log(info.FileName + " " + info.Arguments);

            Process pro = Process.Start(info);
            pro.WaitForExit();
        }
        AssetDatabase.Refresh();
    }

	//刪除所有存檔
	[MenuItem("LuaFramework/Delect Player Prefs")]
	public static void DelectPlayerPrefs() {
		PlayerPrefs.DeleteAll (); 
	}

	// 拷贝pb到StreamingAssets和luaframework文件夹
	[MenuItem("LuaFramework/CopyProtobuf File")]
	public static void BuildCopyProtobuf() {
		CopyProtobuf ();
	}
}