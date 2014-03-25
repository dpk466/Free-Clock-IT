//
//  MySound.h
//  MyClockIt
//
//  Created by Deepak Bharati on 26/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySound : NSObject

@property (strong, nonatomic)NSMutableDictionary *soundDictionary;
@property (strong, nonatomic)NSUserDefaults *defaults;

+ (NSString *)soundWithSoundName:(NSString *)soundName;

@end
