//
//  WishListCell.h
//  Gift Wish
//
//  Created by neyma on 18/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfirmationDialog.h"

@protocol WishListCellDelegate <NSObject>

-(void)deleteWishList:(NSString*)wishListId;
-(void)modifyWishList:(NSString*)wishListId;

-(void)deleteWish:(NSString*)wishId;

@end

@interface WishListCell : UITableViewCell <ConfirmationDialogDelegate>

@property (nonatomic) id<WishListCellDelegate> delegate;
@property (nonatomic, strong) NSString* objectId;
@property (strong, nonatomic) UILabel* objectName;
@property (strong, nonatomic) UIImageView* image;
@property (strong, nonatomic) UIImageView* checkedImage;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier OwnWishList:(BOOL)ownWishList WithControllerType:(int)type;

-(BOOL)isEditing;
-(void)setToDefaultState;
-(void)setToEditingStateWithOffset:(CGFloat)offset;

@end
