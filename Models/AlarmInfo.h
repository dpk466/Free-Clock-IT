//
//  AlarmInfo.h
//  MyClockIt
//
//  Created by Deepak Bharati on 20/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmInfo : NSObject

@property(nonatomic,assign) int alarmId;
@property(nonatomic,assign) int repeat;
@property(nonatomic,assign) int snooze;
@property(nonatomic,copy) NSString *sound;
@property(nonatomic,copy) NSString *label;
@property(nonatomic,copy) NSDate *date;
@property(nonatomic,assign) int status;

-(id) initWithAlarmId:(int)alarmid
               repeat:(int)repeatVal
               snooze:(int)snoozeVal
                sound:(NSString *)soundString
                label:(NSString *)labelString
                 date:(NSDate *)dateTime
               status:(int)statusVal;

@end
