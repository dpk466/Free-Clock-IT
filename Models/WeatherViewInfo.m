//
//  WeatherInfo.m
//  MyClockIt
//
//  Created by Deepak Bharati on 14/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "WeatherViewInfo.h"

@implementation WeatherViewInfo



- (id)initWithWeatherCode:(NSInteger)weatherCode weatherImage:(UIImage *)weatherImage temp_C:(NSString *)temp_C temp_F:(NSString *)temp_F weatherCondition:(NSString *)weatherCondition
{
    self = [super init];
    if(self)
    {
        self.weatherCode = weatherCode;
        self.weatherImage = weatherImage;
        self.temp_C = temp_C;
        self.temp_F = temp_F;
        self.weatherCondition = weatherCondition;
        
    }
    return self;
}

@end
