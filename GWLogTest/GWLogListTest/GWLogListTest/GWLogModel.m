//
//  GWLogModel.m
//  Holoera
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWLogModel.h"

@implementation GWLogModel

- (instancetype)init
{
    if (self = [super init])
    {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        self.softVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return self;
}


@end
