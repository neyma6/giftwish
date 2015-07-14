//
//  WishListViewController.m
//  Gift Wish
//
//  Created by neyma on 12/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "WishManagerController.h"
#import "ConnectionManager.h"
#import "WishList.h"
#import "Wish.h"
#import "BackGroundLayer.h"
#import "WishListCell.h"
#import "InfoPanel.h"
#import "ModalViewController.h"
#import "DateManipulator.h"
#import "HelpController.h"
#import "PurchasesController.h"

@interface WishManagerController ()
{
    CGRect mainWindowRect;
    NSString* deletedObjectIdFromServer;
    WishManagerType controllerType;
    BOOL isEditing;
    BOOL isLoading;
    BOOL isBannerShowed;
}
@property (nonatomic) BOOL isOwn;
@property (nonatomic) NSDictionary<FBGraphUser>* user;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* wishObjects;
@property (strong, nonatomic) ConnectionManager* connectionManager;
@property (strong, nonatomic) UILabel* errorLabel;
@property (strong, nonatomic) UIButton* addNewObjectButton;
@property (strong, nonatomic) InfoPanel* infoPanel;
@property (strong, nonatomic) NSMutableDictionary* cellImages;
@property (nonatomic, strong) UIActivityIndicatorView* progress;
@property (nonatomic, strong) UIButton* retryButton;
@property (nonatomic) ADBannerView* bannerView;
@property (strong, nonatomic) UIButton* purchasesButton;
@end

@implementation WishManagerController

- (id)initWithOwnController:(BOOL)own WithType:(WishManagerType)type AndWithFBUser:(NSDictionary<FBGraphUser>*) user
{
    self = [super init];
    if (self) {
        _isOwn = own;
        _user = user;
        _wishObjects = [[NSMutableArray alloc] init];
        controllerType = type;
        isEditing = NO;
        isLoading = NO;
        isBannerShowed = NO;
        [self initCellImageDictionaryAndLoadImage];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainWindowRect = [[UIScreen mainScreen] bounds];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];//ios7ThreeColorBlueGradient
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    UIImageView* backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_gift1.png" ]];
    backgroundImage.center = self.view.center;
    backgroundImage.alpha = 0.5;
    [self.view addSubview:backgroundImage];
    
    
//    self.navigationController.navigationBar.barTintColor = [BackgroundLayer colorWithHexString:@"1AD6FD"];
    self.navigationController.navigationBar.translucent = YES;
 
    if (_isOwn && controllerType == WISHLIST)
    {
        self.navigationItem.title = @"My Wish Lists";
    }

    if (_isOwn)
    {
        if (controllerType == WISHLIST)
        {
            UIBarButtonItem* helpButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(shopHelpWindow)];
            self.navigationController.topViewController.navigationItem.leftBarButtonItem = helpButton;
        }
        
        UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed)];
        self.navigationController.topViewController.navigationItem.rightBarButtonItem = editButton;
    }
    
    if (!_isOwn)
    {
        if (controllerType == WISHLIST)
        {
            UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWishLists)];
            self.navigationItem.rightBarButtonItem = refresh;
        }
        else if (controllerType == WISH)
        {
            UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWishs)];
            self.navigationItem.rightBarButtonItem = refresh;
        }
    }
    
    [self createInfoPanel];
    
    [self createTable];
    
    [self createProcessIndicator];
    [self startProgressIndicator];
    
    if (_isOwn)
    {
        [self createAddObjectButton];
        [self createPurchasesButton];
    }
    
    
    _connectionManager = [[ConnectionManager alloc] init];
    _connectionManager.delegate = self;
    
    NSDictionary* params = @{@"fbId" : _user[@"id"]};
    
    if (_isOwn && controllerType == WISHLIST)
    {
        [_connectionManager requesWithUrl:@"/wishList/getWishLists" WithParameters:params AndWithOrder:@"getWishLists"];
    }
    else if (!_isOwn && controllerType == WISHLIST)
    {
        [_connectionManager requesWithUrl:@"/user/checkUserExists" WithParameters:params AndWithOrder:@"checkUserExists" ];
    }
    else
    {
        params = @{@"wishListId" : _wishListForWishController.wishListId};
        [_connectionManager requesWithUrl:@"/wish/getWishes" WithParameters:params AndWithOrder:@"getWishes" ];
    }
}

