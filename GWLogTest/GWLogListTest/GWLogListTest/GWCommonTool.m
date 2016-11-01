//
//  GWCommonTool.m
//  GWLogListTest
//
//  Created by yangye on 16/10/31.
//  Copyright © 2016年 gowild. All rights reserved.
//

#import "GWCommonTool.h"

@implementation GWCommonTool

/**
 *  日期转换
 *  @param date   日期
 *  @param format 格式化
 */
+ (NSString *)dateToNSString:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

/**
 *  字符串转为日期
 */
+ (NSDate *)stringToDate:(NSString *)str format:(NSString *)format
{
    NSDateFormatter *formatter =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
    [formatter setTimeZone:timeZone];
    
    NSDate *date = [formatter dateFromString:str];
    
    return date;
}

@end
