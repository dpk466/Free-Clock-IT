//
//  SoundTableViewController.m
//  MyClockIt
//
//  Created by Deepak Bharati on 19/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "SoundTableViewController.h"
#import "MySound.h"
#import <AVFoundation/AVAudioPlayer.h>
#import <MediaPlayer/MediaPlayer.h>

#import "TSLibraryImport.h"
#import <AVFoundation/AVFoundation.h>

#import "Flurry.h"

#import "AlarmDatabase.h"

#import "MyAlert.h"



@interface SoundTableViewController ()<MPMediaPickerControllerDelegate>
{
    NSMutableArray *soundTableDataArray;
    
    UISegmentedControl *segmentedButton;
    UIBarButtonItem *addButton;
    NSMutableArray *musicTitles;
    NSMutableArray *musicURLs;
    
    //NSMutableArray *musicURLs30;
    
    
    AVAudioPlayer *player;
}

//@property(nonatomic,strong) AVAudioPlayer *player;

@property (strong, nonatomic) NSUserDefaults* defaults;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SoundTableViewController

@synthesize defaults = defaults;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize=CGSizeMake(320, 568);
    defaults = [NSUserDefaults standardUserDefaults];
	// Do any additional setup after loading the view.
    
    
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addMusic)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [defaults setInteger:0 forKey:@"SegmentIndex"];//always in first segment(for free)
    musicTitles = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"MusicTitles"]];NSLog(@"TitleCount= %d",musicTitles.count);
    musicURLs = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"MusicURLs"]];NSLog(@"URLCount= %d",musicURLs.count);
    
    //musicURLs30 = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"MusicURLs30"]];NSLog(@"30Sc_URLCount= %d",musicURLs30.count);
    
    if([defaults integerForKey:@"SegmentIndex"] == 0)
    {
        NSLog(@"Alarm tones");
        soundTableDataArray = [[NSMutableArray alloc]initWithObjects: NSLocalizedString(@"SOUND1", @"Tick tock jam"),
                               NSLocalizedString(@"SOUND2", @"Jingle bells"),
                               NSLocalizedString(@"SOUND3", @"Alarming"),
                               NSLocalizedString(@"SOUND4", @"Digital watch"),
                               NSLocalizedString(@"SOUND5", @"Good morning"),
                               NSLocalizedString(@"SOUND6", @"Morning flutter"),
                               NSLocalizedString(@"SOUND7", @"Rooster"),
                               NSLocalizedString(@"SOUND8", @"Spanish guitar"),
                               NSLocalizedString(@"SOUND9", @"Special morning"),
                               NSLocalizedString(@"SOUND10", @"Trance soft alarm"),
                               NSLocalizedString(@"SOUND11", @"Hip hop"), nil];
    }
    else if([defaults integerForKey:@"SegmentIndex"] == 1)
    {
        NSLog(@"Music tones");
        
        self.navigationItem.rightBarButtonItem = addButton;
        soundTableDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"MusicTitles"]];
    }
    
    [self.tableView reloadData];
}



