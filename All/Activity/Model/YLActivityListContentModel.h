//
//  YLActivityListContentModel.h
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLActivityListContentModel : JSONModel
//活动id
@property (nonatomic,copy)NSString<Optional> *Id;
//活动名称
@property (nonatomic,copy)NSString<Optional> *name;
//活动主图
@property (nonatomic,copy)NSString<Optional> *image;
//活动类型
@property (nonatomic,copy)NSString<Optional> *type;
//
@property (nonatomic,copy)NSString<Optional> *sortType;
//
@property (nonatomic,copy)NSString<Optional> *actType;
//活动开始时间（时间戳）
@property (nonatomic,copy)NSString<Optional> *startTime;
//活动结束时间（时间戳）
@property (nonatomic,copy)NSString<Optional> *endTime;
//热度（参与人数）
@property (nonatomic,copy)NSString<Optional> *hot;

@property (nonatomic,copy)NSString<Optional> *hotPlus;
//活动地址
@property (nonatomic,copy)NSString<Optional> *address;

@property (nonatomic,copy)NSString<Optional> *city;

@property (nonatomic,copy)NSString<Optional> *contactPhone;

@property (nonatomic,copy)NSString<Optional> *contactWeixin;
//活动介绍
@property (nonatomic,copy)NSString<Optional> *desc;
//是否已经结束
@property (nonatomic,assign)BOOL finish;
//是否在前台显示
@property (nonatomic,assign)BOOL enable;
//活动主办方ID
@property (nonatomic,copy)NSString<Optional> *sponsorId;
//浏览量
@property (nonatomic,copy)NSString<Optional> *browseval;
//主办方名称
@property (nonatomic,copy)NSString<Optional> *sponsorName;

@property (nonatomic,copy)NSString<Optional> *sponsorImage;
//吸粉数
@property (nonatomic,copy)NSString<Optional> *fansval;
//活动关键字
@property (nonatomic,copy)NSArray<Optional> *kwlist;
//权数
@property (nonatomic,copy)NSString<Optional> *weighting;

@property (nonatomic,copy)NSString<Optional> *peopleLimit;

@property (nonatomic,copy)NSString<Optional> *signStartTime;

@property (nonatomic,copy)NSString<Optional> *signEndTime;

@property (nonatomic,copy)NSString<Optional> *signFinish;
@end
