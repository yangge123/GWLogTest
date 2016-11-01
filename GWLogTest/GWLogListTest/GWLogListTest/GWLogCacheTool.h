//
//  GWLogCacheTool.h
//  Holoera
//
//  Created by yangye on 16/10/29.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GWLogModel.h"
#import "GWQueryLogModel.h"

@interface GWLogCacheTool : NSObject


+ (void)addLogMsg:(GWLogModel *)logModel;

+ (NSArray<GWLogModel *> *)queryLogsWithParam:(GWQueryLogModel *)param;


@end
