//
//  WishListViewController.h
//  Gift Wish
//
//  Created by neyma on 12/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <iAd/iAd.h>
#import "ConnectionManager.h"
#import "ModalViewController.h"
#import "WishListCell.h"
#import "WishList.h"
#import "BannerProtocol.h"


typedef NS_ENUM(NSInteger, WishManagerType) {
    WISHLIST=0,
    WISH
};

@interface WishManagerController : UIViewController <UITableViewDataSource, UITableViewDelegate, ConnectionManagerDelegate, ModalViewControllerDelegate, WishListCellDelegate, BannerProtocol>

//to get the wishes from the server
@property (nonatomic, strong) WishList* wishListForWishController;

- (id)initWithOwnController:(BOOL)own WithType:(WishManagerType)type AndWithFBUser:(NSDictionary<FBGraphUser>*)user;

@end
