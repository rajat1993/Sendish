//
//  ReceivedSendishTableViewCell.h
//  Sendish
//
//  Created by Rajat Sharma on 09/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceivedSendishTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *Label_location;
@property (weak, nonatomic) IBOutlet UILabel *Label_postTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_receivedSendish;
@property (weak, nonatomic) IBOutlet UILabel *Label_comments;
@property (weak, nonatomic) IBOutlet UILabel *Label_cities;
@property (weak, nonatomic) IBOutlet UILabel *Label_likes;

@end
