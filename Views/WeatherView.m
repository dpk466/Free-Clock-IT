//
//  WeatherView.m
//  MyClockIt
//
//  Created by Deepak Bharati on 08/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import "WeatherView.h"

@implementation WeatherView

@synthesize tempratureLabel, weatherConditionLabel, weatherImageView;

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
    weatherImageView.image = [UIImage imageNamed:@"myImage.png"];
    //NSLog(@"..............................%@",[UIImage imageNamed:@"myImage.png"]);
    tempratureLabel.text = @"";
    weatherConditionLabel.text = @"";
}

- (void)dealloc
{
    weatherImageView.image = nil;
    //NSLog(@"..............................%@",[UIImage imageNamed:@"myImage.png"]);
    tempratureLabel.text = nil;
    weatherConditionLabel.text = nil;
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
