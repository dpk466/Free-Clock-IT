//
//  AlarmDatabase.m
//  MyClockIt
//
//  Created by Deepak Bharati on 14/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//
//

#import "AlarmDatabase.h"
#import "AlarmInfo.h"


@interface AlarmDatabase()
{
    

}

@end


@implementation AlarmDatabase

static AlarmDatabase *database;

#pragma mark - Singleton method
+(AlarmDatabase *)database
{
    if(database==nil)
    {
        database=[[AlarmDatabase alloc]init];
    }

    return database;
}

#pragma mark - init & dealloc
-(id)init
{
    
    self =[super init];
    if(self)
    {
        NSLog(@"open alarm database");
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"alarm"
                                                              ofType:@"sqlite3"];
//        if (sqlite3_open([sqLiteDb UTF8String], &database) != SQLITE_OK)
//        {
//            NSLog(@"Failed to open database!");
//        }
//        [self pointToTheDatabase];
//        [self checkAndCreateDatabase];
        
        
        
         databaseName = @"alarm.sqlite3";
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:sqLiteDb toPath:databasePath error:nil];
        NSLog(@"database path = %@",databasePath);
        
        if (sqlite3_open([databasePath UTF8String], &database) != SQLITE_OK)
        {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}

+ (void)resetDatabase
{
    NSLog(@"Resitting Alarm DB");
    database = nil;
    [[NSFileManager defaultManager] removeItemAtPath:[[AlarmDatabase alloc]init]->databasePath error:nil];
}

- (void)dealloc
{
    
    NSLog(@"Database Object Deallocated");
    sqlite3_close(database);
    
}

#pragma mark - Save Update & Delete

-(void) saveAlarmToDatabaseWithAlarmInfo:(AlarmInfo *)alarmInfo