#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //Headerview
    UIView *myView = [[UIView alloc] initWithFrame:CGRectZero] ;
    segmentedButton = [[UISegmentedControl alloc]initWithItems:@[NSLocalizedString(@"ALARMS_TEXT", @"Alarms"), NSLocalizedString(@"MUSIC_TEXT", @"Music")]];
    [segmentedButton setFrame:CGRectMake(25, 10,(self.view.frame.size.width-50), 30.0)];
    [segmentedButton setSelectedSegmentIndex:[defaults integerForKey:@"SegmentIndex"]];
    [segmentedButton addTarget:self action:@selector(segmentedButtonControl:) forControlEvents: UIControlEventValueChanged];
    [myView addSubview:segmentedButton];
    return myView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(segmentedButton.selectedSegmentIndex == 1)
    {
        return  NSLocalizedString(@"MUSIC_FOOTER", @"Music alarms will sound when app is running in foreground. Default alarm Tick tock jam will sound when app in lock screen or background.");
    }
    else
    {
        return @"";
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [soundTableDataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Sound_Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [soundTableDataArray objectAtIndex:indexPath.row];
    if([[soundTableDataArray objectAtIndex:indexPath.row] isEqualToString:[defaults objectForKey:@"SoundName"]])
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if(segmentedButton.selectedSegmentIndex == 1)
    {
        return YES;
    }
    else
    {
        return  NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"commitEditingStyle");
    [player stop];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"Delete in SoundTable Row");
        
        
        [soundTableDataArray removeObjectAtIndex:indexPath.row];
        NSLog(@"ok");
        [[AlarmDatabase database]updateAlarmSoundForSoundName:[musicTitles objectAtIndex:indexPath.row]];
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:[musicURLs objectAtIndex:indexPath.row] ] error:nil];
        NSLog(@"ok");
        [musicTitles removeObjectAtIndex:indexPath.row];NSLog(@"ok");
        [musicURLs removeObjectAtIndex:indexPath.row];NSLog(@"ok");
        
        NSLog(@"TitleCount= %lu",(unsigned long)musicTitles.count);
        NSLog(@"URLCount= %lu",(unsigned long)musicURLs.count);
        
        [defaults setObject:musicTitles forKey:@"MusicTitles"];
        [defaults setObject:musicURLs forKey:@"MusicURLs"];
        
        //[[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:[musicURLs30 objectAtIndex:indexPath.row] ] error:nil];
        //[musicURLs30 removeObjectAtIndex:indexPath.row];NSLog(@"ok");
        //NSLog(@"30Sc_URLCount= %d",musicURLs30.count);
        //[defaults setObject:musicURLs30 forKey:@"MusicURLs30"];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];//this may not be required
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath in SoundTable");
    [defaults setObject:[soundTableDataArray objectAtIndex:indexPath.row] forKey:@"SoundName"];
    [tableView reloadData];
    
    NSURL *url;
    if(segmentedButton.selectedSegmentIndex == 0)
    {
        NSString *fileName = [MySound soundWithSoundName:[defaults objectForKey:@"SoundName"]];
        NSString *fileNameWithoutExtension = [fileName substringToIndex:[fileName length]-4];
        //      NSLog(@"%@",fileName);NSLog(@"%@",fileNameWithoutExtension);
        NSString *path = [[NSBundle mainBundle]pathForResource:fileNameWithoutExtension ofType:@"m4r"];
        //      NSLog(@"path:%@",path);
        url = [NSURL fileURLWithPath:path];
    }
    else if(segmentedButton.selectedSegmentIndex == 1)
    {
        url = [NSURL URLWithString:[[defaults objectForKey:@"MusicURLs"] objectAtIndex:indexPath.row ]];
    }
    //    NSLog(@"%@",url);
    //    NSLog(@"%@",[defaults objectForKey:@"SoundName"]);
    player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [player play];
    
    NSDictionary *alarmSoundParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [defaults objectForKey:@"SoundName"], @"Alarm_Sound", // Capture Sound info
                                      nil];
    [Flurry logEvent:@"Alarm Sound Changed" withParameters:alarmSoundParams];
    
}

