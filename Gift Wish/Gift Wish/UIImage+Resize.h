//
//  UIImage+Resize.h
//  Gift Wish
//
//  Created by neyma on 14/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
@end
