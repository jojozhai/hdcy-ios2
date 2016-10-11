//
//  YLTableHeaderView.h
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol scrollViewScrollClickDelegate <NSObject>

-(void)clickScrollViewItemWithIndex:(NSInteger)index;

@end

@interface YLTableHeaderView : UIView
@property (nonatomic,strong)NSArray *topScrollArray;
@property (nonatomic,strong)NSArray *topControlArray;

@property (nonatomic,assign)id<scrollViewScrollClickDelegate>Sdelegate;

@end
