//
//  YLFamousListSecondTableViewCell.h
//  hdcy
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLFamousTopModel.h"
@interface YLFamousListSecondTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *mainImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *introLabel;

@property (nonatomic,strong)YLFamousTopModel *model;
@end
