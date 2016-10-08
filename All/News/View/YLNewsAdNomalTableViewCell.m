//
//  YLNewsAdNomalTableViewCell.m
//  hdcy
//
//  Created by mac on 16/9/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLNewsAdNomalTableViewCell.h"

@implementation YLNewsAdNomalTableViewCell

 
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
    self.showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 190*SCREEN_MUTI)];
    [self.contentView addSubview:self.showImageView];
    
    UIImageView *hideImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 190*SCREEN_MUTI, SCREEN_WIDTH, 112*SCREEN_MUTI)];
    hideImageView.image=[UIImage imageNamed:@"news_cell_backImage"];
    [self.contentView addSubview:hideImageView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 20*SCREEN_MUTI, SCREEN_WIDTH-24, 40*SCREEN_MUTI)];
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.font=FONT_SYS_TITTLE;
    self.titleLabel.numberOfLines=0;
    [hideImageView addSubview:self.titleLabel];
    
    UILabel *adLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 85*SCREEN_MUTI, 30, 20)];
    adLabel.textColor=[UIColor grayColor];
    adLabel.textAlignment=NSTextAlignmentCenter;
    adLabel.text=@"广告";
    adLabel.font=FONT_SYS_ANNOTATE;
    [hideImageView addSubview:adLabel];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
