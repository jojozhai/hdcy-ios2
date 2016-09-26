//
//  YLButton.m
//  buttonDemo
//
//  Created by mac on 16/9/12.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLButton.h"
@implementation YLButton
-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title rightImage:(UIImage *)image{
    self.frame=frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(0, self.frame.size.width - self.imageView.frame.origin.x - self.imageView.frame.size.width, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.frame.size.width - self.titleLabel.frame.size.width), 0, 0);
    return self;
}

-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title topImage:(UIImage *)image
{
    self.frame=frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    self.imageEdgeInsets = UIEdgeInsetsMake(- (self.frame.size.height - self.imageView.frame.size.height- self.imageView.frame.origin.y),(self.frame.size.width -self.titleLabel.frame.size.width)/2.0f, 0, 0);
    self.titleEdgeInsets = UIEdgeInsetsMake(self.frame.size.height-self.titleLabel.frame.size.height-self.titleLabel.frame.origin.y, -self.imageView.frame.size.width, 0, 0);
    return self;
}

-(UIButton *)customButtonWithFrame:(CGRect)frame title:(NSString *)title bottomImage:(UIImage *)image
{
    self.frame=frame;
    [self setTitle:title forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateNormal];
    self.titleEdgeInsets = UIEdgeInsetsMake(- (self.frame.size.height - self.titleLabel.frame.size.height- self.titleLabel.frame.origin.y),-self.imageView.frame.size.width, 0, 0);
    self.imageEdgeInsets=UIEdgeInsetsMake(self.frame.size.height-self.imageView.frame.size.height-self.imageView.frame.origin.y,(self.frame.size.width-self.titleLabel.frame.size.width)/2, 0, 0);
    return self;
}


@end
