//
//  SystemPreference.m
//  MyClockIt
//
//  Created by Deepak Bharati on 29/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "MySystemPreference.h"

@implementation MySystemPreference

+ (BOOL)is24HourFormat
{
    BOOL is24Hour;
    
    //Method 1
    NSString *format = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    is24Hour = ([format rangeOfString:@"a"].location == NSNotFound);
    
    //Method 2
//    NSLocale *locale = [NSLocale currentLocale];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setLocale:locale];
//    [formatter setDateStyle:NSDateFormatterNoStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    NSString *dateString = [formatter stringFromDate:[NSDate date]];
//    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
//    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
//    is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    NSLog(@"24-hr format: %d",is24Hour);

    return is24Hour;
    
}

+ (BOOL)isMetricSystem
{
    NSLocale *locale = [NSLocale currentLocale];
    BOOL isMetric = [[locale objectForKey:NSLocaleUsesMetricSystem] boolValue];
    
    NSLog(@"Metric: %d",isMetric);
    
    return isMetric;
}

+ (NSString *)deviceLanguageCode
{
    NSString *langCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    return  langCode;
    
}

@end
