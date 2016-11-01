//
//  GWCommonTool.h
//  GWLogListTest
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface GWCommonTool : NSObject

+ (NSString *)dateToNSString:(NSDate *)date format:(NSString *)format;

+ (NSDate *)stringToDate:(NSString *)str format:(NSString *)format;


@end
