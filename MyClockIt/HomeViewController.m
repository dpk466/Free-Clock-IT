//
//  ViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 30/10/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "HomeViewController.h"
#import "MyDateTime.h"
#import "Theme.h"
#import <CoreLocation/CoreLocation.h>
#import "MyWebRequests.h"

#import "AlarmDatabase.h"
#import "WeatherDatabase.h"
#import "AlarmInfo.h"
#import "WeatherViewInfo.h"
#import "AFNetworking.h"

#import "MySound.h"

//#import <AVFoundation/AVAudioPlayer.h>
//#import <AVFoundation/AVFoundation.h>

#import "RingingViewController.h"

#import "Flurry.h"

#import "iAd/iAd.h"


//#import "SettingViewController.h"

@interface HomeViewController ()<CLLocationManagerDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate, ADBannerViewDelegate>
{
//    AVAudioPlayer *player;
    int seconds;
    IBOutlet ADBannerView *buttomAdBanner;
}



@property (strong, nonatomic) CAGradientLayer *myGradientLayer;

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) IBOutlet UIView *dimView;

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) IBOutlet UIImageView *xmasHatImageView;

@property (strong, nonatomic) IBOutlet UILabel *snoozeTimerLabel;

@property (strong, nonatomic) UIView *whatsNewView;
@end


@implementation HomeViewController
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    
    UIPopoverController *myPopOverController;
    
    CGPoint touchBeganLocation;
    float currentBrightness;
    float lastVal;
}

@synthesize defaults = defaults, dimView = dimView;


#pragma mark - Life cycle methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttomAdBanner.delegate = self;
    //[buttomAdBanner setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    defaults = [NSUserDefaults standardUserDefaults];
    //[[UIScreen mainScreen] setBrightness:1];
   	// Do any additional setup after loading the view.
    
    BOOL iDoNotHaveAutoLock = ![defaults boolForKey:@"AutoLockSwitch"];
    if(iDoNotHaveAutoLock)
    {
        //don't lock
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setTheme)
                                                 name:@"UpdateTheme"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissMyPopoverController)
                                                 name:@"DismissPopOver"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toggleWeatherView)
                                                 name:@"toggleWeatherView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeWhatsNewView)
                                                 name:@"removeWhatsNewView"
                                               object:nil];
    
    
    [self displayLocation];
    [self displayDate];
    [self displayTime];
    [self displayAMPM];
