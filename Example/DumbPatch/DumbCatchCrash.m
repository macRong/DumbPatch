//
//  DumbCatchCrash.m
//  DumbPatch_Example
//
//  Created by macRong on 2017/11/23.
//  Copyright © 2017年 rongtian. All rights reserved.
//

#import "DumbCatchCrash.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>

NSString *const UncaughtExceptionHandlerSignalExceptionName =@"UncaughtExceptionHandlerSignalExceptionName";

NSString *const UncaughtExceptionHandlerSignalKey =@"UncaughtExceptionHandlerSignalKey";

NSString *const UncaughtExceptionHandlerAddressesKey =@"UncaughtExceptionHandlerAddressesKey";


volatile int32_t UncaughtExceptionCount =0;

const int32_t UncaughtExceptionMaximum =10;


const NSInteger UncaughtExceptionHandlerSkipAddressCount =4;

const NSInteger UncaughtExceptionHandlerReportAddressCount =5;

@implementation DumbCatchCrash

+ (NSArray *)backtrace
{
    void* callstack[128];
    
    int frames =backtrace(callstack, 128);
    
    char **strs =backtrace_symbols(callstack, frames);
    
    int i;
    
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    
    for (i = UncaughtExceptionHandlerSkipAddressCount ; i <UncaughtExceptionHandlerSkipAddressCount +UncaughtExceptionHandlerReportAddressCount; i++){
        
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    
    free(strs);
    
    return backtrace;
}


- (void)alertView:(UIAlertView *)anAlertView clickedButtonAtIndex:(NSInteger)anIndex {
    
    if (anIndex ==0){
        
        dismissed =YES;
        
    }else if (anIndex==1) {
        
        NSLog(@"ssssssss");
        
    }
    
}


- (void)validateAndSaveCriticalApplicationData {
    
    NSLog(@"validateAndSaveCriticalApplicationData???????");
    
}

- (void)handleException:(NSException *)exception {

    NSLog(@"---runloop 完成----");

    /** 重新启动 runloop */
    [[NSRunLoop currentRunLoop]addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop]run];

    
    return;
    
    
    [self validateAndSaveCriticalApplicationData];
    
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"如果点击继续，程序有可能会出现其他的问题，建议您还是点击退出按钮并重新打开\n\n"@"异常原因如下:\n%@\n%@",nil),[exception reason],[[exception userInfo] objectForKey:UncaughtExceptionHandlerAddressesKey]];
    NSLog(@"+======= crash =%@",message);
  
    
    UIAlertView *alert =[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"抱歉，程序出现了异常",nil)
                         
                                                 message:message
                         
                                                delegate:self
                         
                                       cancelButtonTitle:NSLocalizedString(@"退出",nil)
                         
                                       otherButtonTitles:NSLocalizedString(@"继续",nil), nil];
    
    
    [alert show];
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes = CFRunLoopCopyAllModes(runLoop);
    
    while (!dismissed) {
        
        for (NSString *mode in (__bridge NSArray *)allModes) {
            
            CFRunLoopRunInMode((CFStringRef)mode,0.001, false);
            
        }
    }
    
    
    CFRelease(allModes);
    
    NSSetUncaughtExceptionHandler(NULL);
    
    signal(SIGABRT,SIG_DFL);
    
    signal(SIGILL,SIG_DFL);
    
    signal(SIGSEGV,SIG_DFL);
    
    signal(SIGFPE,SIG_DFL);
    
    signal(SIGBUS,SIG_DFL);
    
    signal(SIGPIPE,SIG_DFL);
    
    
    
    if ([[exception name] isEqual:UncaughtExceptionHandlerSignalExceptionName]) {
        
        kill(getpid(), [[[exception userInfo] objectForKey:UncaughtExceptionHandlerSignalKey]intValue]);
        
    }else{
        
        [exception raise];
    }
}


//+ (void)handelExtremely
//{
//    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
//}
//
//void UncaughtExceptionHandler(NSException *exception)
//{
//    /**
//     *  获取异常崩溃信息
//     */
//    NSArray *callStack = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//    NSDate *currentDate = [NSDate date]; //获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSString *content = [NSString
//                         stringWithFormat:@"崩溃时间:%@========\nname:%@\nreason:\n%@"
//                         @"\ncallStackSymbols:\n%@",
//                         dateString, name, reason,
//                         [callStack componentsJoinedByString:@"\n"]];
//    NSLog(@"[DumbCatchCrash getFilePathWithCaches]=%@,抓住了=%@ ",[DumbCatchCrash getFilePathWithCaches],content);
//
//    if (!content) {
//        return;
//    } else {
//        NSMutableArray *mary = [NSMutableArray
//                                arrayWithContentsOfFile:[[DumbCatchCrash getFilePathWithCaches]
//                                                         stringByAppendingString:@"Extremely"]];
//        if (!mary) {
//            mary = [NSMutableArray array];
//        }
//        [mary insertObject:content atIndex:0];
//     BOOL wirte = [mary writeToFile:[[DumbCatchCrash getFilePathWithCaches]
//                           stringByAppendingString:@"Extremely"]
//               atomically:YES];
//
////       BOOL wirte= [mary writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()] atomically:YES];
//        NSLog(@"写入 %d",wirte);
//    }
//}
//
//+ (NSString *)getFilePathWithCaches {
//    // Caches
//    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachePath = [cacPath objectAtIndex:0];
//    return cachePath;
//}



// ---------------

@end

void HandleException(NSException *exception) {
    
    int32_t exceptionCount =OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount >UncaughtExceptionMaximum) {
        
        return;
        
    }
    
    
    
    NSArray *callStack = [DumbCatchCrash backtrace];
    
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithDictionary:[exception userInfo]];[userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    
    
    [[[DumbCatchCrash alloc] init]performSelectorOnMainThread:@selector(handleException:)withObject:
     
     [NSException exceptionWithName:[exception name] reason:[exception reason] userInfo:userInfo]waitUntilDone:YES];
}


void SignalHandler(int signal)
{
    int32_t exceptionCount =OSAtomicIncrement32(&UncaughtExceptionCount);
    
    if (exceptionCount >UncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo =[NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:UncaughtExceptionHandlerSignalKey];
    
    NSArray *callStack = [DumbCatchCrash backtrace];
    [userInfo setObject:callStack forKey:UncaughtExceptionHandlerAddressesKey];
    
    
   NSException *ex = [NSException exceptionWithName:UncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.",nil),signal]userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal]forKey:UncaughtExceptionHandlerSignalKey]];
    
    [[[DumbCatchCrash alloc] init]performSelectorOnMainThread:@selector(handleException:)withObject:ex waitUntilDone:YES];
}

// 注册崩溃拦截
void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
    
    signal(SIGABRT,SignalHandler);
    
    signal(SIGILL,SignalHandler);
    
    signal(SIGSEGV,SignalHandler);
    
    signal(SIGFPE,SignalHandler);
    
    signal(SIGBUS,SignalHandler);
    
    signal(SIGPIPE,SignalHandler);
    
//    signal(SIGHUP, signalHandler);
//    signal(SIGINT, signalHandler);
//    signal(SIGQUIT, signalHandler);
//    signal(SIGABRT, signalHandler);
//    signal(SIGILL, signalHandler);
//    signal(SIGSEGV, signalHandler);
//    signal(SIGFPE, signalHandler);
//    signal(SIGBUS, signalHandler);
//    signal(SIGPIPE, signalHandler);
    
}
