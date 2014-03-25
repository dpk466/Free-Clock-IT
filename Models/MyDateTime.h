//
//  MyDateTime.h
//  MyClockIt
//
//  Created by Deepak Bharati on 30/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDateTime : NSObject


+ (NSString *) getTimeStringWithFormat:(NSInteger)format;
+ (NSString *) getAMPMString;
+ (NSString *) getDateString;


@end
