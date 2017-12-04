//
//  DumbViewController.m
//  DumbPatch
//
//  Created by rongtian on 11/17/2015.
//  Copyright (c) 2015 rongtian. All rights reserved.
//

#import "DumbViewController.h"

@interface DumbViewController ()

@end

@implementation DumbViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
//    NSString* s = [[NSString alloc]initWithString:@"This is a test string"];
//    s = [s substringFromIndex:[s rangeOfString:@"a"].location];//内存泄露
//    [s release];//错误释放
//    [pool drain];
    
//     NSException *exception = [NSException exceptionWithName:@"HotTeaException" reason:@"The tea is too hot" userInfo:nil];
//
//    [exception raise];
    
//    NSInteger le = s.length;
//    [pool drain];//EXC_BAD_ACCESS

    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
//    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *arr = @[];
        NSInteger len = arr.length;
        
        NSArray *array = @[];
        id co = array[3];
    });
    
//
    self.view.backgroundColor = [UIColor redColor];
//
//        NSArray *array = @[];
//        id co = array[3];
//
//
//
//        NSString *name = nil;
//        NSDictionary *dic = @{@"name":name, @"age":@27};
//    });
}

- (IBAction)action:(id)sender
{
    NSLog(@"---click----");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
