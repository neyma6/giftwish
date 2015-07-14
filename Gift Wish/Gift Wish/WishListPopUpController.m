//
//  WishListPopUpController.m
//  Gift Wish
//
//  Created by neyma on 18/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "WishListPopUpController.h"
#import "BackGroundLayer.h"
#import "ModalViewController.h"

@interface WishListPopUpController ()
{
    CGRect windowFrame;
    WishListPopUpControllerType popUpType;
}

@property (strong, nonatomic) UILabel* popUpTitle;
@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIButton* cancelButton;
@property (strong, nonatomic) UIButton* okButton;
@property (strong, nonatomic) UILabel* dateLabel;

@end

@implementation WishListPopUpController

- (id)initFrame:(CGRect)frame WithType:(WishListPopUpControllerType)type
{
    self = [super init];
    if (self) {
        windowFrame = frame;
        popUpType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = windowFrame;
    //self.view.backgroundColor = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    
    CAGradientLayer *bgLayer = [BackgroundLayer blueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    [self.view roundCornerswithRadius:10 andShadowOffset:10];

    [self createTitle];
    [self createExitButton];
    [self createNameLabel];
    [self createNameInputField];
    [self createDateLabel];
    //[self createDatePicker];
    [self createOkButton];
    
    
}

-(void)createTitle
{
    _popUpTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, windowFrame.size.width, 20)];
    
    if (popUpType == CREATE)
    {
        _popUpTitle.text = @"Create new Wish List";
    }
    else if (popUpType == MODIFY)
    {
        _popUpTitle.text = @"Modify Wish List";
        
    }
    
    _popUpTitle.lineBreakMode = 0;
    _popUpTitle.numberOfLines = 0;
    _popUpTitle.textAlignment = NSTextAlignmentCenter;
    _popUpTitle.font = [UIFont fontWithName:@"NovaScript" size:18];
    
    
    [self.view addSubview:_popUpTitle];
}

-(void)createExitButton
{
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.frame = CGRectMake(windowFrame.size.width - 30, 0, 30, 30);
    [_cancelButton addTarget:self action:@selector(hidePopUp) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton setTitle:@"X" forState:UIControlStateNormal];
    
    [self.view addSubview:_cancelButton];
}

-(void)createNameLabel
{
    CGFloat offset = windowFrame.size.width / 18;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 25, windowFrame.size.width - offset, 40)];
    _nameLabel.text = @"Wish List Name:";
    _nameLabel.lineBreakMode = 0;
    _nameLabel.numberOfLines = 0;
    _nameLabel.font = [UIFont fontWithName:@"NovaScript" size:12];
    
    
    [self.view addSubview:_nameLabel];
}

-(void)createNameInputField
{
    CGFloat offset = windowFrame.size.width / 18;
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(offset, 60, windowFrame.size.width - offset * 2, 30)];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    _nameField.font = [UIFont fontWithName:@"NovaScript" size:15];
    _nameField.placeholder = @"enter wish list's name";
    _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameField.keyboardType = UIKeyboardTypeDefault;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.delegate = self;
    _nameField.layer.cornerRadius = 8;
    _nameField.layer.masksToBounds = YES;
    _nameField.layer.borderWidth = 1;
    [_nameField addTarget:self action:@selector(nameTextChanged) forControlEvents:UIControlEventEditingChanged];
    
    [self.view addSubview:_nameField];
}

-(void)createDateLabel
{
    CGFloat offset = windowFrame.size.width / 18;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 90, windowFrame.size.width - offset, 40)];
    _dateLabel.text = @"Date of the event:";
    _dateLabel.lineBreakMode = 0;
    _dateLabel.numberOfLines = 0;
    _dateLabel.font = [UIFont fontWithName:@"NovaScript" size:12];
    
    [self.view addSubview:_dateLabel];

}

-(void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    //_datePicker.layer.cornerRadius = 8;
    //_datePicker.layer.masksToBounds = YES;
    //_datePicker.layer.borderWidth = 1;
    _datePicker.transform = CGAffineTransformMakeScale(.55, 0.4);
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.frame = CGRectMake(windowFrame.size.width / 2 - 100, 120, 200, 0);
    _datePicker.datePickerMode = UIDatePickerModeDate;

    [self.view addSubview:_datePicker];
}

-(void)createOkButton
{
    _okButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _okButton.frame = CGRectMake(windowFrame.size.width / 2 - 50, 210, 100, 40);
    _okButton.titleLabel.font = [UIFont fontWithName:@"NovaScript" size:20];
    if (popUpType == CREATE)
    {
        [_okButton addTarget:self action:@selector(validateInputAndSendInputToDelegate) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitle:@"CREATE" forState:UIControlStateNormal];
    }
    else if (popUpType == MODIFY)
    {
        [_okButton addTarget:self action:@selector(validateInputAndSendInputToDelegate) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitle:@"MODIFY" forState:UIControlStateNormal];
    }
    
    
    [self.view addSubview:_okButton];
}

-(void)datePickerChanged:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hidePopUp
{
    [self setNameTextFieldToDefault];
    [_datePicker setDate:[NSDate date]];
    [_nameField resignFirstResponder];
    _nameField.text = @"";
    CGRect mainWindowRect = [[UIScreen mainScreen] bounds];
    CGRect updest = CGRectMake(self.view.frame.origin.x, 0 - self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
    
    CGRect destination = CGRectMake(self.view.frame.origin.x, mainWindowRect.size.height + 20, self.view.frame.size.width, self.view.frame.size.height);

    
    [UIView animateWithDuration:.3 animations:^{
        self.view.frame = updest;
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.view.frame = destination;
        }
    }];
    [self.delegate popCanceled];
}

-(void)validateInputAndSendInputToDelegate
{
//    // igy kell majd a date pickeres csoda!
//    UIViewController *test = [[UIViewController alloc] init];
//    test.view.frame = CGRectMake(0, 0, 0, 0);
//    test.view.backgroundColor = [UIColor redColor];
//    
//    [self.view.window.rootViewController presentViewController:test animated:YES completion:nil];

    
    if ([_nameField.text isEqualToString:@""])
    {
        _nameField.layer.borderColor = [[UIColor redColor] CGColor ];
        _nameField.placeholder = @"Please enter a name!";

        return;
    }
    if (popUpType == CREATE)
    {
        [self.delegate wishListAdded:_nameField.text WithDate:nil];
    }
    else if (popUpType == MODIFY)
    {
        [self.delegate wishListModified:_wishListId WithName:_nameField.text WithDate:nil];
    }
    [self hidePopUp];
}

- (void)nameTextChanged
{
    [self setNameTextFieldToDefault];
}

-(void)setNameTextFieldToDefault
{
    _nameField.layer.borderColor = [[UIColor clearColor] CGColor];
    _nameField.placeholder = @"enter wish list's name";
}

//DELEGATES

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_nameField resignFirstResponder];
    return YES;
}



@end
