//
//  YLActivityOffInfoModel.m
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityOffInfoModel.h"

@implementation YLActivityOffInfoModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}
 
@end
