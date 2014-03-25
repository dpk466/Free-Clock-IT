//
//  WhatsNewView.m
//  Clock IT
//
//  Created by Deepak Bharati on 17/12/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "WhatsNewView.h"



@implementation WhatsNewView

@synthesize defaults = defaults;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    
    self.headerLabel.text = NSLocalizedString(@"WHATS_NEW_HEADER", @"About this version, bla bla...");


    self.featureLabel1.text = NSLocalizedString(@"FEATURE_ONE", @"Feature1");
    self.featureLabel2.text = NSLocalizedString(@"FEATURE_TWO", @"Feature2");
    

    self.featureImageLabel1.text = @"↕︎";
    
    self.featureImageLabel2.text = @"⤵︎";
     
    [self.nextButton setTitle:NSLocalizedString(@"OK_BUTTON", @"Ok") forState:UIControlStateNormal];
    
}

- (IBAction)goToApp:(id)sender
{
    NSLog(@"Go to App...");
//    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeWhatsNewView" object:nil];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
