//
//  MyDateTime.m
//  MyClockIt
//
//  Created by Deepak Bharati on 30/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "MyDateTime.h"

#import "MySystemPreference.h"

@interface MyDateTime()


@end

@implementation MyDateTime


//Global Variables Used in Class Methods
NSDateFormatter *dateFormatter;

+ (NSString *) getTimeStringWithFormat:(NSInteger)format
{
    NSString *timeString;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[MySystemPreference deviceLanguageCode]];
    dateFormatter.dateFormat = format == 0 ? @"h:mm" : @"H:mm";
    timeString = [dateFormatter stringFromDate: [NSDate date]];
    
//    NSLog(@"%@",timeString);
    return timeString;
}

+ (NSString *) getAMPMString
{
    NSString *AMPMString;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[MySystemPreference deviceLanguageCode]];
    dateFormatter.dateFormat = @"a";
    AMPMString = [dateFormatter stringFromDate: [NSDate date]];
    
//    NSLog(@"AMPMString: %@ and amSymbol:%@, pmSymbol: %@",AMPMString, dateFormatter.AMSymbol, dateFormatter.PMSymbol);
    return AMPMString;
}

+ (NSString *) getDateString
{
    NSString *dateString;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[MySystemPreference deviceLanguageCode]];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"EEE%@ d MMM",NSLocalizedString(@"COMMA_SYMBOL", @",")];
    dateString = [dateFormatter stringFromDate: [NSDate date]];

//    NSLog(@"%@",dateString);
    return dateString;
}

@end
