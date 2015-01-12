//
//  AppDelegate.m
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "MainViewController.h"
#import "SidePanelViewController.h"
#import "ReceivedSendishViewController.h"
#import "GetLcationViewController.h"
#import "NickNameViewController.h"
#import "UserAccount.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"] == nil || [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_header"] == nil)
    {
        RootViewController *rootObj = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
        UINavigationController *navObj = [[UINavigationController alloc] initWithRootViewController:rootObj];
        [self.window setRootViewController:navObj];

        self.window.backgroundColor = [UIColor whiteColor];
        [self.window makeKeyAndVisible];

    }
    else
    {
        [UserAccount sharedInstance].authHeader = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_header"];
        [UserAccount sharedInstance].authToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_token"];

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"location_updated"] != YES)
        {
            GetLcationViewController *getLocationCtrlr = [[GetLcationViewController alloc] initWithNibName:@"GetLcationViewController" bundle:nil];
            UINavigationController *navObj = [[UINavigationController alloc] initWithRootViewController:getLocationCtrlr];
            [self.window setRootViewController:navObj];
            
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }
        else if ([[NSUserDefaults standardUserDefaults] valueForKey:@"nickname"] == nil)
        {
            NickNameViewController *nickNameCtrlr = [[NickNameViewController alloc] initWithNibName:@"NickNameViewController" bundle:nil];
            UINavigationController *navObj = [[UINavigationController alloc] initWithRootViewController:nickNameCtrlr];
            [self.window setRootViewController:navObj];
            
            self.window.backgroundColor = [UIColor whiteColor];
            [self.window makeKeyAndVisible];
        }
        else
        {
            [UserAccount sharedInstance].nickName = [[NSUserDefaults standardUserDefaults] valueForKey:@"nickname"];

            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"user_pic"] != nil)
            {
                [UserAccount sharedInstance].imageUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_pic"];
            }
            
            [self changeRootViewController];
        }
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [FBAppCall handleDidBecomeActive];
}
/*
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         [self sessionStateChanged:session state:state error:error];
     }];

    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}
*/
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         [self sessionStateChanged:session state:state error:error];
     }];

    return [[FBSession activeSession] handleOpenURL:url];
}


#pragma mark - Custom Methods

-(void)changeRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *sideNavObj = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *navObj = [[UINavigationController alloc] initWithRootViewController:sideNavObj];
    
    SidePanelViewController*sidePanel = [[SidePanelViewController alloc] initWithNibName:@"SidePanelViewController" bundle:nil];
    
    REFrostedViewController *frostedViewCtlr = [[REFrostedViewController alloc] initWithContentViewController:navObj menuViewController:sidePanel];
    [frostedViewCtlr setMenuViewSize:CGSizeMake(self.window.frame.size.width-80, self.window.frame.size.height)];
    frostedViewCtlr.direction = REFrostedViewControllerDirectionLeft;
    frostedViewCtlr.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewCtlr.liveBlur = YES;
    frostedViewCtlr.delegate = self;
    
    [self.window setRootViewController:frostedViewCtlr];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

-(void)makeLoginRootController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RootViewController *rootObj = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *navObj = [[UINavigationController alloc] initWithRootViewController:rootObj];
    [self.window setRootViewController:navObj];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}


#pragma mark - Facebook Handling

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        if (self.calledWithLogin)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"login_with_facebook" object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"fb_session_open" object:nil];
        }
        
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
    }
}


@end
