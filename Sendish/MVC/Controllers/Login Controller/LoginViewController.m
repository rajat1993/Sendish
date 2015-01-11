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
#import "NickNameViewController.h"
#import "MainViewController.h"
#import "UserAccount.h"
#import "Base64.h"
#import <UIImageView+WebCache.h>

@interface LoginViewController ()

@property int success;
@property BOOL forgotPassword;

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@property(nonatomic,strong) NSURLConnection *urlConn ;
@property(nonatomic,retain)NSMutableData *mutData;

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
    
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
        if (error) {
            // Handle error
        }
        
        else {
            NSString *userName = [FBuser name];
            NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBuser objectID]];
            
            [UserAccount sharedInstance].name = userName;
            [UserAccount sharedInstance].imageUrl = userImageURL;
            
            [self performLoginWithLoginType:@"facebook"];
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

#pragma mark - Perform Login

-(void)performLoginWithLoginType : (NSString *)type
{
    NSString *urlStr = [BasePath stringByAppendingString:Login];

    if ([type isEqualToString:@"native"])
    {
        [UserAccount sharedInstance].accountType = @"native";
        NSString *basic = [[NSString stringWithFormat:@"%@:%@",self.TF_loginEmail.text, self.TF_loginPassword.text] base64EncodedString];
        [UserAccount sharedInstance].authToken = [NSString stringWithFormat:@"Basic %@",basic];
        [UserAccount sharedInstance].authHeader = @"Authorization";
    }
    else
    {
        [UserAccount sharedInstance].accountType = @"facebook";
        
        [UserAccount sharedInstance].authToken = [NSString stringWithFormat:@"facebook:%@:::123", [[[FBSession activeSession] accessTokenData] accessToken]];
        [UserAccount sharedInstance].authHeader = @"SocialAuthorization";
    }
    
    self.forgotPassword = NO;

    [self callWebService:urlStr];
    
    [[NSUserDefaults standardUserDefaults] setObject:[UserAccount sharedInstance].accountType forKey:@"account_type"];
    [[NSUserDefaults standardUserDefaults] setObject:[UserAccount sharedInstance].authToken forKey:@"auth_token"];
    [[NSUserDefaults standardUserDefaults] setObject:[UserAccount sharedInstance].authHeader forKey:@"auth_header"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Validation Methods

-(NSString *)validateLogin
{
    NSString *tempStr = @"";
    
    if (self.TF_loginEmail.text.length == 0)
    {
        tempStr = @"Please enter your email";
    }
    else if (![self IsValidEmail:self.TF_loginEmail.text Strict:NO])
    {
        tempStr = @"Please enter valid email";
    }
    else if (self.TF_loginPassword.text.length == 0)
    {
        tempStr = @"Please enter your password";
    }
    
    return tempStr;
}

-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

#pragma mark - Alert Delegate Methods

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    if (![self IsValidEmail:[[alertView textFieldAtIndex:0] text] Strict:NO])
    {
        return NO;
    }
    
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self setUpLoaderView];
        
        NSString *tempStr = [BasePath stringByAppendingString:ResetPassword];
        
        NSString *urlStr = [[NSString stringWithFormat:@"%@/%@", tempStr, [[alertView textFieldAtIndex:0] text]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.forgotPassword = YES;
        [self callWebService:urlStr];
    }
}

#pragma mark - Button Actions

- (IBAction)Action_fbLogin:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [self makeRequestForUserData];
        
    } else {

        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"basic_info"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             AppDelegate* appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self makeRequestForUserData];
         }];
    }
}

- (IBAction)Action_forgotPassword:(id)sender
{
    UIAlertView *alert_forgotPass = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your registered email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
    [alert_forgotPass setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert_forgotPass textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [alert_forgotPass show];
}

- (IBAction)Action_Done:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    NSString *validationStr = [self validateLogin];
    
    if (validationStr.length != 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:validationStr];
        
        return;
    }
    
    [self setUpLoaderView];
    [self performLoginWithLoginType:@"native"];
}

#pragma mark - WebService Methods

-(void)callWebService : (NSString *)urlStr
{
    self.mutData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    if (self.forgotPassword == YES)
    {
        [urlReq setHTTPMethod:@"POST"];
    }
    else
    {
        [urlReq setValue:[[UserAccount sharedInstance] authToken] forHTTPHeaderField:[[UserAccount sharedInstance] authHeader]];
    }
    
    self.urlConn = [[NSURLConnection alloc] initWithRequest:urlReq delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.alertObj = [[AlertView alloc] init];
    
    [self.loaderObj performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Error connecting to server.\nPlease try again later"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    self.alertObj = [[AlertView alloc] init];
    
    [self.mutData setLength:0];
    
    if ([response statusCode] == 200)
    {
        self.success = 1;
    }
    else
    {
        self.success = 0;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.mutData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.loaderObj performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
    
    self.alertObj = [[AlertView alloc] init];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.mutData options:NSJSONReadingMutableLeaves error:nil];
    
    if (self.success == 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:[dict valueForKey:@"message"]];
    }
    else
    {
        if (self.forgotPassword == YES)
        {
            [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"A link has been sent to your email address to reset your password."];
            
            return;
        }

        AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
//        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"login_data"];
//        [[NSUserDefaults standardUserDefaults] synchronize];

        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"first_login"] == nil)
        {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_login"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            TutorialViewController *tutCtrlr = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
            [self.navigationController pushViewController:tutCtrlr animated:YES];
        }
        else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"location_updated"] != YES)
        {
            GetLcationViewController *getLocationCtrlr = [[GetLcationViewController alloc] initWithNibName:@"GetLcationViewController" bundle:nil];
            [self.navigationController pushViewController:getLocationCtrlr animated:YES];
        }
        else if ([[NSUserDefaults standardUserDefaults] valueForKey:@"nickname"] == nil)
        {
            NickNameViewController *nickNameCtrlr = [[NickNameViewController alloc] initWithNibName:@"NickNameViewController" bundle:nil];
            [self.navigationController pushViewController:nickNameCtrlr animated:YES];
        }
        else
        {
            [appDelObj changeRootViewController];
            
            MainViewController *mainCtrlr = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            [self.navigationController pushViewController:mainCtrlr animated:YES];
        }
    }
    
    NSLog(@"%@",dict);
}


@end
