//
//  YLConvertModel.m
//  hdcy
//
//  Created by mac on 16/9/11.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLConvertModel.h"

@implementation YLConvertModel
+(JSONKeyMapper *)keyMapper
{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}
@end
