//
//  BannerProtocol.h
//  Gift Wish
//
//  Created by neyma on 10/06/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@protocol BannerProtocol <NSObject>

-(void)showBanner:(ADBannerView*)bannerview;
-(void)hideBanner:(ADBannerView*)bannerview;

@end
