//
//  ModalViewController.m
//  Gift Wish
//
//  Created by neyma on 20/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "ModalViewController.h"
#import "BackGroundLayer.h"
#import "DateManipulator.h"
#import "CustomTextField.h"

@interface ModalViewController ()
{
    ModalControllerType popUpType;
    CGRect mainWindow;
    int maxNameCharacters;
    int maxDescCharacters;
    
}

@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  CustomTextField *nameField;
@property (strong, nonatomic)  UILabel *dateLabel;
@property (strong, nonatomic)  UIDatePicker *datePicker;
@property (strong, nonatomic)  UIButton *okButton;
@property (strong, nonatomic)  UIButton *cancelButton;
@property (strong, nonatomic)  UILabel *errorLabel;
@property (strong, nonatomic)  UILabel* descriptionLabel;
@property (strong, nonatomic)  UITextView* descriptionView;
@property (strong, nonatomic)  UILabel* levelChooserLabel;
@property (strong, nonatomic)  UISegmentedControl* levelChooser;
@property (strong, nonatomic)  UILabel* urlLabel;
@property (strong, nonatomic)  CustomTextField *urlField;
@property (strong, nonatomic)  UITextView *readOnlyUrlView;

@property (strong, nonatomic) UILabel* textViewPlaceHolder;
@property (strong, nonatomic) UILabel* nameCounterLabel;
@property (strong, nonatomic) UILabel* descCounterLabel;

@property (strong, nonatomic)  UITableView* tableView;
@property (strong, nonatomic)  UIView* mainView;

@end

@implementation ModalViewController


- (id)initFrame:(CGRect)frame WithType:(ModalControllerType)type
{
    self = [super init];//WithStyle:UITableViewStylePlain
    if (self) {
        // Custom initialization
        mainWindow = frame;
        popUpType = type;
        maxNameCharacters = 25;
        maxDescCharacters = 250;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = mainWindow;
    self.view.backgroundColor = [UIColor clearColor];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    CGRect tableRect = CGRectMake(0, 0, mainWindow.size.width, mainWindow.size.height);
    
    _mainView = [[UIView alloc] initWithFrame:tableRect];
    _tableView = [[UITableView alloc] initWithFrame:mainWindow style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self createTitleLabel];
    [self createExitButton];
    [self createNameLabel];
    [self createNameInputField];
    if (popUpType != MODALREADONLYWISH)
    {
        [self createCounterLabel];
    }
    
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALMODIFYWISHLIST)
    {
        [self createDateLabel];
        [self createDatePicker];
        [self createErrorLabel];
    }
    else
    {
        [self createDescriptionLabel];
        [self createDescriptionView];
        if (popUpType != MODALREADONLYWISH)
        {
            [self createDescCounterLabel];
        }
        [self createLevelChooserLabel];
        [self createLevelChooser];
        if (popUpType !=MODALREADONLYWISH)
        {
            [self createUrlLabel];
        }
        [self createUrlInputField];
    }
    
    if (!(popUpType == MODALREADONLYWISH && _wish.checked == YES))
    {
        [self createOkButton];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.view addSubview:_tableView];
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
    return mainWindow.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

-(void)createTitleLabel
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, mainWindow.size.width, 40)];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];
    bgLayer.frame = CGRectMake(0, 0, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    [_titleLabel.layer insertSublayer:bgLayer atIndex:0];
    
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, 30, mainWindow.size.width, 40)];
    [background.layer insertSublayer:bgLayer atIndex:0];
    
    if (popUpType == MODALCREATEWISHLIST)
    {
        _titleLabel.text = @"Create new Wish List";
    }
    else if (popUpType == MODALMODIFYWISHLIST)
    {
        _titleLabel.text = @"Modify Wish List";
        
    }
    else if (popUpType == MODALCREATEWISH)
    {
        _titleLabel.text = @"Create new Wish";
    }
    else if (popUpType == MODALMODIFYWISH)
    {
        _titleLabel.text = @"Modify Wish";
    }
    else if (popUpType == MODALREADONLYWISH)
    {
        _titleLabel.text = @"Description of the Wish";
    }
    
    _titleLabel.lineBreakMode = 0;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setFont:[UIFont systemFontOfSize:22]];
    
    _titleLabel.textColor = [UIColor whiteColor];
  
    [_mainView addSubview:_titleLabel];
}

