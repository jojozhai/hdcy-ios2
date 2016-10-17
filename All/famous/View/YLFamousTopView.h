//
//  YLFamousTopView.h
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol scrollViewClickDelegate <NSObject>
-(void)clickScrollViewItemWithIndex:(NSInteger)index;
@end
@interface YLFamousTopView : UIView
@property (nonatomic,strong)NSArray *topScrollArray;
@property (nonatomic,strong)NSArray *topControlArray;

@property (nonatomic,assign)id<scrollViewClickDelegate>delegate;
@end
