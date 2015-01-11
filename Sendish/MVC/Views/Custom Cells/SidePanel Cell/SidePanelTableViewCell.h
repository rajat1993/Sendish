//
//  SidePanelTableViewCell.h
//  Sendish
//
//  Created by Rajat Sharma on 09/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidePanelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView_leftImg;
@property (weak, nonatomic) IBOutlet UILabel *Label_sidePanelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgView_rightImg;

@end
