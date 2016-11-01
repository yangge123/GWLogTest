//
//  GWQueryLogModel.h
//  Holoera
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GWQueryLogModel : NSObject

@property (nonatomic,copy)NSString *softVersion;


@property (nonatomic,assign)NSInteger start_time; //起始时间


@property (nonatomic,assign)NSInteger logType;

@end
