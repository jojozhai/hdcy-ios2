//
//  YLCommentViewController.h
//  hdcy
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "RootViewController.h"
typedef void(^changeCommnetCountBlock)(NSArray *data);
@interface YLCommentViewController : RootViewController
@property (nonatomic,copy)NSString *Id;
@property (nonatomic,copy)NSString *target;
@property (nonatomic,copy)changeCommnetCountBlock changeBlock;

@end
