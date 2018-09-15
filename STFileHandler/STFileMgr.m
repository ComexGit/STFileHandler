//
//  STFileMgr.m
//  STFileHandler
//
//  Created by yuqian on 2018/9/15.
//  Copyright © 2018年 yuqian. All rights reserved.
//

#import "STFileMgr.h"

static char *queueName = "fileManagerQueue";

@interface STFileMgr ()
{
    //读写队列
    dispatch_queue_t _queue;
}
@end


@implementation STFileMgr

+ (instancetype)shareInstance
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    if(self = [super init]) {
        _queue = dispatch_queue_create(queueName, DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSData *)readFile:(NSString *)path
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"File is not exist.");
        return nil;
    }
    
    __block NSData *data;
    dispatch_sync(_queue, ^{
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        data = [fileHandle readDataToEndOfFile];
        [fileHandle closeFile];
    });
    return data;
}

- (void)readFileAsync:(NSString *)path complete:(void (^)(NSData *data))complete
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSLog(@"File is not exist.");
        if (complete) {
            complete(nil);
        }
    }
    
    dispatch_async(_queue, ^{
        NSData *data = nil;
    
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
        data = [fileHandle readDataToEndOfFile];
        
        if (complete) {
            complete(data);
            [fileHandle closeFile];
        }
    });
}

- (void)writeFile:(NSString *)path data:(NSData *)data
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
         [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    
    dispatch_barrier_sync(_queue, ^{
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        
        NSLog(@"----Writing success. current thread:%@----Date:%@", [NSThread currentThread], [NSDate date]);
    });
}

- (void)writeFileAsync:(NSString *)path data:(NSData *)data complete:(void (^)(BOOL result))complete
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createFileAtPath:path contents:nil attributes:nil];
    }
    
    __block BOOL result = NO;
    dispatch_barrier_async(_queue, ^{
        
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:data];
        
        [fileHandle synchronizeFile];
        [fileHandle closeFile];
        
        NSLog(@"----Writing success. current thread:%@----Date:%@", [NSThread currentThread], [NSDate date]);
        
        if (complete) {
            complete(result);
        }
    });
}

@end
