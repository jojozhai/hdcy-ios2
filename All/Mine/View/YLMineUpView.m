//
//  YLMineUpView.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMineUpView.h"
@interface YLMineUpView ()
{
    UILabel *_detailLabel;
}
@end
@implementation YLMineUpView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self customView];
    }
    return self;
}

-(void)customView
{
    UIImageView *upBackImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    upBackImageVIew.image=[UIImage imageNamed:@"jianbain-2"];
    [self addSubview:upBackImageVIew];
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(142*SCREEN_MUTI, 35*SCREEN_MUTI, 90*SCREEN_MUTI, 90*SCREEN_MUTI)];
    _headImageView.layer.cornerRadius=45;
    _headImageView.layer.masksToBounds=YES;
    [self addSubview:_headImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 145*SCREEN_MUTI, SCREEN_WIDTH, 20)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.textAlignment=NSTextAlignmentCenter;
    _nameLabel.font=FONT_BOLD(15);
    [self addSubview:_nameLabel];
    
    _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 185*SCREEN_MUTI, SCREEN_WIDTH, 15)];
    _detailLabel.textColor=[UIColor whiteColor];
    _detailLabel.textAlignment=NSTextAlignmentCenter;
    _detailLabel.font=FONT_SYS(12);
    [self addSubview:_detailLabel];
}

-(void)setUserDictionary:(NSDictionary *)userDictionary
{
    _userDictionary=userDictionary;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:userDictionary[@"headimgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    _nameLabel.text=userDictionary[@"nickname"];
    if ([userDictionary[@"level"] isKindOfClass:[NSNull class]]) {
        _detailLabel.text=[NSString stringWithFormat:@"等级: lv%@ ｜ 积分: %@ ｜ 友豆: %@",@"1",userDictionary[@"point"],userDictionary[@"beans"]];
    }else{
        _detailLabel.text=[NSString stringWithFormat:@"等级: lv%@ ｜ 积分: %@ ｜ 友豆: %@",userDictionary[@"level"],userDictionary[@"point"],userDictionary[@"beans"]];
    }
}

@end
