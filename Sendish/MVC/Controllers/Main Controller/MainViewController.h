//
//  MainViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceivedSendishViewController.h"
#import "TakeSendishViewController.h"
#import "SentSendishViewController.h"

@interface MainViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic,strong) UIPageViewController *pageViewCtrlr;
@property (nonatomic,strong) ReceivedSendishViewController *receivedCtrlr;
@property (nonatomic,strong) TakeSendishViewController *takeSendishCtrlr;
@property (nonatomic,strong) SentSendishViewController *sentCtrlr;

@property (nonatomic, strong) NSArray *pages;

@end
