//
//  YLConsultRightTableViewCell.m
//  hdcy
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLConsultRightTableViewCell.h"

@implementation YLConsultRightTableViewCell

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
    self.headerImageVIew=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-37, 16, 32, 25)];
//    self.headerImageVIew.layer.cornerRadius=12.5;
//    self.headerImageVIew.layer.masksToBounds=YES;
    self.headerImageVIew.image=[UIImage imageNamed:@""];
    [self.contentView addSubview:self.headerImageVIew];
    
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-142, 16, 100, 12)];
    self.nameLabel.text=@"好多车友";
    self.nameLabel.textColor=[UIColor grayColor];
    self.nameLabel.textAlignment=NSTextAlignmentRight;
    self.nameLabel.font=FONT_SYS_ANNOTATE;
    [self.contentView addSubview:self.nameLabel];
}

-(void)setModel:(YLCommentModel *)model
{
    self.headerImageVIew.image=[UIImage imageNamed:@"hdcy"];
    self.nameLabel.text=model.createrName;
    
    UIImageView *backImageView=[[UIImageView alloc]init];
    UIImage *bgImage = [[[UIImage imageNamed:@"Blue"] stretchableImageWithLeftCapWidth:100 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    backImageView.image=bgImage;
    [self.contentView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-42);
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
    
    if (self.contentLabel.text.length<8||self.contentLabel.text==nil) {
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-42);
            make.top.equalTo(self.nameLabel.mas_bottom).offset(2);
            make.width.equalTo(@(100));
        }];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
