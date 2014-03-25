//
//  SnoozeTableViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 25/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "SnoozeTableViewController.h"
#import "Flurry.h"

@interface SnoozeTableViewController ()
{
    NSArray *snoozeTableDataArray;
}

@property (strong, nonatomic) NSUserDefaults* defaults;


@end

@implementation SnoozeTableViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize=CGSizeMake(320, 568);
    defaults = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view.
    
    snoozeTableDataArray = [[NSArray alloc]initWithObjects: NSLocalizedString(@"SNOOZE1", @"2 minute"),
                                                            NSLocalizedString(@"SNOOZE2", @"5 minute"),
                                                            NSLocalizedString(@"SNOOZE3", @"10 minute"),
                                                            NSLocalizedString(@"SNOOZE4", @"15 minute"),
                                                            NSLocalizedString(@"SNOOZE5", @"30 minute"),
                                                            NSLocalizedString(@"NEVER_TEXT", @"Never"), nil];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [snoozeTableDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Snooze_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [snoozeTableDataArray objectAtIndex:indexPath.row];
    if(indexPath.row == [defaults integerForKey:@"SnoozeValue"])
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
    NSLog(@"didSelectRowAtIndexPath in SnoozeTable");
    [defaults setInteger:indexPath.row forKey:@"SnoozeValue"];
    
    [NSThread sleepForTimeInterval:0.1];
    [tableView reloadData];
    
    NSDictionary *snoozeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithInteger:indexPath.row], @"SnoozeValue", // Capture Snooze info
                                      nil];
    [Flurry logEvent:@"Snooze Value Changed" withParameters:snoozeParams];
}

@end
