//
//  YLActivityOffInfoModel.h
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLActivityOffInfoModel : JSONModel
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
//活动地址
@property (nonatomic,copy)NSString<Optional> *address;
//活动介绍
@property (nonatomic,copy)NSString<Optional> *desc;
//是否已经结束
@property (nonatomic,assign)BOOL finish;
//是否在前台显示
@property (nonatomic,assign)BOOL enable;
//活动主办方ID
@property (nonatomic,copy)NSString<Optional> *sponsorId;
//浏览量
@property (nonatomic,copy)NSString<Optional> *browsecal;
//主办方名称
@property (nonatomic,copy)NSString<Optional> *sponsorName;
//吸粉数
@property (nonatomic,copy)NSString<Optional> *fansval;
//活动关键字
@property (nonatomic,strong)NSArray *kwlist;
//权数
@property (nonatomic,copy)NSString<Optional> *weighting;
//电话
@property (nonatomic,copy)NSString<Optional> *contactPhone;
//客服图片
@property (nonatomic,copy)NSString<Optional> *waiterImage;
//客服名字
@property (nonatomic,copy)NSString<Optional> *waiterName;
//微信
@property (nonatomic,copy)NSString<Optional> *contactWeixin;
//限制人数
@property (nonatomic,copy)NSString<Optional> *peopleLimit;
//循环图片
@property (nonatomic,strong)NSArray *images;

@property (nonatomic,copy)NSString<Optional> *customerServiceId;

@property (nonatomic,copy)NSString<Optional> *signEndTime;

@property (nonatomic,copy)NSString<Optional> *price;
@end
