//
//  AppDelegate.h
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>
#import <REFrostedViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, REFrostedViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
-(void)changeRootViewController;
-(void)makeLoginRootController;

@end