-(void)editButtonPressed
{
    if (([_wishObjects count] == 0 && !isEditing) || isLoading)
    {
        return;
    }
    
    isEditing = !isEditing;
    if (isEditing)
    {
        self.navigationController.topViewController.navigationItem.rightBarButtonItem.title = @"Done";
        [_tableView setEditing:YES animated:YES];
    }
    else
    {
        self.navigationController.topViewController.navigationItem.rightBarButtonItem.title = @"Edit";
        [_tableView setEditing:NO animated:YES];
    }
}

-(void)initCellImageDictionaryAndLoadImage
{
    _cellImages = [[NSMutableDictionary alloc] init];
    [_cellImages setObject:[UIImage imageNamed:@"easy.png"] forKey:@"easy"];
    [_cellImages setObject:[UIImage imageNamed:@"medium.png"] forKey:@"medium"];
    [_cellImages setObject:[UIImage imageNamed:@"urgent.png"] forKey:@"urgent"];
}

-(void)createInfoPanel
{
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    if (controllerType == WISHLIST)
    {
        _infoPanel = [[InfoPanel alloc] initWithFrame:CGRectMake(0, navBarRect.size.height + statusBarHeight, mainWindowRect.size.width, 90) WithFBProfilId:_user WithWishList:nil WithIsOwn:_isOwn];
    }
    else
    {
        _infoPanel = [[InfoPanel alloc] initWithFrame:CGRectMake(0, navBarRect.size.height + statusBarHeight, mainWindowRect.size.width, 100) WithFBProfilId:_user WithWishList:_wishListForWishController WithIsOwn:_isOwn];
    }
    [self.view addSubview:_infoPanel];
}

-(void)createTable
{
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    int addWishListButtonHeight = 35;
    
    if (!_isOwn)
    {
        addWishListButtonHeight = 0;
    }
    
    CGRect tableViewRect = CGRectMake(10, _infoPanel.frame.size.height + navBarRect.size.height + statusBarHeight, mainWindowRect.size.width, mainWindowRect.size.height - tabBarHeight - addWishListButtonHeight - navBarRect.size.height - statusBarHeight - _infoPanel.frame.size.height - 3);//
    _tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    _tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_tableView];
    //[_tableView setEditing:YES animated:NO];
}

-(void)createProcessIndicator
{
    _progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.center.x - 25, self.view.center.y - 25, 50, 50)];
    _progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
}

-(void)startProgressIndicator
{
    NSLog(@"START ANIMATION");
    isLoading = YES;
    [self.view addSubview:_progress];
    [_progress startAnimating];
}

