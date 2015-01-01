//
//  MainViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 29/12/14.
//  Copyright (c) 2014 Rajat Sharma. All rights reserved.
//

#import "MainViewController.h"
#import "NavigationView.h"

@interface MainViewController ()

@property NavigationView *navViewObj;

@end

@implementation MainViewController

#pragma mark - Internal Methods

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
    
    [self setupPages];
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
    self.navViewObj = [[NavigationView alloc] initWithFrame:self.navigationView.frame];
    
    self.pageViewCtrlr = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewCtrlr.dataSource = self;
    self.pageViewCtrlr.delegate = self;

    [self.pageViewCtrlr setViewControllers:@[self.pages[1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];

    [self.pageViewCtrlr.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [self addChildViewController:self.pageViewCtrlr];
    [self.view addSubview:self.pageViewCtrlr.view];
    
    [self.navigationView addSubview:self.navViewObj];
}

-(void)setupPages
{
    self.receivedCtrlr = [[ReceivedSendishViewController alloc] initWithNibName:@"ReceivedSendishViewController" bundle:nil];
    
    self.takeSendishCtrlr = [[TakeSendishViewController alloc] initWithNibName:@"TakeSendishViewController" bundle:nil];
    
    self.sentCtrlr = [[SentSendishViewController alloc] initWithNibName:@"SentSendishViewController" bundle:nil];
    
    self.pages = @[self.receivedCtrlr, self.takeSendishCtrlr, self.sentCtrlr];

}

#pragma mark - Page Controller Methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if(nil == viewController)
    {
        return self.pages[0];
    }
    
    NSInteger i = [self.pages indexOfObject:viewController];
    
    if(i >= [self.pages count]-1)
    {
        return nil;
    }
    
    return self.pages[i+1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if(nil == viewController)
    {
        return self.pages[0];
    }
    
    NSInteger i =[self.pages indexOfObject:viewController];
    if(i <= 0)
    {
        return nil;
    }
    
    return self.pages[i-1];
}



@end
