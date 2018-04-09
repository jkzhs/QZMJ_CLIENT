using UnityEngine;
using System.Collections;
using System;
using System.Text;
using System.IO;
using LuaInterface;

public class Photo : MonoBehaviour {
	Texture2D cutImage; 
	int ManualWidth = 1280;
	int ManualHeight = 720;
    int size = 720;
	void Start () 
	{
		float radio = (float)ManualHeight / ManualWidth;  
        size = Convert.ToInt32(Screen.width * radio);
	}

	public void startCut(LuaFunction func = null)
	{
        StartCoroutine(CutImage(func));
	}

    public IEnumerator CutImage(LuaFunction func = null)  
	{  
		cutImage = new Texture2D(Screen.width,size, TextureFormat.RGB24, true);  
		yield return new WaitForEndOfFrame();  
		cutImage.ReadPixels(new Rect(0,(Screen.height - size)/2,Screen.width,size), 0, 0, true);

		cutImage.Apply();
		yield return cutImage;
        if (func != null) func.Call();
	}

    public void SaveCutImg()
    {
        byte[] byt = cutImage.EncodeToPNG();
        File.WriteAllBytes(Application.persistentDataPath + "/cutImage.png", byt);
    }

    public string getCutImgPath()
	{
        return Application.persistentDataPath + "/cutImage.png";
	}

}