- (void)segmentedButtonControl:(UISegmentedControl *)segmentedControl
{
    [player stop];
    [defaults setInteger:segmentedControl.selectedSegmentIndex forKey:@"SegmentIndex"];
    
    if(segmentedControl.selectedSegmentIndex == 0)
    {
        //action for the first button (Current)
        NSLog(@"Alarm tones");
        soundTableDataArray = [[NSMutableArray alloc]initWithObjects: NSLocalizedString(@"SOUND1", @"Tick tock jam"),
                               NSLocalizedString(@"SOUND2", @"Jingle bells"),
                               NSLocalizedString(@"SOUND3", @"Alarming"),
                               NSLocalizedString(@"SOUND4", @"Digital watch"),
                               NSLocalizedString(@"SOUND5", @"Good morning"),
                               NSLocalizedString(@"SOUND6", @"Morning flutter"),
                               NSLocalizedString(@"SOUND7", @"Rooster"),
                               NSLocalizedString(@"SOUND8", @"Spanish guitar"),
                               NSLocalizedString(@"SOUND9", @"Special morning"),
                               NSLocalizedString(@"SOUND10", @"Trance soft alarm"),
                               NSLocalizedString(@"SOUND11", @"Hip hop"), nil];
        
        self.navigationItem.rightBarButtonItem = nil;
        
        self.editing = NO;
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
        //action for the second button
        NSLog(@"Music tones");
        
        soundTableDataArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"MusicTitles"]];
        
        self.navigationItem.rightBarButtonItem = addButton;
        
        self.editing = YES;
    }
    
    [self.tableView reloadData];
}

- (void) addMusic
{
    //[MyAlert referToFullVersionApp];
    [MyAlert presentAdvertisementPageUsing:self WithStartingPage:4];
//    [Flurry logEvent:@"Add Music from Music Library" ];
//    
//    NSLog(@"Add Music");
//    [player stop];
//    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
//    
//    mediaPicker.delegate                     = self;
//    mediaPicker.allowsPickingMultipleItems   = YES;
//    
//    [self.navigationController setNavigationBarHidden:YES];
//    [self.navigationController pushViewController:mediaPicker animated:NO];
    
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker
{
    //	[mediaPicker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
}


- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    NSLog(@"pickedMediaItem");
    //    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
	for (MPMediaItem* item in mediaItemCollection.items)
    {
		NSString* title = [item valueForProperty:MPMediaItemPropertyTitle];
        NSLog(@">>>%@",title);
        
		NSURL* assetURL = [item valueForProperty:MPMediaItemPropertyAssetURL];
        
		if (nil == assetURL)
        {
			/**
			 * !!!: When MPMediaItemPropertyAssetURL is nil, it typically means the file
			 * in question is protected by DRM. (old m4p files)
			 */
			return;
		}
        
        //save the list of titles
        if(![[defaults objectForKey:@"MusicTitles"] containsObject:title])
        {
            [musicTitles addObject:title];
        }
        [defaults setObject:musicTitles forKey:@"MusicTitles"];
        
        
        // create destination URL
        NSString* ext = [TSLibraryImport extensionForAssetURL:assetURL];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSURL* outURL = [[NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:title]] URLByAppendingPathExtension:ext];
        // we're responsible for making sure the destination url doesn't already exist
        [[NSFileManager defaultManager] removeItemAtURL:outURL error:nil];
        
        /* //creat and save 30 second audio url
         * AVAsset *avAsset = [AVAsset assetWithURL:assetURL];
         * if(![[defaults objectForKey:@"MusicURLs30"] containsObject:[self thirtySecondAudioFor:avAsset andDestinationURL:outURL]])
         * {
         *     [musicURLs30 addObject:[self thirtySecondAudioFor:avAsset andDestinationURL:outURL]];
         * }
         * [defaults setObject:musicURLs30 forKey:@"MusicURLs30"];
         */
        
        //save the list of dest Url
        if(![[defaults objectForKey:@"MusicURLs"] containsObject:[outURL absoluteString]])
        {
            [musicURLs addObject:[outURL absoluteString]];
        }
        [defaults setObject:musicURLs forKey:@"MusicURLs"];
        
        TSLibraryImport* fileToImport = [[TSLibraryImport alloc] init];
        
        [fileToImport importAsset:assetURL toURL:outURL completionBlock:^(TSLibraryImport* import)
         {
             //check the status and error properties of
             //TSLibraryImport
             if (import.status != AVAssetExportSessionStatusCompleted)
             {
                 // something went wrong with the import
                 NSLog(@"Error importing: %@", import.error);
                 import = nil;
                 return;
             }
             
             
             NSLog(@"Dest URL: %@",[outURL absoluteString]);
             
             //[mediaPicker dismissViewControllerAnimated:YES completion:nil];
             
         }];
        
	}
    NSLog(@"TitleCount= %d",musicTitles.count);
    NSLog(@"URLCount= %d",musicURLs.count);
    //NSLog(@"30Sc_URLCount= %d",musicURLs30.count);
    
}

