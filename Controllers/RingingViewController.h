//
//  RingingViewController.h
//  MyClockIt
//
//  Created by Deepak Bharati on 27/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmInfo.h"
#import <AVFoundation/AVFoundation.h>

@interface RingingViewController : UIViewController
{
    AVAudioPlayer *player;
}

@property (strong, nonatomic) IBOutlet UIButton *snoozeButton;
@property (strong, nonatomic) IBOutlet UIButton *iAmAwakeButton;
@property (strong, nonatomic) IBOutlet UIButton *onlyIAmAwakeButton;

@property (strong,nonatomic) AlarmInfo *alarmInfo;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UILabel *alarmLabel;

@property (nonatomic, assign) BOOL allreadySet;

- (IBAction)snooze:(id)sender;
- (IBAction)iAmAwake:(id)sender;

@end