-(void)stopProgressIndicator
{
    isLoading = NO;
    [_progress stopAnimating];
    [_progress removeFromSuperview];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void)createAddObjectButton
{
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    _addNewObjectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addNewObjectButton.frame = CGRectMake(self.view.frame.size.width / 2 - 125, _tableView.frame.size.height +
                                       navBarRect.size.height + statusBarHeight + _infoPanel.frame.size.height - 6, 250, 40);
    [_addNewObjectButton addTarget:self action:@selector(pushCreateModal) forControlEvents:UIControlEventTouchUpInside];
    [_addNewObjectButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    _addNewObjectButton.titleLabel.textColor = [UIColor lightTextColor];
    [_addNewObjectButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    _addNewObjectButton.backgroundColor = [UIColor clearColor];
    //[_addNewObjectButton setBackgroundImage:[UIImage imageNamed:@"button_border.png"] forState:UIControlStateNormal];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7MildBlueGradient];
    bgLayer.frame = _addNewObjectButton.bounds;
    bgLayer.opacity = 0.3;
    [_addNewObjectButton.layer insertSublayer:bgLayer atIndex:0];
    
    //[_addNewObjectButton.layer setCornerRadius:30.0f];
    
    // border radius
//    [_addNewObjectButton.layer setCornerRadius:10.0f];
//    
//    // border
//    [_addNewObjectButton.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [_addNewObjectButton.layer setBorderWidth:1.5f];
    
//    // drop shadow
//    [_addNewObjectButton.layer setShadowColor:[UIColor blackColor].CGColor];
//    [_addNewObjectButton.layer setShadowOpacity:0.8];
//    [_addNewObjectButton.layer setShadowRadius:3.0];
//    [_addNewObjectButton.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    if (controllerType == WISHLIST)
    {
        [_addNewObjectButton setTitle:@"Add new Wish List" forState:UIControlStateNormal];
    }
    else
    {
        [_addNewObjectButton setTitle:@"Add new Wish" forState:UIControlStateNormal];
    }

    [self.view addSubview:_addNewObjectButton];
}

-(void)createPurchasesButton
{
    CGRect navBarRect = self.navigationController.navigationBar.frame;
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;

    _purchasesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _purchasesButton.frame = CGRectMake(self.view.frame.size.width - 75, navBarRect.size.height + statusBarHeight, 75, 30);
    [_purchasesButton setTitle:@"Purchase" forState:UIControlStateNormal];
    [_purchasesButton addTarget:self action:@selector(createPurchasesModalView) forControlEvents:UIControlEventTouchUpInside];
    [_purchasesButton addTarget:self action:@selector(setBgColorForButton:) forControlEvents:UIControlEventTouchDown];
    _purchasesButton.titleLabel.textColor = [UIColor lightTextColor];
    _purchasesButton.backgroundColor = [UIColor clearColor];
    [_purchasesButton.titleLabel setFont:[UIFont systemFontOfSize:15]];

    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlackGradient];
    bgLayer.frame = _purchasesButton.bounds;
    bgLayer.opacity = 0.3;
    [_purchasesButton.layer insertSublayer:bgLayer atIndex:0];
    
    
    [self.view addSubview:_purchasesButton];
}

-(void)createPurchasesModalView
{
    PurchasesController* purchasesController = [[PurchasesController alloc] init];
    [self.view.window.rootViewController presentViewController:purchasesController animated:YES completion:nil];
}

-(void)setBgColorForButton:(id)sender
{
    UIButton* button = (UIButton*)sender;
    button.titleLabel.textColor = [UIColor lightTextColor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wishObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    WishListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[WishListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier OwnWishList:_isOwn WithControllerType:controllerType];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (isEditing)
        {
            [cell setToEditingStateWithOffset:70];
        }
    }
    
    //if table is not in editing mode, but cell remainded in that, it should be restored to default
    if (!isEditing && [cell isEditing])
    {
        [cell setToDefaultState];
    }
    
    if (isEditing && ![cell isEditing])
    {
        [cell setToEditingStateWithOffset:90];
    }
    
    if (controllerType == WISHLIST)
    {
        WishList* wishList = [_wishObjects objectAtIndex:indexPath.row];
        cell.objectName.text = wishList.name;
        cell.objectId = wishList.wishListId;
        cell.image.image = [self selectProperCellImage:wishList.eventDate];
    }
    else
    {
        Wish* wish = [_wishObjects objectAtIndex:indexPath.row];
        cell.objectId = wish.wishId;
        cell.objectName.text = wish.name;
        cell.image.image = [self selectProperCellImageForLevel:[wish.level integerValue]];
        if (!_isOwn && wish.checked == YES)
        {
            cell.checkedImage.hidden = NO;
        }
        else
        {
            cell.checkedImage.hidden = YES;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isLoading)
    {
        return;
    }
    if (controllerType == WISHLIST)
    {
        WishManagerController* wishController = [[WishManagerController alloc] initWithOwnController:_isOwn WithType:WISH   AndWithFBUser:_user];
        WishList* wishList = [_wishObjects objectAtIndex:indexPath.row];
        wishController.wishListForWishController = wishList;
    
        [self.navigationController pushViewController:wishController animated:YES];
    }
    else if (controllerType == WISH && _isOwn)
    {
        Wish* wish = [_wishObjects objectAtIndex:indexPath.row];
        ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALMODIFYWISH];
        modal.delegate = self;
        modal.wish = wish;
        [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];

    }
    else if (controllerType == WISH && !_isOwn)
    {
        Wish* wish = [_wishObjects objectAtIndex:indexPath.row];
        ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALREADONLYWISH];
        modal.delegate = self;
        modal.wish = wish;
        [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];
        
    }
}

-(UIImage*)selectProperCellImage:(NSString*)eventDate
{
    NSDate* eventDateFromString = [DateManipulator formatStringToDate:eventDate];
    NSDate* currentDate = [NSDate date];
    UIImage* ret = nil;
    
    NSCalendar* sysCalendar = [NSCalendar currentCalendar];
    NSDateComponents * info = [sysCalendar components:NSDayCalendarUnit fromDate:currentDate toDate:eventDateFromString options:0];
    
    int day = [info day];
    
    
    if (day <= 7)
    {
        ret = [_cellImages objectForKey:@"urgent"];
    }
    else if (day <= 14)
    {
        ret = [_cellImages objectForKey:@"medium"];
    }
    else
    {
        ret = [_cellImages objectForKey:@"easy"];
    }
    return ret;
}

-(UIImage*)selectProperCellImageForLevel:(int)level
{
    UIImage* ret;

    if (level == 2)
    {
        ret = [_cellImages objectForKey:@"urgent"];
    }
    else if (level == 1)
    {
        ret = [_cellImages objectForKey:@"medium"];
    }
    else
    {
        ret = [_cellImages objectForKey:@"easy"];
    }
    return ret;
}


