//
//  DumbPatchBOOL.m
//  DumbPatch
//
//  Created by macRong on 16/8/9.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchBOOL.h"
#import  <objc/runtime.h>
#import "FixHeader.h"

@interface NSNumber (Fix)

@end

@implementation NSNumber (Fix)

#if MPT_DataSave_enable
void tempMethodIMPBoolmethod(id self, SEL _cmd)
{
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *message = [NSString stringWithFormat:@"【hi, %@有%@方法吗？】____✘____",[self class],sel];
    NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
    fixalert(message,call, FixLevel_VeryHeight);
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (![NSStringFromSelector(sel)  isEqualToString: @"_dynamicContextEvaluation:patternString:"]
    && ![NSStringFromSelector(sel)  isEqualToString: @"_copyFormattingDescription:"] 
    && ![NSStringFromSelector(sel)  isEqualToString: @"_encodingCantBeStoredInEightBitCFString"] 
    && ![NSStringFromSelector(sel)  isEqualToString: @"descriptionWithMultilinePrefix:"]
    && ![NSStringFromSelector(sel)  isEqualToString: @"encodeWithOSLogCoder:options:maxLength:"]
    /** 针对系统相册 */
    && ![NSStringFromSelector(sel)  isEqualToString: @"firstObject"]
    && ![NSStringFromSelector(sel)  isEqualToString: @"lastObject"]
    ) {
        class_addMethod([self class], sel, (IMP)tempMethodIMPBoolmethod, "v@:");
        return YES;
    }

   return [super resolveInstanceMethod:sel];
}

- (NSMethodSignature *)rt_private_resolveInstanceMethod:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([self respondsToSelector:aSelector]) {
            [[self class] resolveInstanceMethod:aSelector];
        }
    }
    return signature;
}
#endif


@end


@implementation DumbPatchBOOL


#if  MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{        
        [self exBool];
    });
}
#endif

+ (void)exBool
{
    
    Class classI = NSClassFromString(@"__NSCFBoolean");
    
    NSArray *exbool = @[

                         @[@"methodSignatureForSelector:", @"rt_private_resolveInstanceMethod:"]
                       ];

    [DumbPatchObject exchangeImpWithArr:exbool class:classI];
}


@end
