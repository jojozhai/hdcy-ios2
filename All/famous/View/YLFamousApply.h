//
//  YLFamousApply.h
//  hdcy
//
//  Created by mac on 16/10/25.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLFamousApplyDelegate <NSObject>
-(void)applyButton:(NSInteger)tag;
@end
@interface YLFamousApply : UIView
@property (nonatomic,assign)id<YLFamousApplyDelegate>delegate;
@end
