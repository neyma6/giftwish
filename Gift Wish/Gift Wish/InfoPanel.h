//
//  InfoPanel.h
//  Gift Wish
//
//  Created by neyma on 19/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "WishList.h"

@interface InfoPanel : UIView

- (id)initWithFrame:(CGRect)frame WithFBProfilId:(NSDictionary<FBGraphUser>*)user WithWishList:(WishList*)wishList WithIsOwn:(BOOL)own;

@end
