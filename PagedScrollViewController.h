//
//  PagedScrollViewController.h
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagedScrollViewController : UIViewController <UIScrollViewDelegate>
{
    


}

@property (nonatomic,strong) NSArray *images;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;

@property BOOL pageControlBeingUsed;
- (IBAction)next;

- (IBAction)dissmisThisView:(id)sender;
- (IBAction)referToAppStore:(id)sender;
@end