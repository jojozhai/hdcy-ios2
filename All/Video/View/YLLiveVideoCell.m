//
//  YLLiveVideoCell.m
//  hdcy
//
//  Created by Nemo on 16/9/13.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLLiveVideoCell.h"

@interface YLLiveVideoCell ()

@end

@implementation YLLiveVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _iconView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        [self.contentView addSubview:_iconView];
        
        UIBlurEffect *backblur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *backeffectview = [[UIVisualEffectView alloc] initWithEffect:backblur];
        backeffectview.alpha = 0.5;
        backeffectview.frame =CGRectMake(0, 0, 435*SCREEN_MUTI, 225*SCREEN_MUTI);
        [_iconView addSubview:backeffectview];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setTextColor:[UIColor whiteColor]];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_subTitleLabel];
    
        _iconView.sd_layout
        .leftEqualToView(self.contentView)
        .rightEqualToView(self.contentView)
        .topEqualToView(self.contentView)
        .bottomEqualToView(self.contentView);
        
        _titleLabel.sd_layout
        .topSpaceToView(self.contentView,79*SCREEN_MUTI)
        .rightSpaceToView(self.contentView,0)
        .autoHeightRatio(0)
        .leftSpaceToView(self.contentView,0);
        
        _subTitleLabel.sd_layout
        .topSpaceToView(_titleLabel,19*SCREEN_MUTI)
        .rightSpaceToView(self.contentView,0)
        .autoHeightRatio(0)
        .leftSpaceToView(self.contentView,0);
        
    }
    return self;
}

- (void)setModel:(YLVideoTopModel *)model
{
    
    _titleLabel.text = model.name;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.image]];
    if (model.live.integerValue)
    {
        if ([model.liveState isEqualToString:@"预告"])
        {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm"];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];

            _subTitleLabel.text = [NSString stringWithFormat:@"#预告# %@",[df stringFromDate:[NSDate dateWithTimeIntervalSinceNow:_model.startTime/1000.0]]];
        }else{
            _subTitleLabel.text = [NSString stringWithFormat:@"#%@#",model.liveState];
        }
    }
    else
    {
        _subTitleLabel.text = [NSString stringWithFormat:@"#视频#"];
    }
}



@end
