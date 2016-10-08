//
//  YLCommentView.h
//  hdcy
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol clickLableWithIndexDelegate<NSObject>
-(void)clickLableWithIndex:(NSInteger)index;
@end
@interface YLCommentView : UIView
- (void)setupcommentItemsArray:(NSArray *)commentItemsArray;
@property (nonatomic,assign)id<clickLableWithIndexDelegate>delegate;
@end
