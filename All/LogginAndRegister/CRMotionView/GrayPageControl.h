//
//  GrayPageControl.h
//  GuidePage-OC
//
//  Created by air on 16/10/24.
//  Copyright © 2016年 付正. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrayPageControl : UIView
{
    UIImage* activeImage;
    
    UIImage* inactiveImage;
    UIImageView* activeImgView;
}

@property(assign,nonatomic)NSInteger count;
@property(assign,nonatomic)NSInteger currentIndex;

@end
