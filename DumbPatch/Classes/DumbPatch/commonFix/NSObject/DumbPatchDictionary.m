//
//  DumbPatchDictionary.m
//  DumbPatch
//
//  Created by macRong on 16/8/9.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchDictionary.h"
#import <objc/runtime.h>
#import "FixHeader.h"


static BOOL logEnabled = NO;

void fixCollectionLog(NSString *fmt, ...) NS_FORMAT_FUNCTION(1, 2);

void fixCollectionLog(NSString *fmt, ...)
{
    if (!logEnabled)
    {
        return;
    }
    va_list ap;
    va_start(ap, fmt);
    NSString *content = [[NSString alloc] initWithFormat:fmt arguments:ap];
    NSLog(@"%@", content);
    va_end(ap);
}


@interface DumbPatchDictionary()

+ (void)setLogEnabled:(BOOL)enabled;

@end



#pragma mark - NSDictionary

@interface NSDictionary (Fix)
@end

@implementation  NSDictionary (Fix)

+ (instancetype)rt_private_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    id validObjects[cnt];
    id<NSCopying> validKeys[cnt];
    NSUInteger count = 0;
    for (NSUInteger i = 0; i < cnt; i++)
    {
        if (objects[i] && keys[i])
        {
            validObjects[count] = objects[i];
            validKeys[count] = keys[i];
            count ++;
        }
        else
        {
            NSString *show = [NSString stringWithFormat:@"[%@ %@] NIL object or key at index{%lu}.",
                              NSStringFromClass(self),
                              NSStringFromSelector(_cmd),
                              (unsigned long)i];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
        }
    }
    
    return [self rt_private_dictionaryWithObjects:validObjects forKeys:validKeys count:count];
}

+ (instancetype)rt_private_dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, firstObject);
    
    for (NSString *object = firstObject; object != nil; object = va_arg(args,NSString*)) {
        NSString *key = va_arg(args,NSString*);
        if(key == nil){
            NSString *show = [NSString stringWithFormat:@"[%@ %@] NIL key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return  nil;
        }
    }
    
    va_end(args);
    
    return [[self class] rt_private_dictionaryWithObjectsAndKeys:firstObject, nil];
}

#if MPT_DataSave_enable
resolveaObjectMethod(NSDictionary);
#endif

@end


#pragma mark - NSMutableDictionary


@interface NSMutableDictionary (Fix)

@end

@implementation NSMutableDictionary (Fix)

+ (Method)methodOfSelector:(SEL)selector
{
    return class_getInstanceMethod(NSClassFromString(@"__NSDictionaryM"),selector);
}

- (void)rt_private_setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (!aKey)
    {
        NSString *show = [NSString stringWithFormat:@"[%@ %@] NIL key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        return;
    }
    if (!anObject)
    {
        NSString *show = [NSString stringWithFormat:@"[%@ %@] NIL object.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        return;
    }
    
    [self rt_private_setObject:anObject forKey:aKey];
}

- (void)rt_private_removeObjectForKey:(id<NSCopying>)aKey
{
    if (!aKey) {
        NSString *show = [NSString stringWithFormat:@"[%@ %@] NIL key.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        return;
    }
    
    [self rt_private_removeObjectForKey:aKey];
}

@end



///////////////////////// .m ////////////////////////////////////////////////////

@implementation DumbPatchDictionary

#if MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        [self rt_method_exchangeImplementations:class_getClassMethod([NSDictionary class],
                                                                     @selector(resolveInstanceMethod:))
                                  withNewMethod:class_getClassMethod([NSDictionary class],
                                                                     @selector(rt_private_resolveInstanceMethod:))];
        
        /** [__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects   :: @{@"key":nil} */
        [self rt_method_exchangeImplementations:class_getClassMethod([NSDictionary class],
                                                                     @selector(dictionaryWithObjects:forKeys:count:))
                                  withNewMethod:class_getClassMethod([NSDictionary class],
                                                                     @selector(rt_private_dictionaryWithObjects:forKeys:count:))];
        
        [self rt_method_exchangeImplementations:[NSMutableDictionary
                                                 methodOfSelector:@selector(setObject:forKey:)]
                                  withNewMethod:[NSMutableDictionary
                                                 methodOfSelector:@selector(rt_private_setObject:forKey:)]];
        

        [self rt_method_exchangeImplementations:[NSMutableDictionary
                                                 methodOfSelector:@selector(removeObjectForKey:)]
                                  withNewMethod:[NSMutableDictionary
                                                 methodOfSelector:@selector(rt_private_removeObjectForKey:)]];
        
    });
}
#endif

+ (void)rt_method_exchangeImplementations:(Method)originalMethod withNewMethod:(Method)newMethod
{
    method_exchangeImplementations(originalMethod, newMethod);
}

+ (void)setLogEnabled:(BOOL)enabled
{
    logEnabled = enabled;
}

@end
