//
//  YLCommunicateView.h
//  hdcy
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLActivityInfoHeaderView.h"
@protocol clickAllButtonDelegate <NSObject>
-(void)clickMoreButton;
@end

@interface YLCommunicateView : UIView
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)id<clickAllButtonDelegate>delegate;
@property (nonatomic,copy)NSString *totalElements;
@property (nonatomic,strong)YLActivityInfoHeaderView *infoHeader;
@end
