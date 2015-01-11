//
//  ReceivedSendishViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedSendishViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewObj;

@end
