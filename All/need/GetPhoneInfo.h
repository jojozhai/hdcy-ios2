//
//  GetPhoneInfo.h
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPhoneInfo : NSObject
+(void)getInfo;
+(NSString *)getDeviceName;
+(NSString *)getPhoneVersion;
+(NSString *)getPhoneModel;
+(NSString *)getAppCurVersion;
+(NSString *)getBaseInfo;
@end
