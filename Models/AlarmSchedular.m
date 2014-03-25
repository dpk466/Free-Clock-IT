//
//  AlarmSchedular.m
//  MyClockIt
//
//  Created by Deepak Bharati on 21/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "AlarmSchedular.h"
#import "MySound.h"



@interface AlarmSchedular()


@end


@implementation AlarmSchedular


- (id)init
{
    self = [super init];
    return self;
}


+ (void)scheduleAlarmWithAlarmInfo:(AlarmInfo *)alarmInfo
{
    NSLog(@"Going to schedule: %d",alarmInfo.alarmId);
    
    NSDate *alarmTime;
    
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    localNotification.alertBody = alarmInfo.label;//@"Hey! wake up";
    localNotification.timeZone = [NSTimeZone localTimeZone];
    NSRange rangeValue = [[MySound soundWithSoundName:alarmInfo.sound] rangeOfString:@"file:///var/mobile/Applications" options:NSCaseInsensitiveSearch];
    if (rangeValue.length > 0)
    {
        //localNotification.soundName = [NSString stringWithFormat:@"%@30",[MySound soundWithSoundName:alarmInfo.sound]];
        //NSLog(@"soundName: %@30",[MySound soundWithSoundName:alarmInfo.sound]);
        //since there is no option to give notification sound as file path we are using the notification as follow...
        localNotification.soundName = @"tickTockJam.m4r";
        NSLog(@"soundName: tickTockJam.m4r");
    }
    else
    {
//        NSString *fileName = [MySound soundWithSoundName:alarmInfo.sound];
//        NSString *fileNameWithoutExtension = [fileName substringToIndex:[fileName length]-4];
//        //NSLog(@"%@",fileName);NSLog(@"%@",fileNameWithoutExtension);
//        NSString *path = [[NSBundle mainBundle]pathForResource:fileNameWithoutExtension ofType:@"m4r"];
//        //NSLog(@"path:%@",path);
//        NSURL *url = [NSURL fileURLWithPath:path];
//        localNotification.soundName =[url absoluteString];
//        NSLog(@"soundName: %@",[url absoluteString]);

        localNotification.soundName = [MySound soundWithSoundName:alarmInfo.sound];
        NSLog(@"soundName: %@",[MySound soundWithSoundName:alarmInfo.sound]);
    }
    localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt: alarmInfo.alarmId] forKey:@"Info"];
    
    //scheduling logic
    
    if(alarmInfo.repeat == 0)
    {
        alarmTime = alarmInfo.date;
        while ([alarmTime compare:[NSDate date]]==NSOrderedAscending) //alarmTime < currentTime
        {
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:1];
            alarmTime = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:alarmTime options:0];
        }
        
        NSLog(@"fireDate: %@",[format stringFromDate:alarmTime]);

        localNotification.fireDate = alarmTime;
        [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
    }
    else
    {
        int repeatInteger = alarmInfo.repeat;
        while (repeatInteger)
        {
            int repeatDayValue = repeatInteger%10;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:alarmInfo.date];
            int alarmDayValue = (int)[components weekday];//NSLog(@"alarmDayValue: %d",alarmDayValue);
            
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:repeatDayValue-alarmDayValue];
            alarmTime = [[NSCalendar currentCalendar] dateByAddingComponents:comps toDate:alarmInfo.date options:0];
            
            NSLog(@"fireDate: %@ |Day: %d",[format stringFromDate:alarmTime], repeatDayValue);

            localNotification.fireDate = alarmTime;
            localNotification.repeatInterval = NSWeekCalendarUnit;
            
            [[UIApplication sharedApplication]scheduleLocalNotification:localNotification];
            repeatInteger = repeatInteger/10;
        }
    }
    
    NSLog(@"Alarm with alarmId: %@ is scheduled",[localNotification.userInfo objectForKey:@"Info"]);
}

+ (void)cancelAlarmWithAlarmInfo:(AlarmInfo *)alarmInfo
{
    NSMutableArray *notificationArray=[[NSMutableArray alloc] initWithArray:[[UIApplication sharedApplication]scheduledLocalNotifications]];
    NSLog(@"Going to cancle: %d",alarmInfo.alarmId);
    for(UILocalNotification *notification in notificationArray)
    {
        NSLog(@"notification.userInfo: %@",[notification.userInfo objectForKey:@"Info"]);
        if([notification.userInfo objectForKey:@"Info"] == [NSNumber numberWithInt:alarmInfo.alarmId])
        {
            NSLog(@"Alarm with alarmId: %@ is cancled",[notification.userInfo objectForKey:@"Info"]);
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}



@end
