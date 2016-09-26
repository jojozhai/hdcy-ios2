//
//  YLOptionBtnView.h
//  djlt
//
//  Created by macmini04 on 16/2/1.
//  Copyright © 2016年 . All rights reserved.
//  选项按钮视图

#import <UIKit/UIKit.h>

typedef void(^MenuOperation)(NSInteger);

@interface YLOptionBtnView : UIScrollView
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleArray;

/** 点击某个按钮要做的操作 */
@property (nonatomic, copy) MenuOperation operation;

/** 选中某索引下的按钮 */
- (void)selectedBtnAtIndex:(NSInteger)index;

@end
