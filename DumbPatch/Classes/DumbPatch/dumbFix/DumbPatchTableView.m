//
//  UITableViewFix.m
//  DumbPatch
//
//  Created by macRong on 16/8/11.
//  Copyright © 2016年 macRong. All rights reserved.
//


#import "DumbPatchTableView.h"
#import  <objc/runtime.h>
#import "FixHeader.h"

@interface UITableView (Fix)

@end


@implementation UITableView (Fix)

- (void)rt_private_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    if (indexPath.row <0 || indexPath.section < 0 ) {
        NSString *show = [NSString stringWithFormat:@"[%@ %@] %@",
                          NSStringFromClass([self class]),
                          NSStringFromSelector(_cmd),
                          indexPath.row <0 ? @"indexPath.row <0" : @"indexPath.section <0"];
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        return;
    }
    
    if (indexPath.section >= self.numberOfSections || indexPath.row >= [self numberOfRowsInSection:indexPath.section]) {
        
        
        NSString *show;
        if (indexPath.section >= self.numberOfSections) {
            show = [NSString stringWithFormat:@"[%@ %@] section beyond bounds【%d(section)>=%d(tableview.sections)?】",
                    NSStringFromClass([self class]),
                    NSStringFromSelector(_cmd),
                    (int)indexPath.section,
                    (int)self.numberOfSections
                    ];
        }else {
            show = [NSString stringWithFormat:@"[%@ %@] row beyond bounds【%d(row)>=%d(tableview.section[rows)?】",
                    NSStringFromClass([self class]),
                    NSStringFromSelector(_cmd),
                    (int)indexPath.section,
                    (int)self.numberOfSections
                    ];
        }
        
        
        NSString *call = [DumbPatchObject threadCallStackSymbols:[self class] cmd:_cmd];
        fixalert(show,call, FixLevel_VeryHeight);
        return;
    }
    
    [self rt_private_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#if MPT_DataSave_enable
resolveaUIKitMethod(UITableView);
#endif


@end


@implementation DumbPatchTableView



#if MPT_DataSave_enable
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        
        [self exTableView];
    });
}
#endif

+ (void)exTableView
{
    Class class = [UITableView class];
    
    NSArray *extableResolve = @[
                                @[@"resolveInstanceMethod:" , @"rt_private_resolveInstanceMethod:"],
                                @[@"scrollToRowAtIndexPath:atScrollPosition:animated:", @"rt_private_scrollToRowAtIndexPath:atScrollPosition:animated:"]
                                ];
    
    [DumbPatchObject exchangeImpWithArr:extableResolve class:class];
}


@end
