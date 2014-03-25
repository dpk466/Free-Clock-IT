//
//  AlarmInfo.m
//  MyClockIt
//
//  Created by Deepak Bharati on 20/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "AlarmInfo.h"

@implementation AlarmInfo

-(id) initWithAlarmId:(int)alarmid
               repeat:(int)repeatVal
               snooze:(int)snoozeVal
                sound:(NSString *)soundString
                label:(NSString *)labelString
                 date:(NSDate *)dateTime
               status:(int)statusVal
{
    self =[super init];
    if (self)
    {
        self.alarmId=alarmid;
        self.repeat=repeatVal;
        self.snooze=snoozeVal;
        self.sound=soundString;
        self.label=labelString;
        self.date=[self dateWithZeroSecondForDate:dateTime];
        self.status=statusVal;
    }
    return self;
}

- (NSDate *)dateWithZeroSecondForDate:(NSDate *)aDate
{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSHourCalendarUnit |
                                                         NSMinuteCalendarUnit |
                                                         NSSecondCalendarUnit)
                                               fromDate:aDate];
    
    [components setSecond:0];
    return  [calendar dateFromComponents:components];
}

@end
