//
//  RepeatTableViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 19/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "RepeatTableViewController.h"
#import "Flurry.h"

@interface RepeatTableViewController ()

{
    NSArray *repeateTableDataArray;
    
    NSMutableArray *repeatDaysIndexArray;

}

@property (strong, nonatomic) NSUserDefaults* defaults;

@end

@implementation RepeatTableViewController

@synthesize  defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.preferredContentSize=CGSizeMake(320, 568);
    defaults = [NSUserDefaults standardUserDefaults];

    repeateTableDataArray = [[NSArray alloc]initWithObjects: NSLocalizedString(@"EVERY_SUNDAY", @"Every sunday"),
                                                             NSLocalizedString(@"EVERY_MONDAY", @"Every monday"),
                                                             NSLocalizedString(@"EVERY_TUESDAY", @"Every tuesday"),
                                                             NSLocalizedString(@"EVERY_WEDNESDAY", @"Every wednesday"),
                                                             NSLocalizedString(@"EVERY_THURDAY", @"Every thursday"),
                                                             NSLocalizedString(@"EVERY_FRIDAY", @"Every friday"),
                                                             NSLocalizedString(@"EVERY_SATURDAY", @"Every saturday"), nil];
    
    repeatDaysIndexArray = [[NSMutableArray alloc]init ];
    [repeatDaysIndexArray addObjectsFromArray:[defaults objectForKey:@"RepeatDaysIndexArray"] ];

    NSLog(@"repeatDaysIndexArray %@", [defaults objectForKey:@"RepeatDaysIndexArray"] );
    

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [repeateTableDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Repeat_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.textLabel.text = [repeateTableDataArray objectAtIndex:indexPath.row];
    
    if([[defaults objectForKey:@"RepeatDaysIndexArray"] containsObject:[NSNumber numberWithInt:indexPath.row+1]])
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
    NSLog(@"didSelectRowAtIndexPath in RepeatTable");
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [repeatDaysIndexArray addObject:[NSNumber numberWithInt: indexPath.row+1]];
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [repeatDaysIndexArray removeObject:[NSNumber numberWithInt: indexPath.row+1]];
    }
    
    [repeatDaysIndexArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2];} ];
    
    [defaults setObject:repeatDaysIndexArray forKey:@"RepeatDaysIndexArray"];
    NSLog(@"repeatDaysIndexArray %@", [defaults objectForKey:@"RepeatDaysIndexArray"] );
    
    [NSThread sleepForTimeInterval:0.1];
    [tableView reloadData];
    
    NSDictionary *repeatParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                     repeatDaysIndexArray, @"Repaet_Days", // Capture Repeat info
                                     nil];
    [Flurry logEvent:@"Repeat Value Changed" withParameters:repeatParams];

}


@end
