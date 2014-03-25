//
//  ViewController.h
//  MyClockIt
//
//  Created by Deepak Bharati on 30/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherView.h"


@interface HomeViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *amPmLabel;

@property (strong, nonatomic) IBOutlet UIButton *settingButton;
@property (strong, nonatomic) IBOutlet UIButton *alarmsButton;

@property (retain, nonatomic) IBOutlet WeatherView *weatherView;



@property (assign, nonatomic) NSInteger valueForTimer;

- (IBAction)goToSetting:(id)sender;
- (IBAction)goToAlarms:(id)sender;

@end
