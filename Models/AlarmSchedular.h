//
//  AlarmSchedular.h
//  MyClockIt
//
//  Created by Deepak Bharati on 21/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmInfo.h"

@interface AlarmSchedular : NSObject


+ (void)scheduleAlarmWithAlarmInfo:(AlarmInfo *)alarmInfo;
+ (void)cancelAlarmWithAlarmInfo:(AlarmInfo *)alarmInfo;


@end
