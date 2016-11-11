//
//  CRMotionView.m
//  CRMotionView
//
//  Created by Christian Roman on 06/02/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "CRMotionView.h"
#import "LocationImageView.h"
@import CoreMotion;

static const CGFloat CRMotionViewRotationMinimumTreshold = 0.1f;
static const CGFloat CRMotionGyroUpdateInterval = 1 / 100;
static const CGFloat CRMotionViewRotationFactor = 1.0f;

@interface CRMotionView ()
{
    NSMutableArray * imagesArray;
}
@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, assign) CGFloat motionRateX;
@property (nonatomic, assign) CGFloat motionRateY;
@property (nonatomic, assign) NSInteger minimumXOffset;
@property (nonatomic, assign) NSInteger maximumXOffset;

@property (nonatomic, assign) NSInteger minimumYOffset;
@property (nonatomic, assign) NSInteger maximumYOffset;

@end

@implementation CRMotionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self commonInit];
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewFrame = frame;
        [self commonInit];
        [self setImage:image];
    }
    return self;
}

- (void)commonInit
{
    _scrollView = [[UIScrollView alloc] initWithFrame:_viewFrame];
    [_scrollView setUserInteractionEnabled:NO];
    [_scrollView setBounces:NO];
    [_scrollView setContentSize:CGSizeZero];
    [self addSubview:_scrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_viewFrame];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_scrollView addSubview:_imageView];
    
    _minimumXOffset = 0;
    _minimumYOffset = 0;
    
    [self startMonitoring];
}

#pragma mark - Setters

-(void)setImagesDic:(NSDictionary *)imagesDic
{
    self->_imagesDic = imagesDic;
    NSString *path = [[NSBundle mainBundle] pathForResource:[_imagesDic valueForKey:@"name"] ofType:@"jpg"];

    UIImage * image = [UIImage imageWithContentsOfFile:path];
    if(image)
    {
        [self setImage:image];
    }
}


-(void)setLocationsArray:(NSMutableArray *)locationsArray
{
    self->_locationsArray = locationsArray;
    if(!imagesArray)
    {
        imagesArray = [NSMutableArray new];
    }
    
    
    LocationImageView * imgView;
    for (NSDictionary * dic in _locationsArray) {
        imgView = [[LocationImageView alloc]init];
        imgView.posX = [[dic valueForKey:@"pos_x"] floatValue];
        imgView.posY = [[dic valueForKey:@"pos_y"] floatValue];
        imgView.title = [dic valueForKey:@"title"];
        
        [_scrollView addSubview:imgView];
    }
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    
    CGFloat width = [[_imagesDic valueForKey:@"width"] floatValue];
    CGFloat height = [[_imagesDic valueForKey:@"height"] floatValue];;
    if(height<self.frame.size.height)
    {
        height=1000;
    }
    
    
    [_imageView setFrame:CGRectMake(0, 0, width, height)];
    [_imageView setBackgroundColor:[UIColor blackColor]];
    [_imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_imageView setImage:_image];
    
    _scrollView.contentSize = CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height);
    _scrollView.contentOffset = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
    
    
    _motionRateX = _image.size.width / _viewFrame.size.width * CRMotionViewRotationFactor;
    _motionRateY = _image.size.height / _viewFrame.size.height * CRMotionViewRotationFactor;
    _maximumXOffset = _scrollView.contentSize.width - _scrollView.frame.size.width;
    _maximumYOffset = _scrollView.contentSize.height - _scrollView.frame.size.height;
}

- (void)setMotionEnabled:(BOOL)motionEnabled
{
    _motionEnabled = motionEnabled;
    if (_motionEnabled) {
        [self startMonitoring];
    } else {
        [self stopMonitoring];
    }
}

#pragma mark - Core Motion

- (void)startMonitoring
{
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.gyroUpdateInterval = CRMotionGyroUpdateInterval;
    }
    
    
    if (![_motionManager isGyroActive] && [_motionManager isGyroAvailable]) {
        [_motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        CGFloat rotationRateX = gyroData.rotationRate.y;
                                        CGFloat rotationRateY = gyroData.rotationRate.x;
                                        
                                        if (fabs(rotationRateX) >= CRMotionViewRotationMinimumTreshold) {
                                            CGFloat offsetX = _scrollView.contentOffset.x - rotationRateX * _motionRateX;
                                            if (offsetX > _maximumXOffset) {
                                                offsetX = _maximumXOffset;
                                            } else if (offsetX < _minimumXOffset) {
                                                offsetX = _minimumXOffset;
                                            }
                                            
                                            
                                             CGFloat offsetY = _scrollView.contentOffset.y - rotationRateY * _motionRateY;
                                            if (offsetY > _maximumYOffset) {
                                                offsetY = _maximumYOffset;
                                            } else if (offsetY < _minimumYOffset) {
                                                offsetY = _minimumYOffset;
                                            }
                                         
                                            [UIView animateWithDuration:0.3f
                                                                  delay:0.0f
                                                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                                                             animations:^{
                                                                 NSLog(@"%f--%f",offsetX,offsetY);
                                                                 [_scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:NO];
                                                                 
                                            }
                                                             completion:nil];
                                        }else{
                                            
                                            CGPoint center = CGPointMake((_scrollView.contentSize.width - _scrollView.frame.size.width) / 2, (_scrollView.contentSize.height - _scrollView.frame.size.height) / 2);
                                             [_scrollView setContentOffset:center animated:YES ];
                                        }
                                    }];
    } else {
        NSLog(@"There is not available gyro.");
    }
}

- (void)stopMonitoring
{
    [_motionManager stopGyroUpdates];
}


@end
