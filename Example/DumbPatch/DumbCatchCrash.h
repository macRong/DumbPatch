//
//  DumbCatchCrash.h
//  DumbPatch_Example
//
//  Created by macRong on 2017/11/23.
//  Copyright © 2017年 rongtian. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <UIKit/UIKit.h>

@interface DumbCatchCrash : NSObject
{
    
    BOOL dismissed;
    
}
//+ (void)handelExtremely;

@end


void HandleException(NSException *exception);

void SignalHandler(int signal);

void InstallUncaughtExceptionHandler(void);
