//
//  MySound.m
//  MyClockIt
//
//  Created by Deepak Bharati on 26/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "MySound.h"

@implementation MySound

//@synthesize soundDictionary = soundDictionary;

@synthesize  defaults = defaults;
- (id)init
{
    self = [super init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *fileNames = [[NSMutableArray alloc] initWithObjects:@"tickTockJam.m4r", @"jingleBells.m4r", @"alarming.m4r", @"digitalWatch.m4r", @"goodMorning.m4r", @"morningFlutter.m4r", @"rooster.m4r", @"spanishGuitar.m4r", @"specialMorning.m4r", @"tranceSoftAlarm.m4r", @"hipHop.m4r", nil];
    
    NSMutableArray *keyNames = [[NSMutableArray alloc] initWithObjects: NSLocalizedString(@"SOUND1", @"Tick tock jam"),
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
    
    //NSLog(@"%@... %@",[defaults objectForKey:@"MusicTitles"],[defaults objectForKey:@"MusicURLs"]);
    [fileNames addObjectsFromArray:[defaults objectForKey:@"MusicURLs"]];
    [keyNames addObjectsFromArray:[defaults objectForKey:@"MusicTitles"]];
    
    NSDictionary *myDictionary = [[NSDictionary alloc] initWithObjects:fileNames forKeys:keyNames];//NSLog(@"myDictionary : %@..",myDictionary);
    self.soundDictionary = [[NSMutableDictionary alloc] initWithDictionary:myDictionary];
    
    return self;
}



+ (NSString *)soundWithSoundName:(NSString *)soundName
{
    MySound *mySound = [[MySound alloc]init];
    
    NSString *soundFileName = [mySound.soundDictionary objectForKey:soundName];
    return soundFileName;
}

@end
