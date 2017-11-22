//
//  DumbPatchSet.m
//  DumbPatch
//
//  Created by macRong on 2016/11/22.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchSet.h"
#import  <objc/runtime.h>
#import "FixHeader.h"

@interface NSSet (Fix)
@end

@implementation NSSet (Fix)

- (instancetype)rt_privateset_initWithObjects:(const id  _Nonnull     __unsafe_unretained *)objects count:(NSUInteger)cnt
{
    BOOL hasNilObject = NO;
    for (NSUInteger i = 0; i < cnt; i++) {
        
        if (objects[i] == nil) {
            hasNilObject = YES;
#ifdef DEBUG
            NSString *show = [NSString stringWithFormat:@"【%@_0 %@】(Set init):insert nil object at index {%lu}",
                              NSStringFromClass([self class]),
                              NSStringFromSelector(_cmd),
                              (unsigned long)i];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
#endif
            break;
        }
    }
    
    if (hasNilObject) {
        id __unsafe_unretained newObjects[cnt];
        NSUInteger index = 0;
        for (NSUInteger i = 0; i < cnt; ++i) {
            if (objects[i] != nil) {
                newObjects[index++] = objects[i];
            }
        }
        return [self rt_privateset_initWithObjects:newObjects count:index];
    }
    return [self rt_privateset_initWithObjects:objects count:cnt];
}

#if MPT_DataSave_enable
resolveaObjectMethod(exSet);
#endif

@end


@implementation DumbPatchSet

#if MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        // placeholdSet
        [self explaceholdSet];
    });
}
#endif

+ (void)explaceholdSet
{
    Class classI = NSClassFromString(@"__NSPlaceholderSet");
    NSArray *exArray = @[
                         /** fixed > ***[__NSPlaceholderSet initWithObjects:count:] */
                         @[@"initWithObjects:count:" , @"rt_privateset_initWithObjects:count:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:classI];
}

@end