{
    sqlite3_stmt *statement;
//    NSString *query=@"insert into alarm(alarmId,repeat,snooze,sound,label,date) VALUES (?,?,?,?,?,?)";
    NSString *query=@"insert into ALARM_INFO (REPEAT, SNOOZE, SOUND, LABEL, DATE_CREATED, STATUS) values (?,?,?,?,?,?)";

    NSLog(@"Prepare to Save");
   
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"Saving...");
        
        sqlite3_bind_int(statement, 1, alarmInfo.repeat);
        sqlite3_bind_int(statement, 2, alarmInfo.snooze);
        sqlite3_bind_text(statement,3, [alarmInfo.sound UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,4, [alarmInfo.label UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement,5, [alarmInfo.date timeIntervalSince1970]);
        sqlite3_bind_int(statement, 6, alarmInfo.status);

        if (sqlite3_step(statement)!= SQLITE_DONE)
        {
            NSLog(@"Save Error:%s",sqlite3_errmsg(database));
        }
        else
        {
            sqlite3_reset(statement);
        }
        
    }//if prepare2 close
    else
    {
        NSLog(@"Oops! Unable to write database to save Alarm Info");

    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil
}

-(void) updateAlarmInDatabaseWithAlarmInfo:(AlarmInfo *)alarmInfo
{
       
    //if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    
    sqlite3_stmt *statement;
    NSString *query=@"update ALARM_INFO set REPEAT=?, SNOOZE=?, SOUND=? ,LABEL=?, DATE_CREATED=?, STATUS=? where ID=?";
    
    NSLog(@"Prepare to Update");
    
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"Updating...");

        sqlite3_bind_int(statement, 1, alarmInfo.repeat);
        sqlite3_bind_int(statement, 2, alarmInfo.snooze);
        sqlite3_bind_text(statement,3 , [alarmInfo.sound UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement,4 , [alarmInfo.label UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_double(statement,5, [alarmInfo.date timeIntervalSince1970]);
        sqlite3_bind_int(statement, 6, alarmInfo.status);
        
        sqlite3_bind_int(statement, 7, alarmInfo.alarmId);
        
        if (sqlite3_step(statement)!= SQLITE_DONE)
        {
            NSLog(@"Update Error:%s",sqlite3_errmsg(database));
        }
        else
        {
            sqlite3_reset(statement);
        }
    }//if prepare2 close
    else
    {
        NSLog(@"Oops! Unable to write database to update Alarm Info");
        
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil
}


-(void) deleteAlarmFromDatabaseWithAlarmId:(int)alarmId
{
    
    sqlite3_stmt *statement;
    NSString *query=@"delete from ALARM_INFO where Id=?";
    NSLog(@"Prepare to Delete");
    
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"Deleting...");
        sqlite3_bind_int(statement, 1, alarmId);
        
        if (sqlite3_step(statement)!= SQLITE_DONE)
        {
            NSLog(@"Delete Error:%s",sqlite3_errmsg(database));
        }
    }//if prepare2 close
    else
    {
        NSLog(@"Oops! Unable to write database to delete Alarm Info");
        
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil;
}

#pragma mark - method to get all Alarms Infos
- (NSArray *)getAllAlarms

{
    NSMutableArray *returnArray=[[NSMutableArray alloc]init];
    
    NSString *query=@"select * from ALARM_INFO";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        //NSLog(@"Availabe Alarm Table");
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            //NSLog(@"row available for Alarm Table");

            int alarmId=sqlite3_column_int(statement, 0);
            int repeat=sqlite3_column_int(statement, 1);
            int snooze=sqlite3_column_int(statement, 2);

            NSString *sound=[[NSString alloc]initWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
            NSString *label=[[NSString alloc]initWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
            NSDate *date= [NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 5)];
            
            int status=sqlite3_column_int(statement, 6);
            //NSLog(@"AlarmName: %@",label);

            AlarmInfo *info=[[AlarmInfo alloc]initWithAlarmId:alarmId repeat:repeat snooze:snooze sound:sound label:label date:date status:status];
            
            [returnArray addObject:info];
        }
    }
    else
    {
        NSLog(@"Oops! Unable to read database to get All AlarmInfos");
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil;
    return returnArray;
}

#pragma mark - method to get an Alarm Info
//used in AppDelegate for setting RingingViewController's property(alarmInfo)
- (AlarmInfo *)getAlarmInfoForAlarmId:(int)alarmId
{
    AlarmInfo *alarmInfo;
    //if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
    
    NSString *query=@"select * from ALARM_INFO where ID=?";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        
        sqlite3_bind_int(statement, 1, alarmId);
        
        if(sqlite3_step(statement)==SQLITE_ROW)
        {
            int alarmId=sqlite3_column_int(statement, 0);
            int repeat=sqlite3_column_int(statement, 1);
            int snooze=sqlite3_column_int(statement, 2);
            
            NSString *sound=[[NSString alloc]initWithUTF8String:(char *) sqlite3_column_text(statement, 3)];
            NSString *label=[[NSString alloc]initWithUTF8String:(char *) sqlite3_column_text(statement, 4)];
            NSDate *date= [NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 5)];
            
            int status=sqlite3_column_int(statement, 6);

            alarmInfo=[[AlarmInfo alloc]initWithAlarmId:alarmId repeat:repeat snooze:snooze sound:sound label:label date:date status:status];
            
            
            
        }//while close
    }
    else
    {
        NSLog(@"Oops! Unable to read database to get an AlarmInfo");
    }
    sqlite3_finalize(statement);
    //sqlite3_close(database);//close only when the database is set to nil;
    return alarmInfo;
    
}

#pragma mark - method to get Image

//get Weather Image from Database
/*- (UIImage*)getImageForWeatherCode:(NSInteger)weatherCode
{
    UIImage *image;
    
    NSString *dayImageName;
    NSString *nightImageName;
    
    NSString *query=@"SELECT * FROM weatherImages where WEATHER_CODE=?";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        sqlite3_bind_int(statement, 1, (int)weatherCode);
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSLog(@"Row available.");
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
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    image = (currentHour > 5 && currentHour <19) ? [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",dayImageName]]
                                                 : [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",nightImageName]];
    
    //NSLog(@"%@",image);
    return image;
}*/

- (UIImage*)getImageForWeatherCode:(NSInteger)weatherCode andLocation:(CLLocation *)location
{
    UIImage *image;
    
    EDSunriseSet *sunRiseAndSetTimes;
    
    NSString *dayImageName;
    NSString *nightImageName;
    
    NSString *query=@"SELECT * FROM weatherImages where WEATHER_CODE=?";
    
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


//called when music alarm is deleted
- (void)updateAlarmSoundForSoundName:(NSString *)soundName
{
    NSString *query=@"update ALARM_INFO set SOUND='Tick tock jam' where SOUND=?";
    
    NSLog(@"Prepare to Update");
    sqlite3_stmt *statement;
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        NSLog(@"Updating alarm sound...");
        sqlite3_bind_text(statement,1 , [soundName UTF8String], -1, SQLITE_TRANSIENT);
        
        if (sqlite3_step(statement)!= SQLITE_DONE)
        {
            NSLog(@"Update Error:%s",sqlite3_errmsg(database));
        }
    }//if prepare2 close
    else
    {
        NSLog(@"Oops! Unable to write database to update Alarm Info's Sound");
        
    }
    sqlite3_finalize(statement);
}

