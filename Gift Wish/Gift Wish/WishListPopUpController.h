//
//  WishListPopUpController.h
//  Gift Wish
//
//  Created by neyma on 18/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIView+Helper.h"

typedef NS_ENUM(NSInteger, WishListPopUpControllerType) {
    CREATE,
    MODIFY
};

@protocol WishListPopUpControllerDelegate <NSObject>

-(void)wishListAdded:(NSString*)name WithDate:(NSString*)date;
-(void)wishListModified:(NSString*)wishListId WithName:(NSString*)name WithDate:(NSString*)date;
-(void)popCanceled;

@end

@interface WishListPopUpController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField* nameField;
@property (strong, nonatomic) NSString* wishListId;
@property (strong, nonatomic) UIDatePicker* datePicker;

- (id)initFrame:(CGRect)frame WithType:(WishListPopUpControllerType)type;

@property (nonatomic) id<WishListPopUpControllerDelegate> delegate;

@end
