//
//  MPSignalHandler.m
//  MPCrashReporter
//
//  Created by macRong on 2017/12/4.
//  Copyright © 2017年 MPCrashReporter. All rights reserved.
//

#import "MPSignalHandler.h"
#include <execinfo.h>

@implementation MPSignalHandler


void mp_SignalHandler(int signal)
{
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    
    for (i = 0; i <frames; ++i)
    {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    
    NSLog(@"single = %d, mstr=%@",signal,mstr);
    
    //    [SignalHandler saveCreash:mstr];
}

void Install_MP_SignalHandlerHandler(void)
{
    signal(SIGHUP, mp_SignalHandler);
    signal(SIGINT, mp_SignalHandler);
    signal(SIGQUIT, mp_SignalHandler);
    
    signal(SIGABRT, mp_SignalHandler);
    signal(SIGILL, mp_SignalHandler);
    signal(SIGSEGV, mp_SignalHandler);
    signal(SIGFPE, mp_SignalHandler);
    signal(SIGBUS, mp_SignalHandler);
    signal(SIGPIPE, mp_SignalHandler);
}

@end
