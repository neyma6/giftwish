//
//  WishListCell.m
//  Gift Wish
//
//  Created by neyma on 18/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "WishListCell.h"
#import "BackGroundLayer.h"
#import "UIImage+Resize.h"

@interface WishListCell()
{
    BOOL isEditing;
}
@property (strong, nonatomic) UIButton* deleteButton;
@property (strong, nonatomic) UIButton* modifyButton;
@property (strong, nonatomic) UIView* controllerView;
@end

@implementation WishListCell


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier OwnWishList:(BOOL)ownWishList WithControllerType:(int)type
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        if (ownWishList)
        {
            [self createDeleteButton:type];
            if (type == 0)
            {
                [self createModifyButton];
            }
        }
        else
        {
            [self createCheckedIcon];
        }
        
        [self createControllerView];
        
        [self createImage];
        
        [self createObjectName];
        
        self.frame = CGRectMake(0, 0, self.frame.size.width - 20, self.frame.size.height);
        
        self.backgroundColor = [UIColor clearColor];
        
        CAGradientLayer *bgLayer = [BackgroundLayer ios7BlackGradient];
        bgLayer.frame = self.bounds;
        bgLayer.opacity = 0.3;
        //[self.layer insertSublayer:bgLayer atIndex:0];

        
        [self setBackgroundView:[[UIView alloc] init]];
        [self.backgroundView.layer insertSublayer:bgLayer atIndex:0];
        
        isEditing = NO;

    }
    return self;
}

-(void)createDeleteButton:(int)type
{
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_deleteButton.frame = CGRectMake(self.frame.size.width - 55, self.center.y - 13, 25, 25);
    _deleteButton.frame = CGRectMake(38, self.frame.size.height / 2 - 12.5, 25, 25);
    if (type == 0)
    {
        [_deleteButton addTarget:self action:@selector(deleteWishList) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [_deleteButton addTarget:self action:@selector(deleteWish) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIImage* buttonPressed = [UIImage imageNamed:@"delete2.png"];
    buttonPressed = [buttonPressed imageByApplyingAlpha:0.5];
    
    [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete2.png"] forState:UIControlStateNormal];
    [_deleteButton setBackgroundImage:buttonPressed forState:UIControlStateHighlighted];
    
    
    //[self addSubview:_deleteButton];

}

-(void)createModifyButton
{
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //_modifyButton.frame = CGRectMake(self.frame.size.width - 90, self.center.y - 13, 25, 25);
    _modifyButton.frame = CGRectMake(7, self.frame.size.height / 2 - 12.5, 25, 25);
    [_modifyButton addTarget:self action:@selector(modifyWishList) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* buttonPressed = [UIImage imageNamed:@"config4.png"];
    buttonPressed = [buttonPressed imageByApplyingAlpha:0.5];
    
    [_modifyButton setBackgroundImage:[UIImage imageNamed:@"config4.png"] forState:UIControlStateNormal];
    [_modifyButton setBackgroundImage:buttonPressed forState:UIControlStateHighlighted];
    
    //[self addSubview:_modifyButton];
}

-(void)createControllerView
{
    _controllerView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0, 70, self.frame.size.height)];
    [_controllerView addSubview:_modifyButton];
    [_controllerView addSubview:_deleteButton];
    _controllerView.backgroundColor = [UIColor orangeColor];
    
    CAGradientLayer *bgLayer = [BackgroundLayer ios7BlackGradient];//ios7MildBlueGradient ios7YellowBlueGradient ios7BlackGradient
    bgLayer.frame = _controllerView.bounds;
    bgLayer.opacity = 0.6;
    [_controllerView.layer insertSublayer:bgLayer atIndex:0];
    _controllerView.backgroundColor = [UIColor clearColor];

    
    [self addSubview:_controllerView];
}

-(void)createImage
{
    _image = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.center.y - 15, 30, 30)];
    _image.image = [UIImage imageNamed:@"easy.png"];
    
    [self addSubview:_image];
}

-(void)createCheckedIcon
{
    _checkedImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 60, self.center.y - 15, 30, 30)];
    _checkedImage.image = [UIImage imageNamed:@"icon_check2.png"];
    _checkedImage.hidden = YES;
    
    [self addSubview:_checkedImage];
}

