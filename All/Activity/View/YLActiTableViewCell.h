//
//  YLActiTableViewCell.h
//  hdcy
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLActivityListContentModel.h"
@interface YLActiTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *placeLabel;
@property (nonatomic,strong)UILabel *inclineLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *endImageView;

@property (nonatomic,strong)YLActivityListContentModel *model;
@end
