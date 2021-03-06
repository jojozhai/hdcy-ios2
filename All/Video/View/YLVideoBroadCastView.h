//
//  YLVideoBroadCastView.h
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLVideoListModel.h"
@interface YLVideoBroadCastView : UIView
@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UIImageView *sponsorImageView;
@property (nonatomic,strong)UILabel *sponorLabel;

@property (nonatomic,strong)YLVideoListModel *model;
@end
