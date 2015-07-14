//
//  ViewController.m
//  Gift Wish
//
//  Created by neyma on 08/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "RootViewController.h"
#import "FriendListViewController.h"
#import "ConnectionManager.h"
#import "BackGroundLayer.h"
#import "WishManagerController.h"
#import "UIImage+Resize.h"
#import "HelpController.h"
#import "AppDelegate.h"
#import "PurchasesController.h"

@interface RootViewController ()
@property (strong, nonatomic) ConnectionManager* connectionManager;
@property (strong, nonatomic) NSDictionary<FBGraphUser>* user;
@property (nonatomic, strong) UIActivityIndicatorView* progress;
@property (nonatomic, strong) UITabBarController* tabBarController;
@property (nonatomic, strong) UILabel* errorLabel;
@property (nonatomic, strong) UIButton* retryButton;
@property (nonatomic) BOOL IsFBFetchMethodAlreadyCalled;
@property (nonatomic) BOOL isUserAlreadyLoggedIn;
@property (nonatomic, strong) UITextView* privacyPolicy;
@property (nonatomic, strong) ADBannerView* bannerView;
@property (nonatomic) UIViewController<BannerProtocol>* upperViewController;
@end

@implementation RootViewController

- (id)initWithAdBanner:(ADBannerView*) bannerView
{
    self = [super init];
    if (self) {

        [self createLogo];
        [self createFBLogin];
        [self createFooter];
        [self createBanner:bannerView];
        
        _connectionManager = [[ConnectionManager alloc] init ];
        _connectionManager.delegate = self;
        
        _progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50, 50)];
        _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];//
        bgLayer.frame = self.view.bounds;
        [self.view.layer insertSublayer:bgLayer atIndex:0];
        
        _upperViewController = nil;
        
        _IsFBFetchMethodAlreadyCalled = NO;
        _isUserAlreadyLoggedIn = NO;
        _isBannerLoaded = NO;
        
    }
    return self;
}

-(void)createLogo
{
    UIImageView* logo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150, 80, 300, 100)];
    logo.image = [UIImage imageNamed:@"main_logo.png"];
    
    [self.view addSubview:logo];
}

-(void)createFBLogin
{
//    _loginView = [[FBLoginView alloc] initWithPublishPermissions:@[@"basic_info", @"read_friendlists", @"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends];
    
    
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info"]];
    
    //initWithReadPermissions
    _loginView.delegate = self;
    
    _loginView.frame = CGRectOffset(_loginView.frame,
                                    (self.view.center.x - (_loginView.frame.size.width / 2)),
                                    5);
    
    _loginView.center = self.view.center;
    
    [self.view addSubview:_loginView];
}

-(void)createBanner:(ADBannerView*) bannerView
{
    _bannerView = bannerView;
    _bannerView.frame = CGRectMake(0, self.view.frame.size.height - 99, 0, 0);
    _bannerView.delegate = self;
}


-(void)openPrivacyUrl:(UIGestureRecognizer*)gesture
{
    NSString* url = @"http://neyma6.com/giftwish/privacy.html";
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}


-(void)createFooter
{
    UITextView* info = [self createTextView];
    info.frame = CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height - 150, 300, 80);
    info.text = @"In order to use this application you must enable internet connection.";
    info.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:info];
    
    UITextView* privacy = [self createTextView];
    privacy.frame = CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height - 105, 300, 30);
    privacy.text = @"Privacy Policy";
    privacy.dataDetectorTypes = UIDataDetectorTypeAll;
    privacy.backgroundColor = [UIColor clearColor];
    privacy.textColor = [UIColor whiteColor];
    privacy.font = [UIFont systemFontOfSize:16];
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPrivacyUrl:)];
    privacy.userInteractionEnabled = YES;
    [privacy addGestureRecognizer:gesture];
    [self.view addSubview:privacy];

    
    
//    UITextView* footer = [self createTextView];
//    footer.frame = CGRectMake(self.view.frame.size.width / 2 - 150, self.view.frame.size.height - 70, 300, 50);
//    footer.font = [UIFont systemFontOfSize:13];
//    footer.text = @"All rights reserved ©\n2014 - Gabor Csatlos";
//    [self.view addSubview:footer];
}

