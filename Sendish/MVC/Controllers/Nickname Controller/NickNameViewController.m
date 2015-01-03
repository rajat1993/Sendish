//
//  NickNameViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 03/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "NickNameViewController.h"
#import "Constants.h"

@interface NickNameViewController ()

@property AlertView *alertObj;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)Action_getStarted:(id)sender
{
    self.alertObj = [[AlertView alloc] init];
    
    if(self.TF_nickName.text.length == 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Please enter your nickname"];
        return;
    }
    
    
    
    
}

@end
