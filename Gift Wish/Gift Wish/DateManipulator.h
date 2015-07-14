//
//  DateManipulator.h
//  Gift Wish
//
//  Created by neyma on 20/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateManipulator : NSObject

+(NSString*)formatDateToString:(NSDate*)date;
+(NSDate*)formatStringToDate:(NSString*)str;

@end
