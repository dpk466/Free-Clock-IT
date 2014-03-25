//
//  WeatherDatabase.m
//  Clock IT
//
//  Created by Deepak Bharati on 30/01/14.
//  Copyright (c) 2014 Deepak Bharati. All rights reserved.
//

#import "WeatherDatabase.h"

#import "MySystemPreference.h"

@implementation WeatherDatabase

static WeatherDatabase *database;

#pragma mark - Singleton method
+(WeatherDatabase *)database
{
    if(database==nil)
    {
        database=[[WeatherDatabase alloc]init];
    }
    
    return database;
}

#pragma mark - init & dealloc
-(id)init
{
    
    self =[super init];
    if(self)
    {
        NSLog(@"open WEATHER database");
        NSString *sqLiteDbFromAppBundle = [[NSBundle mainBundle] pathForResource:@"WEATHER"
                                                             ofType:@"sqlite"];
        //        if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK)
        //        {
        //            NSLog(@"Failed to open database!");
        //        }
        //        [self pointToTheDatabase];
        //        [self checkAndCreateDatabase];
        
        
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePathAtDocumentDirectory = [documentsDir stringByAppendingPathComponent:@"WEATHER.sqlite"];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:sqLiteDbFromAppBundle toPath:databasePathAtDocumentDirectory error:nil];
        NSLog(@"databasePathAtDocumentDirectory = %@",databasePathAtDocumentDirectory);
        
        
        if (sqlite3_open([databasePathAtDocumentDirectory UTF8String], &database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

+ (void)resetDatabase
{
    NSLog(@"Resitting WEATHER DB");
    database = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[[WeatherDatabase alloc]init]->databasePathAtDocumentDirectory error:nil];
}

- (void)dealloc
{
    
    NSLog(@"Database Object Deallocated");
    sqlite3_close(database);
    
}

- (UIImage*)getImageForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location
{
    UIImage *image;
    
    EDSunriseSet *sunRiseAndSetTimes;
    
    NSString *dayImageName;
    NSString *nightImageName;
    
    NSString *query=@"SELECT * FROM WEATHER_INFO where WEATHER_CODE=?";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, 1, (int)weatherCode);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSLog(@"Row available for weatherImage");
            //int code = sqlite3_column_int(statement, 0);
            dayImageName = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
            nightImageName = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
            
            NSLog(@"%d | %@ | %@",sqlite3_column_int(statement, 0), dayImageName, nightImageName);
        }
    }
    else
    {
        NSLog(@"Oops! Unable to read database to get weatherImage.");
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil;
    
    sunRiseAndSetTimes = [EDSunriseSet sunrisesetWithTimezone:[NSTimeZone defaultTimeZone] latitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    //NSLog(@"SunRiseAndSetTime: %@\n %@",sunRiseAndSetTimes.sunrise, sunRiseAndSetTimes.sunset);
    if([[NSDate date]  compare:sunRiseAndSetTimes.sunrise] == NSOrderedDescending && [[NSDate date]  compare:sunRiseAndSetTimes.sunset]== NSOrderedAscending)
    {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",dayImageName]];
    }
    else
    {
        image= [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",nightImageName]];
    }
    
    //    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    //    NSInteger currentHour = [components hour];
    //    image = (currentHour > 5 && currentHour <19) ? [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",dayImageName]]
    //                                                 : [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",nightImageName]];
    
    
    
    //NSLog(@"%@",image);
    return image;
}


- (NSString *)getStringForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location
{
    NSString *weatherString;
    
    //Get columnName
    NSString *columnName = [self getColumnName];
    //NSLog(@"columnName: %@ weatherCode: %d",columnName,weatherCode);
    
    //NSString *query= @"select ENG from WEATHER_INFO where WEATHER_CODE=?";
    NSString *query= [NSString stringWithFormat:@"select %@ from WEATHER_INFO where WEATHER_CODE=?",columnName];
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, 1, (int)weatherCode);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSLog(@"Row available for weatherString");
            
            weatherString = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 0)];//4 is NB
            
            
            NSLog(@"%d | %@ | %@",weatherCode, weatherString, columnName);
        }
    }
    else
    {
        NSLog(@"Oops! Unable to read database to get weatherString.");
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil;
    
    return [self absoluteWeatherStringFor:weatherString andLocation:location];
    
}

- (NSString *)getColumnName
{
   return  NSLocalizedString(@"DB_COLUMN",@"Column name in db for weatherString");
}

- (NSString *)absoluteWeatherStringFor:(NSString *)weatherString andLocation:(CLLocation *)location
{
    if ([weatherString rangeOfString:@"/"].location == NSNotFound)
    {
        return weatherString;
    }
    else
    {
        NSArray *nightAndDayString = [weatherString componentsSeparatedByString:@"/"];
        
        EDSunriseSet *sunRiseAndSetTimes;
        sunRiseAndSetTimes = [EDSunriseSet sunrisesetWithTimezone:[NSTimeZone defaultTimeZone] latitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        
        //NSLog(@"SunRiseAndSetTime: %@\n %@",sunRiseAndSetTimes.sunrise, sunRiseAndSetTimes.sunset);
        if([[NSDate date]  compare:sunRiseAndSetTimes.sunrise] == NSOrderedDescending && [[NSDate date]  compare:sunRiseAndSetTimes.sunset]== NSOrderedAscending)
        {
            return [nightAndDayString objectAtIndex:1];//day
        }
        else
        {
            return [nightAndDayString objectAtIndex:0];//night
        }
        
    }
}

@end
