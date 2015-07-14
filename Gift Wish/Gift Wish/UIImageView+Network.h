//
//  UIImageView+Network.h
//  Gift Wish
//
//  Created by neyma on 13/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Network)

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key;

@property (strong, nonatomic) NSURL* imageURL;

@end