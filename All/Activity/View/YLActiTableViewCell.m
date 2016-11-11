//
//  YLActiTableViewCell.m
//  hdcy
//
//  Created by mac on 16/8/22.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActiTableViewCell.h"

@interface YLActiTableViewCell ()
@property (nonatomic,assign)int second;
@property (nonatomic,assign)int minute;
@property (nonatomic,assign)int hour;
@property (nonatomic, weak)NSTimer *timer;
@end

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
    
    self.countTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 225*SCREEN_MUTI-60*SCREEN_MUTI, SCREEN_WIDTH, 20)];
    self.countTimeLabel.font=FONT_SYS_NORMAL;
    self.countTimeLabel.textAlignment=1;
    self.countTimeLabel.textColor=[UIColor whiteColor];
    [self.contentView addSubview:self.countTimeLabel];
//
    self.endImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 90, 90)];
    self.endImageView.hidden=YES;
    self.endImageView.image=[UIImage imageNamed:@"iconfont-yijieshu"];
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
    .topSpaceToView(self.titleLabel,20*SCREEN_MUTI);
    [self.inclineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(6, 15));
        make.bottom.mas_equalTo(self.contentView.bottom).offset(-86*SCREEN_MUTI);
    }];
    
    self.timeLabel.sd_layout
    .topSpaceToView(self.titleLabel,18*SCREEN_MUTI)
    .autoHeightRatio(0)
    .leftSpaceToView(self.inclineLabel,2)
    .rightSpaceToView(self.contentView,5);
    
    self.placeLabel.sd_layout
    .topSpaceToView(self.titleLabel,18*SCREEN_MUTI)
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
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *datenow = [NSDate date];
    int time=model.signEndTime.integerValue/1000.0-[datenow timeIntervalSince1970];
    
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    self.titleLabel.text=model.name;
    self.placeLabel.text=model.address;
    self.timeLabel.text=[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:model.startTime.integerValue/1000]];
    if (time<60*60*24*3&&time>0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeHeadle) userInfo:nil repeats:YES];
        self.hour=time/60/60;
        self.minute=(time-self.hour*60*60)/60;
        self.second=time-self.hour*60*60-self.minute*60;
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

- (void)timeHeadle{
    
    self.second--;
    if (self.second==-1) {
        self.second=59;
        self.minute--;
        if (self.minute==-1) {
            self.minute=59;
            self.hour--;
        }
    }
    
    self.countTimeLabel.text = [NSString stringWithFormat:@"距离报名截止还有 %ld:%ld:%ld",(long)self.hour,(long)self.minute,(long)self.second];
    if (self.second==0 && self.minute==0 && self.hour==0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
