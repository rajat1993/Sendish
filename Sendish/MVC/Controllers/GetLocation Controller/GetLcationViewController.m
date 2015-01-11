//
//  GetLcationViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "GetLcationViewController.h"
#import "Constants.h"
#import "NickNameViewController.h"
#import "UserAccount.h"

@interface GetLcationViewController ()

@property int success;

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@property(nonatomic,strong) NSURLConnection *urlConn ;
@property(nonatomic,retain)NSMutableData *mutData;

@end

@implementation GetLcationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
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

- (IBAction)Action_getLocation:(id)sender
{
    if([self.Btn_getLocation.titleLabel.text isEqualToString:@"Please wait..."])
    {
        return;
    }
    
    [self.Btn_getLocation setTitle:@"Please wait..." forState:UIControlStateNormal];
    
    self.locMgr = [[CLLocationManager alloc] init];

    if([[[[UIDevice currentDevice] systemVersion] lastPathComponent] integerValue] >= 8)
    {
        [self.locMgr requestWhenInUseAuthorization];
    }
    
    self.locMgr.delegate = self;
    [self.locMgr startUpdatingLocation];
}

#pragma mark - Location Manager Methods

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.Btn_getLocation setTitle:@"Get My Location" forState:UIControlStateNormal];
    
    self.alertObj = [[AlertView alloc] init];
    [self.alertObj showStaticAlertWithTitle:@"" AndMessage:error.localizedDescription];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locMgr stopUpdatingLocation];
    self.locMgr.delegate = nil;
    
    CLLocation *location = [locations lastObject];
    
    NSString *urlStr = [BasePath stringByAppendingString:UpdateLocation];
    
    NSDictionary *params = @{@"latitude" : [NSString stringWithFormat:@"%.8f", location.coordinate.latitude], @"longitude" : [NSString stringWithFormat:@"%.8f", location.coordinate.longitude]};
    
    [self setUpLoaderView];
    [self callWebService:urlStr AndParams:params];
}

#pragma mark - WebService Methods

-(void)callWebService : (NSString *)urlStr AndParams : (NSDictionary *)params
{
    self.mutData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlReq setValue:[[UserAccount sharedInstance] authToken] forHTTPHeaderField:[[UserAccount sharedInstance] authHeader]];
    
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
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:[dict valueForKey:@"message"]];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"location_updated"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NickNameViewController *nickNameCtrlr = [[NickNameViewController alloc] initWithNibName:@"NickNameViewController" bundle:nil];
        
        [self.navigationController pushViewController:nickNameCtrlr animated:YES];
    }
    
    NSLog(@"%@",dict);
}


@end
