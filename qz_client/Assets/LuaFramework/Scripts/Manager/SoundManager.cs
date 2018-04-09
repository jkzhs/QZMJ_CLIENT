using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework 
{
	public class SoundManager : Manager 
	{
		private AudioSource audio;
		private Hashtable sounds = new Hashtable();
		string backSoundKey = "";
		private float backVolmn = 1;
		private float soundVolmn = 1;
        public bool initialize = false;
		void Start() 
		{
			audio = GetComponent<AudioSource>();
			if (audio == null)
				gameObject.AddComponent<AudioSource> ();
            int btnvalue = PlayerPrefs.GetInt("BtnRoller");
            int bgvalue = PlayerPrefs.GetInt("BgRoller");
            if (bgvalue != 0)
            {
                backVolmn = PlayerPrefs.GetFloat("BgVolmn");
            }
            if (btnvalue != 0) 
            {
                soundVolmn = PlayerPrefs.GetFloat("BtnVolmn");
            }
            initialize = true;
		}

		//�ص�����ԭ��
		private delegate void GetBack(AudioClip clip, string key);

		//��ȡ������Դ
		private void Get(string abName, GetBack cb)
		{
			string key = abName;
			if(sounds [key] == null) 
			{
				ResManager.LoadAudioClip(abName, (objs)=>
					{
						if(objs == null)
						{
							//Debug.Log("PlayBackSound fail " + abName);
							cb(null,key);
							return;
						}
						else
						{
							sounds.Add(key, objs);
							cb(objs as AudioClip ,key);
							return;
						}
					});
			} 
			else
			{
				cb(sounds [key] as AudioClip,key);
				return;
			}
		}

		//���ű�������
		public void PlayBackSound(string abName)
		{
            if (backSoundKey == abName)
            {
                return;
            }
			backSoundKey = abName;
			Get(abName,(clip, key)=>
				{
					if(clip == null)
						return;
					if(key != backSoundKey)
						return;
					
					audio.loop = true;
					audio.clip = clip;
					audio.volume = backVolmn;
					audio.Play();
				});
		}


		//ֹͣ��������
		public void StopBackSound()
		{
			backSoundKey = "";
			audio.Stop ();
		}

        //��ͣ��������
        public void PauseBackSound()
        {
            audio.Pause();
        }
		public void PlayMusic(){
			audio.Play();
		}

		//������Ч
		public void PlaySound(string abName)
		{
			Get(abName,(clip, key)=>
				{
					if(clip == null)
						return;
					if(Camera.main == null)
						return;
					AudioSource.PlayClipAtPoint(clip, Camera.main.transform.position,soundVolmn); 
				});
		}

		public void setBackSoundVolmn(float value)
		{
			if(sounds [backSoundKey] != null)
			{
				audio.volume = value;
				PlayerPrefs.SetFloat ("BgVolmn",value);
				backVolmn = value;
			}
		}

		public void setSoundVolmn(float value)
		{
			PlayerPrefs.SetFloat ("BtnVolmn", value);
			soundVolmn = value;
		}
	}
}