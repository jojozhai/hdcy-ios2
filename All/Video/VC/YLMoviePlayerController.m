//
//  YLMoviePlayerController.m
//  hdcy
//
//  Created by Nemo on 16/9/20.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLMoviePlayerController.h"

#define kWindowWidth    [UIApplication sharedApplication].keyWindow.bounds.size.width
#define kWindowHeight   [UIApplication sharedApplication].keyWindow.bounds.size.height

@interface YLMoviePlayerController ()
{
    UIButton *_playBut;
    
    UIButton *_zoomBut;
    
    UILabel *_startTimeLabel;
    
    UILabel *_endTimeLabel;
    
    UISlider *_progressView;
    
    BOOL _isZoom;
    
    void (^_zoom_block) (BOOL isZoom);
    
    BOOL _isShowControl;
    
    UIView *_maskView;
}

@end

@implementation YLMoviePlayerController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.controlStyle = MPMovieControlStyleNone;
        self.scalingMode = MPMovieScalingModeAspectFit;
        self.initialPlaybackTime = 0;
        _isZoom = NO;
        
        self.frame = CGRectMake(0, 0, kWindowWidth, 200);

        [self registNoti];
        
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_maskView];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_maskView addGestureRecognizer:tap];
        
        [self initBottomBar];

        
    }
    return self;
}

- (void)registNoti
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reset) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nowPlaying) name:MPMovieDurationAvailableNotification object:nil];
}

- (void)setFrame:(CGRect)frame
{
    _frame = frame;
    self.view.frame = frame;
}

- (void)initBottomBar
{
    _playBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBut.frame = CGRectMake((_frame.size.width-37)/2.0, (_frame.size.height-37)/2.0, 37, 37);
    [_playBut setBackgroundImage:[UIImage imageNamed:@"video-play-default"] forState:UIControlStateNormal];
    [_playBut addTarget:self action:@selector(playing) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBut];
    
    _startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, self.view.frame.size.height-25, 60, 20)];
    _startTimeLabel.textColor = [UIColor whiteColor];
    _startTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_startTimeLabel];
    _startTimeLabel.text = @"";
    _startTimeLabel.font = [UIFont systemFontOfSize:14];
    
    _progressView = [[UISlider alloc] init];
    _progressView.frame = CGRectMake(_startTimeLabel.frame.origin.x + _startTimeLabel.frame.size.width, self.view.frame.size.height-15, _frame.size.width-_startTimeLabel.frame.size.width*2-20, 4);
    _progressView.minimumTrackTintColor = [UIColor colorWithRed:250/255.0 green:120/255.0 blue:5/255.0 alpha:1];
    _progressView.maximumTrackTintColor = [UIColor whiteColor];
    [self.view addSubview:_progressView];
    _progressView.userInteractionEnabled = YES;
    _progressView.continuous = YES;
    [_progressView addTarget:self action:@selector(slidePorgress:) forControlEvents:UIControlEventValueChanged];
    
    _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWindowWidth-85, self.view.frame.size.height-25, 60, 20)];
    _endTimeLabel.textAlignment = NSTextAlignmentCenter;
    _endTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_endTimeLabel];
    _endTimeLabel.text = @"";
    _endTimeLabel.font = [UIFont systemFontOfSize:14];
    
    _zoomBut = [UIButton buttonWithType:UIButtonTypeCustom];
    _zoomBut.frame = CGRectMake(_endTimeLabel.frame.origin.x + _endTimeLabel.frame.size.width, _endTimeLabel.frame.origin.y+2, 20, 20);
    [_zoomBut setBackgroundImage:[UIImage imageNamed:@"video-zoom-default"] forState:UIControlStateNormal];
    [_zoomBut addTarget:self action:@selector(zooming) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zoomBut];
}

- (void)reset
{
    [_playBut setBackgroundImage:[UIImage imageNamed:@"video-play-default"] forState:UIControlStateNormal];
    [self invalidateTimer];
}

- (void)playing
{
    if (self.playbackState == MPMoviePlaybackStatePlaying)
    {
        [self pause];
        [_playBut setBackgroundImage:[UIImage imageNamed:@"video-play-default"] forState:UIControlStateNormal];
    }
    else
    {
        if (self.currentPlaybackTime == self.duration)
        {
            _progressView.value = 0;
            self.currentPlaybackTime = 0;
        }
        [self play];
        [_playBut setBackgroundImage:[UIImage imageNamed:@"video-pause-default"] forState:UIControlStateNormal];
    }
}

