//
//  AddAlarmViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 19/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "AddAlarmViewController.h"
#import "RepeatTableViewController.h"
#import "SoundTableViewController.h"
#import "SnoozeTableViewController.h"

#import "AlarmDatabase.h"
#import "AlarmSchedular.h"



@interface AddAlarmViewController ()<UITextFieldDelegate>
{
    /*********************************************
    ***********Instances for Alarm Info***********
    *********************************************/
    int repeatVal, snoozeVal, statusVal;
    NSString *soundName, *labelName;
    NSDate *alarmDate;
    /*********************************************/
    
    UITextField *alarmLabelTextField;
    
}

@property (strong, nonatomic)IBOutlet UITableView *tableView;// this IBOutlet is used for updating tableView after comming back from the following views:
                                                             // -_ Repeat Table View Controller
                                                             // -_ Sound Table View Controller
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSUserDefaults* defaults;

@end

@implementation AddAlarmViewController

@synthesize defaults = defaults;

#pragma mark- Life Čycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.preferredContentSize=CGSizeMake(320, 568);

    defaults = [NSUserDefaults standardUserDefaults];
    
    if(self.existingAlarmInfo != nil)
    {
        NSMutableArray * array = [[NSMutableArray alloc]init];
        if((self.existingAlarmInfo).repeat != 0)
        {
            NSString *string = [NSString stringWithFormat:@"%d", (self.existingAlarmInfo).repeat];//124 from db
            for (int i = 0; i < [string length]; i++)
            {
                NSString * individualChar = [NSString stringWithFormat:@"%C", [string characterAtIndex:i]];
                int intForindividualChar = [individualChar intValue];
                [array addObject: [NSNumber numberWithInt:intForindividualChar]];
            }
        }
        //NSLog(@"%@",array);
        [defaults setObject:array forKey:@"RepeatDaysIndexArray"];//(1,2,4)
        [defaults setObject:(self.existingAlarmInfo).sound forKey:@"SoundName"];
        [defaults setInteger:(self.existingAlarmInfo).snooze forKey:@"SnoozeValue"];
        [defaults setObject:(self.existingAlarmInfo).label forKey:@"LabelName"];
        self.datePicker.date = (self.existingAlarmInfo).date;
    }
    else
    {
        [defaults setObject:nil forKey:@"RepeatDaysIndexArray"];
        [defaults setObject:NSLocalizedString(@"SOUND1", @"Tick tock jam") forKey:@"SoundName"];
        [defaults setInteger:0 forKey:@"SnoozeValue"];
        [defaults setObject:NSLocalizedString(@"DEFAULT_ALARM_NAME", @"Alarm") forKey:@"LabelName"];
        // default self.datePicker.date value will be current date
    }
    
    NSLog(@"Time format:%d\n %@",[defaults integerForKey:@"TimeFormat"],self.datePicker.date);
    //24-hr format for DatePicker
    if([defaults integerForKey:@"TimeFormat"] == 1)
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
        [self.datePicker setLocale:locale];
    }
    else//12-hr format
    {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [self.datePicker setLocale:locale];
    }
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SAVE_BUTTON_TEXT", @"Save") style:UIBarButtonItemStylePlain target:self action:@selector(saveAlarm)];
    self.navigationItem.rightBarButtonItem = saveButton;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateRepeatDaysString];

    [self.tableView reloadData];
}

