//
//  TimeFormatViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 08/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "TimeFormatTableViewController.h"
#import "Flurry.h"

@interface TimeFormatTableViewController ()

@property (strong, nonatomic) NSUserDefaults* defaults;

@end

@implementation TimeFormatTableViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize=CGSizeMake(320, 568);
	defaults = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"TimeFormat_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0)cell.textLabel.text = NSLocalizedString(@"12_HOUR_TEXT", @"12-Hour");
    if(indexPath.row == 1)cell.textLabel.text = NSLocalizedString(@"24_HOUR_TEXT", @"24-Hour");
   
    if(indexPath.row == [defaults integerForKey:@"TimeFormat"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath in TimeFormatTable");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [defaults setObject:cell.textLabel.text forKey:@"TimeFormatString"];
    [defaults setInteger:indexPath.row forKey:@"TimeFormat"];

    [NSThread sleepForTimeInterval:0.1];
    [tableView reloadData];
    
    NSDictionary *timeFormatParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [defaults objectForKey:@"TimeFormatString"], @"Time_Format", // Capture time format info
                                        nil];
    [Flurry logEvent:@"Time Format Changed" withParameters:timeFormatParams];

}


@end
