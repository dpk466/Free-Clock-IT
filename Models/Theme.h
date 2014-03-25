//
//  Theme.h
//  DataUsage
//
//  Created by Deepak Bharati on 27/08/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Theme : NSObject

@property(nonatomic,strong) UIColor *carbon;
@property(nonatomic,strong) UIColor *scarlet;
@property(nonatomic,strong) UIColor *azure;
@property(nonatomic,strong) UIColor *harmony;
@property(nonatomic,strong) UIColor *sunshine;
@property(nonatomic,strong) UIColor *aurora;

+ (void)setTheme:(UIColor*)selectedTheme toView:(UIView*)view;
+ (void)setThemeWithThemeValue:(int)themeNo toView:(UIView*)view;

- (NSArray*) getThemeList;

+ (UIImage *)backgroundImageForCurrentContext;

+ (void)applyGradientToView:(UIView *)view;
+ (void)removeGradientFromView:(UIView *)view;


@end

