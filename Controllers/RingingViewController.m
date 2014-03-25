//
//  RingingViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 27/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "RingingViewController.h"
#import "MySound.h"

#import "AlarmDatabase.h"
#import "Theme.h"

#import "HomeViewController.h"// main/root viewController

#import "AlarmSchedular.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>


@interface RingingViewController ()

@property (strong,nonatomic) NSUserDefaults *defaults;

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;

@end

@implementation RingingViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    defaults = [NSUserDefaults standardUserDefaults];
    
    self.alarmLabel.text = self.alarmInfo.label;
    
    
    NSURL *url;
    //NSLog(@"......>>>>%@",[MySound soundWithSoundName:self.alarmInfo.sound]);
    NSRange rangeValue = [[MySound soundWithSoundName:self.alarmInfo.sound] rangeOfString:@"file:///var/mobile/Applications" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0)
    {
        NSLog(@"string contains file:///var/mobile/Applications");
        url = [NSURL URLWithString:[MySound soundWithSoundName:self.alarmInfo.sound]];
    }
    else
    {
        NSString *fileName = [MySound soundWithSoundName:self.alarmInfo.sound];
        NSString *fileNameWithoutExtension = [fileName substringToIndex:[fileName length]-4];
        //NSLog(@"%@",fileName);NSLog(@"%@",fileNameWithoutExtension);
        NSString *path = [[NSBundle mainBundle]pathForResource:fileNameWithoutExtension ofType:@"m4r"];
        //NSLog(@"path:%@",path);
        url = [NSURL fileURLWithPath:path];
    }

    
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    player.numberOfLoops = -1;//infinite loop
    //for playing sound when silent
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
    
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectZero];//to hide the volume controll view
    [self.view addSubview: volumeView];
    volumeView.showsRouteButton = NO;
    volumeView.hidden = YES;
    
    
//    // hide the hardware volume slider
//    UIImage *thumb = [[UIImage alloc] initWithCIImage:[UIImage imageNamed:@"volumeHider"].CIImage scale:0.0 orientation:UIImageOrientationUp];
//    MPVolumeView *hwVolume = [[MPVolumeView alloc] initWithFrame:self.view.frame];
//    [hwVolume setUserInteractionEnabled:NO];
//    hwVolume.showsRouteButton = NO;
//    [hwVolume setVolumeThumbImage:thumb forState:UIControlStateNormal];
//    [hwVolume setMinimumVolumeSliderImage:thumb forState:UIControlStateNormal];
//    [hwVolume setMaximumVolumeSliderImage:thumb forState:UIControlStateNormal];
//    [self.view addSubview:hwVolume];//hwVolume.hidden = YES;

    if(self.allreadySet == NO)
    {
        [defaults setFloat:[self.musicPlayer volume] forKey:@"DeviceVolume"];
        self.allreadySet = YES;
    }
    NSLog(@"DviceVolume: %f",[defaults floatForKey:@"DeviceVolume"]);

    //self.musicPlayer.volume = [defaults floatForKey:@"AppVolume"];
    
    if([defaults boolForKey:@"AlarmFadeInSwitch"] == YES)
    {
        //Fade-in Effect
        self.musicPlayer.volume = 0;
        [player play];
        [self fadeInPlayerVolume];
    }
    else
    {
        self.musicPlayer.volume = [defaults floatForKey:@"AppVolume"];
        [player play];
    }
    
    //    player.volume = [defaults floatForKey:@"AppVolume"];

    
    self.snoozeButton.layer.cornerRadius = 5.0;
    self.iAmAwakeButton.layer.cornerRadius = 5.0;
    self.onlyIAmAwakeButton.layer.cornerRadius = 5.0;
    
    self.snoozeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.iAmAwakeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.onlyIAmAwakeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    

    [self.snoozeButton setTitle: NSLocalizedString(@"SNOOZE_BUTTON", @"Snooze") forState:UIControlStateNormal];
    [self.iAmAwakeButton setTitle: NSLocalizedString(@"AWAKE_BUTTON", @"I'm awake") forState:UIControlStateNormal];
    [self.onlyIAmAwakeButton setTitle: NSLocalizedString(@"AWAKE_BUTTON", @"I'm awake") forState:UIControlStateNormal];
    
    self.onlyIAmAwakeButton.hidden = YES;
    if(self.alarmInfo.snooze == 5)//Never
    {
        self.onlyIAmAwakeButton.hidden = NO;
        
        self.snoozeButton.hidden = YES;
        self.iAmAwakeButton.hidden = YES;
    }
 
}

