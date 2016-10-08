//
//  YLCommentTableViewCell.h
//  hdcy
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLCommentModel.h"
//点label回复
@protocol  clickLabelWithIndexPathAndIndexDelegate<NSObject>
-(void)clickLabelWithIndexPath:(NSIndexPath*)indexPath Index:(NSInteger)index;
@end
//点击更多，显示更多回复
@protocol clickMoreDelegate <NSObject>
-(void)refreshUIWithIndexPath:(NSIndexPath *)indexPath;
@end
@interface YLCommentTableViewCell : UITableViewCell
 
/**
 *  用户头像imageview
 */
@property (nonatomic,strong) UIImageView *userHeaderImage;

/**
 *  用户昵称label
 */
@property (nonatomic,strong) UILabel *userNameLbl;

/**
 *  时间label
 */
@property (nonatomic,strong) UILabel *timeLable;

/**
 *点赞
 */
@property (nonatomic,strong)UIButton *praiseButton;

@property (nonatomic,strong)UILabel *contentLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic,strong)YLCommentModel *model;

@property (nonatomic,assign)id<clickLabelWithIndexPathAndIndexDelegate>delegate;
@property (nonatomic,assign)id<clickMoreDelegate>mDelegate;

@property (nonatomic,assign)BOOL isOpen;
@end
