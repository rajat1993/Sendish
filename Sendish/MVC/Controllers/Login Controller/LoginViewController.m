//
//  LoginViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK.h>
#import "Constants.h"
#import "TutorialViewController.h"
#import "GetLcationViewController.h"
#import "UserAccount.h"
#import "Base64.h"

@interface LoginViewController ()

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@end

@implementation LoginViewController

#pragma mark - Internal Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO;
    
    [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Setter Methods

-(void)setupView
{
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationController.navigationItem.backBarButtonItem = backButton;
    
    self.navigationItem.title = @"Log In";
    self.navigationItem.leftBarButtonItem.title = @"";
}

#pragma mark - TextField Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.TF_loginEmail isFirstResponder])
    {
        [self.TF_loginPassword becomeFirstResponder];
    }
    else if ([self.TF_loginPassword isFirstResponder])
    {
        [self.TF_loginPassword resignFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma mark - Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Facebook Methods

-(void)makeRequestForUserData
{
    [self setUpLoaderView];
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        [self.loaderObj performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
        
        if (!error) {
            // Success! Include your code to handle the results here
            NSLog(@"user info: %@", result);
            
        } else {
            // An error occurred, we need to handle the error
            
            [self.alertObj showStaticAlertWithTitle:@"" AndMessage:error.localizedDescription];
        }
    }];
    
}

#pragma mark - Loader Setup

-(void)setUpLoaderView
{
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.loaderObj = [[LoaderView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.loaderObj startAnimating];
    [appDelObj.window addSubview:self.loaderObj];
    [appDelObj.window bringSubviewToFront:self.loaderObj];
}

#pragma mark - Button Actions

- (IBAction)Action_fbLogin:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [self makeRequestForUserData];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self makeRequestForUserData];
         }];
    }
}

- (IBAction)Action_forgotPassword:(id)sender
{
    
}

- (IBAction)Action_Done:(id)sender
{
    UserAccount *userObj = [[UserAccount alloc] init];
    
    NSString *urlStr = [BasePath stringByAppendingString:Login];
    
    userObj.accountType = @"native";
    NSString *basic = [[NSString stringWithFormat:@"%@:%@",self.TF_loginEmail.text, self.TF_loginPassword.text] base64EncodedString];
    userObj.authToken = [NSString stringWithFormat:@"Basic %@",basic];
    userObj.authHeader = @"Authorization";
    
    [IOSRequest fetchWebData:urlStr success:^(NSDictionary *responseDict) {
                
    } failure:^(NSError *error) {
        
    }];
    
//    if([[NSUserDefaults standardUserDefaults] valueForKey:@"first_login"] == nil)
//    {
//        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"first_login"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        
//        TutorialViewController *tutCtrlr = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
//        [self.navigationController pushViewController:tutCtrlr animated:YES];
//    }
//    else
//    {
//        GetLcationViewController *locationCtrlr = [[GetLcationViewController alloc] initWithNibName:@"GetLcationViewController" bundle:nil];
//        [self.navigationController pushViewController:locationCtrlr animated:YES];
//    }
}



@end
