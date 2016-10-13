//
//  YLActivityOffLineViewController.h
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "RootViewController.h"
#import "YLActivityListContentModel.h"
@interface YLActivityOffLineViewController : RootViewController
@property (nonatomic,strong)YLActivityListContentModel *contentModel;
@property (nonatomic,assign)BOOL isFinish;
@end
