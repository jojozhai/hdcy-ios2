//
//  GetPhoneInfo.m
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "GetPhoneInfo.h"

@implementation GetPhoneInfo
+(void)getInfo{

    //手机别名： 用户定义的名称
    NSString* userPhoneName = [[UIDevice currentDevice] name];
    logdebug(@"手机别名: %@", userPhoneName);
    //设备名称
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    logdebug(@"设备名称: %@",deviceName );
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    logdebug(@"手机系统版本: %@", phoneVersion);
    //手机型号
    NSString* phoneModel = [[UIDevice currentDevice] model];
    logdebug(@"手机型号: %@",phoneModel );
    //地方型号  （国际化区域名称）
    NSString* localPhoneModel = [[UIDevice currentDevice] localizedModel];
    logdebug(@"国际化区域名称: %@",localPhoneModel );
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // 当前应用名称
    NSString *appCurName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    logdebug(@"当前应用名称：%@",appCurName);
    // 当前应用软件版本  比如：1.0.1
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    logdebug(@"当前应用软件版本:%@",appCurVersion);
    // 当前应用版本号码   int类型
    NSString *appCurVersionNum = [infoDictionary objectForKey:@"CFBundleVersion"];
    logdebug(@"当前应用版本号码：%@",appCurVersionNum);
    //UUID
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuidString);
    
    logdebug(@"UUID:%@",result);
}
+(NSString *)getDeviceName{
    return [[UIDevice currentDevice] systemName];
}
+(NSString *)getPhoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}
+(NSString *)getPhoneModel{
    return [[UIDevice currentDevice] model];
}
+(NSString *)getAppCurVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
+ (NSString *)getBaseInfo{
    NSString *model = [[UIDevice currentDevice]model];
    NSString *localModel = [[UIDevice currentDevice]localizedModel];
    NSString *system = [[UIDevice currentDevice]systemName];
    NSString *sysVer = [[UIDevice currentDevice]systemVersion];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    NSString *appVer = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    NSString *returnStr = [NSString stringWithFormat:@"设备:%@-%@\n系统:%@-%@\n应用:%@-%@",model,localModel,system,sysVer,appName,appVer];
    
    return returnStr;
}
@end
