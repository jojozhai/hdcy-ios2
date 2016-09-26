//
//  YLButton.h
//  buttonDemo
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YLButton : UIButton
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title rightImage:(UIImage *)image;
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title topImage:(UIImage *)image;
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title bottomImage:(UIImage *)image;
@end
