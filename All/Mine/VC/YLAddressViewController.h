//
//  YLAddressViewController.h
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^YLChangeAddressBlock)(NSString *address);
@interface YLAddressViewController : UIViewController
@property (nonatomic,copy)YLChangeAddressBlock addressBlock;
@end
