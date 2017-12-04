//
//  MPCrashInfo.m
//  DumbPatch_Example
//
//  Created by macRong on 2017/11/30.
//  Copyright © 2017年 MPCrashHandler. All rights reserved.
//

#import "MPCrashInfo.h"

@implementation MPCrashInfo



@end

NSString *mpException_getCurrentDate()
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return dateString;
}