-(void)downloadCompilted:(NSMutableData*)data WithThisOrder:(NSString*)order
{
    NSLog(@"downloadCompilted");
    if ([order isEqualToString:@"getWishLists"])
    {
        [self processGetWishLists:data];
    }
    else if ([order isEqualToString:@"checkUserExists"])
    {
        [self processCheckUserExists:data];
    }
    else if ([order isEqualToString:@"addWishList"])
    {
        [self processAddWishList:data];
    }
    else if ([order isEqualToString:@"removeWishList"])
    {
        [self processRemoveWishList:data];
    }
    else if ([order isEqualToString:@"modifyWishList"])
    {
        [self processModifyWishList:data];
    }
    else if ([order isEqualToString:@"getWishes"])
    {
        [self processGetWishes:data];
    }
    else if ([order isEqualToString:@"addWish"])
    {
        [self processAddWish:data];
    }
    else if ([order isEqualToString:@"removeWish"])
    {
        [self processRemoveWish:data];
    }
    else if ([order isEqualToString:@"modifyWish"])
    {
        [self processModifyWish:data];
    }
    else if ([order isEqualToString:@"checkWish"])
    {
        [self processGetWishes:data];
    }
}

/////////////////////RESPONSE METHODS///////////////////////////////////
-(void)processCheckUserExists:(NSMutableData*)data
{
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([result isEqualToString:@"true"])
    {
        NSDictionary* params = @{@"fbId" : _user[@"id"]};
        [_connectionManager requesWithUrl:@"/wishList/getWishLists" WithParameters:params AndWithOrder:@"getWishLists"];
    }
    else
    {
        [self stopProgressIndicator];
        [self showErrorLabel:@"User is not registered to Gift Wish"];
    }
}

-(void)processGetWishLists:(NSMutableData*)data
{
    [self stopProgressIndicator];
    [_wishObjects removeAllObjects];
    [_tableView reloadData];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    for (NSDictionary* dict in json)
    {
        WishList* wishList = [[WishList alloc] init];
        wishList.wishListId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wishListId"] ];
        wishList.name = [dict objectForKey:@"name"];
        wishList.lastUpdate = [dict objectForKey:@"lastUpdate"];
        wishList.eventDate = [dict objectForKey:@"wishListDate"];
        [_wishObjects addObject:wishList];
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:([_wishObjects count] - 1)  inSection:0];
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_tableView endUpdates];

    }
    
    if ([_wishObjects count] == 0)
    {
        [self showErrorLabel:@"No Wish List has been added yet!"];
    }
    
    //[_tableView reloadData];
}

-(void)processAddWishList:(NSMutableData*)data
{
    [self stopProgressIndicator];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    
    if ([json count] != 0)
    {
        WishList* wishList = [[WishList alloc] init];
        wishList.wishListId = [NSString stringWithFormat:@"%@", [json objectForKey:@"wishListId"] ];
        wishList.name = [json objectForKey:@"name"];
        wishList.lastUpdate = [json objectForKey:@"lastUpdate"];
        wishList.eventDate = [json objectForKey:@"wishListDate"];
        NSIndexPath* indexPath = [self getIndexPathInList:_wishObjects ForWishList:wishList];
        NSLog(@"indexPath i = %d", indexPath.row);
        [_wishObjects insertObject:wishList atIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_tableView endUpdates];

    }
    
    if ([_tableView isHidden])
    {
        _tableView.hidden = NO;
        if (_errorLabel)
        {
            [_errorLabel removeFromSuperview];
        }
    }
}

-(void)processRemoveWishList:(NSMutableData*)data
{
    [self stopProgressIndicator];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([result isEqualToString:@"true"])
    {
        WishList* itemForDelete = [self findWishList:deletedObjectIdFromServer];
        //ezt majd azért átt kellene 0rni!!!!
        int index = [self findWishListIndex:deletedObjectIdFromServer];
        
        if (itemForDelete != nil)
        {
            [_wishObjects removeObject:itemForDelete];
            
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index  inSection:0];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [_tableView endUpdates];
            
            if ([_wishObjects count] == 0)
            {
                [self showErrorLabel:@"No Wish List has been added yet!"];
                isEditing = NO;
                self.navigationController.topViewController.navigationItem.rightBarButtonItem.title = @"Edit";
                [_tableView setEditing:NO animated:YES];
            }
            //[_tableView reloadData];
        }
    }
    else
    {
        NSLog(@"error");
    }
}

