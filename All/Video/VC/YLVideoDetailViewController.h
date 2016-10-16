//
//  YLVideoDetailViewController.h
//  hdcy
//
//  Created by mac on 16/10/16.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "RootViewController.h"
#import "PlayerManager.h"
#import "YLVideoTopModel.h"
@interface YLVideoDetailViewController : RootViewController
@property (strong, nonatomic) PlayerManager *playerManager;

@property (strong, nonatomic) YLVideoTopModel *model;

@property (strong, nonatomic) UILabel *titlLabel;

- (instancetype)initWithURL:(NSString *)url;

- (void)goBack;

@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *target;
@end
