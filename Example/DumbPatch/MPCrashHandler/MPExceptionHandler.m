//
//  MPExceptionHandler.m
//  DumbPatch_Example
//
//  Created by macRong on 2017/11/30.
//  Copyright © 2017年 MPCrashHandler. All rights reserved.
//

#import "MPExceptionHandler.h"
#include <libkern/OSAtomic.h>
#import "MPCrashHandler-Header.h"


@implementation MPExceptionHandler

void Install_MP_UncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&mp_HandleException);
}

void mp_HandleException(NSException *exception)
{
    mpException_analysisException(exception);
    
    
    [[NSRunLoop currentRunLoop] run];
}


#pragma mark - private

void mpException_analysisException(NSException *exception)
{
    NSArray *callStack = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    
    NSString *content = [NSString stringWithFormat:@"\ncrashDate:%@\nname:%@\nreason:%@"
                         @"\ncallStackSymbols:\n%@",
                         mpException_getCurrentDate(), name, reason,
                         [callStack componentsJoinedByString:@"\n"]];
    
    NSLog(@"%@",content);
    
}


@end