-(void)createExitButton
{
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(mainWindow.size.width - 35, _titleLabel.center.y - 20, 25, 25);
    [_cancelButton addTarget:self action:@selector(hidePopUp) forControlEvents:UIControlEventTouchUpInside];
    //[_cancelButton setTitle:@"X" forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel1.png"] forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageNamed:@"cancel2.png"] forState:UIControlStateHighlighted];
    
    [_mainView addSubview:_cancelButton];
}

-(void)createNameLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 65, mainWindow.size.width - offset, 40)];
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALMODIFYWISHLIST)
    {
        _nameLabel.text = @"Wish List Name:";
    }
    else
    {
        _nameLabel.text = @"Wish Name:";
    }
    _nameLabel.lineBreakMode = 0;
    _nameLabel.numberOfLines = 0;
    _nameLabel.textColor = [UIColor whiteColor];
    [_nameLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_mainView addSubview:_nameLabel];
}

-(void)createNameInputField
{
    CGFloat offset = mainWindow.size.width / 18;
    _nameField = [[CustomTextField alloc] initWithFrame:CGRectMake(offset, 95, mainWindow.size.width - offset * 2, 30)];
    
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALMODIFYWISHLIST)
    {
        _nameField.placeholder = @"enter the name of the wish list";
    }
    else
    {
        _nameField.placeholder = @"enter the name of the wish";
    }
    _nameField.autocorrectionType = UITextAutocorrectionTypeNo;
    _nameField.keyboardType = UIKeyboardTypeDefault;
    _nameField.returnKeyType = UIReturnKeyDone;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameField.backgroundColor = [UIColor lightTextColor];
    _nameField.delegate = self;
    [_nameField addTarget:self action:@selector(nameTextChanged) forControlEvents:UIControlEventEditingChanged];
    
    if (popUpType == MODALMODIFYWISHLIST)
    {
        _nameField.text = _wishList.name;
    }
    else if (popUpType == MODALMODIFYWISH || popUpType == MODALREADONLYWISH)
    {
        _nameField.text = _wish.name;
    }
    
    if (popUpType == MODALREADONLYWISH)
    {
        _nameField.enabled = NO;
    }
    
    [_mainView addSubview:_nameField];
}

-(void)createCounterLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _nameCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 120, mainWindow.size.width - offset * 2, 20)];
    _nameCounterLabel.lineBreakMode = 0;
    _nameCounterLabel.numberOfLines = 0;
    _nameCounterLabel.textColor = [UIColor whiteColor];
    [_nameCounterLabel setFont:[UIFont systemFontOfSize:12]];
    
    if (popUpType == MODALMODIFYWISH || popUpType == MODALMODIFYWISHLIST)
    {
        int typedCharacters = [_nameField.text length];
        _nameCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxNameCharacters - typedCharacters];
    }
    else
    {
        _nameCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxNameCharacters];
    }
    
    [_mainView addSubview:_nameCounterLabel];
}

-(void)createDateLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 135, mainWindow.size.width - offset, 40)];
    _dateLabel.text = @"Date of the event:";
    _dateLabel.lineBreakMode = 0;
    _dateLabel.numberOfLines = 0;
    _dateLabel.textColor = [UIColor whiteColor];
    [_dateLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_mainView addSubview:_dateLabel];
}

-(void)createDescriptionLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 135, mainWindow.size.width - offset, 40)];
    _descriptionLabel.text = @"Description:";
    _descriptionLabel.lineBreakMode = 0;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.textColor = [UIColor whiteColor];
    [_descriptionLabel setFont:[UIFont systemFontOfSize:18]];


    [_mainView addSubview:_descriptionLabel];
}

-(void)createDatePicker
{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 165, 0, 0)];
    [_datePicker addTarget:self action:@selector(validateDate) forControlEvents:UIControlEventValueChanged];
    //_datePicker.layer.borderWidth = 1;
    //_datePicker.layer.borderColor = [[UIColor whiteColor] CGColor];
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    
    if (popUpType == MODALMODIFYWISHLIST)
    {
        NSDate* dateFromString = [DateManipulator formatStringToDate:_wishList.eventDate];
        [_datePicker setDate:dateFromString];
    }
    
    [_mainView addSubview:_datePicker];
}

