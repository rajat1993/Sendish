//
//  ReceivedSendishViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 30/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "ReceivedSendishViewController.h"
#import "NavigationView.h"
#import "ReceivedSendishTableViewCell.h"
#import <UIViewController+REFrostedViewController.h>
#import <REFrostedViewController.h>

@interface ReceivedSendishViewController () <NavigationDelegate>

@property NavigationView *navViewObj;

@end

@implementation ReceivedSendishViewController

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
    [self reloadTableView];
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

#pragma mark - TableView Methods

-(void)reloadTableView
{
    [self.tableViewObj setDataSource:self];
    [self.tableViewObj setDelegate:self];
    [self.tableViewObj reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceivedSendishTableViewCell *receivedSendishCell = (ReceivedSendishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"receivedSendishCell"];
    
    if (receivedSendishCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReceivedSendishTableViewCell" owner:self options:nil];
        receivedSendishCell = [nib objectAtIndex:0];
    }
    
    return receivedSendishCell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForSwipeAccessoryButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"Share";
//}
//
//-(void)tableView:(UITableView *)tableView swipeAccessoryButtonPushedForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

#pragma mark - API Received Sendish List

-(void)getReceivedSendish
{
    
}

@end
