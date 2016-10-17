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
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(32, 145, 120, 16)];
    self.nameLabel.textColor=[UIColor whiteColor];
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=FONT_BOLD(14);
    [self addSubview:self.nameLabel];
    
    UIImageView *clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 173, 22, 22)];
    clockImageView.layer.cornerRadius=11;
    clockImageView.layer.masksToBounds=YES;
    clockImageView.image=[UIImage imageNamed:@"iconfont-shijian"];
    [self addSubview:clockImageView];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 173, 120, 16)];
    self.nameLabel.textColor=RGBCOLOR(0, 254, 252);
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=FONT_BOLD(14);
    [self addSubview:self.timeLabel];
}
@end
