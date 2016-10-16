//
//  YLLiveVideoCell.h
//  hdcy
//
//  Created by Nemo on 16/9/13.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLVideoTopModel.h"

@interface YLLiveVideoCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) YLVideoTopModel *model;


@end
