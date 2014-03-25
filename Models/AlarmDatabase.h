//
//  AlarmDatabase.h
//  MyClockIt
//
//  Created by Deepak Bharati on 14/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//
//


#import <Foundation/Foundation.h>
#import "sqlite3.h"
//#import "WeatherViewInfo.h"
#import "AlarmInfo.h"

#import "EDSunriseSet.h"
#import <CoreLocation/CoreLocation.h>

@interface AlarmDatabase : NSObject
{
    sqlite3 *database;
    NSString *databaseName;
	NSString *databasePath;
    
}

+ (AlarmDatabase *)database;

+ (void)resetDatabase;


-(void) saveAlarmToDatabaseWithAlarmInfo:(AlarmInfo *)alarmInfo;
-(void) updateAlarmInDatabaseWithAlarmInfo:(AlarmInfo *)alarmInfo;
-(void) deleteAlarmFromDatabaseWithAlarmId:(int)alarmId;

-(NSArray *)getAllAlarms;
- (AlarmInfo *)getAlarmInfoForAlarmId:(int)alarmId;


- (NSArray *)getAllOldAlarms;

//- (UIImage*)getImageForWeatherCode:(NSInteger)weatherCode;
//- (UIImage *)getImageForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location;


- (void)updateAlarmSoundForSoundName:(NSString *)soundName;

@end
