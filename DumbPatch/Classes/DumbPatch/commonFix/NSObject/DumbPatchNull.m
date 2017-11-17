//
//  DumbPatchNull.m
//  DumbPatch
//
//  Created by macRong on 16/8/26.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchNull.h"
#import  <objc/runtime.h>
#import "FixHeader.h"

@interface NSNull (fix)

@end

@implementation NSNull (fix)

#ifdef DEBUG

-(NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSString *ss = [NSString stringWithFormat:@"%@ sdsds",@"sdds"];
    return ss;
}
#endif


#if MPT_DataSave_enable

void tempMethodIMPNullmethod(id self, SEL _cmd)
{
#ifdef DEBUG
    NSString *sel = NSStringFromSelector(_cmd);
    NSString *message = [NSString stringWithFormat:@"【hi, %@有%@方法吗？】____✘____",[self class],sel];
    NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
    fixalert(message,call, FixLevel_VeryHeight);
#endif
    
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (![NSStringFromSelector(sel)     isEqualToString: @"_dynamicContextEvaluation:patternString:"]
        && ![NSStringFromSelector(sel)  isEqualToString: @"_copyFormattingDescription:"]
        && ![NSStringFromSelector(sel)  isEqualToString: @"_encodingCantBeStoredInEightBitCFString"]
        && ![NSStringFromSelector(sel)  isEqualToString: @"descriptionWithMultilinePrefix:"]
#ifdef DEBUG
        && ![NSStringFromSelector(sel)  isEqualToString: @"descriptionWithLocale:"]
#endif
        )
        /** 针对系统相册 */
//        && ![NSStringFromSelector(sel)  isEqualToString: @"length"])  // ??
    {
        class_addMethod([self class], sel, (IMP)tempMethodIMPNullmethod, "v@:");
        return YES;
    }
    
    return [super resolveInstanceMethod:sel];
}

- (NSMethodSignature *)rt_private_resolveInstanceMethod:(SEL)aSelector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
 
    if (!signature)
    {
        if ([self respondsToSelector:aSelector])
        {
            [[self class] resolveInstanceMethod:aSelector];
        }
    }
    
    return signature;
}

#endif


@end

@implementation DumbPatchNull
#if MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        [self exNUll];
    });
}
#endif

+ (void)exNUll
{
    
    Class classI = NSClassFromString(@"NSNull");
    
    NSArray *exbool = @[
                        @[@"methodSignatureForSelector:" , @"rt_private_resolveInstanceMethod:"]
                        ];
    
    [DumbPatchObject exchangeImpWithArr:exbool class:classI];
}

@end
