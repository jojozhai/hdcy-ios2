//
//  YLFamousListTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousListTableViewCell.h"

@implementation YLFamousListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=BGColor;
        [self customRect];
    }
    return self;
}

-(void)customRect
{
    self.mainImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 8, SCREEN_WIDTH/2, 100)];
    [self.contentView addSubview:self.mainImageView];
    
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 8, SCREEN_WIDTH/2, 100)];
    backImageView.image=[UIImage imageNamed:@"content-jianbian-"];
    [self.contentView addSubview:backImageView];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 33, 120, 15)];
    self.nameLabel.textColor=[UIColor whiteColor];
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=FONT_BOLD(13);
    [backImageView addSubview:self.nameLabel];
    
    self.introLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 53, 164*SCREEN_MUTI, 40)];
    self.introLabel.textColor=[UIColor whiteColor];
    self.introLabel.numberOfLines=0;
    self.introLabel.textAlignment=NSTextAlignmentLeft;
    self.introLabel.font=FONT_SYS_ANNOTATE;
    [backImageView addSubview:self.introLabel];
}

-(void)setModel:(YLFamousTopModel *)model
{
    _model=model;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:model.topImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    self.nameLabel.text=model.name;
    self.introLabel.text=model.slogan;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
