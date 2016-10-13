//
//  YLPhoneCallView.h
//  hdcy
//
//  Created by mac on 16/8/30.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLActivityOffInfoModel.h"
@interface YLPhoneCallView : UIView
@property (nonatomic,strong)YLActivityOffInfoModel *model;
@property (nonatomic,strong)UIButton *callDialButton;
@property (nonatomic,strong)UIButton *callCancelButton;
@end