-(void)processModifyWishList:(NSMutableData*)data
{
    NSLog(@"processModifyWishList");
    [self stopProgressIndicator];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if ([json count] != 0)
    {
        NSString *wishListId = [NSString stringWithFormat:@"%@", [json objectForKey:@"wishListId"] ];
        NSString* name = [json objectForKey:@"name"];
        NSString* lastUpdate = [json objectForKey:@"lastUpdate"];
        NSString* eventDate = [json objectForKey:@"wishListDate"];
        
        //WishList* wishList = [self findWishList:wishListId];
        int index = [self findWishListIndex:wishListId];
        
        if (index >= _wishObjects.count)
        {
            [self showErrorDialog:@"Parsing Error" WithMessage:@"There was an error during data parsing."];
            return;
        }
        
        WishList* wishList = [_wishObjects objectAtIndex:index];
        
        if (wishList != nil)
        {
            wishList.name = name;
            wishList.lastUpdate = lastUpdate;
            wishList.eventDate = eventDate;
            
            WishList* modifiedWishList = [[WishList alloc] initWithWishList:wishList];
            [_wishObjects removeObjectAtIndex:index];
            [_tableView reloadData];
            
            NSIndexPath* indexPath = [self getIndexPathInList:_wishObjects ForWishList:modifiedWishList];
            [_wishObjects insertObject:modifiedWishList atIndex:indexPath.row];
            
            //NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index  inSection:0];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
            //[_tableView reloadData];
        }
        
    }

}

-(void)processGetWishes:(NSMutableData*)data
{
    [self stopProgressIndicator];
    [_wishObjects removeAllObjects];
    [_tableView reloadData];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    for (NSDictionary* dict in json)
    {
        Wish* wish = [[Wish alloc] init];
        wish.wishId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wishId"] ];
        wish.wishListId = [NSString stringWithFormat:@"%@", [dict objectForKey:@"wishListId"] ];
        wish.name = [dict objectForKey:@"name"];
        wish.description = [dict objectForKey:@"description"];
        wish.checkDate = [dict objectForKey:@"checkDate"];
        wish.checked = [[dict objectForKey:@"checked"] integerValue] == 0 ? NO : YES;
        wish.level = [NSString stringWithFormat:@"%@", [dict objectForKey:@"level"] ];
        wish.url = [dict objectForKey:@"url"];
        [_wishObjects addObject:wish];
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:([_wishObjects count] - 1)  inSection:0];
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [_tableView endUpdates];
    }
    
    if ([_wishObjects count] == 0)
    {
        [self showErrorLabel:@"No wish has been added yet!"];
    }
}

-(void)processAddWish:(NSMutableData*)data
{
    [self stopProgressIndicator];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    Wish* wish = [[Wish alloc] init];
    wish.wishId = [NSString stringWithFormat:@"%@", [json objectForKey:@"wishId"] ];
    wish.wishListId = [NSString stringWithFormat:@"%@", [json objectForKey:@"wishListId"] ];
    wish.name = [json objectForKey:@"name"];
    wish.description = [json objectForKey:@"description"];
    wish.checkDate = [json objectForKey:@"checkDate"];
    wish.checked = (BOOL)[json objectForKey:@"checked"];
    wish.level = [NSString stringWithFormat:@"%@", [json objectForKey:@"level"] ];
    wish.url = [json objectForKey:@"url"];
    //[_wishObjects addObject:wish];
    
    if ([_tableView isHidden])
    {
        _tableView.hidden = NO;
        if (_errorLabel)
        {
            [_errorLabel removeFromSuperview];
        }
    }
    
    
    NSIndexPath* indexPath = [self getIndexPathInList:_wishObjects ForWish:wish];
    [_wishObjects insertObject:wish atIndex:indexPath.row];
    
    //NSIndexPath* indexPath = [NSIndexPath indexPathForItem:([_wishObjects count] - 1)  inSection:0];
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [_tableView endUpdates];
    //[_tableView reloadData];

}

-(void)processRemoveWish:(NSMutableData*)data
{
    [self stopProgressIndicator];
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([result isEqualToString:@"true"])
    {
        //Wish* itemForDelete = [self findWish:deletedObjectIdFromServer];
        int index = [self findWishIndex:deletedObjectIdFromServer];
        
        if (index >= _wishObjects.count)
        {
            [self showErrorDialog:@"Parsing Error" WithMessage:@"There was an error during data parsing."];
            return;
        }
        
        Wish* itemForDelete = [_wishObjects objectAtIndex:index];
        
        if (itemForDelete != nil)
        {
            [_wishObjects removeObject:itemForDelete];
            NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index  inSection:0];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [_tableView endUpdates];
            if ([_wishObjects count] == 0)
            {
                [self showErrorLabel:@"No wish has been added yet!"];
                isEditing = NO;
                self.navigationController.topViewController.navigationItem.rightBarButtonItem.title = @"Edit";
                [_tableView setEditing:NO animated:YES];
                
            }
        }
    }
    else
    {
        NSLog(@"error");
    }
}

