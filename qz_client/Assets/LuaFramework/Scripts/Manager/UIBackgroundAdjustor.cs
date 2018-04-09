using UnityEngine;
using System.Collections;

public class UIBackgroundAdjustor : MonoBehaviour
{
    // the design size
    public float standard_width = 1280f;
    public float standard_height = 720f;
    void Awake()
    {
        SetBackgroundSize();
    }
    private void SetBackgroundSize()
    {
        float device_width = Screen.width;
        float device_height = Screen.height;
        if (transform != null)
        {
            //m_back_sprite.MakePixelPerfect ();
            //float back_width =   m_back_sprite.transform.localScale.x;
            //float back_height =   m_back_sprite.transform.localScale.y;
            float standard_aspect = standard_width / standard_height;
            float device_aspect = device_width / device_height;
            //float extend_aspect =   0f;
            float scale = 0f;
            /*if (device_aspect > standard_aspect)
            { //按宽度适配
                scale = device_aspect / standard_aspect;// + 0.00f;
                //extend_aspect   = back_width / standard_width;
                transform.localScale = new Vector3(scale, 1, 1);
            }
            else*/
            //{ //按高度适配
                scale = standard_aspect / device_aspect;// + 0.00f;
                //extend_aspect   = back_height / standard_height;
                transform.localScale = new Vector3(1, scale, 1);
            //}
        }
    }
    // Use this for initialization
    void Start()
    {
    }
    // Update is called once per frame
    void Update()
    {
    }
}