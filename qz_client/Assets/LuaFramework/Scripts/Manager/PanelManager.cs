using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.IO;

namespace LuaFramework {
    public class PanelManager : Manager {
        private Transform parent;
        private Hashtable curTran = new Hashtable();
        Transform Parent {
            get {
                if (parent == null) {
                    GameObject go = GameObject.FindWithTag("GuiCamera");
                    if (go != null) parent = go.transform;
                }
                return parent;
            }
        }

        /// <summary>
        /// ������壬������Դ������
        /// </summary>
        /// <param name="type"></param>
        public void CreatePanel(string name, LuaFunction func = null) {
            /*string temp = name + "Panel";
            var go = Parent.FindChild(temp);
            if (go == null)
            {
                StartCoroutine(StartCreatePanel(name, func));
            }
            else
            {
                go.gameObject.SetActive(true);
                if (func != null) func.Call(go.gameObject as GameObject);
            }*/
            StartCoroutine(StartCreatePanel(name, func));
        }

        /// <summary>
        /// �������
        /// </summary>
        IEnumerator StartCreatePanel(string name, LuaFunction func = null) {
            string atlasname = name;
            name += "Panel";
            AssetBundle bundle = ResManager.LoadBundle(name);
            GameObject prefab = null;
#if UNITY_5
            prefab = bundle.LoadAsset(name, typeof(GameObject)) as GameObject;
#else
            prefab = bundle.Load(name, typeof(GameObject)) as GameObject;
#endif
            yield return new WaitForEndOfFrame();

            /*var panelObj = Parent.FindChild("UILoadAssets(Clone)");
            if (panelObj != null)
            {
                Destroy(panelObj.gameObject);
            }*/
            if (Parent.FindChild(name) != null || prefab == null)
            {//Parent.FindChild(name) != null ||
                yield break;
            }
            GameObject go = Instantiate(prefab) as GameObject;
            go.name = name;
            go.layer = LayerMask.NameToLayer("UI");
            go.transform.parent = Parent;
            go.transform.localScale = Vector3.one;
            go.transform.localPosition = Vector3.zero;
            var tran = curTran[atlasname];
            if (tran == null)
            {
                curTran.Add(atlasname, go.transform);
            }
            yield return new WaitForEndOfFrame();
            go.AddComponent<LuaBehaviour>().OnInit(bundle);

            if (File.Exists(Util.DataPath + "game/AssetBounld/" + atlasname.ToLower() + AppConst.ExtName))
            {
                Transform st = ((Transform)curTran[atlasname]);
                if (st != null)
                {
                    UISprite[] sp = st.GetComponentsInChildren<UISprite>(true);
                    UIAtlas atlas = ResManager.LoadUrlAssetAltas(atlasname);
                    if (atlas != null)
                    {
                        for (int j = 0; j < sp.Length; j++)
                        {
                            UISprite sprite = sp[j];
                            sprite.atlas = atlas;
                        }
                    }
                }
            }
            if (func != null) func.Call(go);
            //Debug.Log("StartCreatePanel------>>>>" + name);
        }

        public void renderLayerAll (string name,float pz, string scorName, int cameraLayer)
        {
            if (curTran[name] == null)
            {
                return;
            }
            Transform tran = ((Transform)curTran[name]);
            Vector3 tranPoint = tran.position;
            tranPoint.z = pz;
            tran.position = tranPoint;

            Renderer[] renders = tran.GetComponentsInChildren<Renderer>(true);
            int len = renders.Length;
            for (int i = 0; i < len; i++) {
                Renderer render = renders[i];
                Vector3 point = render.transform.position;
                int depth = Mathf.FloorToInt(point.z * -10);
                render.sortingLayerName = scorName;
                render.sortingOrder = depth;
                render.gameObject.layer = cameraLayer; 
            }

            UIPanel[] panels = tran.GetComponentsInChildren<UIPanel>(true);
            int plen = panels.Length;
            for (int i = 0; i < plen; i++) {
                UIPanel panel = panels [i];
                Vector3 point = panel.transform.position;
                int depth = Mathf.FloorToInt(point.z * -10);
                int oldDepth = panel.sortingOrder;
                // panel.sortingLayerName = scorName;
                panel.sortingOrder = depth;
                panel.depth = depth + panel.depth - oldDepth;
                panel.gameObject.layer = cameraLayer;
            }
        }

        /// <summary>
        /// �ر����
        /// </summary>
        /// <param name="name"></param>
        public void ClosePanel(string name) {
            var panelName = name + "Panel";
            var panelObj = Parent.FindChild(panelName);
            if (panelObj == null) return;
            if (curTran[name] != null)
            {
                curTran.Remove(name);
            }
            ResManager.clearBundle(panelName);
            Destroy(panelObj.gameObject);
        }

        public void ClearPrefab(GameObject go) {
            ResManager.clearBundle(go.name);
            Destroy(go);
        }
    }
}