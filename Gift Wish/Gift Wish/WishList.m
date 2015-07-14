//
//  WishList.m
//  Gift Wish
//
//  Created by neyma on 15/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "WishList.h"

@implementation WishList

-(id)initWithWishList:(WishList*)wishList
{
    self = [super init];
    if (self) {
        _wishListId = wishList.wishListId;
        _name = wishList.name;
        _eventDate = wishList.eventDate;
        _lastUpdate = wishList.lastUpdate;
        
    }
    return self;
}

@end
