using UnityEngine;
using System.Collections;

namespace LuaFramework {
    /// <summary>
    /// 框架主入口
    /// </summary>
    public class Main : MonoBehaviour {
        public bool IsUpdate = false;
        void Start() {
            AppFacade.Instance.StartUp(IsUpdate);   //启动游戏
        }
    }
}