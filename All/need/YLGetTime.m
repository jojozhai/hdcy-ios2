//
//  YLGetTime.m
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLGetTime.h"

@implementation YLGetTime

+(NSString *)getTime{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    long long int date = (long long int)time;
    NSString *timeString = [NSString stringWithFormat:@"%lld", date];
    return timeString;
}
+(NSString *)getYYMMDDWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getYYMMDDWithDate2:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getYYMMDDHHMMWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}
+(NSString *)getYYMMDDHHMMWithDate2:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

+(NSString *)getTimeFromTimeString:(NSString *)timeString
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString.doubleValue/1000];
    NSDate *localDate = [NSDate date];
    NSInteger interval = localDate.timeIntervalSince1970 - date.timeIntervalSince1970;
    interval=interval/60/60/24;
    if (interval<1.0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"HH:mm"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        return dateStr;
    }else if(interval<2.0){
        return @"昨天";
    }else if(interval<3.0){
        return @"前天";
    }else{
        
        //日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        
        return dateStr;
    }

    return @"";
}

+(NSString *)getTimeWithSice1970TimeString:(NSString *)timeString{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/1000];
    NSDate *localDate = [NSDate date];
    NSInteger interval = localDate.timeIntervalSince1970 - date.timeIntervalSince1970;
    interval = interval/60;//分钟为单位
    if (interval <= 60) {
        if (interval <= 30) {
            if (interval == 0){
                return @"刚刚";
            }else{
                return [NSString stringWithFormat:@"%ld分钟前",(long)interval];
            }
        }else if (interval > 30){
            return @"半小时前";
        }
    }else{
        interval = interval/60;
        if (interval <= 24) {
            return [NSString stringWithFormat:@"%ld小时前",(long)interval];
        }else{
            
            
            //今年
            NSDate *  senddate=[NSDate date];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"YYYY"];
            
            NSString *  locationString=[dateformatter stringFromDate:senddate];
            
            //日期
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy"];
            NSString *dateStr = [formatter stringFromDate:date];
            
            if ([dateStr isEqualToString:locationString]) {
                
                [formatter setDateFormat:@"MM-dd"];
                dateStr = [formatter stringFromDate:date];
                NSMutableString *mutString = [NSMutableString stringWithFormat:@"%@",dateStr];
                NSString *str = [dateStr substringWithRange:NSMakeRange(3, 1)];
                
                if ([str isEqualToString:@"0"]) {
                    [mutString replaceCharactersInRange:NSMakeRange(3, 1) withString:@""];
                }
                NSString *str2 = [mutString substringWithRange:NSMakeRange(0, 1)];
                
                if ([str2 isEqualToString:@"0"]) {
                    [mutString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
                }
                return mutString;
            }else{
                [formatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [formatter stringFromDate:date];
                return dateStr;
            }
            
            
        }
    }
    
    return @"";
}

@end
