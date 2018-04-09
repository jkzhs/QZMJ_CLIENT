using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.IO;
using System.Collections.Generic;

public class AsyncImageDownload : MonoBehaviour
{
    public  Texture placeholder;

    public UITexture texture;

    public  AsyncImageDownload  Instance;

    void Start()
    {
        //placeholder = Resources.Load("headbg") as Texture;
    }

    public void SetAsyncImage(string url){

        //开始下载图片前，将UITexture的主图片设置为占位图
        placeholder = Resources.Load("headbg") as Texture;
        texture.mainTexture = placeholder;

        if (url == "" || url == null)
        {
            return;
        }

        //判断是否是第一次加载这张图片


        if (!File.Exists (path + url.GetHashCode())) {

            //如果之前不存在缓存文件

            StartCoroutine (DownloadImage (url));

        }

        else {
            
            StartCoroutine(LoadLocalImage(url));

        }

    }
    int limitI = 100;
    IEnumerator  DownloadImage(string url){

        //Debug.Log("downloading new image:"+path+url.GetHashCode());
        int qualityI = 100;
        WWW www = new WWW (url);

        yield return www;

        Texture2D image = www.texture;

        //将图片保存至缓存路径

        byte[] pngData = image.EncodeToJPG(qualityI);
        while ((pngData.Length / 1024) >= limitI)
        {
            qualityI -= 5;
            pngData = image.EncodeToJPG(qualityI);
        }

        File.WriteAllBytes(path+url.GetHashCode(), pngData); 

        texture.mainTexture = image;

    }

    IEnumerator  LoadLocalImage(string url){

        string filePath = "file:///" + path + url.GetHashCode ();

        //Debug.Log("getting local image:"+filePath);

        WWW www = new WWW (filePath);

        yield return www;

        //直接贴图

        texture.mainTexture = www.texture;

    }

    private static string path
    {
        get{
            return Application.persistentDataPath + "/";
        }
    }
}