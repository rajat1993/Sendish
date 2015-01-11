//
//  TutorialViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 04/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "TutorialViewController.h"
#import "GetLcationViewController.h"

@interface TutorialViewController ()

@end

@implementation TutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self setupView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - Setter Methods

-(void)setupView
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollViewObj.frame.size.width, self.scrollViewObj.frame.size.height)];
    imgView.image = [UIImage imageNamed:@"demoImage1.jpg"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scrollViewObj.frame), 0, self.scrollViewObj.frame.size.width, self.scrollViewObj.frame.size.height)];
    imgView2.image = [UIImage imageNamed:@"demoImage2.jpg"];
    imgView.contentMode = UIViewContentModeScaleAspectFit;

    [self.scrollViewObj addSubview:imgView];
    [self.scrollViewObj addSubview:imgView2];
    
    [self.scrollViewObj setContentSize:CGSizeMake(CGRectGetMaxX(imgView2.frame), self.scrollViewObj.frame.size.height - self.scrollViewObj.frame.origin.y)];
}

#pragma mark - Button Actions

- (IBAction)Action_Done:(id)sender
{
    GetLcationViewController *locaionCtrlr = [[GetLcationViewController alloc] initWithNibName:@"GetLcationViewController" bundle:nil];
    [self.navigationController pushViewController:locaionCtrlr animated:YES];
}

@end
