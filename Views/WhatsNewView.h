//
//  WhatsNewView.h
//  Clock IT
//
//  Created by Deepak Bharati on 17/12/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WhatsNewView : UIView

@property (strong, nonatomic) NSUserDefaults *defaults;

@property (strong, nonatomic) IBOutlet UILabel * headerLabel;

@property (strong, nonatomic) IBOutlet UILabel * featureLabel1;

@property (strong, nonatomic) IBOutlet UILabel * featureLabel2;

@property (strong, nonatomic) IBOutlet UILabel * featureImageLabel1;

@property (strong, nonatomic) IBOutlet UILabel * featureImageLabel2;

@property (strong, nonatomic) IBOutlet UIButton *nextButton;

- (void)awakeFromNib;

- (IBAction)goToApp:(id)sender;

@end
