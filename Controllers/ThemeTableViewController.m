//
//  ThemeTableViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 31/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "ThemeTableViewController.h"
#import "Flurry.h"

#import "MyAlert.h"

@interface ThemeTableViewController ()
{
    NSArray * themeArray;
    NSArray * themeImageArray;
}

@property (strong, nonatomic) NSUserDefaults* defaults;

@end

@implementation ThemeTableViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize=CGSizeMake(320, 568);
	defaults = [NSUserDefaults standardUserDefaults];
    // Do any additional setup after loading the view.
    
    themeArray = [NSArray arrayWithObjects: NSLocalizedString(@"MODERNO_TEXT", @"Moderno"),
                                            NSLocalizedString(@"CARBON_TEXT", @"Carbon"),
                                            NSLocalizedString(@"SCARLET_TEXT", @"Scarlet"),
                                            NSLocalizedString(@"AZURE_TEXT", @"Azure"),
                                            NSLocalizedString(@"HARMONY_TEXT", @"Harmony"),
                                            NSLocalizedString(@"SUNSHINE_TEXT", @"Sunshine"),
                                            NSLocalizedString(@"AURORA_TEXT", @"Aurora"),
                                            NSLocalizedString(@"XMAS_TEXT", @"Xmas"), nil];
    
    
    themeImageArray = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"moderno.png"],
                       [UIImage imageNamed:@"carbon.png"],
                       [UIImage imageNamed:@"scarlet.png"],
                       [UIImage imageNamed:@"azure.png"],
                       [UIImage imageNamed:@"harmony.png"],
                       [UIImage imageNamed:@"sunshine.png"],
                       [UIImage imageNamed:@"aurora.png"],
                       [UIImage imageNamed:@"xmas.png"], nil];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [themeArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Theme_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [themeArray objectAtIndex:indexPath.row];
    
    if(indexPath.row == [defaults integerForKey:@"Theme"])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UIImage *myImage = [themeImageArray objectAtIndex:indexPath.row];
    
    UIImageView *myBgImgView = [[UIImageView alloc]initWithFrame:cell.frame];
    
    [myBgImgView setContentMode:UIViewContentModeScaleToFill];
    //Enable maskstobound so that corner radius would work.
    [myBgImgView.layer setMasksToBounds:YES];
    //Set the corner radius
    [myBgImgView.layer setCornerRadius:10.0];
    //Set the border color
    [myBgImgView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    //Set the image border width
    [myBgImgView.layer setBorderWidth:5.0];
    
    [myBgImgView setImage:myImage];
    
    [cell setBackgroundView:myBgImgView];
    if(indexPath.row == 1 && [themeArray count]==2)
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setBackgroundView:nil];
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath in ThemeTable");
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [defaults setObject:cell.textLabel.text forKey:@"ThemeString"];
    [defaults setInteger:indexPath.row forKey:@"Theme"];
    
    [NSThread sleepForTimeInterval:0.1];
    [tableView reloadData];
    
    NSDictionary *themeParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [defaults objectForKey:@"ThemeString"], @"Theme", // Capture theme info
                                          nil];
    [Flurry logEvent:@"Theme Changed" withParameters:themeParams];
    
    if(indexPath.row == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTheme" object:nil];
    }
    else
    {
        NSLog(@"Go to appStore");
        //[MyAlert referToFullVersionApp];
        [MyAlert presentAdvertisementPageUsing:self WithStartingPage:3];
        [defaults setObject:NSLocalizedString(@"MODERNO_TEXT", @"Moderno") forKey:@"ThemeString"];
        [defaults setInteger:0 forKey:@"Theme"];
        
    }
}


@end
