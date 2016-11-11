//
//  YLVideoDetailViewController.h
//  hdcy
//
//  Created by mac on 16/10/16.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "RootViewController.h"
#import "PlayerManager.h"
#import "YLVideoListModel.h"
@interface YLVideoDetailViewController : RootViewController
@property (strong, nonatomic) PlayerManager *playerManager;

@property (strong, nonatomic) UILabel *titlLabel;

@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *target;
@property (nonatomic,strong)YLVideoListModel *model;
@property (nonatomic,copy)NSString *streamId;
@end
