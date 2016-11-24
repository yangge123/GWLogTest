//
//  GWLogListManager.h
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
// 服务器返回的数据,普通数据，异常，错误，

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GWLogModel.h"


@interface GWLogListManager : NSObject

+ (instancetype)shareInstance;

- (void)updateLogList;

//缓存log数据
- (void)cacheLog:(NSString *)msg logType:(int)logType complementBlock:(void (^)(void))complementBlock; // 0 代表异常 1 2 之后实现

- (void)cacheLog:(NSString *)msg fileMsg:(NSString *)fileMsg logType:(int)logType complementBlock:(void (^)(void))complementBlock;

//同步查找
- (NSArray<GWLogModel *> *)syncQueryLogs;

- (void)popOrDismissConfigWithViewController:(UIViewController *)vc;

@end
