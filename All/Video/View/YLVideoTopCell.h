//
//  YLVideoTopCell.h
//  hdcy
//
//  Created by Nemo on 16/9/16.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLVideoTopModel.h"

@interface YLVideoTopCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) YLVideoTopModel *model;

@end
