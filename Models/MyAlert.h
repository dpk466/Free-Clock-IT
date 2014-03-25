//
//  MyAlert.h
//  Free Clock
//
//  Created by Deepak Bharati on 25/02/14.
//  Copyright (c) 2014 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAlert : NSObject

@property (strong,nonatomic) UIImage *imageWeather;
@property (strong,nonatomic) UIImage *imageAds;
@property (strong,nonatomic) UIImage *imageThemes;
@property (strong,nonatomic) UIImage *imageMusicAlarm;

//+ (void)referToFullVersionApp;
+ (void)presentAdvertisementPageUsing:(UIViewController *)viewController WithStartingPage:(int)pageNo;

@end
