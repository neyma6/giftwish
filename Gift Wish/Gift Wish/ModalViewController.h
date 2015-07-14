//
//  ModalViewController.h
//  Gift Wish
//
//  Created by neyma on 20/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wish.h"
#import "WishList.h"
#import "ConfirmationDialog.h"

typedef NS_ENUM(NSInteger, ModalControllerType) {
    MODALCREATEWISHLIST,
    MODALMODIFYWISHLIST,
    MODALCREATEWISH,
    MODALMODIFYWISH,
    MODALREADONLYWISH
};


@protocol ModalViewControllerDelegate <NSObject>

-(void)wishListAdded:(WishList*)wishList;
-(void)wishListModified:(WishList*)wishList;
-(void)wishAdded:(Wish*)wish;
-(void)wishModified:(Wish*)wish;
-(void)wishChecked:(Wish*)wish;

@end

@interface ModalViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UITableViewDataSource, UITableViewDelegate, ConfirmationDialogDelegate>

@property (strong, nonatomic) Wish* wish;
@property (strong, nonatomic) WishList* wishList;

@property (nonatomic) id<ModalViewControllerDelegate> delegate;


- (id)initFrame:(CGRect)frame WithType:(ModalControllerType)type;

@end
