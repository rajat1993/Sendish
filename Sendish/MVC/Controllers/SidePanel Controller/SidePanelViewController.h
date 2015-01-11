//
//  SidePanelViewController.h
//  Sendish
//
//  Created by Rajat Sharma on 07/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIView+REFrostedViewController.h>
#import <REFrostedViewController.h>

@interface SidePanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic,strong) NSString *nickName;

@property (weak, nonatomic) IBOutlet UITableView *sidePanelTable;

@end
