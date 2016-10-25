//
//  YLLiveView.h
//  hdcy
//
//  Created by mac on 16/10/19.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLVideoListModel.h"
@protocol clickEnlargeButtonDelegate <NSObject>
-(void)clickEnlargebutton:(BOOL)isZoom;
@end
@interface YLLiveView : UIView
@property (nonatomic,strong)UIImageView *sponsorImageView;
@property (nonatomic,strong)UILabel *sponorLabel;
@property (nonatomic,strong)UILabel *lengthLabel;
@property (nonatomic,strong)UILabel *livelabel;
@property (nonatomic,strong)UIButton *enlargeButton;
@property (nonatomic,assign)id<clickEnlargeButtonDelegate>delegate;

@property (nonatomic,strong)YLVideoListModel *model;
@end
