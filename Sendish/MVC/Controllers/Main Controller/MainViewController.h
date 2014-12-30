//
//  MainViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic,strong) UIPageViewController *pageViewCtrlr;

@property (weak, nonatomic) IBOutlet UIView *navigationView;

@end