#pragma mark - Save Alarm
- (void)saveAlarm
{
    //NSLog(@"Save alarm");
    if([alarmLabelTextField isFirstResponder])
    {
        //NSLog(@"yes!...");
        [alarmLabelTextField resignFirstResponder];
        if([alarmLabelTextField.text isEqualToString:@""])
        {
            [defaults setObject:NSLocalizedString(@"DEFAULT_ALARM_NAME", @"Alarm") forKey:@"LabelName"];
        }
        else
        {
            [defaults setObject:alarmLabelTextField.text forKey:@"LabelName"];
        }
        
    }
    
    repeatVal =  [[[defaults objectForKey:@"RepeatDaysIndexArray"] componentsJoinedByString:@""]intValue];
    snoozeVal = (int)[defaults integerForKey:@"SnoozeValue"];
    soundName = [defaults objectForKey:@"SoundName"];//NSLog(@"SoundNameToSave: %@",soundName);
    labelName = [defaults objectForKey:@"LabelName"];//NSLog(@"labelName: %@",labelName);
    alarmDate = self.datePicker.date;
    statusVal = 1;
    AlarmInfo *currentAlarmInfo;
    AlarmInfo * lastSavedAlarmInfo;

    if(self.existingAlarmInfo)
    {
        [AlarmSchedular cancelAlarmWithAlarmInfo:self.existingAlarmInfo];//cancle previously scheduled alarm
        
        currentAlarmInfo = [[AlarmInfo alloc]initWithAlarmId:(self.existingAlarmInfo).alarmId repeat:repeatVal snooze:snoozeVal sound:soundName label:labelName date:alarmDate status:statusVal];
        [[AlarmDatabase database]updateAlarmInDatabaseWithAlarmInfo:currentAlarmInfo];
        
        lastSavedAlarmInfo = currentAlarmInfo;
    }
    else
    {
        currentAlarmInfo = [[AlarmInfo alloc]initWithAlarmId:0 repeat:repeatVal snooze:snoozeVal sound:soundName label:labelName date:alarmDate status:statusVal];
        [[AlarmDatabase database]saveAlarmToDatabaseWithAlarmInfo:currentAlarmInfo];
        
        lastSavedAlarmInfo = [[[AlarmDatabase database] getAllAlarms] lastObject];
    }

//    NSLog(@"labelName: %@",currentAlarmInfo.label);
//    NSLog(@"Time(Date_String): %@",currentAlarmInfo.date);

    [AlarmSchedular scheduleAlarmWithAlarmInfo:lastSavedAlarmInfo];
    
    
        
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AddAlarm_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if([indexPath row] == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"REPEAT_TEXT", @"Repeat");
        cell.detailTextLabel.text = [defaults objectForKey:@"RepeatDaysString"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
    }
    if([indexPath row] == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"SOUND_TEXT", @"Sound");
        cell.detailTextLabel.text = [defaults objectForKey:@"SoundName"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if([indexPath row] == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"SNOOZE_TEXT", @"Snooze");
        NSArray *snoozeStrings = [[NSArray alloc]initWithObjects: NSLocalizedString(@"SNOOZE1", @"2 minute"),
                                                                  NSLocalizedString(@"SNOOZE2", @"5 minute"),
                                                                  NSLocalizedString(@"SNOOZE3", @"10 minute"),
                                                                  NSLocalizedString(@"SNOOZE4", @"15 minute"),
                                                                  NSLocalizedString(@"SNOOZE5", @"30 minute"),
                                                                  NSLocalizedString(@"SNOOZE6", @"Never"), nil];
        
        cell.detailTextLabel.text =  [snoozeStrings objectAtIndex:[defaults integerForKey:@"SnoozeValue"]] ;
        
    }
    if([indexPath row] == 3)
    {
        cell.textLabel.text = NSLocalizedString(@"LABEL_TEXT", @"Label");//Alarm name
        cell.detailTextLabel.text =  nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        alarmLabelTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200 , cell.frame.size.height)];
        alarmLabelTextField.clearsOnBeginEditing = NO;
        alarmLabelTextField.textAlignment = NSTextAlignmentRight;//UITextAlignmentRight in (ios < 6.0)
        alarmLabelTextField.placeholder = [defaults objectForKey:@"LabelName"];
        alarmLabelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        alarmLabelTextField.returnKeyType = UIReturnKeyDone;
        alarmLabelTextField.delegate = self;
        [alarmLabelTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
        
        cell.accessoryView = alarmLabelTextField;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0)
    {
        RepeatTableViewController *repaetTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RepeatTableViewController"];
        repaetTVC.title = NSLocalizedString(@"REPEAT_TEXT", @"Repeat");
        [self.navigationController pushViewController:repaetTVC animated:YES];
    }
    if([indexPath row] == 1)
    {
        SoundTableViewController * soundTVC= [self.storyboard instantiateViewControllerWithIdentifier:@"SoundTableViewController"];
        soundTVC.title = NSLocalizedString(@"SOUND_TEXT", @"Sound");
        [self.navigationController pushViewController:soundTVC animated:YES];
    }
    if([indexPath row] == 2)
    {
        SnoozeTableViewController *snoozeTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SnoozeTableViewController"];
        snoozeTVC.title = NSLocalizedString(@"SNOOZE_TEXT", @"Snooze");
        [self.navigationController pushViewController:snoozeTVC animated:YES];
    }
    
}


#pragma mark - KeyBoard methods for Label
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    [defaults setObject:textField.text forKey:@"LabelName"];
    //NSLog(@"labelName: %@",labelName);
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //NSLog(@"textFieldDidEndEditing");
    [textField resignFirstResponder];
    [defaults setObject:textField.text forKey:@"LabelName"];
    //NSLog(@"labelName: %@",labelName);
}

#pragma mark - self Defined Methods...
//called in viewWillAppear
- (void)updateRepeatDaysString
{
    
    NSArray *repeatDaysIndexArray = [defaults objectForKey:@"RepeatDaysIndexArray"];
    
    NSLog(@"repeatDaysIndexArray %@", [repeatDaysIndexArray description]);
    
    NSArray *repeatDaysArray = [NSArray arrayWithObjects: NSLocalizedString(@"SUN_TEXT", @"Sun "),
                                                          NSLocalizedString(@"MON_TEXT", @"Mon "),
                                                          NSLocalizedString(@"TUE_TEXT", @"Tue "),
                                                          NSLocalizedString(@"WED_TEXT", @"Wed "),
                                                          NSLocalizedString(@"THU_TEXT", @"Thu "),
                                                          NSLocalizedString(@"FRI_TEXT", @"Fri "),
                                                          NSLocalizedString(@"SAT_TEXT", @"Sat "), nil];
    
    NSMutableString *repeatDaysString = [[NSMutableString alloc]init];
    
    if([repeatDaysIndexArray count] == 0)
    {
        [repeatDaysString appendString:NSLocalizedString(@"NEVER_TEXT", @"Never")];
    }
    else if([repeatDaysIndexArray count] == 7)
    {
        [repeatDaysString appendString:NSLocalizedString(@"EVERYDAY_TEXT", @"Every day")];
    }
    else if([repeatDaysIndexArray isEqual: @[@2, @3, @4, @5, @6] ])
    {
        [repeatDaysString appendString:NSLocalizedString(@"WEEKDAYS_TEXT", @"Weekdays")];
    }
    else if([repeatDaysIndexArray isEqual: @[@1, @7] ])
    {
        [repeatDaysString appendString:NSLocalizedString(@"WEEKENDS_TEXT", @"Weekends")];
    }
    else
    {
        for(NSNumber *index in repeatDaysIndexArray)
        {
            [repeatDaysString appendString:[repeatDaysArray objectAtIndex:([index intValue]-1)]];
            
        }
    }
    [defaults setObject:repeatDaysString forKey:@"RepeatDaysString"];
    //NSLog(@"repeatDaysString: %@",repeatDaysString);
}


@end
