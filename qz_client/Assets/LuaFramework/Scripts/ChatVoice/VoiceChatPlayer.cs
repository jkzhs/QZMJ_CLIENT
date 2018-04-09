using System;
using System.IO;
using UnityEngine;
using VoiceChat;
using System.Collections;
using ICSharpCode.SharpZipLib.Zip;

[RequireComponent(typeof(AudioSource))]
public class VoiceChatPlayer : MonoBehaviour
{
    NSpeex.SpeexDecoder speexDec = new NSpeex.SpeexDecoder(NSpeex.BandMode.Narrow);

    int index = 0;

    float[] data;
    byte[] cacheData;
    byte[] tempSendAllData;
    int sendLen = 0;
    byte[] SendData;
    [SerializeField]
    int voiceMaxLen = 10;

	float audioVolume = 0;

    [HideInInspector]
    public const int compressLen = 150;

    //lua接口
    public System.Action<int,byte[]> onSendVoice;
    public System.Action onCommitVoice;

    private VoiceChatRecorder recorder;
    private AudioSource source;

    void Start(){
		recorder = GetComponent<VoiceChatRecorder> ();

		int size = VoiceChatSettings.Instance.Frequency * voiceMaxLen;
		source = GetComponent<AudioSource> ();
		source.loop = false;
		source.clip = AudioClip.Create ("VoiceChat", size, 1, VoiceChatSettings.Instance.Frequency, false);
		audioVolume = source.volume;
		source.playOnAwake = true;
		data = new float[size];
		cacheData = new byte[size];
		SendData = new byte[10];
        // 37500 = 150 * 16000 * 10 / 640
		int allsize = compressLen * size / VoiceChatSettings.Instance.SampleSize;
		tempSendAllData = new byte[allsize];
		if (VoiceChatSettings.Instance.LocalDebug) {
            if(VoiceChatRecorder.Instance){
                VoiceChatRecorder.Instance.NewSample += OnNewSample;
            }
		}
    }

    //开始录音
    public void StartRecording(){
#if UNITY_IOS
        if(!VoiceChatPlayer.VoiceAuth()) return;
#endif
        Stop();
        if(recorder == null) return;
        recorder.StartRecording();
        recorder.setTransmitToggled(true);
    }

    //结束录音
    public void StopRecording(){
        if(recorder == null) return;
        recorder.setTransmitToggled(false);
        recorder.StopRecording();
        Stop();
    }

    //设置声音信息
    public void addCacheDataByte(byte[] data){
        for(int i = 0;i < data.Length;i += compressLen){
            int index = (int)(i / compressLen) * 640;
            Array.Copy(data,i,cacheData,index,compressLen);
        }
        PlayRecording(data.Length);
    }

    //播放录音
    public void PlayRecording(int voiceLen){
        if(source == null) return;
        iPhoneSpeaker.ForceToSpeaker();
        int size = VoiceChatSettings.Instance.SampleSize;
        voiceLen = voiceLen / compressLen * size;
        VoiceChatPacket packet = new VoiceChatPacket();
        packet.Compression = VoiceChatSettings.Instance.Compression;
        packet.Data = VoiceChatBytePool.Instance.Get();
        packet.Length = compressLen;
        for(int i = 0;i < voiceLen;i += size){
            float[] sample = null;
            Array.Copy(cacheData,i,packet.Data,0,size);
            int length = VoiceChatUtils.Decompress(speexDec, packet, out sample);
            Array.Copy(sample,0,data,i,length);
            VoiceChatFloatPool.Instance.Return(sample);
        }
        source.clip.SetData(data, 0);
        source.Play();
        // isPlaying = true;
        VoiceChatBytePool.Instance.Return(packet.Data);
    }

    public void Stop()
    {
        if(source == null) return;
        source.Stop();
        source.time = 0;
        index = 0;
        sendLen = 0;
        Array.Clear(data,0,data.Length);
        Array.Clear(cacheData,0,cacheData.Length);
        Array.Clear(tempSendAllData,0,tempSendAllData.Length);
    }

    public void getSendAllData()
    {
        if(onSendVoice != null){
            SendData = new byte[sendLen];
            Array.Copy(tempSendAllData,0,SendData,0,sendLen);
            onSendVoice(SendData.Length, SendData);
        }
        //return SendData;
    }

    byte[] tempSendData = new byte[compressLen];
    public void OnNewSample(VoiceChatPacket packet)
    {
        //if(onSendVoice != null){
            //Array.Copy(packet.Data,0,tempSendData,0,compressLen);
            Array.Copy(packet.Data,0,tempSendAllData,sendLen,compressLen);
            sendLen += compressLen;
            //onSendVoice(tempSendData);
        //}
        // Array.Copy(packet.Data,0,cacheData,index,VoiceChatSettings.Instance.SampleSize);
        index += VoiceChatSettings.Instance.SampleSize;
        // auto stop
        if (index >= source.clip.samples)
        {
            if(onCommitVoice != null){
                onCommitVoice();
            }
        }
    }

    // 判断是否有麦克风权限
    public static bool VoiceAuth(){
        return iPhoneSpeaker.VoiceAuth();
    }

    // 保存语音文件
    // @param isOverWrite 已存在该文件是否覆盖重写
    public static void SaveVoice(string path,byte[] data,bool isOverWrite = false){
        bool isSave = false;
        if(File.Exists(path)){
            if(isOverWrite){
                isSave = true;
            }
        }else{
            isSave = true;
        }
        if(isSave){
            File.WriteAllBytes(path,data);
        }
    }

    // 加载语音文件
    public static byte[] LoadVoice(string path){
        if(File.Exists(path)){
            return File.ReadAllBytes(path);
        }
        return null;
    }

    // 删除语音文件
    public static void DeleteVoice(string path){
        if(File.Exists(path)){
            File.Delete(path);
        }
    }
} 
