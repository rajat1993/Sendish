//
//  SignupViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "SignupViewController.h"
#import "Constants.h"

@interface SignupViewController ()

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@end

@implementation SignupViewController

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
    self.navigationItem.title = @"Sign Up";
    self.navigationItem.leftBarButtonItem.title = @"";
    
}

#pragma mark - TextField Delegate Methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(screenSize.height == 480)
    {
        if(textField == self.TF_email)
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.view setFrame:CGRectMake(0, -20, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
        else if (textField == self.TF_password)
        {
            [UIView animateWithDuration:0.25 animations:^{
                
                [self.view setFrame:CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height)];
            }];

        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self.TF_fullName isFirstResponder])
    {
        [self.TF_email becomeFirstResponder];
    }
    else if ([self.TF_email isFirstResponder])
    {
        [self.TF_password becomeFirstResponder];
    }
    else if ([self.TF_password isFirstResponder])
    {
        [self.TF_password resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
    }
    else
    {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.view setFrame:CGRectMake(0, -60, self.view.frame.size.width, self.view.frame.size.height)];
        }];

    }
    
    return YES;
}

#pragma mark - Touch Methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
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
            
            self.TF_email.text = [result valueForKey:@"email"];
            self.TF_fullName.text = [result valueForKey:@"name"];
            
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

- (IBAction)Action_fbSignup:(id)sender
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

- (IBAction)Action_Next:(id)sender
{
    NSString *urlStr = [BasePath stringByAppendingString:Register];
    
    NSDictionary *params = @{@"email" : self.TF_email.text, @"nickname" : @"", @"password" : self.TF_password.text, @"repeatPassword" : self.TF_password.text};

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    [IOSRequest testMethod:urlStr andParmas:params success:^(NSDictionary *responseStr) {
        
        
    } failure:^(NSError *error) {
        
    }];
    
}


@end
