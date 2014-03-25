//
//  SettingViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 31/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "SettingViewController.h"

#import "TimeFormatTableViewController.h"
#import "TemperatureFormatTableViewController.h"
#import "ThemeTableViewController.h"
#import "AppOsVersion.h"
#import <MessageUI/MFMailComposeViewController.h>

#import "Flurry.h"

#import "MyAlert.h"

@interface SettingViewController ()<MFMailComposeViewControllerDelegate>
{
    NSArray * settingArray;
}

@property (strong, nonatomic)NSUserDefaults *defaults;

@end

@implementation SettingViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.preferredContentSize=CGSizeMake(320, 568);
    defaults = [NSUserDefaults standardUserDefaults];

    self.title = NSLocalizedString(@"SETTING_TABLE_TITLE", @"Title");//@"Settings";
    
    settingArray = [NSArray arrayWithObjects:NSLocalizedString(@"TIME_FORMAT", @"Time format"),
                                             NSLocalizedString(@"WEATHER", @"Weather"),
                                             NSLocalizedString(@"TEMPERATURE_FORMAT", @"Temperature format"),
                                             NSLocalizedString(@"THEME", @"Theme"),
                                             NSLocalizedString(@"APP_BRIGHTNESS", @"In-App Brightness"),
                                             NSLocalizedString(@"SHARE_WITH_FRIENDS", @"Share with friends"),
                                             NSLocalizedString(@"EMAIL_SUPPORT", @"Email support"),
                                             NSLocalizedString(@"WRITE_US_A_REVIEW", @"Write us a review"),
                                             NSLocalizedString(@"VERSION", @"Version"),
                                             NSLocalizedString(@"AUTO_LOCK", @"Auto-lock"),
                                             NSLocalizedString(@"FADE_IN_ALARM", @"Fade-in"), nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"DONE_BUTTON_TEXT", @"Done") style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 6+1;//Last one to remove Ads cell
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if(section == 0) // Time
        return 1;
    if(section == 1) // Weather
        return 1;//2;
    if(section == 2) // Theme/Display
        return 2;
    if(section == 3) // About
        return 4;
    if(section == 4) // Advanced
        return 1;
    return 1;        // Alarm 5 & 6
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) // Time
        return NSLocalizedString(@"TIME_HEADER", @"Time");
    
    if(section == 1) // Weather
        return NSLocalizedString(@"WEATHER_HEADER", @"Weather");
    
    if(section == 2) // Theme/Display
        return NSLocalizedString(@"DISPLAY_HEADER", @"Display");
    
    if(section == 3) // About
        return NSLocalizedString(@"ABOUT_HEADER", @"About");
    
    if(section == 4) // Advanced
        return NSLocalizedString(@"ADVANCED_HEADER", @"Advanced");
    
                    // Alarm
    return NSLocalizedString(@"DEFAULT_ALARM_NAME", @"Alarm");
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
//    if(section == 0) //
//        return @"";
    
    if(section == 1) //
        return @"";//NSLocalizedString(@"WEATHER_FOOTER", @"Automatic hourly weather updates. Turn off weather to prevent cellular and wifi data usage.");
    
    if(section == 2) // Display
        return NSLocalizedString(@"DISPLAY_FOOTER", @"Set brightness control independent of device brightness.");
    
