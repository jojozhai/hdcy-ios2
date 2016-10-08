//
//  YLCommentModel.m
//  hdcy
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLCommentModel.h"

@implementation YLCommentModel
+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}

 

@end


@implementation YLCommentReplyModel

+(JSONKeyMapper *)keyMapper{
    return  [[JSONKeyMapper alloc]initWithDictionary:@{@"id":@"Id"}];
}

@end