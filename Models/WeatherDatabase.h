//
//  WeatherDatabase.h
//  Clock IT
//
//  Created by Deepak Bharati on 30/01/14.
//  Copyright (c) 2014 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "EDSunriseSet.h"//this is neeed for selecting day/night
#import <CoreLocation/CoreLocation.h>


@interface WeatherDatabase : NSObject
{
    sqlite3 *database;
	NSString *databasePathAtDocumentDirectory;
}


+ (WeatherDatabase *)database;

+ (void)resetDatabase;

- (UIImage *)getImageForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location;
- (NSString *)getStringForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location;


@end
