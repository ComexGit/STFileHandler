//
//  ViewController.m
//  STFileHandler
//
//  Created by yuqian on 2018/9/15.
//  Copyright © 2018年 yuqian. All rights reserved.
//

#import "ViewController.h"
#import "STFileMgr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *homePath  = NSHomeDirectory();
    NSString *sourcePath = [homePath stringByAppendingPathComponent:@"test2.text"];
    NSLog(@"homePath:%@", homePath);
    
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
//
//        [[STFileMgr shareInstance] writeFile:sourcePath data:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
//        [[STFileMgr shareInstance] writeFile:sourcePath data:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding]];
//    });
    [self barrier];
    
//    [[STFileMgr shareInstance] writeFileAsync:sourcePath data:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding] complete:nil];
//    [[STFileMgr shareInstance] writeFileAsync:sourcePath data:[@"hello world" dataUsingEncoding:NSUTF8StringEncoding] complete:nil];
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_barrier_sync(queue, ^{
        // 追加任务 barrier
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);// 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务4
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
