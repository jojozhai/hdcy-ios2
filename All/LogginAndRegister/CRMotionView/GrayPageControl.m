//
//  GrayPageControl.m
//  GuidePage-OC
//
//  Created by air on 16/10/24.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "GrayPageControl.h"

@implementation GrayPageControl

-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    activeImage = [UIImage imageNamed:@"car"];
    
    inactiveImage = [UIImage imageNamed:@"racing-flag"];
    
    
    [self updateDots];
    
    
    return self;
    
}


-(void) updateDots

{
    
    if (self.subviews && self.subviews.count>0) {
        for (int i=0; i<[self.subviews count]; i++) {
            UIView * v = [self.subviews objectAtIndex:i];
            if([v isKindOfClass:UIImageView.class])
            {
                UIImageView * imageView = (UIImageView*)v;
//                if (i==self.currentIndex)imageView.image=activeImage;
//                
//                else imageView.image=inactiveImage;
                if(imageView.tag!=10001)
                {
                    CGRect frame;
                    float instance =0;
                    if ((i-1)==_currentIndex)
                    {
                        instance = (self.frame.size.width-28*_count)/(_count-1);
                        frame = CGRectMake((i-1)*28+instance*(i-1), 0, 28, 8.5);
                        
                        [UIView animateWithDuration:0.5f animations:^{
                            
                            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; //InOut 表示进入和出去时都启动动画
                            [UIView setAnimationDuration:1.0f];//动画时间
                            imageView.transform=CGAffineTransformMakeScale(0, 0);
                            activeImgView.transform=CGAffineTransformMakeTranslation(imageView.frame.origin.x-activeImgView.frame.size.width/2, 0);
                            imageView.alpha=0;
                            [UIView commitAnimations]; //启动动画

                        } completion:nil];
                        
                    }
                    else{
                        instance = (self.frame.size.width-13*_count)/(_count-1);
                        frame = CGRectMake((i-1)*13+instance*(i-1), 0, 13, 13);
                        [UIView animateWithDuration:0.5f animations:^{
                            
                            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
                            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; //InOut 表示进入和出去时都启动动画
                            [UIView setAnimationDuration:1.0f];//动画时间
                            imageView.transform=CGAffineTransformMakeScale(1, 1);
                            imageView.alpha=1;
                            [UIView commitAnimations]; //启动动画
                            
                        } completion:nil];
                    }
                    
                    [imageView setFrame:frame];
                }
                //执行动画
            }
        }
    }else{
        for (int i=0; i<_count; i++) {
            CGRect frame;
            float instance =0;
            if (i==_currentIndex)
            {
                instance = (self.frame.size.width-28*_count)/(_count-1);
                frame = CGRectMake(i*28+instance*i, 0, 28, 8.5);
                
                activeImgView = [[UIImageView alloc]initWithFrame:frame];
                activeImgView.tag=10001;
                activeImgView.image = activeImage;
                activeImgView.contentMode = UIViewContentModeScaleAspectFill;
                [self addSubview:activeImgView];
            }
            else{
                instance = (self.frame.size.width-13*_count)/(_count-1);
                frame = CGRectMake(i*13+instance*i, 0, 13, 13);
            }
            
            UIImageView* dot = [[UIImageView alloc] initWithFrame:frame];
            dot.contentMode = UIViewContentModeScaleAspectFit;
            dot.image=inactiveImage;
            
            [self addSubview:dot];
            
            if(i==_currentIndex)
            {
                [UIView animateWithDuration:0.5f animations:^{
                    dot.alpha=0;
                } completion:nil];
            }
        }
    }
}

-(void)setCurrentIndex:(NSInteger)currentIndex

{
    self->_currentIndex = currentIndex;
    
    [self updateDots];
}

@end
