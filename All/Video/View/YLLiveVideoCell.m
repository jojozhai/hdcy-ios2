//
//  YLLiveVideoCell.m
//  hdcy
//
//  Created by Nemo on 16/9/13.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLLiveVideoCell.h"

@interface YLLiveVideoCell ()
@property (nonatomic,assign)int second;
@property (nonatomic,assign)int minute;
@property (nonatomic,assign)int hour;
@property (nonatomic, weak)NSTimer *timer;
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
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
            NSDate *datenow = [NSDate date];
            int time=model.startTime.integerValue/1000.0-[datenow timeIntervalSince1970];
            if (time<60*60*24*3) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
                self.hour=time/60/60;
                self.minute=(time-self.hour*60*60)/60;
                self.second=time-self.hour*60*60-self.minute*60;
            }else{
                _subTitleLabel.text=[NSString stringWithFormat:@"#预告#/%@",[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue/1000.0]]];
            }
        }else{
            _subTitleLabel.text = [NSString stringWithFormat:@"#%@#",model.liveState];
        }
    }
    else
    {
        _subTitleLabel.text = [NSString stringWithFormat:@"#视频#"];
    }
}

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }
    
    _subTitleLabel.text = [NSString stringWithFormat:@"#预告#/距离直播开始还有 %ld:%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
