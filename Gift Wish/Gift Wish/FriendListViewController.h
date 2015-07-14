//
//  FriendListViewTableViewController.h
//  Gift Wish
//
//  Created by neyma on 11/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FriendListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray* friendList;
@property (strong, nonatomic) NSArray* searchedFriendList;
@property (strong, nonatomic) UITableView* tableView;;

@end
