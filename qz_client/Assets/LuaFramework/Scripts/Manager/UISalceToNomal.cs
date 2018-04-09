using UnityEngine;
using System.Collections;

public class UISalceToNomal : MonoBehaviour
{
    // the design size
    public float standard_width = 1280f;
    public float standard_height = 720f;
    public bool IsScale = true;
    void Awake()
    {
        SetUISize();
    }
    private void SetUISize()
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
            if (device_aspect < 1)
            {
                device_aspect = device_height / device_width;
            }
            //float extend_aspect =   0f;
            float startScale = transform.localScale.x;
            float scale = 0f;
            /*if (device_aspect > standard_aspect)
            { //����������
                scale = device_aspect / standard_aspect;// + 0.00f;
                //scale = scale - 1;
                //extend_aspect   = back_width / standard_width;
                transform.localScale = new Vector3(1, scale, 1);
            }
            else*/
            //{ //���߶�����
                scale = standard_aspect / device_aspect;// + 0.00f;
                if (IsScale == false)
                {
                    scale = device_aspect / standard_aspect;
                    transform.localScale = new Vector3(startScale, scale * startScale, 1);
                }else
                {
                    transform.localScale = new Vector3(scale * startScale, startScale, 1);
                }
                //extend_aspect   = back_height / standard_height;
                //scale = scale - 1;
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