//
//  Wish.h
//  Gift Wish
//
//  Created by neyma on 23/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Wish : NSObject

@property (nonatomic, strong) NSString* wishId;
@property (nonatomic, strong) NSString* wishListId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* description;
@property (nonatomic) BOOL checked;
@property (nonatomic, strong) NSString* checkDate;
@property (nonatomic, strong) NSString* level;
@property (nonatomic, strong) NSString* url;

-(id)initWithWish:(Wish*)wish;

@end
