//
//  YLNewsListNomalTableViewCell.m
//  hdcy
//
//  Created by mac on 16/9/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLNewsListNomalTableViewCell.h"

@implementation YLNewsListNomalTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self cusCell];
    }
    return self;
}

-(void)cusCell{
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

    self.tagLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 85*SCREEN_MUTI, 60, 20)];
    self.tagLabel.backgroundColor=[UIColor grayColor];
    self.tagLabel.textAlignment=NSTextAlignmentCenter;
    self.tagLabel.layer.cornerRadius=10;
    self.tagLabel.layer.masksToBounds=YES;
    self.tagLabel.textColor=[UIColor blackColor];
    self.tagLabel.font=FONT_SYS_ANNOTATE;
    [hideImageView addSubview:self.tagLabel];
    
    self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 85*SCREEN_MUTI, 100, 20)];
    self.timeLabel.textColor=[UIColor whiteColor];
    self.timeLabel.textAlignment=NSTextAlignmentLeft;
    self.timeLabel.font=FONT_SYS_ANNOTATE;
    [hideImageView addSubview:self.timeLabel];
    
    UIImageView *eyeImageView=[[UIImageView alloc]init];
    eyeImageView.image=[UIImage imageNamed:@"content-icon-browse-default"];
    [hideImageView addSubview:eyeImageView];
    
    self.eyeLabel=[[UILabel alloc]init];
    self.eyeLabel.textAlignment=NSTextAlignmentLeft;
    self.eyeLabel.textColor=[UIColor grayColor];
    self.eyeLabel.font=FONT_SYS_ANNOTATE;
    [hideImageView addSubview:self.eyeLabel];
    
    [eyeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hideImageView.top).with.offset(90*SCREEN_MUTI);
        make.size.mas_equalTo(CGSizeMake(20, 12));
        make.right.mas_equalTo(hideImageView.right).with.offset(-50);
        
    }];
    
    [self.eyeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hideImageView.top).with.offset(86*SCREEN_MUTI);
        make.right.mas_equalTo(hideImageView.right).with.offset(-12);
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
