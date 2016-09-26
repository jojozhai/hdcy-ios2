//
//  MBProgressHUD+Extension.h
//  djlt
//
//  Created by macmini04 on 16/1/18.
//  Copyright © 2016年 com.topsage.djlt. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

/** 显示信息 */
+ (MBProgressHUD *)showMessage:(NSString *)message;
/** 显示信息 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/** 显示成功 */
+ (void)showSuccess:(NSString *)success;
/** 显示成功 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;


/** 显示错误 */
+ (void)showError:(NSString *)error;
/** 显示错误 */
+ (void)showError:(NSString *)error toView:(UIView *)view;


/** 隐藏 */
+ (void)hideHUD;
/** 隐藏 */
+ (void)hideHUDForView:(UIView *)view;

@end
