//
//  YLActivityListContentModel.m
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityListContentModel.h"

@implementation YLActivityListContentModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"id":@"Id"}];
}
@end
