//
//  YLSignUpViewController.h
//  hdcy
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "RootViewController.h"
#import "YLActivityListContentModel.h"
typedef void(^changeMessageBlock)();
@interface YLSignUpViewController : RootViewController
@property (nonatomic,strong)YLActivityListContentModel *contentModel;
@property (nonatomic,copy)changeMessageBlock messageBlock;
@end
