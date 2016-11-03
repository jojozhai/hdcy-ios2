//
//  YLActivityInfoHeaderView.m
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityInfoHeaderView.h"

@implementation YLActivityInfoHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

-(void)createView
{
    self.infoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 0, 0)];
    [self addSubview:self.infoImageView];
    
    self.titleLabel=[UILabel new];
    self.titleLabel.textColor=[UIColor blackColor];
    self.titleLabel.font=FONT_BOLD(16);
    [self addSubview:self.titleLabel];
    
    self.ylbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    self.ylbutton.titleLabel.font=[UIFont systemFontOfSize:12];
    [self addSubview:self.ylbutton];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, self.height-1, SCREEN_WIDTH-20, 1)];
    lineLabel.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    self.infoImageView.sd_layout
    .leftSpaceToView(self,12)
    .topSpaceToView(self,14)
    .widthIs(20)
    .heightIs(20);
    
    
    self.titleLabel.sd_layout
    .leftSpaceToView(self.infoImageView,8)
    .topSpaceToView(self,16)
    .bottomSpaceToView(self,16)
    .widthIs(100);
    
    self.ylbutton.sd_layout
    .topSpaceToView(self,2)
    .rightSpaceToView(self,12)
    .bottomSpaceToView(self,2);
    
}
@end
