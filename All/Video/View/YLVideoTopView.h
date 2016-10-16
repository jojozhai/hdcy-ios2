//
//  YLVideoTopView.h
//  hdcy
//
//  Created by mac on 16/10/16.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol scrollViewScrollClickDelegate <NSObject>

-(void)clickScrollViewItemWithIndex:(NSInteger)index;

@end

@interface YLVideoTopView : UIView
@property (nonatomic,strong)NSArray *topScrollArray;
@property (nonatomic,strong)NSArray *topControlArray;

@property (nonatomic,assign)id<scrollViewScrollClickDelegate>delegate;
@end
