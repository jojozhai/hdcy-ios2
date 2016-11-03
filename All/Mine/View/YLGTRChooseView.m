//
//  YLGTRChooseView.m
//  hdcy
//
//  Created by mac on 16/10/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLGTRChooseView.h"

@implementation YLGTRChooseView

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
    topBackImageVIew.image=[UIImage imageNamed:@"interest_choose@2x"];
    [self addSubview:topBackImageVIew];
    
    UILabel *questionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 45*SCREEN_MUTI, 315*SCREEN_MUTI, 18)];
    questionLabel.text=@"此选项为高富帅专享，你配吗？";
    questionLabel.textColor=[UIColor whiteColor];
    questionLabel.font=FONT_BOLD(15);
    questionLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:questionLabel];
    
    UIButton *yesButton=[UIButton buttonWithType:UIButtonTypeCustom];
    yesButton.backgroundColor=[UIColor whiteColor];
    [yesButton setTitle:@"任性选择" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yesButton.frame=CGRectMake(0, 148*SCREEN_MUTI, 157*SCREEN_MUTI, 102*SCREEN_MUTI);
    yesButton.tag=601;
    [yesButton addTarget:self action:@selector(yesAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yesButton];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(157*SCREEN_MUTI, 150*SCREEN_MUTI, 1*SCREEN_MUTI, 100*SCREEN_MUTI)];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self addSubview:lineLabel];
    
    UIButton *noButton=[UIButton buttonWithType:UIButtonTypeCustom];
    noButton.backgroundColor=[UIColor whiteColor];
    [noButton setTitle:@"屌丝飘过" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    noButton.frame=CGRectMake(158*SCREEN_MUTI, 148*SCREEN_MUTI, 157*SCREEN_MUTI, 102*SCREEN_MUTI);
    noButton.tag=602;
    [noButton addTarget:self action:@selector(noAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noButton];
}

-(void)yesAction:(UIButton *)btn
{
    [_delegate isDeserveButton:btn.tag-600];
}

-(void)noAction:(UIButton *)btn
{
    [_delegate isDeserveButton:btn.tag-600];
}
@end
