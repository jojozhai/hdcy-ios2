//
//  YLPersonInfoImageTableViewCell.m
//  hdcy
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLPersonInfoImageTableViewCell.h"

@implementation YLPersonInfoImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.urlImageView.layer.cornerRadius=25;
    self.urlImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
