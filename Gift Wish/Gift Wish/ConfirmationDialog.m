//
//  ConfirmationDialog.m
//  Gift Wish
//
//  Created by neyma on 02/05/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "ConfirmationDialog.h"

@implementation ConfirmationDialog

- (id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (_type == CWISH)
        {
            [self.invoker wishDeleteConfirmed];
        }
        else if (_type == CWISHLIST)
        {
            [self.invoker wishListDeleteConfirmed];
        }
        else if (_type == CBOUGHT)
        {
            [self.invoker boughtConfirmed];
        }
        else if (_type == CPOST)
        {
            [self.invoker postGranted];
        }
    }
    else if (buttonIndex == 0)
    {
        if (_type == CPOST)
        {
            [self.invoker postDenied];
        }
    }
}

@end
