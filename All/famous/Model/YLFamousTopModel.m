//
//  YLFamousTopModel.m
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousTopModel.h"

@implementation YLFamousTopModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}
@end
