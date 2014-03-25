//
//  TemperatureFormatTableViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 18/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "TemperatureFormatTableViewController.h"
#import "Flurry.h"

@interface TemperatureFormatTableViewController ()

@property (strong, nonatomic) NSUserDefaults* defaults;

@end

@implementation TemperatureFormatTableViewController

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
    NSString *CellIdentifier = @"TemperatureFormat_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row == 0)cell.textLabel.text = NSLocalizedString(@"CELSIUS_TEXT", @"Celsius");
    if(indexPath.row == 1)cell.textLabel.text = NSLocalizedString(@"FAHRENHEIT_TEXT", @"Fahrenheit");
    
    if(indexPath.row == [defaults integerForKey:@"TemperatureFormat"])
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
    NSLog(@"didSelectRowAtIndexPath in TemperatureFormatTable");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [defaults setObject:cell.textLabel.text forKey:@"TemperatureFormatString"];
    [defaults setInteger:indexPath.row forKey:@"TemperatureFormat"];
    [defaults synchronize];
    
    [NSThread sleepForTimeInterval:0.1];
    [tableView reloadData];
    
    NSDictionary *tempFormatParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [defaults objectForKey:@"TemperatureFormatString"], @"Temperature_Format", // Capture temperature format info
                                      nil];
    [Flurry logEvent:@"Temperature Format Changed" withParameters:tempFormatParams];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"toggleWeatherView" object:nil];
}



@end
