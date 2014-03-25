//
//  MyAlert.m
//  Free Clock
//
//  Created by Deepak Bharati on 25/02/14.
//  Copyright (c) 2014 Deepak Bharati. All rights reserved.
//

#import "MyAlert.h"
#import "PagedScrollViewController.h"

@interface MyAlert ()<UIAlertViewDelegate>
{
    
}


@end
@implementation MyAlert

- (id)init
{
    self = [super init];
  
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        //add images for iPad
        self.imageWeather = [UIImage imageNamed:@"iPad_H.jpg"];
        self.imageAds = [UIImage imageNamed:@"iPad_V_X.jpg"];
        self.imageThemes = [UIImage imageNamed:@"iPad_H.jpg"];
        self.imageMusicAlarm = [UIImage imageNamed:@"iPad_H_X.jpg"];
    }
    else
    {
        //add images for iPhone (3.5 & 4 both)
        self.imageWeather = [UIImage imageNamed:@"i5_V.jpg"];
        self.imageAds = [UIImage imageNamed:@"i5_V.jpg"];
        self.imageThemes = [UIImage imageNamed:@"i4_V.jpg"];
        self.imageMusicAlarm = [UIImage imageNamed:@"i4_V_X.jpg"];

    }
    
    return self;
}

+ (void)referToFullVersionApp
{
    NSLog(@"referToFullVersionApp");
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Upgrade to full version" message:@"-Weather updates\n-Multiple themes\n-Music alarms\n-No ads" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Buy full version", nil];
    [alertView show];
}


+ (void)presentAdvertisementPageUsing:(UIViewController *)viewController WithStartingPage:(int)pageNo
{
    NSLog(@"presentAdvertisementPageUsing");
 
    NSMutableArray *images = [[NSMutableArray alloc]init ];
    switch (pageNo) {
        case 1:images = [[NSMutableArray alloc]initWithObjects:
                                          [[MyAlert alloc]init].imageWeather,
                                          [[MyAlert alloc]init].imageAds,
                                          [[MyAlert alloc]init].imageThemes,
                                          [[MyAlert alloc]init].imageMusicAlarm, nil];
               break;
            
        case 2:images = [[NSMutableArray alloc]initWithObjects:
                                          [[MyAlert alloc]init].imageAds,
                                          [[MyAlert alloc]init].imageThemes,
                                          [[MyAlert alloc]init].imageMusicAlarm,
                                          [[MyAlert alloc]init].imageWeather, nil];
               break;
            
        case 3:images = [[NSMutableArray alloc]initWithObjects:
                                          [[MyAlert alloc]init].imageThemes,
                                          [[MyAlert alloc]init].imageMusicAlarm,
                                          [[MyAlert alloc]init].imageWeather,
                                          [[MyAlert alloc]init].imageAds, nil];
               break;
            
        case 4:images = [[NSMutableArray alloc]initWithObjects:
                                          [[MyAlert alloc]init].imageMusicAlarm,
                                          [[MyAlert alloc]init].imageWeather,
                                          [[MyAlert alloc]init].imageAds,
                                          [[MyAlert alloc]init].imageThemes, nil];
               break;
            
            
        default:images = [[NSMutableArray alloc]initWithObjects:
                                          [[MyAlert alloc]init].imageWeather,
                                          [[MyAlert alloc]init].imageAds,
                                          [[MyAlert alloc]init].imageThemes,
                                          [[MyAlert alloc]init].imageMusicAlarm, nil];
                break;
            
    }
    
    
    PagedScrollViewController *psvc=[viewController.storyboard instantiateViewControllerWithIdentifier:@"PagedScrollViewController"];
    psvc.images = [[NSArray alloc]initWithArray:images];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)//for ipad
    {
        NSLog(@"for iPad");
        psvc.modalPresentationStyle=UIModalPresentationFormSheet;
        //psvc.view.bounds = [UIModalPresentationFormSheet];
        
    }
    
    [viewController presentViewController:psvc animated:YES completion:^{ }];
}

//use it for Alerting...
/*
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d",buttonIndex);
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        NSLog(@"Cancel tapped");
    }
    else if (buttonIndex == alertView.firstOtherButtonIndex)
    {
        NSLog(@"Go to appStore");
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"itms-apps://itunes.apple.com/app/id585965009" ]];
        
    }
}
*/

@end
