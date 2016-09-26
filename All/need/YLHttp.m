//
//  YLHttp.m
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLHttp.h"

@implementation YLHttp


+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure {
 
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 15;
    
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id response = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  // 网络请求失败
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)get:(NSString *)url userName:(NSString *)name passeword:(NSString *)password params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setAuthorizationHeaderFieldWithUsername:name password:password];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.requestSerializer.timeoutInterval = 15;
    // 2.发送请求
    [mgr GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id responsedict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(responsedict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  // 网络请求失败
        
        
        if (failure) {
            failure(error);
        }
    }];
    
    
}


+ (void)post:(NSString *)url params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure {
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];  // 解析为data
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    //mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    mgr.requestSerializer.timeoutInterval = 15;
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id responseDict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        if (success) {
            success(responseDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  // 网络请求失败
        
        
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)post:(NSString *)url userName:(NSString *)name passeword:(NSString *)password params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer setAuthorizationHeaderFieldWithUsername:name password:password];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];  // 解析为data
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    mgr.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    mgr.requestSerializer.timeoutInterval = 15;
    // 2.发送请求
    [mgr POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        id responseDict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        if (success) {
            success(responseDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  // 网络请求失败
        if([error.domain isEqualToString:NSURLErrorDomain])
            error = [NSError errorWithDomain:@"没有网络连接。" code:-100 userInfo:nil];
        
        if (failure) {
            failure(error);
        }
    }];
    
    
}
+ (void)post:(NSString *)url paramsWithChinese:(NSDictionary *)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure {
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];  // 解析为data
    
    mgr.requestSerializer.timeoutInterval = 15;
    
    NSArray *keys = [params allKeys];
    NSMutableString *mString= [NSMutableString stringWithFormat:@"%@?",url];
    for (NSString *key in keys) {
        NSString *value = params[key];
        [mString appendFormat:@"%@=%@&",key,value];
    }
    [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
    
    NSString *urlStr = [mString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 2.发送请求
    [mgr POST:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(responseDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {  // 网络请求失败
        
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block success:(void(^)(id json))success failure:(void(^)(NSError *error))failure {
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];  // 解析为data
    
    mgr.requestSerializer.timeoutInterval = 15;
    
    NSArray *keys = [params allKeys];
    NSMutableString *mString= [NSMutableString stringWithFormat:@"%@?",url];
    for (NSString *key in keys) {
        NSString *value = params[key];
        [mString appendFormat:@"%@=%@&",key,value];
    }
    [mString deleteCharactersInRange:NSMakeRange(mString.length-1, 1)];
    
    NSString *urlStr = [mString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    // 2.发送请求
    [mgr POST:urlStr parameters:nil constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(responseDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        if (failure) {
            failure(error);
        }
    }];
}


+(void)put:(NSString *)url userName:(NSString *)name passeword:(NSString *)password params:(id)params success:(void(^)(id json))success failure:(void(^)(NSError *error))failure
{
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];  // 解析为data
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 15;
    [mgr PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id response=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(response);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
@end
