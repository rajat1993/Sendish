//
//  NavigationView.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NavigationDelegate

-(void)setNavigationDelegates;
-(void)BtnSidePanel;

@end

@interface NavigationView : UIView

@property (nonatomic,assign) id <NavigationDelegate> delegate;

- (IBAction)Action_sidePanel:(id)sender;

@end
