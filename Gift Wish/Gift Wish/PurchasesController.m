//
//  MasterViewController.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PurchasesController.h"
#import "IAPHelper.h"
#import "BackGroundLayer.h"
#import <StoreKit/StoreKit.h>

@interface PurchasesController () {
    NSArray *_products;
    NSNumberFormatter * _priceFormatter;
}
@property (strong, nonatomic) UITableViewController* tableView;
@property (strong, nonatomic) UIButton* restoreButton;
@property (strong, nonatomic) UIButton* closeButton;

@end

@implementation PurchasesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];//ios7ThreeColorBlueGradient
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    [self createTable];
    [self createRestoreButton];
    [self createCloseButton];
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
}

-(void)createRestoreButton
{
    _restoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _restoreButton.frame = CGRectMake(self.view.frame.size.width - 100, 10, 100, 50);
    [_restoreButton setTitle:@"Close" forState:UIControlStateNormal];
    [_restoreButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_restoreButton];
}

-(void)createCloseButton
{
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _closeButton.frame = CGRectMake(10, 10, 100, 50);
    [_closeButton setTitle:@"Restore" forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(restoreTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
}

-(void)createTable
{
    _tableView = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    _tableView.tableView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height- 50);
    _tableView.tableView.delegate = self;
    _tableView.tableView.dataSource = self;
    _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.refreshControl = [[UIRefreshControl alloc] init];
    [_tableView.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    [self reload];
    [_tableView.refreshControl beginRefreshing];
    _tableView.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView.tableView];
}

-(void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)restoreTapped:(id)sender {
    [[IAPHelper sharedInstance] restoreCompletedTransactions];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)productPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            [_tableView.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            *stop = YES;
        }
    }];
    
}

- (void)reload {
    _products = nil;
    [_tableView.tableView reloadData];
    [[IAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {
            _products = products;
            [_tableView.tableView reloadData];
        }
        [_tableView.refreshControl endRefreshing];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"PurchasesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    SKProduct * product = (SKProduct *) _products[indexPath.row];
    cell.textLabel.text = product.localizedTitle;
    [_priceFormatter setLocale:product.priceLocale];
    cell.detailTextLabel.text = [_priceFormatter stringFromNumber:product.price];

    if ([[IAPHelper sharedInstance] productPurchased:product.productIdentifier]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = nil;
    } else {
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(0, 0, 72, 37);
        [buyButton setTitle:@"Buy" forState:UIControlStateNormal];
        buyButton.tag = indexPath.row;
        [buyButton addTarget:self action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = buyButton;
    }
    
    return cell;
}

- (void)buyButtonTapped:(id)sender {
    
    UIButton *buyButton = (UIButton *)sender;
    SKProduct *product = _products[buyButton.tag];
    
    NSLog(@"Buying %@...", product.productIdentifier);
    [[IAPHelper sharedInstance] buyProduct:product];

}

@end
