//
//  YLActivityListModel.h
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLActivityListModel : JSONModel
//具体的查询结果数据
@property (nonatomic,strong)NSArray *content;
//当前页是否为最后一页
@property (nonatomic,assign)BOOL last;
//总页数
@property (nonatomic,assign)int totalPages;
//总记录数
@property (nonatomic,assign)long totalElements;
//每页记录数
@property (nonatomic,assign)int size;
//当前页数
@property (nonatomic,assign)int number;
//当前页是否为第一页
@property (nonatomic,assign)BOOL first;
//
@property (nonatomic,strong)NSArray *sort;
//当前页第一个元素在总查询结果的位置
@property (nonatomic,assign)int numberOfElements;
@end
