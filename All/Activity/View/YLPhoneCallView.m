//
//  YLPhoneCallView.m
//  hdcy
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLPhoneCallView.h"
@interface YLPhoneCallView()
@property (nonatomic,strong)UIImageView *waiterImageView;
@property (nonatomic,strong)UILabel *waiterNameLabel;
@property (nonatomic,strong)UILabel *phoneNumLabel;
@end
@implementation YLPhoneCallView


- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self==[super initWithCoder:aDecoder]) {

    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    
}
-(void)customView
{
    UILabel *isCaonsultLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-60, 52)];
    isCaonsultLabel.text=@"是否立即拨打电话进行咨询？";
    isCaonsultLabel.textColor=[UIColor blackColor];
    isCaonsultLabel.textAlignment=NSTextAlignmentCenter;
    isCaonsultLabel.font=FONT_BOLD_BIG;
    [self addSubview:isCaonsultLabel];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 52, SCREEN_WIDTH, 1)];
    lineLabel.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:lineLabel];
    
    self.waiterImageView=[[UIImageView alloc]init];
    self.waiterImageView.layer.cornerRadius=12;
    self.waiterImageView.layer.masksToBounds=YES;
    [self addSubview:self.waiterImageView];
    
    self.waiterNameLabel=[[UILabel alloc]init];
    self.waiterNameLabel.textColor=[UIColor blackColor];
    self.waiterNameLabel.font=FONT_SYS(15);
    [self addSubview:self.waiterNameLabel];
    
    self.phoneNumLabel=[[UILabel alloc]init];
    self.phoneNumLabel.textColor=[UIColor blackColor];
    self.phoneNumLabel.textAlignment=NSTextAlignmentLeft;
    self.phoneNumLabel.font=FONT_SYS(15);
    [self addSubview:self.phoneNumLabel];
    
    self.callDialButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.callDialButton setImage:[UIImage imageNamed:@"content-button-dial-default"] forState:UIControlStateNormal];
    [self addSubview:self.callDialButton];
    
    self.callCancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.callCancelButton setImage:[UIImage imageNamed:@"content-button-hang-up-default"] forState:UIControlStateNormal];
    [self addSubview:self.callCancelButton];
    
    self.waiterImageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self.waiterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(isCaonsultLabel.mas_bottom).offset(17);
        make.width.equalTo(@(24));
        make.height.equalTo(@(24));
    }];
    
    self.waiterNameLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self.waiterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waiterImageView.mas_right).offset(8);
        make.top.equalTo(isCaonsultLabel.mas_bottom).offset(22);
        make.width.equalTo(@(90));
        make.height.equalTo(@(16));
    }];
    
    self.phoneNumLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.waiterNameLabel.mas_right).offset(6);
        make.top.equalTo(isCaonsultLabel.mas_bottom).offset(22);
        make.right.equalTo(self.mas_right).offset(20);
        make.height.equalTo(@(16));
    }];
    
    self.callDialButton.translatesAutoresizingMaskIntoConstraints=NO;
    [self.callDialButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(51);
        make.bottom.equalTo(self.mas_bottom).offset(-26);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];
    
    self.callCancelButton.translatesAutoresizingMaskIntoConstraints=NO;
    [self.callCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-51);
        make.bottom.equalTo(self.mas_bottom).offset(-26);
        make.height.equalTo(@(50));
        make.width.equalTo(@(50));
    }];

}

-(void)setModel:(YLActivityOffInfoModel *)model
{
    _model=model;
    
    [self customView];
    NSDictionary *dict=model.waiterInfo;
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=10;
    self.layer.masksToBounds=YES;
    [self.waiterImageView sd_setImageWithURL:[NSURL URLWithString:dict[@"image"]]];
    self.waiterNameLabel.text=[NSString stringWithFormat:@"%@:",dict[@"name"]];
    self.phoneNumLabel.text=dict[@"phone"];
}


@end