-(UITextView*)createTextView
{
    UITextView* textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.scrollEnabled = NO;
    textView.textColor = [UIColor whiteColor];
    textView.backgroundColor = [UIColor clearColor];
    return textView;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"loginViewFetchedUserInfo");
    _user = (NSDictionary<FBGraphUser>*)user;
    if (!_IsFBFetchMethodAlreadyCalled)
    {
        _IsFBFetchMethodAlreadyCalled = YES;
        [self identifyUserOnServer];
    }
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
    [_loginView removeFromSuperview];
    [self startProgressIndicator];
}

-(void)identifyUserOnServer
{
    while(_user == nil)
    {
        [NSThread sleepForTimeInterval:.1];
    }

    NSDictionary* checkUserDic = @{@"fbId" : _user[@"id"]};
    [_connectionManager requesWithUrl:@"/user/checkUserExists" WithParameters:checkUserDic AndWithOrder:@"checkUserExists" ];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    NSLog(@"loginViewShowingLoggedOutUser");
    if (_isUserAlreadyLoggedIn)
    {
        _loginView.delegate = nil;
        RootViewController* root = [[RootViewController alloc] initWithAdBanner:_bannerView];
        _bannerView.delegate = nil;
        _bannerView = nil;
        //root.isBannerLoaded = _isBannerLoaded;
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        [app setNewRootViewController:root];
    }
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    NSLog(@"error %@", error);
    [self stopProgressIndicator];
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        //NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)downloadCompilted:(NSMutableData*)data WithThisOrder:(NSString*)order
{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([order isEqualToString:@"checkUserExists"])
    {
        if ([result isEqualToString:@"true"])
        {
             [self createNavigationController];
        }
        else
        {
            NSDictionary* addUser = @{@"fbId" : _user[@"id"]};
            [_connectionManager requesWithUrl:@"/user/addUser" WithParameters:addUser AndWithOrder:@"addUser" ];
        }
    }
    else if ([order isEqualToString:@"addUser"])
    {
        if ([result isEqualToString:@"true"])
        {
            //[self postUsingAppToFacebook];
//            [self requestPermissionCallAPI];
//            [self createNavigationController];
            ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Post to wall" message:@"Gift Wish would like to post the link of its homepage. Do you allow this operation?" cancelButtonTitle:@"NO" otherButtonTitles:@"YES"];
            dialog.invoker = self;
            dialog.type = CPOST;
            
            [dialog show];
        }
        else
        {
            [self stopProgressIndicator];
            [self showErrorTextAndRetryButtonWithError:@"There was an error during the communication. Please try again!"];
        }
    }
    
}

-(void)errorDuringDownload:(NSError *)error
{
    [self stopProgressIndicator];
    
    if (error.code == -1004)
    {
        [self showErrorTextAndRetryButtonWithError:@"Could not connect to the server. Please try again!"];
    }
    else
    {
        [self showErrorTextAndRetryButtonWithError:@"There was an error during the communication. Please try again!"];

    }
    
    
}

-(void)showErrorTextAndRetryButtonWithError:(NSString*)errorMessage
{
    if (_errorLabel == nil)
    {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 200, 200)];
        _errorLabel.lineBreakMode = 0;
        _errorLabel.numberOfLines = 0;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    _errorLabel.text = errorMessage;
    
    [self.view addSubview:_errorLabel];
    
    if (_retryButton == nil)
    {
        _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryButton.frame = CGRectMake(self.view.center.x - 60, self.view.center.y + 50, 120, 40);
        _retryButton.titleLabel.textColor = [UIColor whiteColor];
        [_retryButton addTarget:self action:@selector(retryConnection) forControlEvents:UIControlEventTouchUpInside];
        [_retryButton setTitle:@"Try again!" forState:UIControlStateNormal];
    }
    
    [self.view addSubview:_retryButton];
    
}

-(void)retryConnection
{
    [_errorLabel removeFromSuperview];
    [_retryButton removeFromSuperview];
    [self startProgressIndicator];
    [self identifyUserOnServer];
}

-(void)startProgressIndicator
{
    [self.view addSubview:_progress];
    [_progress startAnimating];
}

-(void)stopProgressIndicator
{
    [_progress stopAnimating];
    [_progress removeFromSuperview];
}

