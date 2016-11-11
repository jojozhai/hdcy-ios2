//
//  YLInterestViewController.h
//  hdcy
//
//  Created by mac on 16/10/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^changeInterestBlock)(NSString *data);
@interface YLInterestViewController : UIViewController
@property (nonatomic,copy)changeInterestBlock interestBlock;
@property (nonatomic,copy)NSString *tagString;
@end
