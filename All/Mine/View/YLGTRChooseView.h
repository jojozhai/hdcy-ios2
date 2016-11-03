//
//  YLGTRChooseView.h
//  hdcy
//
//  Created by mac on 16/10/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YLGTRChooseDelegate <NSObject>
-(void)isDeserveButton:(NSInteger)tag;
@end
@interface YLGTRChooseView : UIView
@property (nonatomic,assign)id<YLGTRChooseDelegate>delegate;
@end
