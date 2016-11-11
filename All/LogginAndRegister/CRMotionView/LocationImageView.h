//
//  LocationImageView.h
//  CRMotionViewDemo
//
//  Created by air on 16/11/2.
//  Copyright © 2016年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationImageView : UIImageView
{
    UILabel * label;
}

@property(nonatomic,assign)float posX;
@property(nonatomic,assign)float posY;
@property(nonatomic,retain)NSString* title;
-(id)init;
@end
