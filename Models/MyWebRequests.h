//
//  MyWebRequests.h
//  MyClockIt
//
//  Created by Deepak Bharati on 12/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherView.h"

@interface MyWebRequests : NSObject

+ (void)updateWeatherInfo:(WeatherView *)weatherView withLocation:(CLLocation *)location;

@end
