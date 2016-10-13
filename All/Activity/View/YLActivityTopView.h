//
//  YLActivityTopView.h
//  hdcy
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  topViewHeightChangeDelegate<NSObject>
-(void)topViewChangeViewHeight:(NSInteger)height;
@end

@protocol  imageViewClickDelegate<NSObject>
-(void)imageViewClickWithIndex:(NSInteger)index;
@end

@interface YLActivityTopView : UIView
@property (nonatomic,copy)NSString *descip;
@property (nonatomic,strong)NSArray *picArray;
@property (nonatomic,assign)id<topViewHeightChangeDelegate>delegate;
@property (nonatomic,assign)id<imageViewClickDelegate>iDelegate;
@end