/*
 - (NSString *)thirtySecondAudioFor:(AVAsset *)avAsset andDestinationURL:(NSURL *)destURL
 {
 
 // we need the audio asset to be at least 30 seconds long for this snippet
 CMTime assetTime = [avAsset duration];
 Float64 duration = CMTimeGetSeconds(assetTime);
 if (duration < 30.0) return nil;
 
 // get the first audio track
 NSArray *tracks = [avAsset tracksWithMediaType:AVMediaTypeAudio];
 if ([tracks count] == 0) return nil;
 
 AVAssetTrack *track = [tracks objectAtIndex:0];
 
 // create the export session
 // no need for a retain here, the session will be retained by the
 // completion handler since it is referenced there
 AVAssetExportSession *exportSession = [AVAssetExportSession
 exportSessionWithAsset:avAsset
 presetName:AVAssetExportPresetAppleM4A];
 if (nil == exportSession) return nil;
 
 // create trim time range - 20 seconds starting from 30 seconds into the asset
 CMTime startTime = CMTimeMake(0, 1);
 CMTime stopTime = CMTimeMake(29, 1);
 CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
 
 // create fade in time range - 10 seconds starting at the beginning of trimmed asset
 CMTime startFadeInTime = startTime;
 CMTime endFadeInTime = CMTimeMake(10, 1);
 CMTimeRange fadeInTimeRange = CMTimeRangeFromTimeToTime(startFadeInTime,
 endFadeInTime);
 
 // setup audio mix
 AVMutableAudioMix *exportAudioMix = [AVMutableAudioMix audioMix];
 AVMutableAudioMixInputParameters *exportAudioMixInputParameters =
 [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
 
 [exportAudioMixInputParameters setVolumeRampFromStartVolume:0.0 toEndVolume:1.0
 timeRange:fadeInTimeRange];
 exportAudioMix.inputParameters = [NSArray
 arrayWithObject:exportAudioMixInputParameters];
 
 
 NSURL *newURLFor30SecondPlayBack = [NSURL URLWithString:[NSString stringWithFormat:@"%@30",[destURL absoluteString]]];
 // we're responsible for making sure the destination url doesn't already exist
 [[NSFileManager defaultManager] removeItemAtURL:newURLFor30SecondPlayBack error:nil];
 
 // configure export session  output with all our parameters
 exportSession.outputURL = newURLFor30SecondPlayBack; // output path
 exportSession.outputFileType = AVFileTypeAppleM4A; // output file type
 exportSession.timeRange = exportTimeRange; // trim time range
 exportSession.audioMix = exportAudioMix; // fade in audio mix
 
 // perform the export
 [exportSession exportAsynchronouslyWithCompletionHandler:^{
 
 if (AVAssetExportSessionStatusCompleted == exportSession.status) {
 NSLog(@"AVAssetExportSessionStatusCompleted");
 } else if (AVAssetExportSessionStatusFailed == exportSession.status) {
 // a failure may happen because of an event out of your control
 // for example, an interruption like a phone call comming in
 // make sure and handle this case appropriately
 NSLog(@"AVAssetExportSessionStatusFailed");
 } else {
 NSLog(@"Export Session Status: %d", exportSession.status);
 }
 }];
 
 
 return  [newURLFor30SecondPlayBack absoluteString];
 }
 */

@end