-(void)createObjectName
{
    _objectName = [[UILabel alloc] initWithFrame:CGRectMake(50, self.center.y - 15, self.frame.size.width - 70, 30)];
    _objectName.textColor = [UIColor whiteColor];//[UIColor colorWithRed:0.0f green:0.0f blue:(255.0/255.0) alpha:1];
    [_objectName setFont:[UIFont systemFontOfSize:18]];

    [self addSubview:_objectName];
}

-(void)deleteWishList
{
    ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Delete Confirmation" message:@"Are you sure to delete Wish List?" cancelButtonTitle:@"NO" otherButtonTitles:@"YES"];
    dialog.invoker = self;
    dialog.type = CWISHLIST;
    
    [dialog show];
}

-(void)deleteWish
{
    ConfirmationDialog* dialog = [[ConfirmationDialog alloc] initWithTitle:@"Delete Confirmation" message:@"Are you sure to delete Wish?" cancelButtonTitle:@"NO" otherButtonTitles:@"YES"];
    dialog.invoker = self;
    dialog.type = CWISH;
    
    [dialog show];
}

//ConfirmationDialog delegate
-(void)wishListDeleteConfirmed
{
    [self.delegate deleteWishList:_objectId];
}

//ConfirmationDialog delegate
-(void)wishDeleteConfirmed
{
    [self.delegate deleteWish:_objectId];
}

-(void)modifyWishList
{
    [self.delegate modifyWishList:_objectId];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if (state & UITableViewCellStateShowingEditControlMask && !isEditing)
    {
        isEditing = YES;
        [UIView setAnimationsEnabled:YES];
        [self animateIncomeControlPanel];
    }
}

-(void)didTransitionToState:(UITableViewCellStateMask)state
{

    if (!(state & UITableViewCellStateShowingEditControlMask) && isEditing)
    {
        isEditing = NO;
        [UIView setAnimationsEnabled:YES];
        [self animateOutcomeControlPanel];
    }
}

-(void)animateIncomeControlPanel
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setToEditingStateWithOffset:90];
    }];
}

-(void)animateOutcomeControlPanel
{
    [UIView animateWithDuration:0.3 animations:^{
        
        _controllerView.frame = CGRectMake(self.frame.size.width, _controllerView.frame.origin.y, _controllerView.frame.size.width, _controllerView.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _objectName.frame = CGRectMake(_objectName.frame.origin.x, _objectName.frame.origin.y, self.frame.size.width - _objectName.frame.origin.x - 20, _objectName.frame.size.height);
        }
    }];
}

-(BOOL)isEditing
{
    return isEditing;
}

-(void)setToDefaultState
{
    isEditing = NO;
    _controllerView.frame = CGRectMake(self.frame.size.width + 20, _controllerView.frame.origin.y, _controllerView.frame.size.width, _controllerView.frame.size.height);
    _objectName.frame = CGRectMake(_objectName.frame.origin.x, _objectName.frame.origin.y, self.frame.size.width - _objectName.frame.origin.x - 20, _objectName.frame.size.height);
}

-(void)setToEditingStateWithOffset:(CGFloat)offset
{
    isEditing = YES;
    _objectName.frame = CGRectMake(_objectName.frame.origin.x, _objectName.frame.origin.y, self.frame.size.width - _objectName.frame.origin.x - 90, _objectName.frame.size.height);
    _controllerView.frame = CGRectMake(self.frame.size.width - offset, _controllerView.frame.origin.y, _controllerView.frame.size.width, _controllerView.frame.size.height);
}

@end
