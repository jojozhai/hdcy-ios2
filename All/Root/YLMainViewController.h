//
//  YLMainViewController.h
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLMineViewController.h"
#import "YLInLetterViewController.h"
@interface YLMainViewController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, assign) NSInteger topHeight;

@property (nonatomic, strong) UIColor *selectedButtonColor;

@property (nonatomic, strong) UIColor *topBackgroudColor;

@property (nonatomic,strong) YLMineViewController *mineVC;
@property (nonatomic,strong) YLInLetterViewController *inletterVC;
@end
