//
//  DateManipulator.m
//  Gift Wish
//
//  Created by neyma on 20/04/14.
//  Copyright (c) 2014 neyma. All rights reserved.
//

#import "DateManipulator.h"

@implementation DateManipulator

+(NSString*)formatDateToString:(NSDate*)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    return [dateFormatter stringFromDate:date];
}
+(NSDate*)formatStringToDate:(NSString*)str
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    return [dateFormatter dateFromString:str];
}

@end
