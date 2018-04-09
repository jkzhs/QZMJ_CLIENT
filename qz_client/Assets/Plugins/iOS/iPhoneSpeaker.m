
#import "iPhoneSpeaker.h"
#import <AVFoundation/AVFoundation.h>


void _forceToSpeaker() {
    // want audio to go to headset if it's connected
    if (_headsetConnected()) {
        return;
    }
    
    OSStatus error;
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    error = AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,
                                     sizeof(audioRouteOverride),
                                     &audioRouteOverride);
    
    if (error) {
        NSLog(@"Audio already playing through speaker!");
    } else {
        NSLog(@"Forcing audio to speaker");
    }
}


bool _headsetConnected() {
    
    UInt32 routeSize = sizeof(CFStringRef);
    CFStringRef route = NULL;
    OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &routeSize, &route);
    
    if (!error &&
        (route != NULL)&&
        ([(__bridge NSString*)route rangeOfString:@"Head"].location != NSNotFound))
    {
        /*  don't think this is needed
            see "the get rule":
            https://developer.apple.com/library/mac/#documentation/CoreFoundation/Conceptual/CFMemoryMgmt/Concepts/Ownership.html#//apple_ref/doc/uid/20001148-CJBEJBHH
        */
        //CFRelease(route);
        
        NSLog(@"Headset connected!");
        return true;
    }
    
    return false;
}

bool _voiceAuth(){
    __block bool bCanRecord = true;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = true;
                } else {
                    bCanRecord = false;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc]  initWithTitle:nil
                                                message:@"请在iPhone的\"设置-隐私-麦克风\"选项中，允许访问手机麦克风。"
                                                delegate:nil
                                                cancelButtonTitle:@"好"
                                                otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    return bCanRecord;
}

// 获取手机电量
float _getBattery(){
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    return [[UIDevice currentDevice] batteryLevel];
}

// 获取信号强度 ios直接获取信号强度的api被封，现在是通过遍历statusbar获取，未必能用
int _getSignalStrength(){
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSString *dataNetworkItemView = nil;

    for (id subview in subviews) {
        if([subview isKindOfClass:    [NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
        dataNetworkItemView = subview;
        break;
        }
     }

    return [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
}