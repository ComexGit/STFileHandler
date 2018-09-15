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
    __block NSData *data;
    dispatch_sync(_queue, ^{
        if([[NSFileManager defaultManager] fileExistsAtPath:path]){
            data = [[NSFileManager defaultManager] contentsAtPath:path];
        }
    });
    return data;
}

- (void)readFileAsync:(NSString *)path complete:(void (^)(NSData *data))complete
{
    dispatch_async(_queue, ^{
        NSData *data = nil;
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path]){
            data = [[NSFileManager defaultManager] contentsAtPath:path];
        }
        
        if (complete) {
            complete(data);
        }
    });
}

- (BOOL)writeFile:(NSString *)path data:(NSData *)data
{
    __block BOOL result = NO;
    dispatch_barrier_sync(_queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]){
            [fileManager removeItemAtPath:path error:nil];
        }
        
        result = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        
        
        NSLog(@"写文件：");
    });
    return result;
}

- (void)writeFileAsync:(NSString *)path data:(NSData *)data complete:(void (^)(BOOL result))complete
{
    __block BOOL result = NO;
    dispatch_barrier_async(_queue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:path]){
            [fileManager removeItemAtPath:path error:nil];
        }
        
        result = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
        
        if (complete) {
            complete(result);
        }
    });
    
}

@end
