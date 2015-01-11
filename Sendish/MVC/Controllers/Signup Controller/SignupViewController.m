//
//  SignupViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "SignupViewController.h"
#import "Constants.h"
#import "UserAccount.h"

@interface SignupViewController ()

@property int success;

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@property(nonatomic,strong) NSURLConnection *urlConn ;
@property(nonatomic,retain)NSMutableData *mutData;

@end

@implementation SignupViewController

#pragma mark - Internal Methods

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserDetails:) name:@"fb_session_open" object:nil];
}

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

#pragma mark - Handle Notifications

-(void)getUserDetails : (NSNotification *)notification
{
    [self makeRequestForUserData];
}

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
    self.alertObj = [[AlertView alloc] init];
    
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

#pragma mark - Validation Methods

-(NSString *)validateRegister
{
    NSString *validationStr = @"";
    
    if (self.TF_fullName.text.length == 0)
    {
        validationStr = @"Please enter your full name";
    }
    else if (self.TF_email.text.length == 0)
    {
        validationStr = @"Please enter your email address";
    }
    else if (![self IsValidEmail:self.TF_email.text Strict:NO])
    {
        validationStr = @"Please enter valid email address";
    }
    else if (self.TF_password.text.length == 0)
    {
        validationStr = @"Please enter your password";
    }
    
    return validationStr;
}

-(BOOL) IsValidEmail:(NSString *)emailString Strict:(BOOL)strictFilter
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = strictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
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
    }
    else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
             [self makeRequestForUserData];
        }];
    }
}

- (IBAction)Action_Next:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    NSString *tempStr = [self validateRegister];
    
    if (tempStr.length != 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:tempStr];
        
        return;
    }
    
    NSString *urlStr = [BasePath stringByAppendingString:Register];
    
    NSDictionary *params = @{@"email" : self.TF_email.text, @"nickname" : @"", @"password" : self.TF_password.text, @"repeatPassword" : self.TF_password.text};
    
    [self setUpLoaderView];
    [self callWebService:urlStr AndParmas:params];
}

#pragma mark - WebService Methods

-(void)callWebService : (NSString *)urlStr AndParmas : (NSDictionary *)params
{
    self.mutData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlReq setHTTPMethod:@"POST"];
    NSError *error = nil;
    NSData *executionsData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    [urlReq setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlReq setHTTPBody:executionsData];
    
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
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:[[dict valueForKeyPath:@"errors.email"] objectAtIndex:0]];
    }
    else
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"A verification email has been sent to your email address. Please verify your email address before proceeding further"];
    }
    
    NSLog(@"%@",dict);
}


@end
