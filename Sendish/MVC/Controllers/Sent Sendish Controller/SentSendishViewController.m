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
#import "SentSendishTableViewCell.h"
#import "Constants.h"
#import "UserAccount.h"
#import "SentSendishParser.h"
#import "SentSendishModal.h"

@interface SentSendishViewController () <NavigationDelegate>

@property NavigationView *navViewObj;
@property AlertView *alertObj;
@property LoaderView *loaderObj;

@property NSMutableArray *sentSendishArr;

@property int success;
@property (nonatomic,strong) NSURLConnection *urlConn;
@property (nonatomic,retain) NSMutableData *mutData;

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
    [self getSentSendishList];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.pullToRefreshManager relocatePullToRefreshView];
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

    self.pullToRefreshManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.f tableView:self.tableView_sentSendish withClient:self];

    [self.tableView_sentSendish setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableView_sentSendish setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;

    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"current_page_sent"] != nil)
    {
        appDelObj.currentPage_sent = (int)[[[NSUserDefaults standardUserDefaults] valueForKey:@"current_page_sent"] integerValue];
    }
    else
    {
        appDelObj.currentPage_sent = 0;
    }
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

#pragma mark - TableView Methods

-(void)reloadTableView
{
    [self.tableView_sentSendish setDataSource:self];
    [self.tableView_sentSendish setDelegate:self];
    [self.tableView_sentSendish reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sentSendishArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SentSendishTableViewCell *sentSendishCell = (SentSendishTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"sentSendishCell"];
    
    if (sentSendishCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SentSendishTableViewCell" owner:sentSendishCell options:nil];
        sentSendishCell = [nib objectAtIndex:0];
    }
    
    SentSendishModal *sentSendishObj = (SentSendishModal *)[self.sentSendishArr objectAtIndex:indexPath.row];
    
    sentSendishCell.Label_lastLocation.text = sentSendishObj.sentSendish_city;
    sentSendishCell.Label_timeAgo.text = sentSendishObj.sentSendish_timeAgo;
    [sentSendishCell.Btn_citiesCount setTitle:[NSString stringWithFormat:@"%@ Cities", sentSendishObj.sentSendish_cityCount] forState:UIControlStateNormal];
    [sentSendishCell.Btn_commentsCount setTitle:[NSString stringWithFormat:@"%@ Comments", sentSendishObj.sentSendish_commentCount] forState:UIControlStateNormal];
    [sentSendishCell.Btn_likesCount setTitle:[NSString stringWithFormat:@"%@ Likes", sentSendishObj.sentSendish_likeCount] forState:UIControlStateNormal];
    
    
    if (sentSendishCell.imageLoaded == NO)
    {
        [sentSendishCell.imgView_sentSendish setImage:[UIImage imageNamed:@"blurImage.jpg"]];
        [sentSendishCell.bottomView setHidden:YES];
    }
    else
    {
        [sentSendishCell.bottomView setHidden:NO];
    }
    
    return sentSendishCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SentSendishTableViewCell *cell = (SentSendishTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    SentSendishModal *sentSendishobj = (SentSendishModal *)[self.sentSendishArr objectAtIndex:indexPath.row];
    
    if (cell.imageLoaded == YES)
    {
        
    }
    else
    {
        self.loaderObj = [[LoaderView alloc] initWithFrame:cell.imgView_sentSendish.frame];
        [self.loaderObj startAnimating];
        [cell.imgView_sentSendish addSubview:self.loaderObj];
        
        NSString *tempStr = [BasePath stringByAppendingString:GetSentImage];
        NSString *urlStr = [NSString stringWithFormat:tempStr, sentSendishobj.sentSendish_imgUniqueId];
        
        [self callWebService:urlStr];
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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

#pragma mark - Load More Bookings

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.pullToRefreshManager tableViewReleased];
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager
{
    [self performSelector:@selector(loadMoreSendish) withObject:nil afterDelay:1.0f];
}

-(void)loadMoreSendish
{
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *tempStr = [BasePath stringByAppendingString:SentSendishList];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?page=%d", tempStr, ++appDelObj.currentPage_sent];
    
    [self callWebService:urlStr];
}

#pragma mark - API Get Sent Sendish

-(void)getSentSendishList
{
    [self setUpLoaderView];
    
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *tempStr = [BasePath stringByAppendingString:SentSendishList];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@?page=%d", tempStr, appDelObj.currentPage_sent];

    if (!appDelObj.endOfSentSendish)
    {
        [self callWebService:urlStr];
    }
    
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

#pragma mark - WebService Methods

-(void)callWebService : (NSString *)urlStr
{
    self.mutData = [[NSMutableData alloc] init];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *urlReq = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [urlReq setValue:[[UserAccount sharedInstance] authToken] forHTTPHeaderField:[[UserAccount sharedInstance] authHeader]];
    
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
 
    AppDelegate *appDelObj = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    self.alertObj = [[AlertView alloc] init];
    
    NSMutableArray *responseArr = [NSJSONSerialization JSONObjectWithData:self.mutData options:NSJSONReadingMutableLeaves error:nil];
    
    if (responseArr == nil)
    {
        return;
    }
    
    self.sentSendishArr = responseArr;
    
    if (self.success == 0)
    {
        [self.alertObj showStaticAlertWithTitle:@"" AndMessage:@"Error Occured"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", appDelObj.currentPage_sent] forKey:@"current_page_sent"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([responseArr count] == 0)
        {
            appDelObj.endOfSentSendish = YES;
        }
        
        NSArray *tempArr = [responseArr mutableCopy];
        
        SentSendishParser *parser = [[SentSendishParser alloc] init];
        
        self.sentSendishArr = (NSMutableArray *)[parser parseArrForSentSendish:tempArr];
        
        [self reloadTableView];
    }
    
    NSLog(@"%@", responseArr);
}

@end
