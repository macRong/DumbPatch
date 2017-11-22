//
//  DumbPatchObject.h
//  DumbPatch
//
//  Created by macRong on 16/8/9.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DumbPatchObject : NSObject

/**
 * fix > unrecognized selector sent to instance 0x101011
 */
+ (void)exchangeImpWithArr:(NSArray *)arr class:(Class)clas;

+ (NSString *)threadCallStackSymbols:(Class)threadClass cmd:(SEL)selector;

@end

// resolveThisMethodDynamically

#define resolveaObjectMethod(method) \
void tempMethodIMP##method(id self, SEL _cmd)\
{\
NSString *sel = NSStringFromSelector(_cmd);\
NSString *message = [NSString stringWithFormat:@"【hi, %@有%@方法吗？】____✘____",[self class],sel];\
NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];\
fixalert(message,call, FixLevel_VeryHeight);\
}\
\
+ (BOOL)resolveInstanceMethod:(SEL)sel\
{\
if (![NSStringFromSelector(sel)  isEqualToString: @"_dynamicContextEvaluation:patternString:"] \
&& ![NSStringFromSelector(sel)  isEqualToString: @"_copyFormattingDescription:"] \
&& ![NSStringFromSelector(sel)  isEqualToString: @"_encodingCantBeStoredInEightBitCFString"] \
&& ![NSStringFromSelector(sel)  isEqualToString: @"descriptionWithMultilinePrefix:"] \
&& ![NSStringFromSelector(sel)  isEqualToString: @"encodeWithOSLogCoder:options:maxLength:"] \
) { \
class_addMethod([self class], sel, (IMP)tempMethodIMP##method, "v@:"); \
return YES;\
}\
\
return [super resolveInstanceMethod:sel];\
}\
\
- (NSMethodSignature *)rt_private_resolveInstanceMethod:(SEL)aSelector {\
NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];\
if (!signature) {\
if ([self respondsToSelector:aSelector]) {\
[[self class] resolveInstanceMethod:aSelector];\
}\
}\
return signature;\
}\
