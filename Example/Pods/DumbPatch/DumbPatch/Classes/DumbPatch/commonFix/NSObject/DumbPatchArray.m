//
//  DumbPatchArray.m
//  DumbPatch
//
//  Created by macRong on 16/8/9.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatchArray.h"
#import  <objc/runtime.h>
#import "FixHeader.h"



#pragma mark - NSArray

@interface NSArray(Fix)
@end

@implementation NSArray(Fix)


/** fixed > objectAtIndex */
- (id)rt_private_objectAtIndexI:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count || self.count < 1)
        {
            NSString *show = [NSString stringWithFormat:@"objectAtIndex_I:%@",self.count < 1 ? @"【empty array】" : @"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return nil;
        }
        
        return [self rt_private_objectAtIndexI:index];
    }

}

- (id)rt_private_objectAtIndex0:(NSUInteger)index
{
    NSString *show = [NSString stringWithFormat:@"objectAtIndex_0:%@",@"【empty array】"];
    NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
    fixalert(show,call, FixLevel_VeryHeight);
    return nil;
}


- (id)rt_private_objectAtIndex_singI:(NSUInteger)index
{
    @autoreleasepool
    {
        if (index >= self.count || self.count < 1)
        {
            NSString *show = [NSString stringWithFormat:@"objectAtIndex_I:%@",self.count < 1 ? @"【empty array】" : @"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return nil;
        }
        
        return [self rt_private_objectAtIndex_singI:index];
    }
}


+ (id)rt_private_arrayWithObjects:(const id [])objects countI:(NSUInteger)cnt
{
    @autoreleasepool
    {
        id validObjects[cnt];
        NSUInteger count = 0;
        
        for (NSUInteger i = 0; i < cnt; i++) {
            
            if (objects[i]) {
                
                validObjects[count] = objects[i];
                count++;
                
            }else {
                NSString *show = [NSString stringWithFormat:@"[%@ %@] nil object at index {%lu}",
                                  NSStringFromClass([self class]),
                                  NSStringFromSelector(_cmd),
                                  (unsigned long)i];
                NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
                fixalert(show,call, FixLevel_VeryHeight);
            }
        }
        
        return [self rt_private_arrayWithObjects:validObjects countI:count];
    }

}

+ (id)rt_private_arrayWithObjects:(const id [])objects count0:(NSUInteger)cnt
{
    @autoreleasepool
    {
        NSString *show = [NSString stringWithFormat:@"【%@_0 %@】 nil object at index {%lu}",
                          NSStringFromClass([self class]),
                          NSStringFromSelector(_cmd),
                          (unsigned long)cnt];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        
        return [self rt_private_arrayWithObjects:objects countI:cnt];
    }
}

- (instancetype)rt_private_initWithObjects:(const id _Nonnull [_Nullable])objects count:(NSUInteger)cnt
{
    @autoreleasepool
    {
        id validObjects[cnt];
        NSUInteger count = 0;
        
        for (NSUInteger i = 0; i < cnt; i++) {
            
            if (objects[i]) {
                
                validObjects[count] = objects[i];
                count++;
                
            }else {
                NSString *show = [NSString stringWithFormat:@"[%@ %@] nil object at index {%lu}",
                                  NSStringFromClass([self class]),
                                  NSStringFromSelector(_cmd),
                                  (unsigned long)i];
                NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
                fixalert(show,call, FixLevel_VeryHeight);
            }
        }
        
        return [self rt_private_initWithObjects:objects count:count];
    }
}

#if MPT_DataSave_enable
resolveaObjectMethod(array);
#endif

@end


#pragma mark - NSMutableArray

@interface NSMutableArray(Fix)
@end

@implementation NSMutableArray(Fix)


/** fixed > objectAtIndex */
- (id)rt_private_objectAtIndexM:(NSUInteger)index
{
    @autoreleasepool
    {
        if (self.count < 1 || index >= self.count ) {
            NSString *show = [NSString stringWithFormat:@"objectAtIndex_M:%@",self.count < 1 ? @"【empty array】" : @"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return nil;
        }
        
        return [self rt_private_objectAtIndexM:index];
    }
}

/** fixed > addObject */
- (void)rt_private_addObjectM:(id)object
{
    @autoreleasepool
    {
        if (object != nil) {
            [self rt_private_addObjectM:object];
            return;
        }
        
        NSString *show = [NSString stringWithFormat:@"addObject_M:%@", @"【object = nil】"];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
    }
}

/** fixed > removeObjectAtIndex */
- (void)rt_private_removeObjectAtIndexM:(NSUInteger)objectIndex
{
    @autoreleasepool
    {
        if (self.count < 1 || objectIndex >= self.count ) {
            NSString *show = [NSString stringWithFormat:@"removeObjectAtIndex_M:%@", self.count < 1 ? @"【empty mutabelArray】" :@"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return ;
        }
        
        return [self rt_private_removeObjectAtIndexM:objectIndex];
    }
}

/** fixed > insertObject:atIndex */
- (void)rt_private_insertObject:(id)anObject atIndexM:(NSUInteger)index
{
    @autoreleasepool
    {
        if (anObject == nil || index > self.count) {
            
            NSString *show = [NSString stringWithFormat:@"insertObject_M:atIndex:%@", anObject == nil ? @"【object = nil】" :@"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return;
        }
        
        [self rt_private_insertObject:anObject atIndexM:index];
    }
}

/** fixed > replaceObjectAtIndex:withObject */
- (void)replace_RT_Private_ObjectAtIndex:(NSUInteger)index withObjectM:(id)anObject
{
    @autoreleasepool
    {
        if (index >= self.count || anObject == nil) {
            NSString *show = [NSString stringWithFormat:@"replaceObjectAtIndex_M:withObject%@", anObject == nil ? @"【object = nil】" :@"【index >= array.count】"];
            NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
            fixalert(show,call, FixLevel_VeryHeight);
            return ;
        }
        
        [self replace_RT_Private_ObjectAtIndex:index withObjectM:anObject];
    }
}


@end




///////////////////////// .m ////////////////////////////////////////////////////

@implementation DumbPatchArray

#if MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        
        [self exArray];
        
        // NSMutableArray
        [self exMutableArray];
        
        // NSArray
        [self exArrayI];
        
        // NSArray0
        [self exArray0];
        
        // __NSSingleObjectArrayI
        [self exSingleArrayI];
        
        // __NSPlaceholderArray
   //     [self exPlaceholderArray];
    });
}
#endif

+ (void)exArray
{
    Class classI = [NSArray class];
    
    NSArray *exArray = @[
                         @[@"resolveInstanceMethod:" , @"rt_private_resolveInstanceMethod:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:classI];
}

+ (void)exArrayI
{
    Class classI = NSClassFromString(@"__NSArrayI");
    
    NSArray *exArray = @[
                         /** fixed > *** Terminating app due to uncaught exception 'NSRangeException',
                          reason: '*** -[__NSArrayM objectAtIndex:]: index 21 beyond bounds [0 .. 1] */
                         @[@"objectAtIndex:" , @"rt_private_objectAtIndexI:"],
                         @[@"arrayWithObjects:count:", @"rt_private_arrayWithObjects:countI:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:classI];
}

+ (void)exArray0
{
    /** empty array */
    Class class0 = NSClassFromString(@"__NSArray0");
    
    NSArray *exArray = @[
                         /** *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArray0 objectAtIndex:]: index 1 beyond bounds for empty NSArray' */
                         @[@"objectAtIndex:" , @"rt_private_objectAtIndex0:"],
                         @[@"arrayWithObjects:count:", @"rt_private_arrayWithObjects:count0:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:class0];
    
}

+ (void)exMutableArray
{
    Class class = NSClassFromString(@"__NSArrayM");
    
    NSArray *exArray = @[
                         /** fixed > *** Terminating app due to uncaught exception 'NSRangeException',
                          reason: '*** -[__NSArrayM objectAtIndex:]: index 21 beyond bounds [0 .. 1] */
                         @[@"objectAtIndex:" , @"rt_private_objectAtIndexM:"],
                         
                         /** fixed > *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil' */
                         @[@"addObject:" , @"rt_private_addObjectM:"],
                         
                         /** fixed > *** Terminating app due to uncaught exception 'NSRangeException',
                          reason: '*** -[__NSArrayM removeObjectAtIndex:]: index 33 beyond bounds [0 .. 1]' */
                         @[@"removeObjectAtIndex:" , @"rt_private_removeObjectAtIndexM:"],
                         
                         /** fixed > *** Terminating app due to uncaught exception 'NSInvalidArgumentException',
                          reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil' */
                         @[@"insertObject:atIndex:" , @"rt_private_insertObject:atIndexM:"],
                         
                         /** fixed > *** Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM replaceObjectAtIndex:withObject:]: index 3 beyond bounds [0 .. 1]' */
                         @[@"replaceObjectAtIndex:withObject:" , @"replace_RT_Private_ObjectAtIndex:withObjectM:"]
                         
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:class];
    
}

+ (void)exSingleArrayI
{
    Class classI = NSClassFromString(@"__NSSingleObjectArrayI");
    
    NSArray *exArray = @[
                         /** fixed > *** Terminating app due to uncaught exception 'NSRangeException',
                          reason: '*** -[__NSSingleObjectArrayI objectAtIndex:]: index 21 beyond bounds [0 .. 1] */
                         @[@"objectAtIndex:" , @"rt_private_objectAtIndex_singI:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:classI];
}

+ (void)exPlaceholderArray
{
    Class classPlaceholder = NSClassFromString(@"__NSPlaceholderArray");
    NSArray *exArray = @[
                         /** fixed > *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'
                          example：NSString *k = nil;  [NSArray arrayWithObject:k];
                          */
                         @[@"initWithObjects:count:" , @"rt_private_initWithObjects:count:"]
                         ];
    
    [DumbPatchObject exchangeImpWithArr:exArray class:classPlaceholder];
}


@end
