//
//  GetLcationViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "GetLcationViewController.h"
#import "AlertView.h"
#import "NickNameViewController.h"

@interface GetLcationViewController ()

@property AlertView *alertObj;

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


#pragma mark - Button Actions

- (IBAction)Action_getLocation:(id)sender
{
    if([self.Btn_getLocation.titleLabel.text isEqualToString:@"Please wait.."])
    {
        return;
    }
    
    [self.Btn_getLocation setTitle:@"Please wait.." forState:UIControlStateNormal];
    
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
    
    NickNameViewController *nicNameCtrlr = [[NickNameViewController alloc] initWithNibName:@"NickNameViewController" bundle:nil];
    nicNameCtrlr.currentUserLocation = location;
    [self.navigationController pushViewController:nicNameCtrlr animated:YES];
}


@end
