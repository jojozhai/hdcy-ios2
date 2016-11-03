//
//  YLCarStyleViewController.h
//  hdcy
//
//  Created by mac on 16/10/27.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^changeCarStyleBlock)(NSString *data);
@interface YLCarStyleViewController : UIViewController
@property (nonatomic,copy)changeCarStyleBlock carStyleBlock;
@end
