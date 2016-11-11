//
//  LocationImageView.m
//  CRMotionViewDemo
//
//  Created by air on 16/11/2.
//  Copyright © 2016年 Christian Roman. All rights reserved.
//

#import "LocationImageView.h"

@implementation LocationImageView

-(id)init
{
    if(self = [super init])
    {
        label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:@"Arial" size:14];
        
        [self addSubview:label];
        
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        //执行动画
        [self actionAnimation];
    }
    
    return self;
}

-(void)actionAnimation
{
    // 如果正在动画，直接退出
    if ([self isAnimating]) return;
    // 动画图片的数组
    NSMutableArray *arrayM = [NSMutableArray array];
    // 添加动画播放的图片
    for (int i = 1; i <= 5; i++) {
        // 图像名称
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", @"tag", i];
        // ContentsOfFile需要全路径
        UIImage *image = [UIImage  imageNamed:imageName];
        [arrayM addObject:image];
    }
    // 设置动画数组
    self.animationImages = arrayM;
    // 重复1次
    self.animationRepeatCount = 0;
    // 动画时长
    self.animationDuration = self.animationImages.count * 0.2;
    // 开始动画
    [self startAnimating];

}

-(void)setPosX:(float)posX
{
    self->_posX = posX;
}


-(void)setPosY:(float)posY
{
    self->_posY = posY;
}

-(void)setTitle:(NSString *)title
{
    self->_title = title;
    
    [label setText:title];
    
    [self setFrame:CGRectMake(_posX, _posY, 90, 30)];
    [label setFrame:CGRectMake(15, 0, 80, 30)];
}
@end
