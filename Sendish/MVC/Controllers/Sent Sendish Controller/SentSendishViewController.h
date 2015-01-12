//
//  SentSendishViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MNMBottomPullToRefreshManager.h"

@interface SentSendishViewController : UIViewController <MNMBottomPullToRefreshManagerClient, UITableViewDataSource, UITableViewDelegate>

@property MNMBottomPullToRefreshManager *pullToRefreshManager;

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView_sentSendish;

@end
