# DumbPatch

[![CI Status](http://img.shields.io/travis/macRong/DumbPatch.svg?style=flat)](https://travis-ci.org/macRong/DumbPatch)
[![Version](https://img.shields.io/cocoapods/v/DumbPatch.svg?style=flat)](http://cocoapods.org/pods/DumbPatch)
[![License](https://img.shields.io/cocoapods/l/DumbPatch.svg?style=flat)](http://cocoapods.org/pods/DumbPatch)
[![Platform](https://img.shields.io/cocoapods/p/DumbPatch.svg?style=flat)](http://cocoapods.org/pods/DumbPatch)
[![Language](https://awesomelinkcounter.herokuapp.com/objc)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) 

快速降低iOS崩溃率 (只需要加入项目中)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

* <mark>Array</mark> (__NSArrayM, __NSArray0, __NSArrayI, Unrecognized selector sent to instance):

```
NSArray *arr = @[];
NSMutableArray *mArr = @[].mutableCopy;
```
 

```
Unrecognized selector sent to instance ✅

*** Terminating app due to uncaught exception 'NSRangeException',
 reason: '*** -[__NSArrayM objectAtIndex:]: index 6 beyond bounds for empty NSArray
id obj = arr[6];  ✅
id objc = [arr objectAtIndex:6]; ✅

*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil
[mArr addObject:nil]; ✅

Terminating app due to uncaught exception 'NSRangeException',reason: '*** -[__NSArrayM removeObjectAtIndex:]: index 6  beyond bounds for empty
[mArr removeObjectAtIndex:6]; ✅
 
 *** Terminating app due to uncaught exception 'NSInvalidArgumentException',reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil
[mArr insertObject:nil atIndex:6]; ✅

Terminating app due to uncaught exception 'NSRangeException', reason: '*** -[__NSArrayM replaceObjectAtIndex:withObject:]: index 6 beyond bounds for empty
[mArr replaceObjectAtIndex:6 withObject:@"obj"]; ✅

*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[0]'example：NSString *k = nil;  [NSArray arrayWithObject:k]
NSString *k = nil; 
[NSArray arrayWithObject:k] ✅

*** -attempt to insert nil object from objects[0]
NSArray *ar = [NSArray arrayWithObjects:@"1",,@"2", nil]; ✅

```

## Requirements

## Installation

DumbPatch is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DumbPatch'
```

## Author

macRong, rong@shengshui.com

## License

DumbPatch is available under the MIT license. See the LICENSE file for more info.
