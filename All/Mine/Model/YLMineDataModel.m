//
//  YLMineDataModel.m
//  hdcy
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLMineDataModel.h"

@implementation YLMineDataModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}
@end