//    if([defaults boolForKey:@"WeatherSwitch"])
//    {
//        [self displayWeather];
//    }
    [self setTheme];
    //[self addSwipesToAdjustBrightness];
    
    [self.snoozeTimerLabel setHidden:YES];

    seconds = (int)self.valueForTimer;
    if(seconds > 0)
    {
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimerWithNoOfSeconds) userInfo:nil repeats:YES];
    }
    
    BOOL newFeatureAdded = [defaults boolForKey:@"NewFeatureAdded"];
    if(newFeatureAdded)
    {
        [self loadWhatsNewView];

    }
    
    currentBrightness = [[UIScreen mainScreen] brightness];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL whatNewViewIsLoaded = [defaults boolForKey:@"NewFeatureAdded"];
    if(whatNewViewIsLoaded)
    {
        [defaults setBool:NO forKey:@"SwipeEnabled"];
    }
    else
    {
        [defaults setBool:YES forKey:@"SwipeEnabled"];
    }
    
    NSArray *alarmInfos = [[NSMutableArray alloc]initWithArray:[[AlarmDatabase database]getAllAlarms]];
    for(AlarmInfo *anInfo in alarmInfos)
    {
        if(anInfo.status == 1)
        {
            [defaults setBool:YES forKey:@"ActiveAlarms"];
            break;
        }
        [defaults setBool:NO forKey:@"ActiveAlarms"];
    }
    if([defaults boolForKey:@"ActiveAlarms"])
    {
        //self.alarmsButton.alpha = 1;
        [self setAlarmIconOn:YES];
    }
    else
    {
        //self.alarmsButton.alpha = 0.5;
        [self setAlarmIconOn:NO];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [defaults setBool:NO forKey:@"SwipeEnabled"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Display Methods

- (void) displayLocation
{
    //self.locationLabel.text = @"\"Current Location\"";
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
}

- (void) displayDate
{
    self.dateLabel.text = [MyDateTime getDateString];
    [self performSelector:@selector(displayDate) withObject:self afterDelay:1.0];
}

- (void) displayTime
{
    self.timeLabel.text = [MyDateTime getTimeStringWithFormat:[defaults integerForKey:@"TimeFormat"]];
    [self performSelector:@selector(displayTime) withObject:self afterDelay:1.0];
}

- (void) displayAMPM
{
    self.amPmLabel.text = [defaults integerForKey:@"TimeFormat"] == 0 ? [[MyDateTime getAMPMString] uppercaseString] : @"";
    [self performSelector:@selector(displayAMPM) withObject:self afterDelay:1.0];
}

- (void) displayWeather
{

    //[MyWebRequests updateWeatherInfo:self.weatherView withLocation:locationManager.location];
    [self performSelector:@selector(displayWeather) withObject:self afterDelay:3600];
   
}


-(void) toggleWeatherView
{
    if([defaults boolForKey:@"WeatherSwitch"])
    {
        NSLog(@"Weather ON");
        [self displayLocation];//this take care of location update as well
        //[self displayWeather];
    }
    else
    {
        NSLog(@"Weather OFF");
        self.weatherView.weatherImageView.image = nil;
        self.weatherView.weatherConditionLabel.text = nil;
        self.weatherView.tempratureLabel.text = nil;
    }
}


- (void) setTheme
{
    [self.timeLabel setTextColor:[UIColor whiteColor]];
    [self.amPmLabel setTextColor:[UIColor whiteColor]];
    [self.xmasHatImageView setHidden:YES];
    
    
    NSArray * themeLists = [[[Theme alloc]init ]getThemeList];
    //NSLog(@"themeLists count = %lu",(unsigned long)[themeLists count]);
    id theme = ([themeLists count] > [defaults integerForKey:@"Theme"]) ? [themeLists objectAtIndex:[defaults integerForKey:@"Theme"] ] : NULL;
    
    if ([defaults integerForKey:@"Theme"] == 0 | [defaults integerForKey:@"Theme"] == 7)//Moderno image and Xmas images
    {
        [self.myGradientLayer removeFromSuperlayer];
        [Theme setTheme:theme toView:self.backgroundImageView];
        
        if([defaults integerForKey:@"Theme"] == 7)
        {
            //code change the font color to dark blue.. for timeLabel and AM/PM label
            [self.timeLabel setTextColor:[UIColor colorWithRed:0.0235 green:0.2313 blue:0.5058 alpha:1]];
            [self.amPmLabel setTextColor:[UIColor colorWithRed:0.0235 green:0.2313 blue:0.5058 alpha:1]];
            [self.xmasHatImageView setHidden:NO];
        }
    }
    else if([defaults integerForKey:@"Theme"] == 6)//gradient
    {
        self.backgroundImageView.image = nil;
        [self.myGradientLayer removeFromSuperlayer];
        self.view.backgroundColor = [UIColor blackColor];

        self.myGradientLayer = [CAGradientLayer layer];
        self.myGradientLayer .colors = [NSArray arrayWithObjects:
                        (id)[[UIColor colorWithRed:0.094 green:0.172 blue:0.2 alpha:1]CGColor],
                        (id)[[UIColor colorWithRed:0.184 green:0.364 blue:0.239 alpha:1]CGColor],
                        (id)[[UIColor colorWithRed:0.63 green:0.803 blue:0.596 alpha:1]CGColor], nil];
        self.myGradientLayer.frame = self.view.bounds;//needs improvement
        [self.view.layer insertSublayer:self.myGradientLayer  atIndex:0];
    }
    else//color theme
    {
        [self.myGradientLayer removeFromSuperlayer];
        self.backgroundImageView.image = nil;
        [Theme setTheme:theme toView:self.view];
    }

}

- (void)viewWillLayoutSubviews
{
    if ([defaults integerForKey:@"Theme"] == 0 |
        [defaults integerForKey:@"Theme"] == 7)
    {
        [self setTheme];

    }
    if([defaults integerForKey:@"Theme"] == 6)
    {
        [self.myGradientLayer removeFromSuperlayer];
        [self setTheme];
    }
}

#pragma mark - Brightness Methods

#pragma mark -Using Swipe
/*//-(void) addSwipesToAdjustBrightness
//{
//    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft)];
//    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.view addGestureRecognizer:swipeLeft];
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRight];
//
//}
//
//- (void)swipeLeft
//{
//    //NSLog(@"leftSwipe");
//    brightnessValue -= 0.2;
//    if(brightnessValue < 0) brightnessValue = 0;
//    [[UIScreen mainScreen] setBrightness:brightnessValue];
//}
//
//- (void)swipeRight
//{
//    //NSLog(@"rightSwipe");
//    brightnessValue += 0.2;
//    if(brightnessValue > 1) brightnessValue = 1;
//    [[UIScreen mainScreen] setBrightness:brightnessValue];
//}
*/
 
#pragma mark -Using UITouch & Black UIView Coordinate


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    touchBeganLocation = [touch locationInView:self.view];
    NSLog(@"touchBeganLocation: %f",touchBeganLocation.y);
    dimView.userInteractionEnabled = NO;
    
    lastVal = touchBeganLocation.y;
    
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if([defaults boolForKey:@"SwipeEnabled"])
    {
        currentBrightness = [[UIScreen mainScreen] brightness];
        float currentAlpha = dimView.alpha;

        UITouch *touch = [touches anyObject];
        CGPoint currentPosition = [touch locationInView:self.view];
        
        
    //    if(currentPosition.y < touchBeganLocation.y  )
    //    {
    //        NSLog(@"currentMagnitude: %.2f",1-(currentPosition.y/touchBeganLocation.y));
    //    }
    //    else
    //    {
    //        NSLog(@"currentMagnitude: %.2f",(touchBeganLocation.y/currentPosition.y));
    //    }
        
        
        if(abs(lastVal-currentPosition.y) > 5)//only when significant changes
        {
            
            if(currentPosition.y < touchBeganLocation.y  )//moving up side
            {
    //            if(abs(currentPosition.x - touchBeganLocation.x) < 10)
                {
                    currentAlpha -= (50/self.view.frame.size.height);
                    if(currentAlpha <= 0.0)currentAlpha = 0.0;
                    
                    currentBrightness += (50/self.view.frame.size.height);
                    if(currentBrightness > 1.0)currentBrightness = 1.0;
                }
            }
            else//moving down side
            {
                
    //            if(abs(currentPosition.x - touchBeganLocation.x) < 10)
                {
                    currentAlpha += (50/self.view.frame.size.height);
                    if([defaults boolForKey:@"BrightnessSwitch"] == NO)
                    {
                        if(currentAlpha >= 0.60)currentAlpha = 0.60;
                    }
                    else
                    {
                        if(currentAlpha >= 0.80)currentAlpha = 0.80;
                    }
                    
                    currentBrightness -= (50/self.view.frame.size.height);
                    if(currentBrightness < 0.2)currentBrightness = 0.2;
                }
            }
            lastVal = currentPosition.y;
        }
        
        NSLog(@"alphaVal: %f", currentAlpha);
        NSLog(@"brightVal: %f", currentBrightness);
        
        dimView.alpha = currentAlpha;
        if([defaults boolForKey:@"BrightnessSwitch"] == NO)
        {
            [[UIScreen mainScreen] setBrightness:currentBrightness];

        }
        
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [Flurry logEvent:@"Swiped for Brightness"];
}

#pragma mark - Button Methods

- (IBAction)goToSetting:(id)sender
{
    NSLog(@"goToSetting");
    
    UINavigationController *navigationControllerForSetting = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigationControllerForSetting"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (myPopOverController == nil)
        {
            myPopOverController = [[UIPopoverController alloc] initWithContentViewController:navigationControllerForSetting];
            [myPopOverController presentPopoverFromRect:((UIButton*)sender).bounds inView:(UIButton*)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            myPopOverController.delegate=self;
            
        }
        else
        {
            [myPopOverController dismissPopoverAnimated:YES];
            myPopOverController = nil;
        }
    }
    else
    {
        [self presentViewController:navigationControllerForSetting animated:YES completion:nil];
    }
    
}

- (IBAction)goToAlarms:(id)sender
{
    NSLog(@"goToAlarms");
    
    UINavigationController *navigationControllerForAlarms = [self.storyboard instantiateViewControllerWithIdentifier:@"UINavigatoionControllerForAlarms"];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (myPopOverController == nil)
        {
            myPopOverController = [[UIPopoverController alloc] initWithContentViewController:navigationControllerForAlarms];
            [myPopOverController presentPopoverFromRect:((UIButton*)sender).bounds inView:(UIButton*)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            myPopOverController.delegate=self;
            
        }
        else
        {
            [myPopOverController dismissPopoverAnimated:YES];
            myPopOverController = nil;
        }
    }
    else
    {
        [self presentViewController:navigationControllerForAlarms animated:YES completion:nil];
    }

}

#pragma mark - hide status bar method
//for hiding the status bar
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - CLLocationManagerDelegate Method

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    
    //NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        //NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0)
        {
            placemark = [placemarks lastObject];
            //NSLog(@"Place String: %@",[NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea]);
            if(placemark.locality && placemark.administrativeArea)//only if locality is available then show it.
            {
                //self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.administrativeArea, placemark.country];//Karnataka, India
                
                self.locationLabel.text = [NSString stringWithFormat:@"%@, %@", placemark.locality, placemark.administrativeArea];//Bangalore, Karnataka
            }
            else
            {
                if(placemark.locality)self.locationLabel.text = placemark.locality;
                else if(placemark.administrativeArea)self.locationLabel.text = placemark.administrativeArea;
                else self.locationLabel.text = nil;
            }
            
            //find the weather
            if([defaults boolForKey:@"WeatherSwitch"])
            {
                //[MyWebRequests updateWeatherInfo:self.weatherView withLocation:locationManager.location];
            }
            
        }
        else
        {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}

#pragma mark - UIPopoverControllerDelegate Method
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self dismissMyPopoverController];
    
    NSArray *alarmInfos = [[NSMutableArray alloc]initWithArray:[[AlarmDatabase database]getAllAlarms]];
    for(AlarmInfo *anInfo in alarmInfos)
    {
        if(anInfo.status == 1)
        {
            [defaults setBool:YES forKey:@"ActiveAlarms"];
            break;
        }
        [defaults setBool:NO forKey:@"ActiveAlarms"];
    }
    if([defaults boolForKey:@"ActiveAlarms"])
    {
        //self.alarmsButton.alpha = 1;
        [self setAlarmIconOn:YES];
    }
    else
    {
        //self.alarmsButton.alpha = 0.5;
        [self setAlarmIconOn:NO];
    }
}

