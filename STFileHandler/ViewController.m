//
//  ViewController.m
//  STFileHandler
//
//  Created by yuqian on 2018/9/15.
//  Copyright © 2018年 yuqian. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSString *homePath  = NSHomeDirectory();
    NSString *sourcePath = [homePath stringByAppendingPathComponent:@"testfile.text"];
    NSLog(@"homePath:%@", homePath);
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:sourcePath]) {
        [fm createFileAtPath:sourcePath contents:nil attributes:nil];
    }
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:sourcePath];
    NSUInteger length = [[handle availableData] length];
    NSLog(@"file length:%lud", length);
    
    handle = [NSFileHandle fileHandleForWritingAtPath:sourcePath];
    
    NSLog(@"Current offset:%llud", handle.offsetInFile);
    [handle seekToEndOfFile];
    NSLog(@"Current offset:%llud", handle.offsetInFile);
    
    [handle truncateFileAtOffset:590];
    [handle seekToFileOffset:295];
    NSLog(@"Current offset:%llud", handle.offsetInFile);
    
    NSString *str = @"1. Let me tell you how much I liked /appreciated / enjoyed\n\
2. I want you to know how much we / I appreciate\n\
3. We appreciate your taking time to\n\
4. I don’t know how I would have managed without your help\n\
5. I hope I can return the favor someday\n\
6. Do let me know if I can ever returnthe favor\n";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [handle writeData:data];
    
    NSLog(@"Current offset:%llud", handle.offsetInFile);
    
    
    
    [handle synchronizeFile];
    [handle closeFile];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
