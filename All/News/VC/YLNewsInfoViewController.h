//
//  YLNewsInfoViewController.h
//  hdcy
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "RootViewController.h"
#import "YLNewsListModel.h"

@interface YLNewsInfoViewController : RootViewController

@property (nonatomic,copy)NSString *Id;
@property (nonatomic,strong)YLNewsListModel *listModel;

@end
