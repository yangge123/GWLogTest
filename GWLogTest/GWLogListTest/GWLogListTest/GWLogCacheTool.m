//
//  GWLogCacheTool.m
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWLogCacheTool.h"
#import "FMDB.h"

static FMDatabaseQueue *_queue;

@implementation GWLogCacheTool

+ (void)setup
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"log.sqlite"];
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists t_log (id integer primary key autoincrement, logCreatTime integer, softVersion text, logType integer, logMsg text, fileMsg text);"];
    }];
}

+ (void)addLogMsg:(GWLogModel *)logModel
{
    [self setup];
  
    [_queue inDatabase:^(FMDatabase *db) {
        // 1.获得需要存储的数据
        NSNumber *logCreatTime = [NSNumber numberWithInteger:logModel.logCreatTime];
        NSString *softVersion = logModel.softVersion;
        NSNumber *logType = [NSNumber numberWithInt:logModel.logType];
        NSString *logMsg = logModel.logMsg ? logModel.logMsg : @"";
        NSString *fileMsg = logModel.fileMsg ? logModel.fileMsg : @"";
        // 2.存储数据
        [db executeUpdate:@"insert into t_log (logCreatTime, softVersion, logType, logMsg, fileMsg) values(?, ?, ? , ?, ?)",logCreatTime,softVersion, logType, logMsg, fileMsg];
    }];
    
    [_queue close];
}

+ (NSArray<GWLogModel *> *)queryLogsWithParam:(GWQueryLogModel *)param
{
    [self setup];

    // 1.定义数组
    __block NSMutableArray<GWLogModel *> *logsArrM = nil;
    
    // 2.使用数据库
    [_queue inDatabase:^(FMDatabase *db) {
        // 创建数组
        logsArrM = [NSMutableArray<GWLogModel *> array];
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *softVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        FMResultSet *rs = nil;
        
        if (param.start_time)
        {
            NSNumber *startTime = [NSNumber numberWithInteger:param.start_time];
            rs = [db executeQuery:@"select * from t_log where softVersion = ? and logCreatTime >= ? order by logCreatTime desc", softVersion, startTime];
        }
        
        while (rs.next)
        {
            GWLogModel *logModel = [[GWLogModel alloc] init];
            logModel.logCreatTime = [rs intForColumn:@"logCreatTime"];
            logModel.softVersion = [rs stringForColumn:@"softVersion"];
            logModel.logType = [rs intForColumn:@"logType"];
            logModel.logMsg = [rs stringForColumn:@"logMsg"];
            logModel.fileMsg = [rs stringForColumn:@"fileMsg"];
            [logsArrM addObject:logModel];
        }
    }];
    
    [_queue close];
    
    // 3.返回数据
    return [logsArrM copy];
}

@end
