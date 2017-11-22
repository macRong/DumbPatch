//
//  DumbPatch-UIKit.h
//  DumbPatch_Example
//
//  Created by macRong on 2017/11/16.
//  Copyright © 2017年 MacRong. All rights reserved.
//

#ifndef DumbPatch_UIKit_h
#define DumbPatch_UIKit_h

#define resolveaUIKitMethod(method) \
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
if ([NSStringFromSelector(sel)  isEqualToString: @"resolveThisMethodDynamically"]) { \
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


#endif /* DumbPatch_UIKit_h */
