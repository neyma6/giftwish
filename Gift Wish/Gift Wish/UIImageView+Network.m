//
//  UIImageView+Network.m
//  Gift Wish
//
//  Created by neyma on 13/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "UIImageView+Network.h"
#import "FTWCache.h"
#import <objc/runtime.h>


static char URL_KEY;


@implementation UIImageView(Network)

@dynamic imageURL;

- (void) loadImageFromURL:(NSURL*)url placeholderImage:(UIImage*)placeholder cachingKey:(NSString*)key {
	self.imageURL = url;
	self.image = placeholder;
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
	dispatch_async(queue, ^{
		NSData *data = [NSData dataWithContentsOfURL:url];
        
		UIImage *imageFromData = [UIImage imageWithData:data];
        
		[FTWCache setObject:UIImagePNGRepresentation(imageFromData) forKey:key];
		UIImage *imageToSet = imageFromData;
		if (imageToSet) {
			if ([self.imageURL.absoluteString isEqualToString:url.absoluteString]) {
				dispatch_async(dispatch_get_main_queue(), ^{
					self.image = imageFromData;
				});
			}
		}
		self.imageURL = nil;
	});
}

- (void) setImageURL:(NSURL *)newImageURL {
	objc_setAssociatedObject(self, &URL_KEY, newImageURL, OBJC_ASSOCIATION_COPY);
}

- (NSURL*) imageURL {
	return objc_getAssociatedObject(self, &URL_KEY);
}


@end
