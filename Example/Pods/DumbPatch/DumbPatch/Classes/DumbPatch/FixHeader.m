//
//  FixHeader.m
//  DumbPatch
//
//  Created by macRong on 16/8/8.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "FixHeader.h"

const NSArray *_fixLevelArray;
#define FixGetLevelArray (_fixLevelArray == nil ? _fixLevelArray = [[NSArray alloc] initWithObjects:\
@"【崩溃😡】",\
@"【警告😰】",\
nil] : _fixLevelArray)

#define ActionFixLevelTypeEnum(string) ([FixGetLevelArray indexOfObject:string])
#define ActionFixLevelTypeString(enum) ([FixGetLevelArray objectAtIndex:enum])

#define DumbPathFixMark            @"❌❌❌❌❌❌❌❌❌❌❌❌❌❌【DumbPatch_Log】crash: ❌❌❌❌❌❌❌❌❌❌❌❌❌❌"
#define DumbPathFixMarkEnd         @"❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌❌"

#define DumbPatchWarn              @"【👆crash_log】 严 重 crash 快 去 解 决"

@implementation FixHeader

@end

#if DEBUG
void fixalert (NSString *message, NSString *callsym,FixLevelType type) {

    NSLog(@"\n\n\n %@ \n %@, %@ \n %@\n\n\n·",DumbPathFixMark,message,callsym,DumbPathFixMarkEnd);

}

#else
void fixalert (NSString *message, NSString *callsym,FixLevelType type){return;}

#endif
