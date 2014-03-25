//
//  AlarmViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 18/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//





#import "AlarmViewController.h"
#import "AddAlarmViewController.h"
#import "AlarmDatabase.h"
#import "AlarmInfo.h"
#import "AlarmSchedular.h"

#import <MediaPlayer/MediaPlayer.h>

#import "Flurry.h"


@interface AlarmViewController ()
{
    NSMutableArray *alarmInfos;
    UISwitch *alarmSwitch;
}

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (nonatomic, retain) MPMusicPlayerController *musicPlayer;


@end

@implementation AlarmViewController

@synthesize defaults = defaults;

#pragma mark - Life Čycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.preferredContentSize=CGSizeMake(320, 568);
    defaults = [NSUserDefaults standardUserDefaults] ;
    
    [self.volumeSlider setValue:[defaults floatForKey:@"AppVolume"]];

    self.title = NSLocalizedString(@"ALARMS_TEXT", @"Alarms");
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE_BUTTON_TEXT", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAlarm:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self readDatabaseAndUpdateTheTableView];
    
    [super setEditing:NO animated:NO];
    [self.tableView setEditing:NO animated:NO];
    [self.tableView reloadData];

}

- (void) viewWillLayoutSubviews
{
    [self.tableView reloadData];//required for Edit Button position
    
}

-(void)readDatabaseAndUpdateTheTableView
{
    alarmInfos = [[NSMutableArray alloc]init];
    alarmInfos = [[NSMutableArray alloc]initWithArray:[[AlarmDatabase database]getAllAlarms]];
    
}



#pragma mark - UITableView Methods

