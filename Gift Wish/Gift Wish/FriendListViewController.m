//
//  FriendListViewTableViewController.m
//  Gift Wish
//
//  Created by neyma on 11/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "FriendListViewController.h"
#import "WishManagerController.h"
#import "FriendCell.h"
#import "UIImageView+Network.h"
#import "FTWCache.h"
#import "BackGroundLayer.h"

@interface FriendListViewController ()

@property (nonatomic, strong) UIActivityIndicatorView* progress;
@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) NSMutableDictionary *profilePictures;
@end

@implementation FriendListViewController

- (id)init
{
    self = [super init];
    if (self) {
        _profilePictures = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"facebook_big.png" ]];
    backgroundImage.bounds = CGRectMake(0, 0, 200, 200);
    backgroundImage.center = self.view.center;
    backgroundImage.alpha = 0.5;
    [self.view addSubview:backgroundImage];
    
    CGRect mainWindowRect = [[UIScreen mainScreen] bounds];
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGRect tableViewRect = CGRectMake(0, navBarRect.size.height + statusBarHeight + 30, mainWindowRect.size.width, mainWindowRect.size.height - navBarRect.size.height - statusBarHeight - tabBarHeight - 30);
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, navBarRect.size.height + statusBarHeight, mainWindowRect.size.width, 30)];
    _searchBar.backgroundColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    
    [self.view addSubview:_searchBar];
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
    //[self.navigationController.navigationBar addSubview:_searchBar];
    self.navigationItem.title = @"Friend list";
    
    
    _progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x - 15, self.view.center.y - 15, 30, 30)];
    _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:_progress];
    [_progress startAnimating];
    
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        _friendList = [result objectForKey:@"data"];
        NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        _friendList = [_friendList sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        _searchedFriendList = _friendList;
        
        [_progress stopAnimating];
        [_progress removeFromSuperview];
        
        [self.view addSubview:_tableView];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchedFriendList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"FriendCell";
    
    FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSDictionary<FBGraphUser>* friend = (NSDictionary<FBGraphUser>*)[_searchedFriendList objectAtIndex:indexPath.row];
    
    NSString *key = friend[@"id"];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        cell.profilePictureView.image = [UIImage imageWithData:data];
    } else {
        cell.profilePictureView.image = [UIImage imageNamed:@"default.jpg"];
        [cell.profilePictureView loadImageFromURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", key]] placeholderImage:cell.profilePictureView.image cachingKey:key ];
    }
    
    cell.friendName.text = friend.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishManagerController* wishList = [[WishManagerController alloc] initWithOwnController:NO WithType:WISHLIST AndWithFBUser:[_searchedFriendList objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:wishList animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

//SEARCHBAR
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([_searchBar.text isEqualToString:@""])
    {
        [_searchBar resignFirstResponder];
    }
    else
    {
        _searchBar.text = @"";
        [_searchBar resignFirstResponder];
        
        _searchedFriendList = _friendList;
        [_tableView reloadData];
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self dismissKeyboard];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString:@""])
    {
        NSPredicate* resultPredicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchText];
        
        _searchedFriendList = [_friendList filteredArrayUsingPredicate:resultPredicate];
    }
    else
    {
        _searchedFriendList = _friendList;
    }
    
    [_tableView reloadData];
}


-(void)dismissKeyboard {
    [_searchBar endEditing:YES];
}


@end