-(void)createDescriptionView
{
    CGFloat offset = mainWindow.size.width / 18;
    _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(offset, 170, mainWindow.size.width - offset * 2, 110)];
    
    _descriptionView.autocorrectionType = UITextAutocorrectionTypeNo;
    _descriptionView.keyboardType = UIKeyboardTypeDefault;
    _descriptionView.returnKeyType = UIReturnKeyDefault;
    _descriptionView.backgroundColor = [UIColor lightTextColor];
    _descriptionView.font = [UIFont systemFontOfSize:18];
    _descriptionView.delegate = self;
    
    
    _textViewPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _descriptionView.frame.size.width - 5, 30)];
    _textViewPlaceHolder.text = @"Touch here to add description";
    _textViewPlaceHolder.textColor = [UIColor lightTextColor];
    
    [_descriptionView addSubview:_textViewPlaceHolder];
    
    if (popUpType == MODALMODIFYWISH || popUpType == MODALREADONLYWISH)
    {
        _descriptionView.text = _wish.description;
        if ([_descriptionView.text length] > 0 || popUpType == MODALREADONLYWISH)
        {
            _textViewPlaceHolder.hidden = YES;
        }
    }
    
    if (popUpType == MODALREADONLYWISH)
    {
        _descriptionView.editable = NO;
    }
    
    [_mainView addSubview:_descriptionView];
}

-(void)createDescCounterLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _descCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 280, mainWindow.size.width - offset * 2, 20)];
    _descCounterLabel.lineBreakMode = 0;
    _descCounterLabel.numberOfLines = 0;
    _descCounterLabel.textColor = [UIColor whiteColor];
    [_descCounterLabel setFont:[UIFont systemFontOfSize:12]];
    
    if (popUpType == MODALMODIFYWISH)
    {
        int typedCharacters = [_descriptionView.text length];
        _descCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxDescCharacters - typedCharacters];

    }
    else
    {
        _descCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxDescCharacters];
    }
    
    [_mainView addSubview:_descCounterLabel];
}

-(void)createErrorLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 360, mainWindow.size.width - offset * 2, 80)];
    _errorLabel.text = @"Date of the event:";
    _errorLabel.lineBreakMode = 0;
    _errorLabel.numberOfLines = 0;
    _errorLabel.textColor = [UIColor whiteColor];
    _errorLabel.textAlignment = NSTextAlignmentCenter;
    _errorLabel.hidden = YES;
    
    [_mainView addSubview:_errorLabel];
}

-(void)createLevelChooserLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _levelChooserLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 295, mainWindow.size.width - offset, 40)];
    _levelChooserLabel.text = @"Importance of the Wish:";
    _levelChooserLabel.lineBreakMode = 0;
    _levelChooserLabel.numberOfLines = 0;
    _levelChooserLabel.textColor = [UIColor whiteColor];
    [_levelChooserLabel setFont:[UIFont systemFontOfSize:18]];
    
    
    [_mainView addSubview:_levelChooserLabel];
}

-(void)createLevelChooser
{
    CGFloat offset = mainWindow.size.width / 18;
    NSArray* levels = [NSArray arrayWithObjects:@"Low", @"Medium", @"High", nil];
    _levelChooser = [[UISegmentedControl alloc] initWithItems:levels];
    _levelChooser.frame = CGRectMake(offset, 335, mainWindow.size.width - offset * 2, 30);
    _levelChooser.tintColor = [UIColor whiteColor];
    
    if (popUpType == MODALMODIFYWISH || popUpType == MODALREADONLYWISH)
    {
        _levelChooser.selectedSegmentIndex = [_wish.level intValue];
    }
    else
    {
        _levelChooser.selectedSegmentIndex = 1;
    }
    
    if (popUpType == MODALREADONLYWISH)
    {
        _levelChooser.enabled = NO;
    }
    
    [_mainView addSubview:_levelChooser];
}

-(void)createUrlLabel
{
    CGFloat offset = mainWindow.size.width / 18;
    _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset, 365, mainWindow.size.width - offset, 40)];
    _urlLabel.text = @"Link of the Wish";
    _urlLabel.lineBreakMode = 0;
    _urlLabel.numberOfLines = 0;
    _urlLabel.textColor = [UIColor whiteColor];
    [_urlLabel setFont:[UIFont systemFontOfSize:18]];
    
    [_mainView addSubview:_urlLabel];
}

