//
//  YLInLetterTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLInLetterTableViewCell.h"

@interface YLInLetterTableViewCell ()
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_detailLabel;
    UILabel *_timeLabel;
}
@end

@implementation YLInLetterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(12, 13, 44, 44)];
        _headImageView.layer.cornerRadius=22;
        _headImageView.layer.masksToBounds=YES;
        [self.contentView addSubview:_headImageView];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(68, 20, 100, 15)];
        _nameLabel.textColor=[UIColor whiteColor];
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        _nameLabel.font=FONT_SYS(14);
        [self.contentView addSubview:_nameLabel];
        
        _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(68, 42, 200, 12)];
        _detailLabel.textColor=[UIColor grayColor];
        _detailLabel.textAlignment=NSTextAlignmentLeft;
        _detailLabel.font=FONT_SYS(11);
        [self.contentView addSubview:_detailLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-80, 19, 68, 12)];
        _timeLabel.textColor=[UIColor grayColor];
        _timeLabel.textAlignment=NSTextAlignmentLeft;
        _timeLabel.font=FONT_SYS(11);
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

-(void)setDict:(NSDictionary *)dict
{
    _dict=dict;
    _headImageView.image=[UIImage imageNamed:dict[@"image"]];
    _nameLabel.text=dict[@"name"];
    _detailLabel.text=dict[@"detail"];
    _timeLabel.text=@"11-01";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
