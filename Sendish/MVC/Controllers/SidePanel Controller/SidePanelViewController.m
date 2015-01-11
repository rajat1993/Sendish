//
//  SidePanelViewController.m
//  Sendish
//
//  Created by Rajat Sharma on 07/01/15.
//  Copyright (c) 2015 Rajat Sharma. All rights reserved.
//

#import "SidePanelViewController.h"
#import "SidePanelTableViewCell.h"
#import "UserAccount.h"
#import "Colors.h"
#import "Constants.h"

@interface SidePanelViewController ()

@property NSArray *sidePanelArr;

@property AlertView *alertObj;
@property LoaderView *loaderObj;

@property int success;
@property(nonatomic,strong) NSURLConnection *urlConn ;
@property(nonatomic,retain)NSMutableData *mutData;

@end

@implementation SidePanelViewController

#pragma mark - Internal Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupView];
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
    self.sidePanelTable.backgroundColor = [UIColor clearColor];
    
//    self.sidePanelArr = @[[[UserAccount sharedInstance] nickName], @"Explore", @"Following", @"Following", @"Upload Recipe", @"Post Photo", @"Interactions", @"Cook Book", @"Settings", @"Sign Out"];
    
    self.nickName = [[NSUserDefaults standardUserDefaults] valueForKey:@"nickname"];
    
    [UserAccount sharedInstance].nickName = self.nickName;
    
    self.sidePanelArr = @[self.nickName, @"Location", @"Inbox", @"Take Sendish", @"My sendish", @"Explore", @"Notifications", @"Settings", @"Logout"];

    [self reloadTableView];
}

#pragma mark - TableView Methods

-(void)reloadTableView
{
    [self.sidePanelTable setDataSource:self];
    [self.sidePanelTable setDelegate:self];
    [self.sidePanelTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sidePanelArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SidePanelTableViewCell *sidePanelCell = (SidePanelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sidePanelCell"];
    
    if (sidePanelCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SidePanelTableViewCell" owner:self options:nil];
        sidePanelCell = [nib objectAtIndex:0];
    }
    
    sidePanelCell.backgroundColor = [UIColor clearColor];
    [sidePanelCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    sidePanelCell.Label_sidePanelTitle.text = [self.sidePanelArr objectAtIndex:indexPath.row];
    
    return sidePanelCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.frostedViewController hideMenuViewController];
    
    switch (indexPath.row)
    {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        case 4:
            
            break;
            
        case 5:
            
            break;
            
        case 6:
            
            break;
            
        case 7:
            
            break;
            
        case 8:
            
            [self logoutUser];
            break;
        default:
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - Alert Delegate Methods

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelObj makeLoginRootController];
    }
}

#pragma mark - SidePanel Actions

-(void)logoutUser
{
    UIAlertView *alert_logout = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert_logout show];
}

@end