-(void)createUrlInputField
{
    CGFloat offset = mainWindow.size.width / 18;
    if (popUpType == MODALREADONLYWISH)
    {
        _readOnlyUrlView = [[UITextView alloc] initWithFrame:CGRectMake(offset, 370, mainWindow.size.width - offset * 2, 45)];
        _readOnlyUrlView.text = @"Press here to open link of the Wish";
        _readOnlyUrlView.editable = NO;
        _readOnlyUrlView.dataDetectorTypes = UIDataDetectorTypeAll;
        _readOnlyUrlView.backgroundColor = [UIColor clearColor];
        _readOnlyUrlView.textColor = [UIColor blueColor];
        _readOnlyUrlView.font = [UIFont systemFontOfSize:16];
        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openGiftUrl:)];
        _readOnlyUrlView.userInteractionEnabled = YES;
        [_readOnlyUrlView addGestureRecognizer:gesture];
        [_mainView addSubview:_readOnlyUrlView];

        return;
    }
    
    _urlField = [[CustomTextField alloc] initWithFrame:CGRectMake(offset, 395, mainWindow.size.width - offset * 2, 30)];
    
    _urlField.autocorrectionType = UITextAutocorrectionTypeNo;
    _urlField.keyboardType = UIKeyboardTypeDefault;
    _urlField.returnKeyType = UIReturnKeyDone;
    _urlField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _urlField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _urlField.delegate = self;
    _urlField.backgroundColor = [UIColor lightTextColor];

    [_urlField addTarget:self action:nil forControlEvents:UIControlEventEditingChanged];
    
    if (popUpType == MODALMODIFYWISH || popUpType == MODALREADONLYWISH)
    {
        _urlField.text = _wish.url;
    }
    
    _urlField.placeholder = @"enter the link of the wish";
    
    [_mainView addSubview:_urlField];
}

-(void)createOkButton
{
    _okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _okButton.frame = CGRectMake(0, 425, mainWindow.size.width, 40);
    [_okButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [_okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALCREATEWISH)
    {
        [_okButton addTarget:self action:@selector(validateInputAndSendInputToDelegate) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitle:@"CREATE" forState:UIControlStateNormal];
    }
    else if (popUpType == MODALMODIFYWISHLIST || popUpType == MODALMODIFYWISH)
    {
        [_okButton addTarget:self action:@selector(validateInputAndSendInputToDelegate) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitle:@"MODIFY" forState:UIControlStateNormal];
    }
    else if (popUpType == MODALREADONLYWISH)
    {
        [_okButton addTarget:self action:@selector(iBoughtItPressed) forControlEvents:UIControlEventTouchUpInside];
        [_okButton setTitle:@"I bought it!" forState:UIControlStateNormal];
    }
    
//    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlueGradient];
//    bgLayer.frame = CGRectMake(0, 0, _okButton.frame.size.width, _okButton.frame.size.height);
//    [_titleLabel.layer insertSublayer:bgLayer atIndex:0];
//    
//    UIView* background = [[UIView alloc] initWithFrame:_okButton.frame];
//    [background.layer insertSublayer:bgLayer atIndex:0];
    
    [_mainView addSubview:_okButton];
}

-(void)openGiftUrl:(UIGestureRecognizer*)gesture
{
    NSRange textRange = [[_wish.url lowercaseString] rangeOfString:@"http://"];
    NSString* url;
    if (textRange.location == NSNotFound)
    {
        url = [NSString stringWithFormat:@"http://%@", _wish.url];
    }
    else
    {
        url = _wish.url;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)iBoughtItPressed
{
    ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Mark Confirmation" message:@"Are you sure to mark this Wish as bought?" cancelButtonTitle:@"NO" otherButtonTitles:@"YES"];
    dialog.invoker = self;
    dialog.type = CBOUGHT;
    
    [dialog show];
}

//ConfirmationDialogDelegate
-(void)boughtConfirmed
{
    [self.delegate wishChecked:_wish];
    [self hidePopUp];
}

-(void)hidePopUp
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nameTextChanged
{
    [self setNameTextFieldToDefault];
    
    int typedCharacters = [_nameField.text length];
    
    if (maxNameCharacters - typedCharacters >= 0)
    {
        _nameCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxNameCharacters - typedCharacters];
    }
    else
    {
        _nameField.text = [_nameField.text substringToIndex:maxNameCharacters];
    }
}

-(void)setNameTextFieldToDefault
{
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALMODIFYWISHLIST)
    {
        _nameField.placeholder = @"enter the name of the wish list";
    }
    else
    {
        _nameField.placeholder = @"enter the name of the wish";
    }
}

