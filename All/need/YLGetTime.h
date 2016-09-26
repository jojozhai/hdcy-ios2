//
//  YLGetTime.h
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLGetTime : NSObject

/**
 *  获取时间
 *  @return NSString精确到秒
 */
+(NSString *)getTime;
/**
 *  时间转换年月日
 */
+(NSString *)getYYMMDDWithDate:(NSDate *)date;
+(NSString *)getYYMMDDWithDate2:(NSDate *)date;
+(NSString *)getYYMMDDHHMMWithDate:(NSDate *)date;
/**
 *  转换字符串时间到显示时间
 *
 *  @param timeString 14xxxxx格式字符串
 *
 *  @return 显示字符串
 
 */
+(NSString *)getTimeFromTimeString:(NSString *)timeString;

+(NSString *)getTimeWithSice1970TimeString:(NSString *)timeString;

@end
