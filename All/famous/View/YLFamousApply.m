//
//  YLFamousApply.m
//  hdcy
//
//  Created by mac on 16/10/25.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousApply.h"

@implementation YLFamousApply

-(id)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame]) {
        [self customeRect];
        self.layer.cornerRadius=15;
        self.layer.masksToBounds=YES;
    }
    return self;
}

-(void)customeRect
{
    UIImageView *topBackImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 315*SCREEN_MUTI, 148*SCREEN_MUTI)];
    topBackImageVIew.image=[UIImage imageNamed:@"famous_apply_back"];
    [self addSubview:topBackImageVIew];
    
    UIImageView *logoImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100*SCREEN_MUTI, 114*SCREEN_MUTI)];
    logoImageVIew.center=topBackImageVIew.center;
    logoImageVIew.image=[UIImage imageNamed:@"iconfont-shenghuodaka"];
    [topBackImageVIew addSubview:logoImageVIew];
    
    UIButton *personalApplyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    personalApplyButton.backgroundColor=[UIColor whiteColor];
    [personalApplyButton setTitle:@"个人申请" forState:UIControlStateNormal];
    [personalApplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    personalApplyButton.frame=CGRectMake(0, 148*SCREEN_MUTI, 157*SCREEN_MUTI, 102*SCREEN_MUTI);
    personalApplyButton.tag=601;
    [personalApplyButton addTarget:self action:@selector(personApply:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:personalApplyButton];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(157*SCREEN_MUTI, 150*SCREEN_MUTI, 1*SCREEN_MUTI, 100*SCREEN_MUTI)];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self addSubview:lineLabel];
    
    UIButton *instituteApplyButton=[UIButton buttonWithType:UIButtonTypeCustom];
    instituteApplyButton.backgroundColor=[UIColor whiteColor];
    [instituteApplyButton setTitle:@"机构申请" forState:UIControlStateNormal];
    [instituteApplyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    instituteApplyButton.frame=CGRectMake(158*SCREEN_MUTI, 148*SCREEN_MUTI, 157*SCREEN_MUTI, 102*SCREEN_MUTI);
    instituteApplyButton.tag=602;
    [instituteApplyButton addTarget:self action:@selector(instituteApply:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:instituteApplyButton];
}

-(void)personApply:(UIButton *)btn
{
    [_delegate applyButton:btn.tag-600];
}

-(void)instituteApply:(UIButton *)btn
{
    [_delegate applyButton:btn.tag-600];
}
@end
