//
//  YLMoviePlayerController.h
//  hdcy
//
//  Created by Nemo on 16/9/20.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import "YLVideoListModel.h"
@interface YLMoviePlayerController : MPMoviePlayerController

@property (nonatomic, assign) CGRect frame;

@property (nonatomic, retain) NSTimer *timer;

@property (nonatomic, retain) NSString *endTime;

@property (nonatomic,strong) YLVideoListModel *model;
- (void)zoomBlock:(void (^) (BOOL isZoom))block;

- (void)invalidateTimer;



@end
