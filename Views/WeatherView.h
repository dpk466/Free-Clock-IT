//
//  WeatherView.h
//  MyClockIt
//
//  Created by Deepak Bharati on 08/11/13.
//  Copyright (c) 2013 Deepak Bharati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (strong, nonatomic) IBOutlet UILabel * tempratureLabel;
@property (strong, nonatomic) IBOutlet UILabel * weatherConditionLabel;


@end
