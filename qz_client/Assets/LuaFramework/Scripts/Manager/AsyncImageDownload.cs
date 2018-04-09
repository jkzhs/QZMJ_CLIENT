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

        //��ʼ����ͼƬǰ����UITexture����ͼƬ����Ϊռλͼ
        placeholder = Resources.Load("headbg") as Texture;
        texture.mainTexture = placeholder;

        if (url == "" || url == null)
        {
            return;
        }

        //�ж��Ƿ��ǵ�һ�μ�������ͼƬ


        if (!File.Exists (path + url.GetHashCode())) {

            //���֮ǰ�����ڻ����ļ�

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

        //��ͼƬ����������·��

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

        //ֱ����ͼ

        texture.mainTexture = www.texture;

    }

    private static string path
    {
        get{
            return Application.persistentDataPath + "/";
        }
    }
}