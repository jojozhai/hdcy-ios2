//
//  YLCommentModel.h
//  hdcy
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLCommentModel : JSONModel
/**
 *  用户内容
 */
@property (nonatomic,copy)NSString<Optional> *content;
//创建时间
@property (nonatomic,copy)NSString<Optional> *createdTime;
/**
 *  用户头像url 此处直接用图片名代替
 */
@property (nonatomic,copy)NSString<Optional> *createrHeadimgurl;
//发post的人
@property (nonatomic,copy)NSString<Optional> *createrId;
/**
 *  用户名
 */
@property (nonatomic,copy)NSString<Optional> *createrName;
//评论ID
@property (nonatomic,copy)NSString<Optional> *Id;
//回复的评论的Id
@property (nonatomic,copy)NSString<Optional> *replyToId;
//回复姓名
@property (nonatomic,copy)NSString<Optional> *replyToName;
//回复数组
@property (nonatomic,strong)NSArray<Optional> *replys;
//评论的目标
@property (nonatomic,copy)NSString<Optional> *target;
//目标对象的id
@property (nonatomic,copy)NSString<Optional> *targetId;
//赞
@property (nonatomic,copy)NSString<Optional> *praiseCount;
 
@end

@interface YLCommentReplyModel : JSONModel
/**
 *同上
 */
@property (nonatomic,copy)NSString<Optional> *target;
@property (nonatomic,copy)NSString<Optional> *targetId;
@property (nonatomic,copy)NSString<Optional> *createrId;
@property (nonatomic,copy)NSString<Optional> *createrName;
@property (nonatomic,copy)NSString<Optional> *createrHeaderimgurl;
@property (nonatomic,copy)NSString<Optional> *replyToId;
@property (nonatomic,copy)NSString<Optional> *replyToName;
@property (nonatomic,copy)NSString<Optional> *content;
@property (nonatomic,copy)NSString<Optional> *praise;
@property (nonatomic,copy)NSString<Optional> *praiseCount;
@property (nonatomic,copy)NSString<Optional> *Id;
@property (nonatomic,copy)NSString<Optional> *createdTime;

@property (nonatomic, copy) NSAttributedString<Optional> *attributedContent;

@end