#pragma mark -Data Source Methods
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Headerview
    UIView *myView = [[UIView alloc] initWithFrame:CGRectZero] ;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:self.editing
                    ? NSLocalizedString(@"DONE_BUTTON_TEXT", @"Done")
                    : NSLocalizedString(@"EDIT_BUTTON_TEXT", @"Edit") forState:UIControlStateNormal];
    [button setFrame:CGRectMake((self.view.frame.size.width-100), 10.0, 100.0, 30.0)];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(reloadTableViewForEditMode:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:button];
    return alarmInfos.count ? myView : NULL;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [alarmInfos count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Alarm_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    alarmSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    alarmSwitch.tag = indexPath.row;

    if(!self.editing)
    {
        [alarmSwitch addTarget:self
                        action:@selector(toggleAlarmSwitch:)
              forControlEvents:UIControlEventTouchUpInside];
        alarmSwitch.on = ((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).status;
        cell.accessoryView = alarmSwitch;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if(((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).status == 1)
        {
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.textColor=[UIColor blackColor];
            cell.detailTextLabel.textColor=[UIColor blackColor];
            
        }
        else
        {
            cell.backgroundColor=[UIColor clearColor];
            cell.textLabel.textColor=[UIColor lightGrayColor];
            cell.detailTextLabel.textColor=[UIColor lightGrayColor];
            
        }
        
    }
    else//in editing
    {
        cell.accessoryView = nil;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    }
    
    NSDate *alarmTime = ((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).date;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //[format setDateFormat:@"MMM dd, yyyy HH:mm"];
    [format setDateFormat: [defaults integerForKey:@"TimeFormat"] ? @"HH:mm" : @"hh:mm a"];//1 for 24hr, 0 for 12hr
    cell.textLabel.text = [format stringFromDate: alarmTime] ;
    NSString *detailText;
    if(((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).repeat != 0)
    {
        detailText = [NSString stringWithFormat:@"%@,  %@",((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).label, [self getRepeatdaysStringFor:((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).repeat]];
    }
    else
    {
        detailText = ((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).label;
    }
    cell.detailTextLabel.text = detailText;
    return cell;
}



#pragma mark -Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.editing)
    {
        AddAlarmViewController *addAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAlarmViewController"];
        addAlarmVC.title = NSLocalizedString(@"EDIT_ALARM_TITLE", @"Edit alarm");
        addAlarmVC.existingAlarmInfo = (AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:addAlarmVC animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Delete in AlarmViewController Row");
        [[AlarmDatabase database]deleteAlarmFromDatabaseWithAlarmId:((AlarmInfo *)[alarmInfos objectAtIndex:indexPath.row]).alarmId ];
        [AlarmSchedular cancelAlarmWithAlarmInfo:[alarmInfos objectAtIndex:indexPath.row]];
        [alarmInfos removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [alarmInfos removeObjectAtIndex:indexPath.row];
        [self readDatabaseAndUpdateTheTableView];
        [self.tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Back Button
- (IBAction)backButtonPressed:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:^{ }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissPopOver" object:nil];

}

#pragma mark - Add Button
- (IBAction)addAlarm:(id)sender
{
    [Flurry logEvent:@"Add Alarms"];
    
    AddAlarmViewController *addAlarmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAlarmViewController"];
    addAlarmVC.title = NSLocalizedString(@"ADD_ALARM_TITLE", @"Add alarm");
    [self.navigationController pushViewController:addAlarmVC animated:YES];
}

#pragma mark - Edit Alarms
- (void)reloadTableViewForEditMode:(UIButton *)sender
{
    
    if(self.editing)
	{
		[super setEditing:NO animated:NO];
		[self.tableView setEditing:NO animated:NO];
        [sender setTitle:NSLocalizedString(@"EDIT_BUTTON_TEXT", @"Edit") forState:UIControlStateNormal];
	}
	else
	{
        [Flurry logEvent:@"Edit Alarms"];
        NSLog(@"Load Edit mode");
		[super setEditing:YES animated:YES];
		[self.tableView setEditing:YES animated:YES];
        [sender setTitle:NSLocalizedString(@"DONE_BUTTON_TEXT", @"Done") forState:UIControlStateNormal];
	}
    
    [self readDatabaseAndUpdateTheTableView];
    [self.tableView reloadData];
}

#pragma mark - Togggle Alarm Switch
- (void)toggleAlarmSwitch:(id)sender
{
    NSLog(@"toggleAlarmSwitch");
    
    UISwitch *alarmEnableSwitch = sender;
    AlarmInfo *currentAlarmInfo = [[AlarmInfo alloc]
                                   initWithAlarmId:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).alarmId
                                            repeat:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).repeat
                                            snooze:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).snooze
                                             sound:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).sound
                                             label:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).label
                                              date:((AlarmInfo *)[alarmInfos objectAtIndex:alarmEnableSwitch.tag]).date
                                            status:alarmEnableSwitch.on ? 1 : 0];
    
    [[AlarmDatabase database] updateAlarmInDatabaseWithAlarmInfo:currentAlarmInfo];
    if(alarmEnableSwitch.on)
    {
        NSLog(@"Alarm is ON now");
        NSLog(@"%d",currentAlarmInfo.alarmId);
        [AlarmSchedular scheduleAlarmWithAlarmInfo:currentAlarmInfo];
    }
    else
    {
        NSLog(@"Alarm is OFF now");
        NSLog(@"%d",currentAlarmInfo.alarmId);
        [AlarmSchedular cancelAlarmWithAlarmInfo:currentAlarmInfo];
    }
    
    UITableViewCell *cell = (UITableViewCell *)[[alarmEnableSwitch superview] superview];
    if(alarmEnableSwitch.on)
    {
        [UIView animateWithDuration:0.3
                              delay:0.2
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{ cell.backgroundColor=[UIColor whiteColor];
                             cell.textLabel.textColor=[UIColor blackColor];
                             cell.detailTextLabel.textColor=[UIColor blackColor];}
                         completion:^(BOOL finished){if (finished){}}];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.3
                              delay:0.2
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{ cell.backgroundColor=[UIColor clearColor];
                             cell.textLabel.textColor=[UIColor lightGrayColor];
                             cell.detailTextLabel.textColor=[UIColor lightGrayColor];}
                         completion:^(BOOL finished){if (finished){}}];
        
        
    }

}


- (NSString *)getRepeatdaysStringFor:(int)repeatValue
{
    NSString *rptString;
    if(repeatValue == 1234567)//everyDay
    {
        rptString = NSLocalizedString(@"EVERYDAY_TEXT", @"Every day");
    }
    else if (repeatValue == 23456)//weekDays
    {
        rptString = NSLocalizedString(@"WEEKDAYS_TEXT", @"Weekdays");
    }
    else if (repeatValue == 17)//weekEnds
    {
        rptString = NSLocalizedString(@"WEEKENDS_TEXT", @"Weekends");
    }
    else
    {
        NSArray *repeatDaysArray = [NSArray arrayWithObjects: NSLocalizedString(@"SUN_TEXT", @"Sun "),
                                                              NSLocalizedString(@"MON_TEXT", @"Mon "),
                                                              NSLocalizedString(@"TUE_TEXT", @"Tue "),
                                                              NSLocalizedString(@"WED_TEXT", @"Wed "),
                                                              NSLocalizedString(@"THU_TEXT", @"Thu "),
                                                              NSLocalizedString(@"FRI_TEXT", @"Fri "),
                                                              NSLocalizedString(@"SAT_TEXT", @"Sat "), nil];
        
        NSMutableString *rptMutableString = [[NSMutableString alloc]init];
        while (repeatValue)
        {
            int dayValue = repeatValue%10;
            
            NSMutableString *myMutableString = [NSMutableString stringWithString:[repeatDaysArray objectAtIndex:(dayValue-1)]];
            [myMutableString appendString:rptMutableString];
            
            rptMutableString = myMutableString;
            repeatValue = repeatValue/10;
        }
        rptString = rptMutableString;
    }
    return rptString;
}

- (IBAction)adjustVolume:(id)sender
{
    NSLog(@"Adjust Volume");
    UISlider *slider = (UISlider *)sender;
    [defaults setFloat:slider.value forKey:@"AppVolume"];
    
    NSDictionary *appVolumeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [NSNumber numberWithFloat:slider.value], @"AppVolume", // Capture AppVolume info
                                      nil];
    [Flurry logEvent:@"App Volume Changed" withParameters:appVolumeParams];
    
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    NSLog(@"Current device_volume:%f",[self.musicPlayer volume]);
    //self.musicPlayer.volume = slider.value;
    NSLog(@"Current app_volume:%f",[defaults floatForKey:@"AppVolume"]);
}
@end
