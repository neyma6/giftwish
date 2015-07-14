//
//  WishList.h
//  Gift Wish
//
//  Created by neyma on 15/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WishList : NSObject

@property (nonatomic, strong) NSString* wishListId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* lastUpdate;
@property (nonatomic, strong) NSString* eventDate;

-(id)initWithWishList:(WishList*)wishList;

@end
