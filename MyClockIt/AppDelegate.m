//
//  AppDelegate.m
//  MyClockIt
//
//  Created by Deepak Bharati on 30/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "AppDelegate.h"

#import "AlarmDatabase.h"
#import "AlarmInfo.h"
#import "RingingViewController.h"

#import "MySystemPreference.h"

#import <MediaPlayer/MediaPlayer.h>

#import "AlarmDatabase.h"
#import "AlarmInfo.h"

#import "Flurry.h"

#import "WeatherDatabase.h"


@implementation AppDelegate
{
    
}

@synthesize defaults = defaults;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [Flurry setCrashReportingEnabled:YES];
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry startSession:@"Q5RGYPBXPQS7688T6VX3"];
    
    
    defaults = [NSUserDefaults standardUserDefaults];
    BOOL appNotInstalled = ![defaults boolForKey:@"AppInstalled"];
    if(appNotInstalled)
    {
        NSLog(@"App is installing...");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        //other stuff for app installation
        [self doInitialSetUp];//default value set-up
        
        [self updateDatabaseForExistingUser];
        
        
        
        [defaults setBool:YES forKey:@"AppInstalled"];

        [defaults setBool:YES forKey:@"NewFeatureAdded"];//this is for loading whatsNewView

    }
    else//already installed 2.0x
    {
        
    }
    
    if(![defaults boolForKey:@"NayaBool" ])
    {
        [defaults setBool:YES forKey:@"NewFeatureAdded"];//this is for loading whatsNewView
        [defaults setBool:YES forKey:@"NayaBool"];
    }
    
    NSLog(@"Other codes for didFinishLaunchingWithOptions");

    //make use of previous version
    [self doSomethingWithPreviousVersion];//replace static db
    
    
    NSLog(@"Language_Code: %@",MySystemPreference.deviceLanguageCode);
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //NSLog(@"applicationWillResignActive");
    //[[UIScreen mainScreen] setBrightness:1];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //NSLog(@"applicationDidEnterBackground");
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    NSLog(@"Last Weather Request: %@",[defaults objectForKey:@"LastWeatherRequest"]);
//    NSLog(@"Time diffrence: %f",[[defaults objectForKey:@"LastWeatherRequest"] timeIntervalSinceNow]);
//    if([[defaults objectForKey:@"LastWeatherRequest"] timeIntervalSinceNow] < -3600)
//    {
//        NSLog(@"Request again for weather");
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleWeatherView" object:nil];
//    }
//    else
//    {
//        NSLog(@"No current weather request");
//    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
    
    
    int alarmId = [[notification.userInfo objectForKey:@"Info"]intValue];
    NSLog(@"Alarm with alarmId: %d has rung",alarmId);
    
    AlarmInfo *alarmInfo = [[AlarmDatabase database] getAlarmInfoForAlarmId:alarmId];
    
    RingingViewController *ringingVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"RingingViewController"];
    ringingVC.alarmInfo = alarmInfo;
//    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame: CGRectZero];//to hide the volume controll view
//    [ringingVC.view addSubview: volumeView];

    [self.window setRootViewController:ringingVC];
}

- (void)doInitialSetUp
{
    //Weather switch
    //[defaults setBool:YES forKey:@"WeatherSwitch"];//on
    
    //Auto lock
    [defaults setBool:NO forKey:@"AutoLockSwitch"];//off
    
    //Theme
    [defaults setInteger:0 forKey:@"Theme"];//Moderno
    [defaults setObject:NSLocalizedString(@"MODERNO_TEXT", @"Moderno") forKey:@"ThemeString"];
    
    //Time format
    if([MySystemPreference is24HourFormat])
    {
        [defaults setInteger:1 forKey:@"TimeFormat"];//24-Hr
        [defaults setObject:NSLocalizedString(@"24_HOUR_TEXT", @"24-Hour") forKey:@"TimeFormatString"];
    }
    else
    {
        [defaults setInteger:0 forKey:@"TimeFormat"];//12-Hr
        [defaults setObject:NSLocalizedString(@"12_HOUR_TEXT", @"12-Hour") forKey:@"TimeFormatString"];
    }
    
    //Temperature format
    if([MySystemPreference isMetricSystem])
    {
        [defaults setInteger:0 forKey:@"TemperatureFormat"];//C
        [defaults setObject:NSLocalizedString(@"CELSIUS_TEXT", @"Celsius") forKey:@"TemperatureFormatString"];
    }
    else
    {
        [defaults setInteger:1 forKey:@"TemperatureFormat"];//F
        [defaults setObject:NSLocalizedString(@"FAHRENHEIT_TEXT", @"Fahrenheit") forKey:@"TemperatureFormatString"];
    }
    
    //Alarm volume
    [defaults setFloat:0.5 forKey:@"AppVolume"];

}

-(void)updateDatabaseForExistingUser
{
    
    //fetch all alarms from existing database
    NSLog(@"Fetching existing Database");
//    NSMutableArray * oldAlarmInfos = [[NSMutableArray alloc]init];
    NSMutableArray * oldAlarmInfos = [NSMutableArray arrayWithArray:[[AlarmDatabase database]getAllOldAlarms]];
    
    NSLog(@"Reading existing Database");
    for(AlarmInfo *info in oldAlarmInfos)
    {
        NSLog(@"Old Infos:");
        NSLog(@"%d\n%d\n%d,\n%@\n%@\n%@,\n%d",info.alarmId,info.repeat,info.snooze,info.sound,info.label,info.date,info.status);
    }
    
    NSLog(@"Deleting existing Database");
    //drop old Database from the existing database
    [AlarmDatabase resetDatabase];
    
    NSLog(@"Loading and updating new Database");
    //load cuurrent database and
    //add the fetched content to current database
    for(AlarmInfo *info in oldAlarmInfos)
    {
        [[AlarmDatabase database] saveAlarmToDatabaseWithAlarmInfo:info];
    }
//    NSMutableArray * newAlarmInfos = [[NSMutableArray alloc]init];
    NSMutableArray * newAlarmInfos = [NSMutableArray arrayWithArray:[[AlarmDatabase database] getAllAlarms]];
    NSLog(@"New Infos:");
    for(AlarmInfo *info in newAlarmInfos)
    {
        NSLog(@"%d\n%d\n%d,\n%@\n%@\n%@,\n%d",info.alarmId,info.repeat,info.snooze,info.sound,info.label,info.date,info.status);
    }
    
}

- (void)saveCurrentAppVersion
{
    [defaults setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"AppVersion"];
}

- (void)doSomethingWithPreviousVersion
{
    if(![[defaults objectForKey:@"AppVersion"] isEqualToString:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]])
    {
        NSLog(@"New App version");
        //remove the WEATHER db
        [WeatherDatabase resetDatabase];
        
        //then update ur defaults for Current AppVersion
        [self saveCurrentAppVersion];

    }
    else
    {
        NSLog(@"Same App version");
    }
}
@end
