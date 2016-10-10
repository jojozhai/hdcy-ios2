//
//  YLReplyViewController.h
//  hdcy
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "RootViewController.h"
#import "YLCommentModel.h"
typedef void(^changeCommnetItemBlock)(YLCommentModel *model);
@interface YLReplyViewController : RootViewController
@property (nonatomic,copy)NSString *target;
@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)changeCommnetItemBlock changeItemBlock;
@end
