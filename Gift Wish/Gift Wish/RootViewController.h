//
//  ViewController.h
//  Gift Wish
//
//  Created by neyma on 08/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ConnectionManager.h"
#import "BannerProtocol.h"
#import "ConfirmationDialog.h"

@interface RootViewController : UIViewController <FBLoginViewDelegate, ConnectionManagerDelegate, UINavigationControllerDelegate, ADBannerViewDelegate, ConfirmationDialogDelegate>

@property (strong, nonatomic) FBLoginView *loginView;
@property (nonatomic) BOOL isBannerLoaded;

- (id)initWithAdBanner:(ADBannerView*) bannerView;

@end
