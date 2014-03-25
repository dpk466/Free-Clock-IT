//
//  Theme.m
//  DataUsage
//
//  Created by Deepak Bharati on 27/08/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "Theme.h"



@implementation Theme



#pragma mark- theme data initialization

- (id)init
{
    self = [super init];
    
    _carbon = [UIColor blackColor];
    _scarlet = [UIColor colorWithRed:0.59 green:0.08 blue:0.07 alpha:1];
    _azure = [UIColor colorWithRed:0.11 green:0.27 blue:0.51 alpha:1];
    _harmony = [UIColor colorWithRed:0.56 green:0.05 blue:0.40 alpha:1];
    _sunshine = [UIColor colorWithRed:1.00 green:0.77 blue:0.00 alpha:1];
    _aurora = [UIColor colorWithRed:0.72 green:0.85 blue:0.62 alpha:1];
    
    return self;
}

+ (void) setTheme:(id)selectedTheme toView:(UIView*)view
{
    if([view isKindOfClass:[UIImageView class]])
    {
        UIImageView *myView = (UIImageView *)view;
        myView.image = selectedTheme;
    }
    else
    {
        view.backgroundColor = selectedTheme;
    }
}


//this medthod is not being used in the current project...
+ (void)setThemeWithThemeValue:(int)themeNo toView:(UIView *)view
{
//    NSArray * themeLists = [[[Theme alloc]init ]getThemeList];
//    //NSLog(@"themeLists count = %lu",(unsigned long)[themeLists count]);
//    id themeItem = ([themeLists count] > themeNo) ? [themeLists objectAtIndex:themeNo ] : NULL;
//    
//    if([view isKindOfClass:[UIImageView class]])
//    {
//        UIImageView *myView = (UIImageView *)view;
//        myView.image = themeItem;
//    }
//    else
//    {
//        view.backgroundColor = themeItem;
//    }
}

- (NSArray*) getThemeList
{
    return [NSArray arrayWithObjects:[Theme backgroundImageForCurrentContext], _carbon, _scarlet, _azure, _harmony, _sunshine, _aurora, [Theme backgroundImageForCurrentContext_X], nil];
}

+ (UIImage *)backgroundImageForCurrentContext
{
    UIImage *image;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        CGSize deviceSize = [[UIScreen mainScreen] bounds].size;
        if(deviceSize.height == 568)
        {
            //NSLog(@"iPhone5");
            if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i5_V.png"];
            }
            if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i5_H.png"];
            }
        }
        else//(deviceSize.height == 480)
        {
            //NSLog(@"iPhone4");
            if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i4_V.png"];
            }
            if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i4_H.png"];
            }
        }
    }
    else
    {
        //NSLog(@"iPad");
        if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
        {
            image = [UIImage imageNamed:@"iPad_V.png"];
        }
        if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
        {
            image = [UIImage imageNamed:@"iPad_H.png"];
        }
    }
    return image;
}


+ (UIImage *)backgroundImageForCurrentContext_X
{
    UIImage *image;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        
        CGSize deviceSize = [[UIScreen mainScreen] bounds].size;
        if(deviceSize.height == 568)
        {
            //NSLog(@"iPhone5");
            if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i5_V_X.png"];
            }
            if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i5_H_X.png"];
            }
        }
        else//(deviceSize.height == 480)
        {
            //NSLog(@"iPhone4");
            if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i4_V_X.png"];
            }
            if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
            {
                image = [UIImage imageNamed:@"i4_H_X.png"];
            }
        }
    }
    else
    {
        //NSLog(@"iPad");
        if(UIInterfaceOrientationIsPortrait(statusBarOrientation))
        {
            image = [UIImage imageNamed:@"iPad_V_X.png"];
        }
        if(UIInterfaceOrientationIsLandscape(statusBarOrientation))
        {
            image = [UIImage imageNamed:@"iPad_H_X.png"];
        }
    }
    return image;
}

+ (void)applyGradientToView:(UIView *)view
{
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.colors = [NSArray arrayWithObjects:
                    (id)[[UIColor colorWithRed:0.094 green:0.172 blue:0.2 alpha:1]CGColor],
                    (id)[[UIColor colorWithRed:0.184 green:0.364 blue:0.239 alpha:1]CGColor],
                    (id)[[UIColor colorWithRed:0.63 green:0.803 blue:0.596 alpha:1]CGColor], nil];
    layer.frame = view.frame;
    
    [view.layer insertSublayer:layer atIndex:0];
}

+ (void)removeGradientFromView:(UIView *)view
{
    [[view.layer.sublayers lastObject] removeFromSuperlayer];
}
@end