-(void)validateInputAndSendInputToDelegate
{
    
    if ([_nameField.text isEqualToString:@""])
    {
        _nameField.layer.borderColor = [[UIColor redColor] CGColor ];
        _nameField.placeholder = @"Please enter a name!";
        
        return;
    }
    
    NSString* dateString = @"";
    
    if (popUpType == MODALCREATEWISHLIST || popUpType == MODALMODIFYWISHLIST)
    {
        if (![self validateDate])
        {
            NSLog(@"ERROR DATE IS IN THE PAST");
            return;
        }
    
        NSDate* pickerDate = [_datePicker date];
        dateString = [DateManipulator formatDateToString:pickerDate];
        NSLog(@"dateString = %@",dateString);
    }
    
    if (popUpType == MODALCREATEWISHLIST)
    {
        WishList* wishList = [[WishList alloc] init];
        wishList.name = _nameField.text;
        wishList.eventDate = dateString;
        [self.delegate wishListAdded:wishList];
    }
    else if (popUpType == MODALMODIFYWISHLIST)
    {
        WishList* wishList = [[WishList alloc] init];
        wishList.name = _nameField.text;
        wishList.eventDate = dateString;
        wishList.wishListId = _wishList.wishListId;
        [self.delegate wishListModified:wishList];
    }
    else if (popUpType == MODALCREATEWISH)
    {
        Wish* wish = [[Wish alloc] init];
        wish.wishListId = _wishList.wishListId;
        wish.name = _nameField.text;
        wish.description = _descriptionView.text;
        wish.url = _urlField.text;
        wish.level = [NSString stringWithFormat:@"%d", [_levelChooser selectedSegmentIndex]];
        [self.delegate wishAdded:wish];
    }
    else if (popUpType == MODALMODIFYWISH)
    {
        Wish* wish = [[Wish alloc] init];
        wish.wishId = _wish.wishId;
        wish.name = _nameField.text;
        wish.description = _descriptionView.text;
        wish.url = _urlField.text;
        wish.level = [NSString stringWithFormat:@"%d", [_levelChooser selectedSegmentIndex]];
        wish.wishListId = _wish.wishListId;
        [self.delegate wishModified:wish];
    }
    [self hidePopUp];
}

-(BOOL)validateDate
{
    NSDate* pickerDate = [_datePicker date];
    NSDate* currentDate = [NSDate date];
    
    BOOL ret = YES;
    
    if ([currentDate compare:pickerDate] == NSOrderedDescending)
    {
        _errorLabel.hidden = NO;
        _errorLabel.text = @"Event date is in the past or the same as current date!";
        ret = NO;
    }
    else
    {
        _errorLabel.hidden = YES;
    }
    return ret;
}

-(void)hideOrDisplayTextViewPlaceHolder
{
    if (_descriptionView.text.length > 0)
    {
        _textViewPlaceHolder.hidden = YES;
    }
    else
    {
        _textViewPlaceHolder.hidden = NO;
    }
}

//DELEGATES

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _descriptionView.backgroundColor = [UIColor colorWithRed:(179/255.0) green:1.0 blue:1.0 alpha:0.7];
    _textViewPlaceHolder.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    _descriptionView.backgroundColor = [UIColor lightTextColor];
    [self hideOrDisplayTextViewPlaceHolder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    int typedCharacters = [_descriptionView.text length];
    
    if (maxDescCharacters - typedCharacters >= 0)
    {
        _descCounterLabel.text = [NSString stringWithFormat:@"%d characters remain", maxDescCharacters - typedCharacters];
    }
    else
    {
        _descriptionView.text = [_descriptionView.text substringToIndex:maxNameCharacters];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
    NSLog(@"color: %@", self.view.backgroundColor);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //CGRect textFieldRect = [textField frame];
    //[self.tableView scrollRectToVisible:textFieldRect animated:YES];
    NSLog(@"textFieldDidBeginEditing");
}

- (void)keyboardWillShow:(NSNotification *)sender {
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat height = UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]) ? kbSize.height : kbSize.width;
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = height;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = height;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}

- (void)keyboardWillHide:(NSNotification *)sender {
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets edgeInsets = [[self tableView] contentInset];
        edgeInsets.bottom = 0;
        [[self tableView] setContentInset:edgeInsets];
        edgeInsets = [[self tableView] scrollIndicatorInsets];
        edgeInsets.bottom = 0;
        [[self tableView] setScrollIndicatorInsets:edgeInsets];
    }];
}



@end
