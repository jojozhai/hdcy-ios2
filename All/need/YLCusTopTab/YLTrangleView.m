//
//  YLTrangleView.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLTrangleView.h"

@implementation YLTrangleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawRect:frame];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Drawing code
    
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(0,rect.origin.y+rect.size.height)];
    //从开始位置画一条直线
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, 0)];
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,rect.origin.y+rect.size.height)];
    
    //关闭path
    [path closePath];
    
    //三角形内填充颜色
    [_fillColor setFill];
    
    [path fill];
    //    //三角形的边框为红色
    //    [[UIColor clearColor] setStroke];
    //    [path stroke];
}


@end
