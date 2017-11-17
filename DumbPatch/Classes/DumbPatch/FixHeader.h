//
//  FixHeader.h
//  DumbPatch
//
//  Created by macRong on 16/8/8.
//  Copyright © 2016年 macRong. All rights reserved.
//

#import "DumbPatch.h"

#ifdef DEBUG
#define MPT_DataSave_enable  1
#else
#define MPT_DataSave_enable  1
#endif


#ifdef DEBUG
#define FixLog(...) NSLog(__VA_ARGS__)
#else
#define FixLog(...) /*  */
#endif



typedef NS_ENUM(NSInteger, FixLevelType) {
    FixLevel_VeryHeight = 0,
    FixLevel_Warn
};


void fixalert (NSString *message, NSString *callsym,FixLevelType type);

@interface FixHeader : NSObject

@end



