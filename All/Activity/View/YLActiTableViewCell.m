//
//  YLActiTableViewCell.m
//  hdcy
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActiTableViewCell.h"

@implementation YLActiTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self configUI];
    }
    return self;
}

-(void)configUI
{
//背景图
    self.backImageView=[[UIImageView alloc]init];
    [self.contentView addSubview:self.backImageView];
    
    UIBlurEffect *backblur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *backeffectview = [[UIVisualEffectView alloc] initWithEffect:backblur];
    backeffectview.alpha = 0.5;
    backeffectview.frame =CGRectMake(0, 0, 435*SCREEN_MUTI, 225*SCREEN_MUTI);
    [self.backImageView addSubview:backeffectview];
    
//
    self.titleLabel=[[UILabel alloc]init];
    self.titleLabel.font=FONT_BOLD_BIG;
    self.titleLabel.textAlignment=1;
    self.titleLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
//
    self.placeLabel=[[UILabel alloc]init];
    self.placeLabel.font=FONT_SYS_NORMAL;
    self.placeLabel.textAlignment=NSTextAlignmentRight;
    self.placeLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.placeLabel];
//
    
    self.inclineLabel=[[UILabel alloc]init];
    self.inclineLabel.font=FONT_SYS_NORMAL;
    self.inclineLabel.textColor=[UIColor whiteColor];
    self.inclineLabel.text=@"/";
    [self.contentView addSubview:self.inclineLabel];
    
//
    self.timeLabel=[UILabel new];
    self.timeLabel.font=FONT_SYS_NORMAL;
    self.timeLabel.textAlignment=0;
    self.timeLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.timeLabel];
//
    self.endImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 90, 90)];
    self.endImageView.hidden=YES;
    self.endImageView.image=[UIImage imageNamed:@"组-13@2x"];
    [self.contentView addSubview:self.endImageView];
 
    self.sponsorLabel=[UILabel new];
    self.sponsorLabel.font=FONT_SYS_NORMAL;
    self.sponsorLabel.textAlignment=0;
    self.sponsorLabel.textColor=[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7];
    [self.contentView addSubview:self.sponsorLabel];
    
    self.sponsorImage=[[UIImageView alloc]init];
    [self.contentView addSubview:self.sponsorImage];
    
    self.backImageView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .bottomEqualToView(self.contentView);
    
    self.titleLabel.sd_layout
    .topSpaceToView(self.contentView,79*SCREEN_MUTI)
    .rightSpaceToView(self.contentView,0)
    .autoHeightRatio(0)
    .leftSpaceToView(self.contentView,0);
    
    self.inclineLabel.sd_layout
    .topSpaceToView(self.titleLabel,19*SCREEN_MUTI);
    [self.inclineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 15));
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-86*SCREEN_MUTI);
    }];
    
    self.timeLabel.sd_layout
    .topEqualToView(self.inclineLabel)
    .autoHeightRatio(0)
    .leftSpaceToView(self.inclineLabel,2)
    .rightSpaceToView(self.contentView,5);
    
    self.placeLabel.sd_layout
    .topEqualToView(self.inclineLabel)
    .autoHeightRatio(0)
    .leftSpaceToView(self.contentView,5)
    .rightSpaceToView(self.timeLabel,10);
    
    self.sponsorLabel.sd_layout
    .bottomSpaceToView(self.contentView,7)
    .rightSpaceToView(self.contentView,12)
    .heightIs(16);

    self.sponsorImage.sd_layout
    .rightSpaceToView(self.sponsorLabel,2)
    .bottomSpaceToView(self.contentView,7)
    .widthIs(16)
    .heightIs(16);
}


-(void)setModel:(YLActivityListContentModel *)model
{
    _model=model;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    self.titleLabel.text=model.name;
    self.placeLabel.text=model.address;
    
    if (model.startTime.integerValue/1000-nowtimeStr.integerValue>60*60*24*3) {
        self.timeLabel.text=[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue/1000]];
    }else{
    
    }
    
    self.sponsorLabel.text=model.sponsorName;
    [self.sponsorImage sd_setImageWithURL:[NSURL URLWithString:model.sponsorImage]];
    CGSize size = CGSizeMake(MAXFLOAT, 14);
    CGSize sponsorLabelSize = [model.sponsorName boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:FONT_SYS(14)}
                                              context:nil].size;
    self.sponsorLabel.sd_layout
    .widthIs(sponsorLabelSize.width);
}

@end
