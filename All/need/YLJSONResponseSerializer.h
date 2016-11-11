//
//  YLJSONResponseSerializer.h
//  hdcy
//
//  Created by mac on 16/11/6.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
static NSString * const JSONResponseSerializerWithDataKey = @"body";
static NSString * const JSONResponseSerializerWithBodyKey = @"statusCode";
@interface YLJSONResponseSerializer : AFJSONResponseSerializer

@end
