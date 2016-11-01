//
//  GWLogListManager.m
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWLogListManager.h"
#import "GWLogFatalHandler.h"
#import "GWLogCacheTool.h"
#import "GWLogListViewController.h"

@interface GWLogListManager()

@property(nonatomic,copy) NSString* logPath;

@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,strong)GWLogListViewController *logListVc;

@end

@implementation GWLogListManager

- (GWLogListViewController *)logListVc
{
    if (!_logListVc) {
        _logListVc = [[GWLogListViewController alloc] init];
    }
    return _logListVc;
}

+ (instancetype)shareInstance
{
    static GWLogListManager *_sharedManager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[GWLogListManager alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        InstallUncaughtExceptionHandler(); // 开启异常监控
    }
    
    return self;
}

- (void)getCurrentLog
{
    [self.logListVc getLogMessage];
}

- (void)cacheLog:(NSString *)msg fileMsg:(NSString *)fileMsg logType:(int)logType // logType 0 表示异常
{
    GWLogModel *logModel = [[GWLogModel alloc] init];
    
    logModel.logCreatTime = [[NSDate date] timeIntervalSince1970];
    
    logModel.logType = logType;
    
    logModel.logMsg = msg;
    
    if (fileMsg.length > 0) {
        logModel.fileMsg = fileMsg;
    }
    
    [GWLogCacheTool addLogMsg:logModel];
}

- (void)cacheLog:(NSString *)msg logType:(int)logType // logType 0 表示异常
{
    [self cacheLog:msg fileMsg:nil logType:logType];
}

- (NSArray<GWLogModel *> *)queryLogs
{
    GWQueryLogModel *req = [[GWQueryLogModel alloc] init];
    
    NSInteger currentTime = [[NSDate date] timeIntervalSince1970];
    
    req.start_time = currentTime - 1 * 60 * 60; //从当前时间1小时前开始查找日志
    
    NSArray<GWLogModel *> *logArr = [GWLogCacheTool queryLogsWithParam:req];
    
    return logArr;
}

- (void)popOrDismissConfigWithViewController:(UIViewController *)vc
{
    if (!_isShow) {
        //
        [vc presentViewController:self.logListVc animated:YES completion:NULL];
    }else{
        [self.logListVc dismissViewControllerAnimated:YES completion:NULL];
    }
    
    _isShow = !_isShow;
}

@end
