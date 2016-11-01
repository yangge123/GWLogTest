//
//  GWLogModel.h
//  Holoera
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWLogModel : NSObject

@property (nonatomic,copy)NSString *softVersion;

@property (nonatomic,assign) NSInteger logCreatTime;

@property (nonatomic,assign)int logType; // 0 异常 1 普通打印  2 网络数据打印

@property (nonatomic,copy) NSString *logMsg;

@property (nonatomic,copy) NSString *fileMsg; //文件的信息，包括输出log的当前类和当前行

@end