- (void)dismissMyPopoverController
{
    if (myPopOverController)
    {
        [myPopOverController dismissPopoverAnimated:YES];
        myPopOverController = nil;
    }
}

- (void)updateTimerWithNoOfSeconds
{
    if(seconds > 0 )
    {
        //hours = secondsLeft / 3600;
        int minutes = (seconds % 3600) / 60;
        //NSLog(@"minutes===%d seconds==%d",minutes,seconds);
        int  secondsTemp = (seconds %3600) % 60;
        NSString *minutesToSnooze=[NSString stringWithFormat:@"%02d",minutes];
        NSString *secondsToSnooze=[NSString stringWithFormat:@"%02d",secondsTemp];
        NSString *snoozeLabelString=[NSString stringWithFormat:@"%@:%@",minutesToSnooze,secondsToSnooze];
        [self.snoozeTimerLabel setHidden:NO];
        self.snoozeTimerLabel.text=snoozeLabelString;
        //NSLog(@"snoozeLabelString===%@",snoozeLabelString);
        seconds--;
    }
    else
    {
        
        [self.snoozeTimerLabel setHidden:YES];
        
    }
}


- (void)loadWhatsNewView
{
    self.whatsNewView = [[UIView alloc]init];
   
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)//iPhone
    {
        self.whatsNewView = [[[NSBundle mainBundle] loadNibNamed:@"WhatsNewView_iPhone"
                                                          owner:[[UIView alloc] init]
                                                        options:nil] objectAtIndex:0 ];
        
    }
    else//iPad, iPod_touch
    {
        self.whatsNewView = [[[NSBundle mainBundle] loadNibNamed:@"WhatsNewView_iPad"
                                                           owner:[[UIView alloc] init]
                                                         options:nil] objectAtIndex:0 ];
    }
    self.whatsNewView.frame = self.view.frame;
    [self.view addSubview:self.whatsNewView];
    
