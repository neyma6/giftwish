//
//  Wish.m
//  Gift Wish
//
//  Created by neyma on 23/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "Wish.h"

@implementation Wish


-(id)initWithWish:(Wish*)wish
{
    self = [super init];
    if (self) {
        _wishId = wish.wishId;
        _wishListId = wish.wishListId;
        _name = wish.name;
        _description = wish.description;
        _checked = wish.checked;
        _checkDate = wish.checkDate;
        _level = wish.level;
        _url = wish.url;
    }
    return self;
}

@end
