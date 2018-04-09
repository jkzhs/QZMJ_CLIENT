using UnityEngine;
using System.Collections;
using LuaFramework;

public class LoadAssets : MonoBehaviour {

	public GameObject MyGameObj;
	public Transform MyTransform;
    public GameObject MyAnima;
    public UITexture texture;
    public UILabel LoadInfo;
    public GameObject bigversion;
    public GameObject showDown;
    public UILabel downsize;
    public UIButton downOk;
    public UIButton button;
    public UILabel content;
    public UILabel textsize;
    private GameManager _main = null;
    public void init(GameManager main)
	{
		_main = main;
        LoadInfo.text = "正在检查版本。。。";
        LoadInfo.gameObject.SetActive(true);
        showDown.SetActive(false);
	}

	public void clear ()
	{
		_main = null;
        MyAnima.SetActive(false);
	}

	public void timeEvent()
	{
		
	}
    
    public void showDownSize(string size)
    {
        showDown.SetActive(true);
        downsize.text = "检测到新的资源包，大小" + size;
        EventDelegate.Add(downOk.onClick, delegate()
        {
            showDown.SetActive(false);
            MyTransform.localPosition = new Vector3(-695.0f, -230.0f, 0.0f);
            _main.StartLoadUpdate();
        });
    }

    public void showStateInit(string text)
    {
        textsize.text = text;
    }

    public void showBigVersion(string text,int state)
    {
        bigversion.SetActive(true);
        content.text = text;
        EventDelegate.Add(button.onClick, delegate()
        {
            if (state == 1)
            {
                _main.startUp();
            }
            else if (state == 2)
            {
					Application.OpenURL(AppConst.WebUrlDown);
            }
            else if (state == 3)
            {
                _main.resertUpdate();
            }
        });
    }

    public void updateAnimaPos(int total,int index,string text)
    {
        LoadInfo.text = text;
        float px = 1280 * index / total;
        MyTransform.localPosition = new Vector3(-695.0f + px, -230.0f, 0.0f);
        texture.width = 61 + (int)px;
    }
}
