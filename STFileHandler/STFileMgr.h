//
//  STFileMgr.h
//  STFileHandler
//
//  Created by yuqian on 2018/9/15.
//  Copyright © 2018年 yuqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STFileMgr : NSObject

+ (instancetype)shareInstance;

- (NSData *)readFile:(NSString *)path;
- (void)readFileAsync:(NSString *)path complete:(void (^)(NSData *data))complete;

- (void)writeFile:(NSString *)path data:(NSData *)data;
- (void)writeFileAsync:(NSString *)path data:(NSData *)data complete:(void (^)(BOOL result))complete;   

@end
