//
//  AppDelegate.h
//  Gift Wish
//
//  Created by neyma on 08/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *loginUIViewController;

-(void)setNewRootViewController:(RootViewController*)view;

@end
