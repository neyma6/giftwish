//
//  ConfirmationDialog.h
//  Gift Wish
//
//  Created by neyma on 02/05/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConfirmationDialogType) {
    CWISHLIST=0,
    CWISH,
    CBOUGHT,
    CPOST
};

@protocol ConfirmationDialogDelegate <NSObject>

@optional
-(void)wishListDeleteConfirmed;
-(void)wishDeleteConfirmed;
-(void)boughtConfirmed;

-(void)postGranted;
-(void)postDenied;

@end

@interface ConfirmationDialog : UIAlertView

@property (nonatomic) ConfirmationDialogType type;
@property (nonatomic) id<ConfirmationDialogDelegate> invoker;

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;

@end
