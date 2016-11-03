//
//  YLMyActivityTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMyActivityTableViewCell.h"

@interface YLMyActivityTableViewCell()
{
    UIImageView *_leftImageView;
    UILabel *_titleLabel;
    UILabel *_detailLabel;
    UILabel *_endLabel;
}
@end

@implementation YLMyActivityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    backImageView.image=[UIImage imageNamed:@"jianbian-beijing@2x"];
    [self.contentView addSubview:backImageView];
    
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12*SCREEN_MUTI, 7, 110*SCREEN_MUTI, 80)];
    [self.contentView addSubview:_leftImageView];
    
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(138*SCREEN_MUTI, 7, 220*SCREEN_MUTI, 60)];
    _titleLabel.textColor=[UIColor whiteColor];
    _titleLabel.font=FONT_SYS(16);
    _titleLabel.textAlignment=NSTextAlignmentLeft;
    _titleLabel.numberOfLines=0;
    [self.contentView addSubview:_titleLabel];
    
    _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(138*SCREEN_MUTI, 70,150, 18)];
    _detailLabel.textColor=RGBCOLOR(149, 149, 149);
    _detailLabel.textAlignment=NSTextAlignmentLeft;
    _detailLabel.font=FONT_SYS(13);
    [self.contentView addSubview:_detailLabel];
    
    _endLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-60, 70, 50, 18)];
    _endLabel.textColor=RGBCOLOR(149, 149, 149);
    _endLabel.textAlignment=NSTextAlignmentRight;
    _endLabel.font=FONT_SYS(13);
    [self.contentView addSubview:_endLabel];
}

-(void)setModel:(YLActivityListContentModel *)model
{
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    _titleLabel.text=model.name;
    _detailLabel.text=[NSString stringWithFormat:@"%@/%@",model.address,[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue/1000]]];
                       
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
