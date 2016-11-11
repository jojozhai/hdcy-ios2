//
//  YLHttp.h
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLHttp : NSObject
/**
 *普通get请求
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 *验证get请求
 */
+(void)get:(NSString *)url token:(NSString *)token params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 *验证post请求
 */
+(void)post:(NSString *)url token:(NSString *)token params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 *普通post请求
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

/**
 * post的参数有中文时,用这个方法
 */
+ (void)post:(NSString *)url paramsWithChinese:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

+(void)post:(NSString *)url bodyparams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**
 *put请求
 */
+(void)put:(NSString *)url token:(NSString *)token params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;
/**
 *上传头像
 */
+(void)postImage:(NSData *)imageData url:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure;

@end
