using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using UnityEngine;
using System.Collections;
using LuaInterface;
using ICSharpCode.SharpZipLib;
using ICSharpCode.SharpZipLib.GZip;

public class MicroPhoneInput : MonoBehaviour
{

    public MicroPhoneInput m_instance;
    public AudioSource audio;
    public float sensitivity = 100;
    public float loudness = 0;

    private static string[] micArray = null;

    const int HEADER_SIZE = 44;

    const int RECORD_TIME = 10;
    // Use this for initialization
    void Start()
    {
        micArray = Microphone.devices;
        InitPhone();
    }

    public void InitPhone()
    {
            if (micArray.Length == 0)
            {
                //Debug.Log("Microphone.devices is null");
            }
            foreach (string deviceStr in Microphone.devices)
            {
                //Debug.Log("device name = " + deviceStr);
            }
            if (micArray.Length == 0)
            {
                //Debug.Log("no mic device");
            }
    }
    /*public static MicroPhoneInput getInstance(GameObject MicObj)
    {
        if (m_instance == null)
        {
            micArray = Microphone.devices;
            if (micArray.Length == 0)
            {
                Debug.LogError("Microphone.devices is null");
            }
            foreach (string deviceStr in Microphone.devices)
            {
                Debug.Log("device name = " + deviceStr);
            }
            if (micArray.Length == 0)
            {
                Debug.LogError("no mic device");
            }

            m_instance = MicObj.AddComponent<MicroPhoneInput>();
            audio = MicObj.GetComponent<AudioSource>();
        }
        return m_instance;
    }*/

    string device = null;
    public string Device
    {
        get { return device; }
        set
        {
            if (value != null && !Microphone.devices.Contains(value))
            {
                //Debug.LogError(value + " is not a valid microphone device");
                return;
            }

            device = value;
        }
    }

    public void StartRecord()
    {
        audio.Stop();
        if (micArray.Length == 0)
        {
            //Debug.Log("No Record Device!");
            return;
        }
        audio.loop = false;
        audio.mute = true;
        audio.clip = Microphone.Start(null, false, RECORD_TIME, 11025); //22050 44100
        while (!(Microphone.GetPosition(null) > 0))
        {
        }
        audio.Play();
        //倒计时
        StartCoroutine(TimeDown());

    }

    public void StopRecord()
    {
        if (micArray.Length == 0)
        {
            //Debug.Log("No Record Device!");
            return;
        }
        if (!Microphone.IsRecording(null))
        {
            return;
        }
        Microphone.End(null);
        audio.Stop();

        //Debug.Log("StopRecord");
    }

    public Byte[] GetClipData()
    {
        if (audio.clip == null)
        {
            //Debug.Log("GetClipData audio.clip is null");
            return null;
        }

        float[] samples = new float[audio.clip.samples];

        audio.clip.GetData(samples, 0);


        Byte[] outData = new byte[samples.Length * 2];
        //Int16[] intData = new Int16[samples.Length];
        //converting in 2 float[] steps to Int16[], //then Int16[] to Byte[]

        int rescaleFactor = 32767; //to convert float to Int16

        for (int i = 0; i < samples.Length; i++)
        {
            short temshort = (short)(samples[i] * rescaleFactor);
            
            Byte[] temdata = System.BitConverter.GetBytes(temshort);

            outData[i * 2] = temdata[0];
            outData[i * 2 + 1] = temdata[1];


        }
        if (outData == null || outData.Length <= 0)
        {
            //Debug.Log("GetClipData intData is null");
            return null;
        }
        /*bool IsSave = AudioSave.Save("test",audio.clip);
        if (IsSave)
        {

        }*/
        /*Debug.Log(audio.clip.samples+"aaaaaaaaaaaa" + outData.Length);
        outData = CompressBytes(outData);
        Debug.Log("GetClipData intData is null++++++" + outData.Length);*/
        //return intData;
        return outData;
    }

    //压缩字节
    public static byte[] CompressBytes(byte[] bytes)
    {
        MemoryStream ms = new MemoryStream();
        GZipOutputStream gzip = new GZipOutputStream(ms);
        gzip.Write(bytes, 0, bytes.Length);
        gzip.Close();
        byte[] press = ms.ToArray();
        return press;
    }

    //解压缩字节
    public static byte[] Decompress(byte[] bytes)
    {
        GZipInputStream gzi = new GZipInputStream(new MemoryStream(bytes));

        MemoryStream re = new MemoryStream();
        int count = 0;
        byte[] data = new byte[4096];
        while ((count = gzi.Read(data, 0, data.Length)) != 0)
        {
            re.Write(data, 0, count);
        }
        byte[] depress = re.ToArray();
        return depress;
    }

    public Int16[] ByteToInt(Byte[] press)
    {
        byte[] data = Decompress(press);
        int i = 0;
        List<short> result = new List<short>();
        while (data.Length - i > 2)
        {
            result.Add(BitConverter.ToInt16(data, i));
            i += 2;
        }
        return result.ToArray();
    }

    public void PlayClipData(Int16[] intArr)
    {

        string aaastr = intArr.ToString();
        long aaalength = aaastr.Length;
       // Debug.LogError("aaalength=" + aaalength);

        string aaastr1 = Convert.ToString(intArr);
        aaalength = aaastr1.Length;
        //Debug.LogError("aaalength=" + aaalength);

        if (intArr.Length == 0)
        {
            //Debug.Log("get intarr clipdata is null");
            return;
        }
        //从Int16[]到float[]
        float[] samples = new float[intArr.Length];
        int rescaleFactor = 32767;
        for (int i = 0; i < intArr.Length; i++)
        {
            samples[i] = (float)intArr[i] / rescaleFactor;
        }

        //从float[]到Clip
        /*AudioSource audioSource = this.GetComponent<AudioSource>();
        if (audioSource.clip == null)
        {
            audioSource.clip = AudioClip.Create("playRecordClip", intArr.Length, 1, 44100, false, false);
        }
        audioSource.clip.SetData(samples, 0);
        audioSource.mute = false;
        audioSource.Play();*/
        if (audio.clip == null)
        {
            //Debug.Log("audio.clip=null");
            return;
        }
        audio.clip.SetData(samples, 0);
        audio.mute = false;
        audio.Play();
    }
    public void PlayRecord()
    {
        if (audio.clip == null)
        {
            //Debug.Log("audio.clip=null");
            return;
        }
        audio.mute = false;
        audio.loop = false;
        audio.Play();
        //Debug.Log("PlayRecord");

    }



    public float GetAveragedVolume()
    {
        float[] data = new float[256];
        float a = 0;
        audio.GetOutputData(data, 0);
        foreach (float s in data)
        {
            a += Mathf.Abs(s);
        }
        return a / 256;
    }

    // Update is called once per frame
    void Update()
    {
        //loudness = GetAveragedVolume() * sensitivity;
        /*if (loudness > 1)
        {
            Debug.Log("loudness = " + loudness);
        }*/
    }

    private IEnumerator TimeDown()
    {
        //Debug.Log(" IEnumerator TimeDown()");
        int time = 0;
        while (time < RECORD_TIME)
        {
            if (!Microphone.IsRecording(null))
            { //如果没有录制
                Debug.Log("IsRecording false");
                yield break;
            }
            //Debug.Log("yield return new WaitForSeconds " + time);
            yield return new WaitForSeconds(1);
            time++;
        }
        if (time >= 10)
        {
            //Debug.Log("RECORD_TIME is out! stop record!");
            StopRecord();
        }
        yield return 0;
    }
}