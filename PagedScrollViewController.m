//
//  PagedScrollViewController.m
//  ScrollViews
//
//  Created by Matt Galloway on 01/03/2012.
//  Copyright (c) 2012 Swipe Stack Ltd. All rights reserved.
//

#import "PagedScrollViewController.h"

@interface PagedScrollViewController ()
{
    //NSMutableArray *controllers;
}
@end

@implementation PagedScrollViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PagedScrollViewController loaded");
    
	// Do any additional setup after loading the view.
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //controllers = [[NSMutableArray alloc] initWithCapacity:0];
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    //just adding 4 views
    for(int i = 0; i < self.images.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:(UIImage *)[self.images objectAtIndex:i]];
        imageView.frame = CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height);
        //imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imageView];
    }
    
    /*
    UIImageView *firstImageView = [[UIImageView alloc]initWithImage:(UIImage *)[self.images objectAtIndex:0]];
    firstImageView.frame = CGRectMake(self.view.frame.size.width*0, 0, self.view.frame.size.width, self.view.frame.size.height);
    //firstImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:firstImageView];
    [controllers addObject:firstImageView];
    
    UIImageView *secondImageView = [[UIImageView alloc]initWithImage:(UIImage *)[self.images objectAtIndex:1]];
    secondImageView.frame = CGRectMake(self.view.frame.size.width*1, 0, self.view.frame.size.width, self.view.frame.size.height);
    //secondImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:secondImageView];
    [controllers addObject:secondImageView];
    
    UIImageView *thirdImageView = [[UIImageView alloc]initWithImage:(UIImage *)[self.images objectAtIndex:2]];
    thirdImageView.frame = CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height);
    //thirdImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:thirdImageView];
    [controllers addObject:thirdImageView];
    
    UIImageView *fourthImageView = [[UIImageView alloc]initWithImage:(UIImage *)[self.images objectAtIndex:3]];
    fourthImageView.frame = CGRectMake(self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height);
    //fourthImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:fourthImageView];
    [controllers addObject:fourthImageView];
    */
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.images.count, self.scrollView.frame.size.height);
    //NSLog(@"\nEntire content size :\n\n\t\t%1.0f\n\t\t%1.0f",self.scrollView.contentSize.width,self.scrollView.contentSize.height);
    self.pageControl.numberOfPages = self.images.count;//[controllers count];

}
#pragma mark - scroll view delegates

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	_pageControlBeingUsed = NO;
}

#pragma mark - my method to change to appropriate page

- (IBAction)next {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    _pageControlBeingUsed = YES;
}

- (IBAction)dissmisThisView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)referToAppStore:(id)sender
{
    NSLog(@"Go to appStore");
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: @"itms-apps://itunes.apple.com/app/id585965009" ]];
}

@end