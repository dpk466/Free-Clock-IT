//
//  AlarmViewController.h
//  MyClockIt
//
//  Created by Deepak Bharati on 18/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmViewController : UIViewController

- (IBAction)addAlarm:(id)sender;
@property (strong, nonatomic)IBOutlet UITableView *tableView;// this IBOutlet is used for updating tableView at time of Edit button pressed
                                                             // since, Edit Button does not provide the current tableView object.

@property (strong, nonatomic) IBOutlet UISlider *volumeSlider;
- (IBAction)adjustVolume:(id)sender;


@end
