//
//  YLMyDataViewController.h
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "RootViewController.h"
#import "YLMineDataModel.h"
typedef void(^changeHeadImageBlock)(NSString *headImage,NSString *name);
@interface YLMyDataViewController : RootViewController
@property (nonatomic,strong)YLMineDataModel *model;
 
@property (nonatomic,copy)changeHeadImageBlock headimageBlock;
@end
