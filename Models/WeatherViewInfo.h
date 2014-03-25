//
//  WeatherInfo.h
//  MyClockIt
//
//  Created by Deepak Bharati on 14/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherViewInfo : NSObject

@property(nonatomic,assign) NSInteger weatherCode;
@property(nonatomic,copy) UIImage *weatherImage;
@property(nonatomic,copy) NSString *temp_C;
@property(nonatomic,copy) NSString *temp_F;
@property(nonatomic,copy) NSString *weatherCondition;

- (id)initWithWeatherCode:(NSInteger)weatherCode
             weatherImage:(UIImage *)weatherImage
                   temp_C:(NSString *)temp_C
                   temp_F:(NSString *)temp_F
         weatherCondition:(NSString *)weatherCondition;

@end
