//
//  YLVideoTopCell.m
//  hdcy
//
//  Created by Nemo on 16/9/16.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLVideoTopCell.h"
#import "YLVideoTopModel.h"
@interface YLVideoTopCell ()

@end

@implementation YLVideoTopCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_iconView];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 87, frame.size.width, 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.origin.y + _titleLabel.frame.size.height+19, frame.size.width, 30)];
        [_subTitleLabel setTextColor:[UIColor whiteColor]];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_subTitleLabel];
        
    }
    return self;
}
- (void)setModel:(YLVideoTopModel *)model
{
    _titleLabel.text = model.name;
    _subTitleLabel.text = @"";
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.image]];
 
}

@end