-(void)processModifyWish:(NSMutableData*)data
{
    [self stopProgressIndicator];
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    if ([json count] != 0)
    {
        NSString *wishId = [NSString stringWithFormat:@"%@", [json objectForKey:@"wishId"] ];
        NSString* name = [json objectForKey:@"name"];
        NSString* description = [json objectForKey:@"description"];
        NSString* level = [NSString stringWithFormat:@"%@", [json objectForKey:@"level"] ];
        NSString* url = [json objectForKey:@"url"];
        
        //Wish* wish = [self findWish:wishId];
        int index = [self findWishIndex:wishId];
        
        if (index >= _wishObjects.count)
        {
            [self showErrorDialog:@"Parsing Error" WithMessage:@"There was an error during data parsing."];
            return;
        }
        
        Wish* wish = [_wishObjects objectAtIndex:index];
        
        if (wish != nil)
        {
            wish.name = name;
            wish.description = description;
            wish.level = level;
            wish.url = url;
            
            Wish* modifiedWish = [[Wish alloc] initWithWish:wish];
            [_wishObjects removeObjectAtIndex:index];
            [_tableView reloadData];
            
            NSIndexPath* indexPath = [self getIndexPathInList:_wishObjects ForWish:modifiedWish];
            [_wishObjects insertObject:modifiedWish atIndex:indexPath.row];
            
            
            //NSIndexPath* indexPath = [NSIndexPath indexPathForItem:index  inSection:0];
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [_tableView endUpdates];

            //[_tableView reloadData];
        }
        
    }
}
///////////////////////////////////////////////////////////////////////

-(NSIndexPath*)getIndexPathInList:(NSMutableArray*)array ForWishList:(WishList*)wishlist
{
    NSDate* newWishListDate = [DateManipulator formatStringToDate:wishlist.eventDate];
    int i = 0;
    for (WishList* wl in array)
    {
        NSDate* wishListDate = [DateManipulator formatStringToDate:wl.eventDate];
        
        if (([newWishListDate compare:wishListDate] == NSOrderedAscending) || ([newWishListDate compare:wishListDate] == NSOrderedSame))
        {
            break;
        }
        
        i++;
    }
    return [NSIndexPath indexPathForItem:i  inSection:0];
}

-(NSIndexPath*)getIndexPathInList:(NSMutableArray*)array ForWish:(Wish*)wish
{
    int i = 0;
    for (Wish* w in array)
    {
        if ([wish.level intValue] > [w.level intValue])
        {
            break;
        }
        
        i++;
    }
    return [NSIndexPath indexPathForItem:i  inSection:0];
}

//ConnectionManagerDelegate
-(void)errorDuringDownload:(NSError *)error
{
    [self stopProgressIndicator];
    
    [self showErrorDialog:@"Communication Error" WithMessage:@"There was an error during the communication."];
    
    //if (error.code == -1001 && _wishObjects.count == 0)
    {
        [self showErrorLabel:@"To keep syncronized you must reload your data"];
        [_wishObjects removeAllObjects];
        [_tableView reloadData];
        [self showRetryButton];
    }
}


