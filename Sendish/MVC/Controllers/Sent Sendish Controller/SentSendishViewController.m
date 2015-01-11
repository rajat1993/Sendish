//
//  SentSendishViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "SentSendishViewController.h"
#import "NavigationView.h"
#import <UIViewController+REFrostedViewController.h>
#import <REFrostedViewController.h>

@interface SentSendishViewController () <NavigationDelegate>

@property NavigationView *navViewObj;

@end

@implementation SentSendishViewController

#pragma mark - Internal Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self setupView];
    [self setNavigationDelegates];
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
    self.navViewObj = [[NavigationView alloc] initWithFrame:self.navigationView.frame];
    
    [self.navigationView addSubview:self.navViewObj];
}

#pragma mark - Custom Delegate Methods

-(void)setNavigationDelegates
{
    self.navViewObj.delegate = self;
}

-(void)BtnSidePanel
{
    [self showMenu];
}

#pragma mark - Side Panel Setup

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}


@end
