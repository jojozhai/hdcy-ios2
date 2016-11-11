//
//  YLLiveView.m
//  hdcy
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLLiveView.h"
@interface YLLiveView()
{
    BOOL _isZoom;
}
@end
@implementation YLLiveView

-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.backgroundColor=[UIColor clearColor];
        _isZoom=NO;
        [self createView];
    }
    return self;
}

-(void)createView
{
    
    self.sponsorImageView=[[UIImageView alloc]init];
    self.sponsorImageView.layer.cornerRadius=15;
    self.sponsorImageView.layer.masksToBounds=YES;
    [self addSubview:self.sponsorImageView];
    
    self.sponorLabel=[[UILabel alloc]init];
    self.sponorLabel.textColor=RGBCOLOR(0, 254, 252);
    self.sponorLabel.textAlignment=NSTextAlignmentLeft;
    self.sponorLabel.font=FONT_BOLD(14);
    [self addSubview:self.sponorLabel];
    
    self.livelabel =[[UILabel alloc]init];
    self.livelabel.text=@"正在直播";
    self.livelabel.textColor=[UIColor whiteColor];
    self.livelabel.layer.borderColor=[UIColor whiteColor].CGColor;
    self.livelabel.layer.borderWidth=0.5;
    self.livelabel.layer.cornerRadius=2;
    self.livelabel.layer.masksToBounds=YES;
    self.livelabel.textColor=[UIColor whiteColor];
    self.livelabel.font=FONT_SYS(11);
    self.livelabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.livelabel];
    
    self.lengthLabel=[[UILabel alloc]init];
    self.lengthLabel.textColor=[UIColor whiteColor];
    self.lengthLabel.font=FONT_SYS(11);
    self.lengthLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.lengthLabel];
    
    self.enlargeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.enlargeButton setImage:[UIImage imageNamed:@"content-icon-fullscreen-default"] forState:UIControlStateNormal];
    [self.enlargeButton addTarget:self action:@selector(enlargeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.enlargeButton];
    
    self.sponsorImageView.sd_layout
    .leftSpaceToView(self,12)
    .topSpaceToView(self,self.height-40)
    .widthIs(30)
    .heightIs(30);
    
    self.sponorLabel.sd_layout
    .leftSpaceToView(self,50)
    .topSpaceToView(self,self.height-40)
    .widthIs(80)
    .heightIs(30);
    
    self.livelabel.sd_layout
    .leftSpaceToView(self,self.width-125)
    .topSpaceToView(self,self.height-35)
    .widthIs(50)
    .heightIs(22);
    
    self.lengthLabel.sd_layout
    .leftSpaceToView(self,self.width-75)
    .topSpaceToView(self,self.height-32)
    .widthIs(40)
    .heightIs(14);
    
    self.enlargeButton.sd_layout
    .leftSpaceToView(self,self.width-32)
    .topSpaceToView(self,self.height-40)
    .widthIs(30)
    .heightIs(30);
}

-(void)enlargeAction
{
    if (_isZoom==NO) {
        self.transform=CGAffineTransformRotate(self.transform, M_PI_2);
        self.frame=CGRectMake(0, 0, Window_Width, Window_Height);
        
        
        self.sponsorImageView.sd_layout
        .leftSpaceToView(self,12)
        .topSpaceToView(self,self.frame.size.width-40)
        .widthIs(30)
        .heightIs(30);
        
        self.sponorLabel.sd_layout
        .leftSpaceToView(self,50)
        .topSpaceToView(self,self.frame.size.width-40)
        .widthIs(80)
        .heightIs(30);
        self.sponsorImageView.hidden=YES;
        self.sponorLabel.hidden=YES;
        
        self.livelabel.sd_layout
        .leftSpaceToView(self,self.frame.size.height-125)
        .topSpaceToView(self,self.frame.size.width-35)
        .widthIs(50)
        .heightIs(22);
        
        self.lengthLabel.sd_layout
        .leftSpaceToView(self,self.frame.size.height-75)
        .topSpaceToView(self,self.frame.size.width-32)
        .widthIs(40)
        .heightIs(14);
        
        self.enlargeButton.sd_layout
        .leftSpaceToView(self,self.frame.size.height-32)
        .topSpaceToView(self,self.frame.size.width-40)
        .widthIs(30)
        .heightIs(30);
    }else{
        self.transform=CGAffineTransformRotate(self.transform, -M_PI_2);
        self.frame=CGRectMake(0, 0, Window_Width, 250);
        
        self.sponsorImageView.sd_layout
        .leftSpaceToView(self,12)
        .topSpaceToView(self,self.frame.size.height-40)
        .widthIs(30)
        .heightIs(30);
        
        self.sponorLabel.sd_layout
        .leftSpaceToView(self,50)
        .topSpaceToView(self,self.frame.size.height-40)
        .widthIs(80)
        .heightIs(30);
        self.sponsorImageView.hidden=NO;
        self.sponorLabel.hidden=NO;
        
        self.livelabel.sd_layout
        .leftSpaceToView(self,self.frame.size.width-125)
        .topSpaceToView(self,self.frame.size.height-35)
        .widthIs(50)
        .heightIs(22);
        
        self.lengthLabel.sd_layout
        .leftSpaceToView(self,self.frame.size.width-75)
        .topSpaceToView(self,self.frame.size.height-32)
        .widthIs(40)
        .heightIs(14);
        
        self.enlargeButton.sd_layout
        .leftSpaceToView(self,self.frame.size.width-32)
        .topSpaceToView(self,self.frame.size.height-40)
        .widthIs(30)
        .heightIs(30);
    }
     
    _isZoom=!_isZoom;
    [_delegate clickEnlargebutton:_isZoom];
    
}

-(void)setModel:(YLVideoListModel *)model
{
    _model=model;
    
    self.lengthLabel.text=model.length;
    [self.sponsorImageView sd_setImageWithURL:[NSURL URLWithString:model.sponsorImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    self.sponorLabel.text=model.sponsorName;
}

@end
