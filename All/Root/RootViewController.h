//
//  RootViewController.h
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@property (nonatomic,strong)UIView *cusNavigationView;
-(void)addLeftBarButtonItemWithImageName:(NSString *)imageName
                                  target:(id)target
                                selector:(SEL)selector;
-(void)addRightBarButtonItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                 selector:(SEL)selector;
@end