- (void)zooming
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    if (_isZoom)
    {
        self.frame = CGRectMake(0, 0, 200, kWindowWidth);
        self.view.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, 1.0));
        self.view.center = CGPointMake(window.center.x, 100);
        
        _playBut.frame = CGRectMake((kWindowWidth-37)/2.0, 100, 37, 37);
        _startTimeLabel.frame = CGRectMake(5, self.view.frame.size.height-25, 60, 20);
        _progressView.frame = CGRectMake(_startTimeLabel.frame.origin.x + _startTimeLabel.frame.size.width, self.view.frame.size.height-15, _frame.size.height-_startTimeLabel.frame.size.width*2-20, 4);
        _endTimeLabel.frame = CGRectMake(kWindowWidth-85, self.view.frame.size.height-25, 60, 20);
        _zoomBut.frame = CGRectMake(_endTimeLabel.frame.origin.x + _endTimeLabel.frame.size.width, _endTimeLabel.frame.origin.y+2, 20, 20);
    }
    else
    {
        self.view.frame = CGRectMake(0, 0, kWindowHeight, kWindowWidth);
        self.view.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI_2), CGAffineTransformMakeScale(1, 1));
        self.view.center = window.center;
        
        _playBut.frame = CGRectMake(self.view.center.y, (_frame.size.width-37)/2.0, 37, 37);
        _startTimeLabel.frame = CGRectMake(5, self.view.frame.size.width-35, 60, 20);
        _progressView.frame = CGRectMake(_startTimeLabel.frame.origin.x + _startTimeLabel.frame.size.width, self.view.frame.size.width-25, kWindowHeight-_startTimeLabel.frame.size.width*2-20, 4);
        _endTimeLabel.frame = CGRectMake(kWindowHeight-85, self.view.frame.size.width-35, 60, 20);
        _zoomBut.frame = CGRectMake(_endTimeLabel.frame.origin.x + _endTimeLabel.frame.size.width, _endTimeLabel.frame.origin.y+2, 20, 20);
    }
    
    
    

    _maskView.frame = self.frame;
    
    _isZoom = !_isZoom;
    
    [self.view setNeedsDisplay];
    
    if (_zoom_block) _zoom_block(_isZoom);
}

- (void)nowPlaying
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doProgress) userInfo:nil repeats:YES];
}

- (void)invalidateTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)doProgress
{
    CGFloat min = 0;
    CGFloat sec = 0;
    
    if (self.currentPlaybackTime > 60)
    {
        min = floorf(self.currentPlaybackTime / 60);
        sec = self.currentPlaybackTime - min * 60;
        
        _startTimeLabel.text = [NSString stringWithFormat:@"%.0f:%.0f",min, sec];
    }
    else
    {
        _startTimeLabel.text = [NSString stringWithFormat:@"00:%.0f",self.currentPlaybackTime];
    }
    
    if (self.duration > 60)
    {
        min = floorf(self.duration / 60);
        sec = self.duration - min * 60;
        
        _endTimeLabel.text = [NSString stringWithFormat:@"%.0f:%.0f",min,sec];
    }
    else
    {
        _endTimeLabel.text = [NSString stringWithFormat:@"00:%.0f",self.duration];
    }

    _progressView.value = self.currentPlaybackTime / self.duration;
}

- (void)slidePorgress:(id)sender
{
    if (self.playbackState != MPMoviePlaybackStatePlaying)
    {
        return;
    }
    
    if ([sender isKindOfClass:[UISlider class]]) {
        UISlider * slider = sender;
        CGFloat value = slider.value;
        NSLog(@"%f", value);
        [self setCurrentPlaybackTime:self.duration * slider.value];
    }
}

- (void)zoomBlock:(void (^) (BOOL isZoom))block
{
    _zoom_block = nil;
    
    _zoom_block = block;
}

- (void)tap
{
    _playBut.hidden = _isShowControl;
    _zoomBut.hidden = _isShowControl;
    _startTimeLabel.hidden = _isShowControl;
    _endTimeLabel.hidden = _isShowControl;
    _progressView.hidden = _isShowControl;
    _isShowControl = !_isShowControl;
}


@end
