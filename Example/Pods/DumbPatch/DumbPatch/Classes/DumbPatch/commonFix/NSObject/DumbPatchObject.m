//
//  DumbPatchObject.m
//  DumbPatch
//
//  Created by macRong on 16/8/9.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchObject.h"
#import  <objc/runtime.h>

@interface NSObject (Fix)
@end

@implementation NSObject (Fix)


@end



@implementation DumbPatchObject


+ (void)exchangeImpWithArr:(NSArray *)arr class:(Class)clas
{
    [arr enumerateObjectsUsingBlock:^(NSArray * obj, NSUInteger idx, BOOL *stop) {
        
        SEL originalSelector = NSSelectorFromString(obj[0]);
        SEL swizzledSelector = NSSelectorFromString(obj[1]);
        
        Method originalMethod = class_getInstanceMethod(clas, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(clas, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(clas,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(clas,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }];
}


+ (NSString *)threadCallStackSymbols:(Class)threadClass cmd:(SEL)selector
{
    NSArray *syms = [NSThread  callStackSymbols];
    __block NSString *show = @"";
    /*
     [syms enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
     NSString *tempshow;
     if (obj == 0) {
     tempshow = [NSString stringWithFormat:@"<%@ %p> %@ - caller: %@ ", [threadClass class], threadClass, NSStringFromSelector(selector),[syms objectAtIndex:idx]];
     }else {
     tempshow = [NSString stringWithFormat:@" %@ ", [syms objectAtIndex:idx]];
     }
     
     show = [show stringByAppendingString:tempshow];
     }];
     */

    
//    if ([syms count] > 2) {
//        show = [NSString stringWithFormat:@"<%@ %p> %@ - caller: %@ ", [threadClass class], threadClass, NSStringFromSelector(selector),[syms objectAtIndex:2]];
//    } else {
//        show = [NSString stringWithFormat:@"<%@ %p> %@", [threadClass class], threadClass, NSStringFromSelector(selector)];
//    }
    
    show = [self getMainCallStackSymbolMessageWithCallStackSymbols:syms];
    return show;
}


+ (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols {
    
    __block NSString *mainCallStackSymbolMsg = nil;
    
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    
    return mainCallStackSymbolMsg;
}

@end
