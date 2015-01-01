//
//  AlertView.h
//  CliqueIn
//
//  Created by CB Macmini_2 on 21/11/14.
//  Copyright (c) 2014 CB Macmini_2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertView.h"

@interface AlertView : UIView <UIAlertViewDelegate>

-(void)showStaticAlertWithTitle : (NSString *)title AndMessage : (NSString *)msg;

@end