-(void)createNavigationController
{
    [self stopProgressIndicator];
    
    _isUserAlreadyLoggedIn = YES;
    
    UINavigationController* myWishListNavigationController = [[UINavigationController alloc] initWithRootViewController:[[WishManagerController alloc] initWithOwnController:YES WithType:WISHLIST AndWithFBUser:_user]];
    myWishListNavigationController.tabBarItem.title = @"My Wish Lists";
    [myWishListNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:22], NSFontAttributeName, nil]];
    myWishListNavigationController.delegate = self;
    
    UIImage* myWishListImage = [UIImage imageNamed:@"Kitchen-List-ingredients-icon.png"];
    myWishListImage = [[myWishListImage scaleToSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    myWishListNavigationController.tabBarItem.image = myWishListImage;
    
    UINavigationController* friendListNavigationController = [[UINavigationController alloc] initWithRootViewController:[[FriendListViewController alloc] init]];
    friendListNavigationController.tabBarItem.title = @"Friend List";
    [friendListNavigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:22], NSFontAttributeName, nil]];
    friendListNavigationController.delegate = self;
    
    UIImage* friendListImage = [UIImage imageNamed:@"facebook.png"];
    friendListImage = [[friendListImage scaleToSize:CGSizeMake(30, 30)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    friendListNavigationController.tabBarItem.image = friendListImage;
    
    PurchasesController* purchaseController = [[PurchasesController alloc] init];
    purchaseController.tabBarItem.title = @"Purchase";
    
    
    _tabBarController = [[UITabBarController alloc] init];
    [_tabBarController setViewControllers:[NSArray arrayWithObjects:myWishListNavigationController,friendListNavigationController,purchaseController, nil]];
    
    [self.view addSubview:_tabBarController.view];
//    self.tabBarController.tabBar.barTintColor = [BackgroundLayer colorWithHexString:@"1D62F0"];
//    self.tabBarController.tabBar.tintColor = [UIColor whiteColor];
//    self.tabBarController.tabBar.translucent = YES;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController conformsToProtocol:@protocol(BannerProtocol) ])
    {
        UIViewController<BannerProtocol>* vc = (UIViewController<BannerProtocol>*)viewController;
        _upperViewController = vc;
        
        BOOL isRemoveAdOptionBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.giftwish.gift.wish.removeAds"];
        
        if (isRemoveAdOptionBought)
        {
            NSLog(@"hide the banner");
            [vc hideBanner:_bannerView];
        }
        else if (_isBannerLoaded || _bannerView.bannerLoaded)
        {
            [vc showBanner:_bannerView];
        }
    }
    
}

//banner
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    _isBannerLoaded = YES;
    NSLog(@"bannerViewDidLoadAd");
    
    BOOL isRemoveAdOptionBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.giftwish.gift.wish.removeAds"];
    
    if (_upperViewController != nil && !isRemoveAdOptionBought)
    {
        [_upperViewController showBanner:_bannerView];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    _isBannerLoaded = NO;
    NSLog(@"didFailToReceiveAdWithError");
    if (_upperViewController != nil)
    {
        [_upperViewController hideBanner:_bannerView];
    }
}

//confirmation delegates
-(void)postGranted
{
    NSLog(@"granted");
    [self requestPermissionCallAPI];
    [self createNavigationController];
}

-(void)postDenied
{
    NSLog(@"denied");
    [self createNavigationController];
}

- (void)requestPermissionCallAPI {
    
    [FBSession.activeSession
     requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
     defaultAudience:FBSessionDefaultAudienceEveryone
     completionHandler:^(FBSession *session, NSError *error) {
         if (error) {
             // Handle new permissions request errors
             NSLog(@"error");
         } else {
             NSLog(@"requestPermissionCallAPI");
             [self postUsingAppToFacebook];
         }
     }];
}

-(void)postUsingAppToFacebook
{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Gift Wish", @"name",
                                       @"Gift Wish is what you have ever wanted!", @"caption",
                                       [NSString stringWithFormat:@"%@ started to use Gift Wish!", _user.name], @"description",
                                       @"http://neyma6.com/giftwish/index.html", @"link",
                                       @"http://neyma6.com/giftwish/images/logo.png", @"picture",
                                       nil];
    
        // Make the request
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      // Link posted successfully to Facebook
                                      NSLog([NSString stringWithFormat:@"result: %@", result]);
                                  } else {
                                      // An error occurred, we need to handle the error
                                      // See: https://developers.facebook.com/docs/ios/errors
                                      NSLog([NSString stringWithFormat:@"%@", error.description]);
                                  }
                              }];
}

@end
