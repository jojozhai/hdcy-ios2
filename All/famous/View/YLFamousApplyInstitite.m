//
//  YLFamousApplyInstitite.m
//  hdcy
//
//  Created by mac on 16/10/25.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousApplyInstitite.h"

@implementation YLFamousApplyInstitite

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
    UIImageView *topBackImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 315*SCREEN_MUTI, 189*SCREEN_MUTI)];
    topBackImageVIew.image=[UIImage imageNamed:@"famous_apply_back"];
    [self addSubview:topBackImageVIew];
    
    UIImageView *logoImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(108*SCREEN_MUTI, 17*SCREEN_MUTI, 100*SCREEN_MUTI, 114*SCREEN_MUTI)];
    logoImageVIew.image=[UIImage imageNamed:@"iconfont-shenghuodaka"];
    [topBackImageVIew addSubview:logoImageVIew];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 145*SCREEN_MUTI, 315*SCREEN_MUTI, 25*SCREEN_MUTI)];
    nameLabel.text=@"机构申请";
    nameLabel.font=FONT_BOLD(20);
    nameLabel.textColor=[UIColor whiteColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    [topBackImageVIew addSubview:nameLabel];
    
    UILabel *mannerLabel=[[UILabel alloc]initWithFrame:CGRectMake(74*SCREEN_MUTI, 215*SCREEN_MUTI, 200*SCREEN_MUTI, 15)];
    mannerLabel.text=@"请通过以下方式与我们联系";
    mannerLabel.font=FONT_SYS(14);
    mannerLabel.textColor=[UIColor blackColor];
    mannerLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:mannerLabel];
    
    UILabel *phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(74*SCREEN_MUTI, 240*SCREEN_MUTI, 45, 20*SCREEN_MUTI)];
    phoneLabel.font=FONT_BOLD(16);
    phoneLabel.text=@"电话:";
    phoneLabel.textColor=[UIColor grayColor];
    phoneLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:phoneLabel];
    
    self.phoneNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(125*SCREEN_MUTI, 240*SCREEN_MUTI, 180*SCREEN_MUTI, 20*SCREEN_MUTI)];
    self.phoneNumLabel.font=FONT_BOLD(16);
    self.phoneNumLabel.textColor=[UIColor blackColor];
    self.phoneNumLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.phoneNumLabel];
    
    UILabel *mailLabel=[[UILabel alloc]initWithFrame:CGRectMake(74*SCREEN_MUTI, 270*SCREEN_MUTI, 45, 20*SCREEN_MUTI)];
    mailLabel.font=FONT_BOLD(16);
    mailLabel.text=@"邮箱:";
    mailLabel.textColor=[UIColor grayColor];
    mailLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:mailLabel];
    
    self.mailNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(125*SCREEN_MUTI, 270*SCREEN_MUTI, 180*SCREEN_MUTI, 40*SCREEN_MUTI)];
    self.mailNumLabel.numberOfLines=0;
    self.mailNumLabel.font=FONT_BOLD(16);
    self.mailNumLabel.textColor=[UIColor blackColor];
    self.mailNumLabel.textAlignment=NSTextAlignmentLeft;
    [self addSubview:self.mailNumLabel];
}

@end
