//
//  YLConvertTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLConvertTableViewCell.h"

@interface YLConvertTableViewCell()
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UIImageView *_bigImageView;
    UILabel *_titleLabel;
    UILabel *_beansLabel;
    UILabel *_leftBeanLabel;
}
@end

@implementation YLConvertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self cusCell];
        self.backgroundColor=DarkBGColor;
    }
    return self;
}

-(void)cusCell
{
    UIImageView *upimageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH-24, 50)];
    upimageView.image=[UIImage imageNamed:@"convert_cell_up@2x"];
    [self.contentView addSubview:upimageView];
    
    _bigImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 58, SCREEN_WIDTH-24, 175)];
    [self.contentView addSubview:_bigImageView];
    
    UIImageView *downimageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 233, SCREEN_WIDTH-24, 90)];
    downimageView.image=[UIImage imageNamed:@"convert_cell_down@2x"];
    [self.contentView addSubview:downimageView];
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(22*SCREEN_MUTI, 9, 30, 30)];
    _headImageView.layer.cornerRadius=15;
    _headImageView.layer.masksToBounds=YES;
    [upimageView addSubview:_headImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(62*SCREEN_MUTI, 19, 100, 15)];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=FONT_SYS(15);
    _nameLabel.textAlignment=NSTextAlignmentLeft;
    [upimageView addSubview:_nameLabel];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(24*SCREEN_MUTI, 15, 150, 20)];
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.font=FONT_BOLD(18);
    [downimageView addSubview:_titleLabel];
    
    _beansLabel=[[UILabel alloc]initWithFrame:CGRectMake(24*SCREEN_MUTI, 55, 100*SCREEN_MUTI, 18)];
    _beansLabel.textAlignment=NSTextAlignmentLeft;
    _beansLabel.textColor=[UIColor whiteColor];
    _beansLabel.font=FONT_SYS(15);
    [downimageView addSubview:_beansLabel];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-0.5, 55, 1, 18)];
    lineLabel.backgroundColor=[UIColor whiteColor];
    [downimageView addSubview:lineLabel];
    
    _leftBeanLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+1, 55, 173*SCREEN_MUTI, 18)];
    _leftBeanLabel.textAlignment=NSTextAlignmentCenter;
    _leftBeanLabel.textColor=[UIColor whiteColor];
    _leftBeanLabel.font=FONT_SYS(15);
    [downimageView addSubview:_leftBeanLabel];
}

-(void)setModel:(YLConvertModel *)model
{
    _model=model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.brandImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    _nameLabel.text=model.brand;
    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:model.images[0]] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    _titleLabel.text=model.name;
    _beansLabel.text=[NSString stringWithFormat:@"%@友豆",model.beans];
    _leftBeanLabel.text=[NSString stringWithFormat:@"剩余%@个",model.stock];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
