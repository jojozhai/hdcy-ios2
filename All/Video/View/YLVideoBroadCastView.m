//
//  YLVideoBroadCastView.m
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLVideoBroadCastView.h"

@implementation YLVideoBroadCastView

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, 250)];
    [self addSubview:self.backImageView];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(32, 145, 250, 16)];
    self.nameLabel.textColor=[UIColor whiteColor];
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=FONT_BOLD(14);
    [self addSubview:self.nameLabel];
    
    UIImageView *clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 173, 22, 22)];
    clockImageView.layer.cornerRadius=11;
    clockImageView.layer.masksToBounds=YES;
    clockImageView.image=[UIImage imageNamed:@"iconfont-shijian"];
    [self addSubview:clockImageView];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 175, 220, 16)];
    self.timeLabel.textColor=RGBCOLOR(0, 254, 252);
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=FONT_BOLD(14);
    [self addSubview:self.timeLabel];
    
    self.sponsorImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 210, 30, 30)];
    self.sponsorImageView.layer.cornerRadius=15;
    self.sponsorImageView.layer.masksToBounds=YES;
    [self addSubview:self.sponsorImageView];
    
    self.sponorLabel=[[UILabel alloc]initWithFrame:CGRectMake(54, 210, 60, 30)];
    self.sponorLabel.textColor=RGBCOLOR(0, 254, 252);
    self.sponorLabel.textAlignment=NSTextAlignmentLeft;
    self.sponorLabel.font=FONT_BOLD(14);
    [self addSubview:self.sponorLabel];
}

-(void)setModel:(YLVideoListModel *)model
{
    _model=model;
    self.nameLabel.text=model.name;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd/HH:mm"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    self.timeLabel.text=[NSString stringWithFormat:@"开始时间:%@",[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:model.startTime/1000.0]]];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    [self.sponsorImageView sd_setImageWithURL:[NSURL URLWithString:model.sponsorImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    self.sponorLabel.text=model.sponsorName;
}

@end