- (void) viewWillLayoutSubviews
{
    //load again on change in interface orientation
    //NSLog(@"Interface orientation: %d",UIInterfaceOrientationIsPortrait([UIDevice currentDevice].orientation));
    self.backgroundImageView.image = [Theme backgroundImageForCurrentContext];
    
    [self.snoozeButton setTitle: NSLocalizedString(@"SNOOZE_BUTTON", @"Snooze") forState:UIControlStateNormal];
    [self.iAmAwakeButton setTitle: NSLocalizedString(@"AWAKE_BUTTON", @"I'm awake") forState:UIControlStateNormal];
    [self.onlyIAmAwakeButton setTitle: NSLocalizedString(@"AWAKE_BUTTON", @"I'm awake") forState:UIControlStateNormal];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    //status bar text color to white
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (IBAction)snooze:(id)sender
{
    NSLog(@"snooze tapped");
    [player stop];
    int snoozeTimeInterval = [self snoozeTimeIntervalForAlarmInfo:self.alarmInfo];
    
    self.alarmInfo.date = [NSDate dateWithTimeInterval:snoozeTimeInterval sinceDate:[NSDate date]];
//    NSLog(@"^v^v^self.alarmInfo.date:%@",self.alarmInfo.date);
    if(self.alarmInfo.snooze < 5)
    {
        [AlarmSchedular scheduleAlarmWithAlarmInfo:self.alarmInfo];
    }
    else
    {
        self.alarmInfo.status = 0;
        [[AlarmDatabase database]updateAlarmInDatabaseWithAlarmInfo:self.alarmInfo];
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    HomeViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    rootViewController.valueForTimer = snoozeTimeInterval;
    [window setRootViewController:rootViewController];
    
    self.musicPlayer.volume = [defaults floatForKey:@"DeviceVolume"];
    NSLog(@"DviceVolume: %f",[defaults floatForKey:@"DeviceVolume"]);
    
}

- (IBAction)iAmAwake:(id)sender
{
    NSLog(@"i'm awake tapped");
    [player stop];
    
    //set alarm off only for never repeate
    NSLog(@"Repeat Value = %d",self.alarmInfo.repeat);
    if(self.alarmInfo.repeat == 0)
    {
        self.alarmInfo.status = 0;
        [[AlarmDatabase database]updateAlarmInDatabaseWithAlarmInfo:self.alarmInfo];
    }
        
    [self dismissViewControllerAnimated:YES completion:nil];
    UIWindow *window = [[UIApplication sharedApplication]keyWindow];
    HomeViewController *rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [window setRootViewController:rootViewController];
    
    self.musicPlayer.volume = [defaults floatForKey:@"DeviceVolume"];
    NSLog(@"DviceVolume: %f",[defaults floatForKey:@"DeviceVolume"]);

    
}

- (int)snoozeTimeIntervalForAlarmInfo:(AlarmInfo *)alarmInfo
{
    int timeInterval = 0;
    
    switch(alarmInfo.snooze)
    {
        case 0:
            timeInterval = 60*2;//2 minute
            break;
        case 1:
            timeInterval = 60*5;//5 minute
            break;
        case 2:
            timeInterval = 60*10;//10 minute
            break;
        case 3:
            timeInterval = 60*15;//15 minute
            break;
        case 4:
            timeInterval = 60*30;//30 minute
            break;
        case 5:
            timeInterval = 0;//never
            break;
        default:
            break;
    }
    return timeInterval;
}


- (void)fadeInPlayerVolume
{
    if(self.musicPlayer.volume <= [defaults floatForKey:@"AppVolume"] && player.isPlaying)
    {
        self.musicPlayer.volume += 0.05;
    	[self performSelector:@selector(fadeInPlayerVolume) withObject:self afterDelay:3];
    }
    NSLog(@"fadeIn");
}
@end
