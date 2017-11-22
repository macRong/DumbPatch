//
//  UIViewFix.m
//  DumbPatch
//
//  Created by macRong on 2017/6/29.
//  Copyright © 2017年 macRong. All rights reserved.
//

#import "DumbPatchView.h"
#import  <objc/runtime.h>
#import "FixHeader.h"


@interface UIView (DumbPatch)

@end


@implementation UIView (DumbPatch)

- (void)rt_private_addSubview:(UIView *)view
{
    if (view == self)
    {
        return;
    }
    
    [self rt_private_addSubview:view];
}


@end


@implementation DumbPatchView

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        [self exAddUIView];
    });
}

+ (void)exAddUIView
{
    Class classI = NSClassFromString(@"UIView");
    
    NSArray *exbool = @[
                        @[@"addSubview:", @"rt_private_addSubview:"]
                        ];
    
    [DumbPatchObject exchangeImpWithArr:exbool class:classI];
}


@end
