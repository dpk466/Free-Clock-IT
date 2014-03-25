//
//  SystemPreference.h
//  MyClockIt
//
//  Created by Deepak Bharati on 29/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySystemPreference : NSObject

+ (BOOL)is24HourFormat;

+ (BOOL)isMetricSystem;

+ (NSString *)deviceLanguageCode;

@end
