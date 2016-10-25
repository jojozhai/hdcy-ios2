//
//  YLFamousDetailModel.m
//  hdcy
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousDetailModel.h"

@implementation YLFamousDetailModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}
@end
