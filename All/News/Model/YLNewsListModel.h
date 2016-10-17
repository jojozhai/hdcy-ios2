//
//  YLNewsListModel.h
//  hdcy
//
//  Created by mac on 16/8/10.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLNewsListModel : JSONModel
//创建时间
@property (nonatomic,copy)NSString *createTime;
//是否置顶
@property (nonatomic,strong)NSNumber *top;
//标题
@property (nonatomic,copy)NSString *title;
//阅读量
@property (nonatomic,strong)NSNumber *readCount;
//图片
@property (nonatomic,copy)NSString *image;
//分类的ID，通过资讯分类接口获取
@property (nonatomic,copy)NSString *tagID;
//资讯ID
@property (nonatomic,copy)NSString *Id;
//评论数
@property (nonatomic,strong)NSNumber *commentCount;

@property (nonatomic,strong)NSArray *tagInfos;

@property (nonatomic,strong)NSNumber *business;

@property (nonatomic,copy)NSString *displayType;

@property (nonatomic,assign)BOOL linkOut;

@property (nonatomic,copy)NSString *outLink;
@end