//    if(section == 3) //
//        return @"About";
    
    if(section == 4)//Advanced
        return NSLocalizedString(@"ADVANCED_FOOTER", @"When Auto-Lock is on, device locks automatically according to native settings.");
    
    if(section == 5)//Alarm Fade In
        return NSLocalizedString(@"ALARM_FOOTER", @"Enable fade-in effect for the allarm sound");
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Setting_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if([indexPath section] == 0)//Time Format
    {
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row];// 0
        cell.detailTextLabel.text = [defaults objectForKey:@"TimeFormatString"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView = nil;
    }
    if([indexPath section] == 1)//Weather
    {
        /*
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row+1];// 1 & 2
        if(indexPath.row == 0)//weather OnOff
        {
            cell.detailTextLabel.text = nil;
            UISwitch* weatherSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [weatherSwitch addTarget:self action:@selector(weatherSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
            weatherSwitch.on = [defaults boolForKey:@"WeatherSwitch"];
            cell.accessoryView = weatherSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(indexPath.row == 1)//Temperature format
        {
            cell.detailTextLabel.text = [defaults objectForKey:@"TemperatureFormatString"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;

        }
        */
        cell.textLabel.text = NSLocalizedString(@"GET_UPGRADE", @"Upgrade");
        cell.detailTextLabel.text = nil;
        cell.accessoryView = nil;
    }
    if([indexPath section] == 2)//Theme
    {
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row+3];// 3 & 4
        if(indexPath.row == 0)
        {
            cell.detailTextLabel.text = [defaults objectForKey:@"ThemeString"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
        }
        if(indexPath.row == 1)
        {
            cell.detailTextLabel.text = nil;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UISwitch* brightnessSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [brightnessSwitch addTarget:self action:@selector(brightnessSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
            brightnessSwitch.on = [defaults boolForKey:@"BrightnessSwitch"];
            cell.accessoryView = brightnessSwitch;
        }

    }
    if([indexPath section] == 3)//About
    {
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row+5];// 5, 6, 7 & 8
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        cell.accessoryView = nil;
        cell.detailTextLabel.text = nil;

//        if(indexPath.row == 0)//share
//        if(indexPath.row == 1)//email Support
//        if(indexPath.row == 2)//review
        if(indexPath.row == 3)//Version
        {
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    if([indexPath section] == 4)//Advanced
    {
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row+9];// 9
        if(indexPath.row == 0)//Auto Lock OnOff
        {
            cell.detailTextLabel.text = nil;
            UISwitch* autolLockSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [autolLockSwitch addTarget:self action:@selector(autoLockSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
            autolLockSwitch.on = [defaults boolForKey:@"AutoLockSwitch"];
            cell.accessoryView = autolLockSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    if([indexPath section] == 5)//Alarm
    {
        cell.textLabel.text = [settingArray objectAtIndex:indexPath.row+10];// 10
        if(indexPath.row == 0)//Alarm Fade In OnOff
        {
            cell.detailTextLabel.text = nil;
            UISwitch* alarmFadeInSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
            [alarmFadeInSwitch addTarget:self action:@selector(alarmFadeInSwitchChanged:) forControlEvents:UIControlEventTouchUpInside];
            alarmFadeInSwitch.on = [defaults boolForKey:@"AlarmFadeInSwitch"];
            cell.accessoryView = alarmFadeInSwitch;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if([indexPath section] == 6)
    {
        cell.textLabel.text =  NSLocalizedString(@"REMOVE_AD", @"Remove ads");
        cell.detailTextLabel.text = nil;
        cell.accessoryView = nil;
    }
    
    return cell;
}

- (void) weatherSwitchChanged:(id)sender
{
    UISwitch* weatherSwitch = sender;
    
    NSNumber *ON_OFF = [NSNumber numberWithBool:weatherSwitch.on];
    NSDictionary *weatherSwitchParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                             ON_OFF, @"Weather_Switch_Status", // Capture weather switch info
                                             nil];
    [Flurry logEvent:@"Weather Switch Taped" withParameters:weatherSwitchParams];

    [defaults setBool:weatherSwitch.on forKey:@"WeatherSwitch"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"toggleWeatherView" object:nil];
}

- (void) brightnessSwitchChanged:(id)sender
{
    UISwitch* brightnessSwitch = sender;
    [defaults setBool:brightnessSwitch.on forKey:@"BrightnessSwitch"];
}

- (void) autoLockSwitchChanged:(id)sender
{
    NSLog(@"autoLockSwitchChanged");
    UISwitch *autoLockSwitch = sender;
    
    NSNumber *ON_OFF = [NSNumber numberWithBool:autoLockSwitch.on];
    NSDictionary *autoLockSwitchParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                         ON_OFF, @"Auto_Lock_Switch_Status", // Capture autolock switch info
                                         nil];
    [Flurry logEvent:@"Auto_Lock Switch Taped" withParameters:autoLockSwitchParams];
    
    [defaults setBool:autoLockSwitch.on forKey:@"AutoLockSwitch"];
    
    if(autoLockSwitch.on)
    {
        //lock device after IdleTimer
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
    else
    {
        //Don't lock
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
}

- (void) alarmFadeInSwitchChanged:(id)sender
{
    NSLog(@"alarmFadeInSwitchChanged");
    UISwitch *alarmFadeInSwitch = sender;
    
    NSNumber *ON_OFF = [NSNumber numberWithBool:alarmFadeInSwitch.on];
    NSDictionary *alarmFadeInSwitchParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          ON_OFF, @"Alarm_Fade-in_Switch_Status", // Capture autolock switch info
                                          nil];
    [Flurry logEvent:@"Fade-in Switch Taped" withParameters:alarmFadeInSwitchParams];
    
    [defaults setBool:alarmFadeInSwitch.on forKey:@"AlarmFadeInSwitch"];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
   
    switch(indexPath.section)
    {
        case 0:{
            //NSLog(@"Section 0");//time format
            if(indexPath.row == 0)
            {
                TimeFormatTableViewController *tftvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TimeFormatTableViewController"];
                tftvc.title = NSLocalizedString(@"TIME_FORMAT", @"Time format");
                [self.navigationController pushViewController:tftvc animated:YES];
            }
            else if(indexPath.row == 1)
            {
                
            }
            break;
        }
            
        case 1:{
            //NSLog(@"Section 1");//weather
            /*if(indexPath.row == 0)
            {
                
            }
            else if(indexPath.row == 1)
            {
                TemperatureFormatTableViewController *tempftvc = [self.storyboard instantiateViewControllerWithIdentifier:@"TemperatureFormatTableViewController"];
                tempftvc.title = NSLocalizedString(@"TEMPERATURE_FORMAT", @"Temperature format");
                [self.navigationController pushViewController:tempftvc animated:YES];
            }*/
            //code to redirect toAppStore
            //[MyAlert referToFullVersionApp];
            [MyAlert presentAdvertisementPageUsing:self WithStartingPage:1];
            break;
        }
            
        case 2:{
            //NSLog(@"Section 2");//Display
            if(indexPath.row == 0)
            {
                ThemeTableViewController *ttvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ThemeTableViewController"];
                ttvc.title = NSLocalizedString(@"THEME", @"Theme");
                [self.navigationController pushViewController:ttvc animated:YES];
            }
            else if(indexPath.row == 1)
            {
                
            }
            break;
        }
        case 3:{
            //NSLog(@"Section 3");//About
            if(indexPath.row == 0)//Share With Friend
            {
                [self shareWithFriends];
                
            }
            else if(indexPath.row == 1)//Email Support
            {
                [self eMailSupport];
            }
            else if(indexPath.row == 2)//Write us a review
            {
                [self writeUsAReview];
            }
            break;
        }
            
        case 4:{
            //NSLog(@"Section 4");//Advanced
            break;
        }
            
        case 6:{
            //[MyAlert referToFullVersionApp];
            [MyAlert presentAdvertisementPageUsing:self WithStartingPage:2];
           
        }
            
        default:
            break;
    }
    [tableView reloadData];
}

-(void)shareWithFriends
{
    //-- set up the data objects
    NSString *textObject = NSLocalizedString(@"SHARE_TEXT", @"Check out this cool app I've been using, Clock IT. Transform your device into an elegant modern nightstand alarm.");
    NSURL *url = [NSURL URLWithString:@"http://bit.ly/11XT7DG"];
    UIImage *image = [UIImage imageNamed:@"ShareIcon.png"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:textObject, url, image, nil];
    
    
    //-- initialising the activity view controller
    UIActivityViewController *avc = [[UIActivityViewController alloc]
                                     initWithActivityItems:activityItems
                                     applicationActivities:nil];
    
    //-- define the activity view completion handler
    avc.completionHandler = ^(NSString *activityType, BOOL completed){
        //NSLog(@"Activity Type selected: %@", activityType);
        if (completed) {
            //NSLog(@"Selected activity was performed.");
        } else {
            if (activityType == NULL) {
                //NSLog(@"User dismissed the view controller without making a selection.");
            } else {
                //NSLog(@"Activity was not performed.");
            }
        }
    };
    
    //-- define activity to be excluded (if any)
    avc.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypeAssignToContact, UIActivityTypePostToWeibo,UIActivityTypePrint,UIActivityTypeSaveToCameraRoll,UIActivityTypeCopyToPasteboard,nil];
    
    //-- show the activity view controller
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    //    {
    //        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:activityVC];
    //
    //        CGRect rect = [[UIScreen mainScreen] bounds];
    //
    //        [self.popoverController
    //         presentPopoverFromRect:rect inView:self.view
    //         permittedArrowDirections:0
    //         animated:YES];
    //    }
    //    else
    //    {
    [self presentViewController:avc animated:YES completion:nil];
    //    }

}


- (void) eMailSupport
{
    NSDateFormatter *detailedDateFormat = [[NSDateFormatter alloc]init];
    [detailedDateFormat setDateFormat:@"MMM dd, yyyy HH:mm:ss"];
    
    AppOsVersion *appdetail = [[AppOsVersion alloc]init];
    NSMutableArray *supportDetail = [appdetail supportDetailArray];
    NSLog(@"support array = %@",supportDetail);
    NSString *userDesclaimer=[NSString stringWithFormat: NSLocalizedString(@"SUPPORT_TEXT", @"PLEASE DESCRIBE BELOW THE PROBLEM YOU ARE FACING SO WE CAN IMPROVE YOUR Clock IT EXPERIENCE:<br><br><br><br><br>The following details relate to your application and device, helps us diagnose any technical issues which your comments might relate to.<br><br>However, you can remove them if you prefer.")];
    NSString *contentEmail =[NSString stringWithFormat:@"%@<br><br>OS version: %@<br>App version: %@<br>Device: %@<br>Country: %@",userDesclaimer,[supportDetail objectAtIndex:0],[supportDetail objectAtIndex:1],[supportDetail objectAtIndex:3],[supportDetail objectAtIndex:2]];
    
    MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
    [composer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail])
    {
        [composer setToRecipients:[NSArray arrayWithObjects:@"info@creoit.com", nil]];
        
        [composer setSubject:@"Clock IT Feedback"];
        // [composer setMessageBody:emailBody isHTML:NO];
        [composer setMessageBody:contentEmail isHTML:YES];
        [composer setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        [self presentViewController:composer animated:YES completion:nil];
    }

}
#pragma mark- Mail Delegate method

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(error)
    {
        // NSLog(@"Error occured ");
        [self dismissViewControllerAnimated:YES completion:^{ }];}
    else {
        [self dismissViewControllerAnimated:YES completion:^{ }];
    }
    [self.tableView reloadData];
}

- (void)writeUsAReview
{
    NSLog(@"writeUsAReview");
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"itms-apps://itunes.apple.com/app/id585965009" ]];

}

- (IBAction)doneButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{ }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DismissPopOver" object:nil];
    
}


@end
