//
//  YLActiConsultTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLActiConsultTableViewCell.h"

@implementation YLActiConsultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
    self.headerImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(12, 16, 25, 25)];
    self.headerImageVIew.layer.cornerRadius=12.5;
    self.headerImageVIew.layer.masksToBounds=YES;
    [self.contentView addSubview:self.headerImageVIew];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(42, 16, 200, 12)];
    self.nameLabel.textColor=[UIColor grayColor];
    self.nameLabel.textAlignment=NSTextAlignmentLeft;
    self.nameLabel.font=FONT_SYS_ANNOTATE;
    [self.contentView addSubview:self.nameLabel];
    
}

-(void)setModel:(YLCommentModel *)model
{
    [self.headerImageVIew sd_setImageWithURL:[NSURL URLWithString:model.createrHeadimgurl]];
    self.nameLabel.text=model.createrName;

    UIImageView *backImageView=[[UIImageView alloc]init];
    UIImage *bgImage = [[[UIImage imageNamed:@"White"] stretchableImageWithLeftCapWidth:100 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    backImageView.image=bgImage;
    [self.contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(42);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
    }];
    
    self.contentLabel=[[UILabel alloc]init];
    self.contentLabel.text=model.content;
    self.contentLabel.textColor=[UIColor blackColor];
    CGSize constrained=CGSizeMake(200, 1000);
    self.contentLabel.font=FONT_SYS(13);
    CGSize labelsize = [self.contentLabel.text boundingRectWithSize:constrained options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.contentLabel.font} context:nil].size;
    self.contentLabel.frame=CGRectMake(23, 8, labelsize.width, labelsize.height);
    self.contentLabel.numberOfLines=0;
    [backImageView addSubview:self.contentLabel];
    
    self.timeLabel=[UILabel new];
    self.timeLabel.text=[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:model.createdTime.integerValue/1000]];
    self.timeLabel.textColor=[UIColor grayColor];
    self.timeLabel.textAlignment=NSTextAlignmentRight;
    self.timeLabel.font=FONT_SYS(11);
    [backImageView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).with.offset(8);
        make.bottom.equalTo(backImageView.mas_bottom).with.offset(-7);
        make.right.equalTo(self.contentLabel.mas_right);
        make.right.equalTo(backImageView.mas_right).with.offset(-22);
        
    }];
    
    if (self.contentLabel.text.length<8) {
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(42);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
            make.width.equalTo(@(120));
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
