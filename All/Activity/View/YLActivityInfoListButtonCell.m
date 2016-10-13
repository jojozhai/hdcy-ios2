//
//  YLActivityInfoListButtonCell.m
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityInfoListButtonCell.h"

@implementation YLActivityInfoListButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.myImageView.layer.cornerRadius=12;
    self.myImageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