//    self.alarmsButton.alpha = 1;
}

- (void)removeWhatsNewView
{
    NSLog(@"remove whats new view");
    [self.whatsNewView removeFromSuperview];
    self.whatsNewView = nil;
    if([defaults boolForKey:@"ActiveAlarms"])
    {
        //self.alarmsButton.alpha = 1;
        [self setAlarmIconOn:YES];
    }
    else
    {
        //self.alarmsButton.alpha = 0.5;
        [self setAlarmIconOn:NO];
    }
    [defaults setBool:YES forKey:@"SwipeEnabled"];
    [defaults setBool:NO forKey:@"NewFeatureAdded"];

}




-(void)detectOrientation
{
    
    switch ([[UIDevice currentDevice] orientation])
    {

        case UIDeviceOrientationFaceDown:
        {
            NSLog(@"facedown!!");
            [[UIScreen mainScreen] setBrightness:0];
            break;
        }
        default:
        {
            [[UIScreen mainScreen] setBrightness:currentBrightness];
            break;
        }
    }
}

- (void)setAlarmIconOn:(BOOL)on
{
    if(on)
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.alarmsButton setImage:[UIImage imageNamed:@"alarmOn_iPhone"] forState:UIControlStateNormal];
        }
        else
        {
            [self.alarmsButton setImage:[UIImage imageNamed:@"alarmOn_iPad"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            [self.alarmsButton setImage:[UIImage imageNamed:@"alarmOff_iPhone"] forState:UIControlStateNormal];
        }
        else
        {
            [self.alarmsButton setImage:[UIImage imageNamed:@"alarmOff_iPad"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - iAdBanner Delegates

-(void)bannerView:(ADBannerView *)banner
didFailToReceiveAdWithError:(NSError *)error{
    NSLog(@"Error in Loading Banner!");
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd banner Loaded Successfully!");
}
-(void)bannerViewWillLoadAd:(ADBannerView *)banner{
    NSLog(@"iAd Banner will load!");
}
-(void)bannerViewActionDidFinish:(ADBannerView *)banner{
    NSLog(@"iAd Banner did finish");
    
}



@end
