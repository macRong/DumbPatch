#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "DumbPatchArray.h"
#import "DumbPatchBOOL.h"
#import "DumbPatchDictionary.h"
#import "DumbPatchNull.h"
#import "DumbPatchObject.h"
#import "DumbPatchSet.h"
#import "DumbPatch-UIKit.h"
#import "DumbPatchView.h"
#import "DumbPatchTableView.h"
#import "DumbPatch.h"
#import "FixHeader.h"

FOUNDATION_EXPORT double DumbPatchVersionNumber;
FOUNDATION_EXPORT const unsigned char DumbPatchVersionString[];

