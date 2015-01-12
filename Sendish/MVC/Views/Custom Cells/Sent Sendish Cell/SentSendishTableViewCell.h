//
//  SentSendishTableViewCell.h
//  Sendish
//
//  Created by Rajat Sharma on 12/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SentSendishTableViewCell : UITableViewCell

@property BOOL imageLoaded;

@property (weak, nonatomic) IBOutlet UILabel *Label_lastLocation;
@property (weak, nonatomic) IBOutlet UILabel *Label_timeAgo;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_sentSendish;
@property (weak, nonatomic) IBOutlet UIButton *Btn_likesCount;
@property (weak, nonatomic) IBOutlet UIButton *Btn_citiesCount;
@property (weak, nonatomic) IBOutlet UIButton *Btn_commentsCount;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

- (IBAction)Action_comments:(id)sender;
- (IBAction)Action_cities:(id)sender;
- (IBAction)Action_likes:(id)sender;

@end
