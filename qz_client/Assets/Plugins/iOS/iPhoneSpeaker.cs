using UnityEngine;
using System.Runtime.InteropServices;

public class iPhoneSpeaker {

#if UNITY_IOS
	[DllImport ("__Internal")]
	private static extern void _forceToSpeaker();
	[DllImport ("__Internal")]
	private static extern bool _voiceAuth();
#endif
	
	public static void ForceToSpeaker() {
#if UNITY_IOS
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			_forceToSpeaker();
		}
#endif
	}

	public static bool VoiceAuth(){
#if UNITY_IOS
		if (Application.platform == RuntimePlatform.IPhonePlayer) {
			return _voiceAuth();
		}
#endif
		return true;
	}

}
