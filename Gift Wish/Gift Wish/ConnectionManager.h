//
//  ConnectionManager.h
//  Gift Wish
//
//  Created by neyma on 12/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConnectionManagerDelegate <NSObject>

-(void)downloadCompilted:(NSMutableData*)data WithThisOrder:(NSString*)order;
-(void)errorDuringDownload:(NSError *)error;

@end

@interface ConnectionManager : NSObject <NSURLConnectionDelegate>

@property (nonatomic) id<ConnectionManagerDelegate> delegate;

-(void)requesWithUrl:(NSString*)url WithParameters:(NSDictionary*)parameters AndWithOrder:(NSString*)order;

@end
