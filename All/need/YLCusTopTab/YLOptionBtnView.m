//
//  TFOptionBtnView.m
//  djlt
//
//  Created by macmini04 on 16/2/1.
//  Copyright © 2016年  . All rights reserved.
//

#import "YLOptionBtnView.h"
#import "UIView+AZView.h"
#define BaseTag 10
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface YLOptionBtnView()
/**   */
@property (nonatomic, assign) CGFloat scrollWidth;
/** 记录上一次选中的按钮 */
@property (nonatomic, weak) UIButton *selectedBtn;
 

@end

@implementation YLOptionBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.bounces = NO;
        self.scrollEnabled=YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}


- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    
    NSUInteger count = titleArray.count;
    
    self.scrollWidth=0;
    // 设置内部子控件frame
    for (NSUInteger i = 0; i < count; i++) {
        // 创建btn
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.scrollWidth=self.scrollWidth+[self.titleArray[i] length]*(self.height-2)*SCREEN_MUTI;
        
        if (i==count-1) {
            if (self.scrollWidth > ScreenWidth) {
                self.contentSize = CGSizeMake(self.scrollWidth, 0);
            } else {
                self.contentSize = CGSizeMake(ScreenWidth, 0);
            }
        }
        btn.frame=CGRectMake(self.scrollWidth-[self.titleArray[i] length]*(self.height-2)*SCREEN_MUTI, 0, [self.titleArray[i] length]*(self.height-2)*SCREEN_MUTI, self.height-2);
        btn.tag = BaseTag + i;
         
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];

        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加底部线条
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.origin.x+([self.titleArray[i] length]*(self.height-2)*SCREEN_MUTI)/2-12.5, self.height - 2,25, 2)];
        bottomLine.backgroundColor =btn.titleLabel.textColor;
        bottomLine.tag=1111+i;
        bottomLine.hidden=YES;
        [self addSubview:bottomLine];
        
        if (count<4) {
            self.contentSize = CGSizeMake(ScreenWidth, 0);
            btn.frame=CGRectMake(ScreenWidth/count*i, 0, ScreenWidth/count, self.height-2);
            bottomLine.frame=CGRectMake(ScreenWidth/3*(i+1)-ScreenWidth/6-12.5, self.height - 2,25, 2);
        }

        
        // 添加btn
        [self addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            bottomLine.hidden=NO;
        }
    }
    
}

// 按钮点击
- (void)buttonClick:(UIButton *)btn {
    [self selectedBtnAtIndex:btn.tag - BaseTag];
    
    if (self.operation) {
        self.operation(btn.tag - BaseTag);
    }
}

- (void)selectedBtnAtIndex:(NSInteger)index {
 
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"Refresh" object:nil userInfo:@{@"num":@(index)}];
    self.selectedBtn.selected = NO; // 取消上次选中
    UIButton *selectedBtn = (UIButton *)[self viewWithTag:index + BaseTag];

    selectedBtn.selected = YES;
    self.selectedBtn = selectedBtn; // 重新赋值选中的按钮
    // 滚动条滚到当前选中位置
    [UIView animateWithDuration:0.2 animations:^{
        UIView *bottomView=[self viewWithTag:1111+index];
        for (UIView *obj in self.subviews) {
            if ([obj isKindOfClass:[UILabel class]]) {
                obj.hidden=YES;
            }
        }
        bottomView.hidden=NO;
    }];

    
    CGPoint center;
    center=self.selectedBtn.center;
    if (center.x > self.width/2) {
        
        if (center.x > self.contentSize.width - self.width/2) {
            if (self.contentSize.width<ScreenWidth) {
                [UIView animateWithDuration:0.4 animations:^{
                    self.contentOffset = CGPointMake(0, 0);
                }];
                return;
            }
            
            [UIView animateWithDuration:0.4 animations:^{
                
                if (self.contentSize.width > self.width) {
                    if (center.x - self.width/2>self.contentSize.width-self.width) {
                        [UIView animateWithDuration:0.4 animations:^{
                            self.contentOffset = CGPointMake(self.contentSize.width-self.width, 0);
                        }];
                    }else{
                        [UIView animateWithDuration:0.4 animations:^{
                            self.contentOffset = CGPointMake(center.x - self.width/2, 0);                        }];
                    }
                }else {
                    [UIView animateWithDuration:0.4 animations:^{
                        self.contentOffset = CGPointMake( ScreenWidth -self.contentSize.width, 0);                  }];
                }
                
                
                return;
            }];
            
        }
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.contentOffset = CGPointMake(0, 0);
        }];
    }

    
    
}

@end