/*
- (WeatherInfo *)weatherInfos
{
    
    //NSMutableArray *weatherInfos = [[NSMutableArray alloc] init];
    WeatherInfo *info;
    //NSString *query = @"SELECT * FROM weatherImages;";
    NSString *query=@"SELECT * FROM weatherImages where WEATHER_CODE=?";
    
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil) == SQLITE_OK)
    {
        //sqlite3_bind_int(statement, 1, weathercode);
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSLog(@"inside if...");
            int weatherCode = sqlite3_column_int(statement, 0);
            NSString *dayImage = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 1)];
            NSString *nightImage = [[NSString alloc] initWithUTF8String:(char *) sqlite3_column_text(statement, 2)];
            
            info = [[WeatherInfo alloc] initWithWeatherCode:weatherCode
                                                    dayIcon:dayImage
                                                  nightIcon:nightImage];
            //[weatherInfos addObject:info];
            
        }
        sqlite3_finalize(statement);
    }
    else
    {
        NSLog(@"Oops! Unable to read database.");
    }
    //return weatherInfos;
    return info;
}
*/

#pragma mark- Reading oldDatabase
- (NSArray *)getAllOldAlarms
{
    NSLog(@"getAllOldAlarms");
    
    //sqlite3 *database;
    NSMutableArray *returnArray=[[NSMutableArray alloc]init];
    
    NSString *query=@"select * from alarm";
    
    query = @"select alarmId, repeat, snooze, sound, label, strftime('%s',date) from alarm";
    sqlite3_stmt *statement;
    
    if(sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil)==SQLITE_OK)
    {
        
        
        while (sqlite3_step(statement)==SQLITE_ROW)
        {
            int alarmId=sqlite3_column_int(statement, 0);
//            int repeat=sqlite3_column_int(statement, 1);
            int repeat=[self sortedInteger:sqlite3_column_int(statement, 1)];
            
            int snooze=sqlite3_column_int(statement, 2);
            
            char *soundChars=(char *) sqlite3_column_text(statement, 3);
            char *labelChars=(char *) sqlite3_column_text(statement, 4);
//            NSDate *date= [NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 5)];
            NSDate *date= [self getLocalTimeFrom:[NSDate dateWithTimeIntervalSince1970: sqlite3_column_double(statement, 5)]];
            
            // NSString *repeat=[[NSString alloc]initWithUTF8String:repeatChars];
            
            NSString *sound=[[NSString alloc]initWithUTF8String:soundChars];
            NSString *label=[[NSString alloc]initWithUTF8String:labelChars];
            
            
           //AlarmInfo *info=[[AlarmInfo alloc]initWithAlarmId:alarmId repeatday:repeat snooze:snooze sound:sound label:label date:date WeatherCode:0 dayIcon:nil nightIcon:nil];
            AlarmInfo *info=[[AlarmInfo alloc]initWithAlarmId:alarmId repeat:repeat snooze:0 sound:sound label:label date:date status:snooze];
            
            [returnArray addObject:info];
        }//while close
    }
   //sqlite3_close(database);//close only when the database is set to nil;
    
    return returnArray;
}

-(NSDate *)getLocalTimeFrom:(NSDate *)UTCTime
{
    //called in getAllOldAlarm
    NSTimeZone *tz = [NSTimeZone localTimeZone];
    NSLog(@"%@",tz);
    NSInteger seconds = [tz secondsFromGMTForDate: UTCTime];
    NSLog(@"%ld",(long)seconds);
    return [NSDate dateWithTimeInterval: -seconds sinceDate: UTCTime];
}

- (int)sortedInteger:(int)myInt
{
    //called in getAllOldAlarm
    NSMutableArray *array = [[NSMutableArray alloc] init];
    int sortedInt;
    if(myInt > 0)
    {
        NSString *string = [NSString stringWithFormat:@"%d", myInt];//1243 from db
        for (int i = 0; i < [string length]; i++)
        {
            NSString * individualChar = [NSString stringWithFormat:@"%C", [string characterAtIndex:i]];
            int intForIndividualChar = [individualChar intValue];
            [array addObject: [NSNumber numberWithInt:intForIndividualChar]];
        }
        NSLog(@"BeforeSorting%@",array);
    }
    //sort this array
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2];} ];
    
    NSLog(@"%@",array);
    sortedInt = [[array componentsJoinedByString:@""]intValue];
    NSLog(@"RepeatValue: %d",sortedInt);
    return sortedInt;
}

@end
