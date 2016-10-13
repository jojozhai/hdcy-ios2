//
//  YLConsultRightTableViewCell.h
//  hdcy
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLCommentModel.h"
@interface YLConsultRightTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *headerImageVIew;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)YLCommentReplyModel *model;
@end