-(void)showErrorDialog:(NSString*)title WithMessage:(NSString*)message
{
    ConfirmationDialog* errorDialog = [[ConfirmationDialog alloc] initWithTitle:title message:message cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [errorDialog show];
}

-(void)showRetryButton
{
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
    [_retryButton removeFromSuperview];
    [_errorLabel removeFromSuperview];
    [_tableView setHidden:NO];
    [self startProgressIndicator];
    if (controllerType == WISHLIST)
    {
        NSDictionary* params = @{@"fbId" : _user[@"id"]};
        [_connectionManager requesWithUrl:@"/wishList/getWishLists" WithParameters:params AndWithOrder:@"getWishLists"];
    }
    else if (controllerType == WISH)
    {
        NSDictionary* params = @{@"wishListId" : _wishListForWishController.wishListId};
        [_connectionManager requesWithUrl:@"/wish/getWishes" WithParameters:params AndWithOrder:@"getWishes" ];
    }
}

-(WishList*)findWishList:(NSString*)wishlistId
{
    WishList* wishList = nil;
    
    for (WishList* wl in _wishObjects)
    {
        if ([wl.wishListId isEqualToString:wishlistId])
        {
            wishList = wl;
            break;
        }
    }
    
    return wishList;
}

-(int)findWishListIndex:(NSString*)wishlistId
{
    int i = 0;
    for (WishList* wl in _wishObjects)
    {
        
        if ([wl.wishListId isEqualToString:wishlistId])
        {
            break;
        }
        i++;
    }
    
    return i;
}

-(Wish*)findWish:(NSString*)wishId
{
    Wish* wish = nil;
    
    for (Wish* w in _wishObjects)
    {
        if ([w.wishId isEqualToString:wishId])
        {
            wish = w;
            break;
        }
    }
    
    return wish;
}

-(int)findWishIndex:(NSString*)wishId
{
    int i = 0;
    
    for (Wish* w in _wishObjects)
    {
        if ([w.wishId isEqualToString:wishId])
        {
            break;
        }
        i++;
    }
    
    return i;
}

-(void)refreshWishLists
{
    if (_retryButton)
    {
        [_retryButton removeFromSuperview];
    }
    [self startProgressIndicator];
    NSDictionary* params = @{@"fbId" : _user[@"id"]};
    [_connectionManager requesWithUrl:@"/wishList/getWishLists" WithParameters:params AndWithOrder:@"getWishLists"];
}

-(void)refreshWishs
{
    if (_retryButton)
    {
        [_retryButton removeFromSuperview];
    }
    [self startProgressIndicator];
    NSDictionary* params = @{@"wishListId" : _wishListForWishController.wishListId};
    [_connectionManager requesWithUrl:@"/wish/getWishes" WithParameters:params AndWithOrder:@"getWishes" ];
}

-(void)shopHelpWindow
{
    HelpController* helpController = [[HelpController alloc] init];
    helpController.view.frame = [[UIScreen mainScreen] bounds];
    [self.view.window.rootViewController presentViewController:helpController animated:YES completion:nil];
}



//ModalViewControllerDelegate delegate
-(void)wishListAdded:(WishList*)wishList
{
    [self startProgressIndicator];
    NSDictionary* params = @{@"fbId" : _user[@"id"], @"name" : wishList.name, @"wishListDate": wishList.eventDate};
    [_connectionManager requesWithUrl:@"/wishList/addWishList" WithParameters:params AndWithOrder:@"addWishList"];
}

//ModalViewControllerDelegate delegate
-(void)wishListModified:(WishList*)wishList
{
    [self startProgressIndicator];
    NSDictionary* params = @{@"wishListId" : wishList.wishListId, @"name" : wishList.name, @"fbId" : _user[@"id"], @"wishListDate": wishList.eventDate};
    [_connectionManager requesWithUrl:@"/wishList/modifyWishList" WithParameters:params AndWithOrder:@"modifyWishList"];
}

//ModalViewControllerDelegate delegate
-(void)wishAdded:(Wish*)wish
{
    [self startProgressIndicator];
    NSDictionary* params = @{@"wishListId" : wish.wishListId, @"name" : wish.name, @"description": wish.description
                             , @"level" : wish.level, @"url" : wish.url};
    [_connectionManager requesWithUrl:@"/wish/addWish" WithParameters:params AndWithOrder:@"addWish"];
}

//ModalViewControllerDelegate delegate
-(void)wishChecked:(Wish*)wish
{
    [self startProgressIndicator];
    NSDictionary* params = @{@"wishId" : wish.wishId, @"wishListId" : wish.wishListId};
    [_connectionManager requesWithUrl:@"/wish/checkWish" WithParameters:params AndWithOrder:@"checkWish"];
}

//WishListCellDelegate delegate
-(void)deleteWishList:(NSString*)wishListId
{
    [self startProgressIndicator];
    deletedObjectIdFromServer = wishListId;
    NSDictionary* params = @{@"wishListId" : deletedObjectIdFromServer};
    [_connectionManager requesWithUrl:@"/wishList/removeWishList" WithParameters:params AndWithOrder:@"removeWishList"];
}

//WishListCellDelegate delegate
-(void)modifyWishList:(NSString*)objectId
{
    [self pushModifyModal:objectId];
}

//WishListCellDelegate delegate
-(void)deleteWish:(NSString*)wishId
{
    [self startProgressIndicator];
    deletedObjectIdFromServer = wishId;
    NSDictionary* params = @{@"wishId" : deletedObjectIdFromServer};
    [_connectionManager requesWithUrl:@"/wish/removeWish" WithParameters:params AndWithOrder:@"removeWish"];
}

//Modal delegate
-(void)wishModified:(Wish*)wish
{
    [self startProgressIndicator];
    NSDictionary* params = @{@"wishId" : wish.wishId, @"name" : wish.name, @"description": wish.description
                             , @"level" : wish.level, @"url" : wish.url, @"wishListId" : wish.wishListId};
    [_connectionManager requesWithUrl:@"/wish/modifyWish" WithParameters:params AndWithOrder:@"modifyWish"];
}


-(void)showErrorLabel:(NSString*)error
{
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                   @"Sharing Tutorial", @"name",
//                                   @"Build great social apps and get more installs.", @"caption",
//                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
//                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
//                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
//                                   nil];
//    
//    // Make the request
//    [FBRequestConnection startWithGraphPath:@"/me/feed"
//                                 parameters:params
//                                 HTTPMethod:@"POST"
//                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                              if (!error) {
//                                  // Link posted successfully to Facebook
//                                  NSLog([NSString stringWithFormat:@"result: %@", result]);
//                              } else {
//                                  // An error occurred, we need to handle the error
//                                  // See: https://developers.facebook.com/docs/ios/errors
//                                  NSLog([NSString stringWithFormat:@"%@", error.description]);
//                              }
//                          }];
    
    
    if (!_errorLabel)
    {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 100, self.view.center.y - 100, 200, 200)];
    }
    _errorLabel.text = error;
    _errorLabel.lineBreakMode = 0;
    _errorLabel.numberOfLines = 0;
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    
    [_tableView setHidden:YES];
    [self.view addSubview:_errorLabel];
}

