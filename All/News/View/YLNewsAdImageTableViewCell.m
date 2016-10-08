//
//  YLNewsAdImageTableViewCell.m
//  hdcy
//
//  Created by mac on 16/9/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLNewsAdImageTableViewCell.h"

@implementation YLNewsAdImageTableViewCell
 
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cusCell];
    }
    return self;
}

-(void)cusCell
{
    self.showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 302*SCREEN_MUTI)];
    [self.contentView addSubview:self.showImageView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 143*SCREEN_MUTI, SCREEN_WIDTH, 50*SCREEN_MUTI)];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.tintAdjustmentMode=NSTextAlignmentCenter;
    self.titleLabel.font=FONT_BOLD(20);
    self.titleLabel.numberOfLines=0;
    [self.contentView addSubview:self.titleLabel];
    
    UILabel *adLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 250*SCREEN_MUTI, 30, 20)];
    adLabel.textColor=[UIColor whiteColor];
    adLabel.textAlignment=NSTextAlignmentCenter;
    adLabel.text=@"广告";
    adLabel.font=FONT_SYS_ANNOTATE;
    [self.contentView addSubview:adLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
