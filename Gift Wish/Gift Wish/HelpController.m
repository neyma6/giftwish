//
//  HelpController.m
//  Gift Wish
//
//  Created by neyma on 17/05/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "HelpController.h"
#import "BackGroundLayer.h"

@interface HelpController ()
{
    CGRect mainWindow;
    CGFloat offset;
}
@property (strong, nonatomic) FBLoginView *loginView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIView* mainView;

@end

@implementation HelpController


- (void)viewDidLoad
{
    [super viewDidLoad];

    mainWindow = self.view.frame;
    offset = mainWindow.size.width / 25;
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];//
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    [self createExitButton];
    [self createFBLogin];
    
    [self.view addSubview:_loginView];
    
    CGRect tableRect = CGRectMake(0, 50, mainWindow.size.width, mainWindow.size.height - 105);
    CGRect mainViewRect = CGRectMake(0, 0, mainWindow.size.width, 1600);
    _mainView = [[UIView alloc] initWithFrame:mainViewRect];
    _tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    NSArray* wishListLevelNames = [NSArray arrayWithObjects:@"Event in 1 week", @"Event in 2 weeks", @"Event is after 3 weeks", nil];
    NSArray* wishLevelNames = [NSArray arrayWithObjects:@"Very important wish", @"Important wish", @"Less important wish", nil];
    NSArray* images = [NSArray arrayWithObjects:[UIImage imageNamed:@"urgent.png"], [UIImage imageNamed:@"medium.png"], [UIImage imageNamed:@"easy.png"], nil];
    
    [self createIntroduction];
    [self createWishListHelp];
    [self createLevelHelpWithY:610.0 WithImages:images AndWithNameArray:wishListLevelNames];
    [self createWishHelp];
    [self createLevelHelpWithY:1100.0 WithImages:images AndWithNameArray:wishLevelNames];
    [self createFriendHelp];
    [self createAboutTheAuthor];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createFBLogin
{
    _loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info"]];
    
    _loginView.delegate = self;
    
    _loginView.frame = CGRectMake(mainWindow.size.width / 2 - 100, mainWindow.size.height - 50, 200, 50);//
    
    [self.view addSubview:_loginView];
}

-(void)createExitButton
{
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(mainWindow.size.width - 35,  25, 25, 25);
    [_cancelButton addTarget:self action:@selector(hidePopUp) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel1.png"] forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel2.png"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:_cancelButton];
}

-(void)createIntroduction
{
    [self AddLabelWithName:@"Introduction" WithY:0];
    
    UITextView* intro = [self createUITextViewWithY:25 AndWithHeight:275];
    
    intro.text = @"Are you always in trouble, because you don't know what you should buy for your friend for her/his birthday or any event? \n\nThis application is what you have ever wanted!\n\nThe one thing you have to do is to see what your friend would like to get!\n\nYou also can set your wishes for your friends!";

    [_mainView addSubview:intro];
}

-(void)createWishListHelp
{
    [self AddLabelWithName:@"Wish List" WithY:260];
    
    UITextView* wishListHelp = [self createUITextViewWithY:285 AndWithHeight:325];
    
    wishListHelp.text = @"After logging with your Facebook account you can see the Wish Lists. Wish List is like \"MyBirthday\" or a \"Wedding Party\".\nTo set your Wish List first of all touch the \"Add Wish List\" button. One the Create New Wish List page you can give your Wish List's name and the date of the event. After touching the CREATE button your new Wish List will appear in the list.\nYou can modify or delete your Wish Lists, just touch the edit button on the right upper corner.\n\nIn every row there's a red, orange or green icon, the meaning of these are the following:\n\n";
    [_mainView addSubview:wishListHelp];
}

-(void)createWishHelp
{
    [self AddLabelWithName:@"Wishes" WithY:730];
    
    UITextView* wishHelp = [self createUITextViewWithY:755 AndWithHeight:345];
    
    wishHelp.text = @"After touching one of your Wish Lists you can see your Wishes of the touched Wish List.\nTo add a new Wish just touch the \"Add New Wish List\" button.\nOn the \"Create New Wish\" page you can set the name, the description, the importance and the link of your new Wish.\nAfter touching the \"CREATE\" button your new Wish will appear in the list.\nYou can modify or delete your Wishs, just touch the edit button on the right upper corner.\n\nIn every row there's a red, orange or green icon, the meaning of these are the following:\n\n";
    [_mainView addSubview:wishHelp];
}

-(void)createFriendHelp
{
    [self AddLabelWithName:@"My Friend's Wishes" WithY:1220];
    
    UITextView* friendHelp = [self createUITextViewWithY:1245 AndWithHeight:245];
    
    friendHelp.text = @"If you would like to see your friend's lists just touch the \"Friend List\" tab button and select one of your friend.\nTouch the desired Wish List and check what he/she would like to get for that event.\nYou can see the details of a Wish if you touch the row of it.\nIf you decided or you have already bought that present just press the \"I bought it\" button in the detail view.\nAfter pressing \"I bought it\" button a tich will appear at the end of the row.";
    [_mainView addSubview:friendHelp];
}

-(void)createAboutTheAuthor
{
    [self AddLabelWithName:@"About the author" WithY:1480];
    
    UITextView* about = [self createUITextViewWithY:1505 AndWithHeight:75];
    
    about.text = @"Author: Gabor Csatlos\nContact: neyma6@gmail.com\n2014 All rights reserved. ©";
    [_mainView addSubview:about];
}

-(void)createLevelHelpWithY:(CGFloat)start WithImages:(NSArray*)images AndWithNameArray:(NSArray*)names //y=600
{
    UIView* levelPanel = [[UIView alloc] initWithFrame:CGRectMake(offset, start, mainWindow.size.width - offset * 2, 110)];
    
    CGFloat yStep = 40;
    CGFloat y = 0;
    for (int i = 0; i < images.count; i++)
    {
        UIImageView* red = [[UIImageView alloc] initWithFrame:CGRectMake(0, y, 30, 30)];
        red.image = [images objectAtIndex:i];
        [levelPanel addSubview:red];
    
        UILabel* urgent = [[UILabel alloc] initWithFrame:CGRectMake(40, y, mainWindow.size.width - offset * 2 - 40, 30)];
        urgent.text = [names objectAtIndex:i];
        urgent.textColor = [UIColor whiteColor];
        urgent.font = [UIFont systemFontOfSize:15];
        [levelPanel addSubview:urgent];
        y += yStep;
    }
    
    [_mainView addSubview:levelPanel];
}

-(UITextView*)createUITextViewWithY:(CGFloat)y AndWithHeight:(CGFloat)height
{
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(offset, y , mainWindow.size.width - offset * 2, height)];
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    return textView;
}

-(UILabel*)createLabeldWithY:(CGFloat)y AndWithHeight:(CGFloat)height
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(offset, y, mainWindow.size.width - offset * 2, height)];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:18];
    return label;
}

-(void)AddLabelWithName:(NSString*)name WithY:(CGFloat)y
{
    UILabel* title = [self createLabeldWithY:y AndWithHeight:30];
    title.text = name;
    [_mainView addSubview:title];
}

-(void)hidePopUp
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        [cell addSubview:_mainView];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _mainView.frame.size.height;
}

@end