-(void)pushCreateModal
{
    if (isEditing || isLoading)
    {
        return;
    }
    if (controllerType == WISHLIST)
    {
        BOOL isWishListUnlimitedBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.giftwish.gift.wish.wishlistlimitation"];
        
        if (isWishListUnlimitedBought || [_wishObjects count] < 3)
        {
            ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALCREATEWISHLIST];
            modal.delegate = self;
            [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];
        }
        else
        {
            ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Limit reached!" message:@"You can only have 3 wish lists. If you would like to create unlimited wish lists, please go the Purchase page and buy this feature!" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [dialog show];
        }
    }
    else
    {
        BOOL isWishUnlimitedBought = [[NSUserDefaults standardUserDefaults] boolForKey:@"com.giftwish.gift.wish.wishlimitation"];
        
        if (isWishUnlimitedBought || [_wishObjects count] < 3)
        {
        
            ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALCREATEWISH];
            modal.delegate = self;
            modal.wishList = _wishListForWishController;
            [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];
        }
        else
        {
            ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Limit reached!" message:@"You can only have 3 wishes in a wish list. If you would like to create unlimited wishes, please go the Purchase page and buy this feature!" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [dialog show];
        }
    }
    
}

-(void)pushModifyModal:(NSString*)objectId
{
    if (controllerType == WISHLIST)
    {
        WishList* wishList = [self findWishList:objectId];
    
        if (!wishList)
        {
            return;
        }
        
        ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALMODIFYWISHLIST];
        modal.delegate = self;
        modal.wishList = wishList;
        [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];
    }
    else
    {
        Wish* wish = [self findWish:objectId];
        
        if (!wish)
        {
            return;
        }
        
        ModalViewController *modal = [[ModalViewController alloc] initFrame:[[UIScreen mainScreen] bounds] WithType:MODALMODIFYWISH];
        modal.delegate = self;
        modal.wish = wish;
        [self.view.window.rootViewController presentViewController:modal animated:YES completion:nil];
        
    }
}

//banner
-(void)showBanner:(ADBannerView*)bannerview
{
    if (!isBannerShowed)
    {
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height - 50);
        _addNewObjectButton.frame = CGRectMake(_addNewObjectButton.frame.origin.x, _addNewObjectButton.frame.origin.y - 50, _addNewObjectButton.frame.size.width, _addNewObjectButton.frame.size.height);
        isBannerShowed = YES;
        _bannerView = bannerview;
        
    }
    [self.view addSubview:_bannerView];
}
-(void)hideBanner:(ADBannerView*)bannerview
{
    if (isBannerShowed)
    {
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height + 50);
        _addNewObjectButton.frame = CGRectMake(_addNewObjectButton.frame.origin.x, _addNewObjectButton.frame.origin.y + 50, _addNewObjectButton.frame.size.width, _addNewObjectButton.frame.size.height);
        isBannerShowed = NO;
        [_bannerView removeFromSuperview];
    }
}

@end
