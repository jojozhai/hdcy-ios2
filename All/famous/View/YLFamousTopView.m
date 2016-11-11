//
//  YLFamousTopView.m
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousTopView.h"
#import "YLFamousTopModel.h"
@interface YLFamousTopView()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *topScrollView;
@property (nonatomic,weak)NSTimer *scrollTimer;
@property (nonatomic,weak)UIPageControl *pageControl;
@property (nonatomic,assign)CGFloat startPointX;
@property (nonatomic,assign)CGFloat endPointX;

@end
@implementation YLFamousTopView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}
-(void)createView
{
    if (self.topScrollView) {
        [self.topScrollView removeFromSuperview];
    }
    //创建轮播
    UIScrollView *sc=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    self.topScrollView=sc;
    self.topScrollView.bounces = NO;
    self.topScrollView.pagingEnabled = YES;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.delegate = self;
    self.topScrollView.scrollEnabled=YES;
    self.topScrollView.tag=6666;
    [self addSubview:self.topScrollView];
    
    
}

-(void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    self.scrollTimer = timer;
    [[NSRunLoop mainRunLoop] addTimer:self.scrollTimer forMode:NSRunLoopCommonModes];
}

-(void)automaticScroll
{
    NSInteger index=self.topScrollView.contentOffset.x/SCREEN_WIDTH;
    self.startPointX=SCREEN_WIDTH*index;
    index=index+1;
    
    [UIView animateWithDuration:1 animations:^{
        self.topScrollView.contentOffset=CGPointMake(SCREEN_WIDTH*index, 0);
        self.pageControl.currentPage=index;
        
        NSInteger number=index;
        if (number==self.topScrollArray.count+1) {
            number=1;
        }else if (number==0){
            number=self.topScrollArray.count;
        }
        
        
        for (int i=0; i<self.topScrollArray.count+2; i++) {
            UIImageView *Precell=self.topScrollView.subviews[i];
            Precell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
        }
        
        //改变cell
        UIImageView *cell=self.topScrollView.subviews[number];
        cell.frame=CGRectMake(number*SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
        
    } completion:^(BOOL finished) {
        
    }];
    
    if (index==self.topScrollArray.count+1) {
        [self.topScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.topScrollView.frame), 0) animated:NO];
        self.pageControl.currentPage=0;
        
        
    }else if(index==0)
    {
        [self.topScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.topScrollView.frame)*self.topScrollArray.count, 0) animated:NO];
        self.pageControl.currentPage=self.topScrollArray.count;
    }
    else
    {
        self.pageControl.currentPage=index-1;
    }
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //改变cell
    [UIView animateWithDuration:0.3 animations:^{
        for (int i=0;i<self.topScrollView.subviews.count;i++) {
            UIImageView *cell=self.topScrollView.subviews[i];
            cell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
        }
    }];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag==6666) {
        NSInteger pageNum=self.topScrollView.contentOffset.x/SCREEN_WIDTH;
        
        self.pageControl.currentPage=pageNum;
        if (pageNum==self.topScrollArray.count+1) {
            [self.topScrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:NO];
            self.pageControl.currentPage=0;
        }else if(pageNum==0)
        {
            [self.topScrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame)*self.topScrollArray.count, 0) animated:NO];
            self.pageControl.currentPage=self.topScrollArray.count;
        }
        else
        {
            self.pageControl.currentPage=pageNum-1;
        }
        
        
        [UIView animateWithDuration:0.3 animations:^{
            NSInteger num=pageNum;
            
            for (int i=0; i<self.topScrollArray.count+2; i++) {
                UIImageView *Precell=self.topScrollView.subviews[i];
                Precell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
            }
            
            if (num==self.topScrollArray.count+1) {
                num=1;
            }else if (num==0){
                num=self.topScrollArray.count;
            }
            UIImageView *cell=self.topScrollView.subviews[num];
            cell.frame=CGRectMake(num*SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
        }];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    self.startPointX=scrollView.contentOffset.x;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger pageNum=self.startPointX/SCREEN_WIDTH;
    if (scrollView.contentOffset.x>self.startPointX) {
        pageNum=pageNum+1;
    }else{
        pageNum=pageNum-1;
    }
    if (scrollView.tag==6666) {
        [UIView animateWithDuration:0.3 animations:^{
            NSInteger num=pageNum;
            if (num==self.topScrollArray.count+1) {
                num=1;
            }else if (num==0){
                num=self.topScrollArray.count;
            }
            UIImageView *cell=self.topScrollView.subviews[num];
            cell.frame=CGRectMake(num*SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
        }];
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [self setupTimer];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView.tag==6666) {
        int pageNum=scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
        self.pageControl.currentPage=pageNum;
        
        
        if (pageNum==self.topScrollArray.count+1) {
            [self.topScrollView  setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:NO];
            self.pageControl.currentPage=0;
        }
        else if(pageNum==0)
        {
            [self.topScrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame)*self.topScrollArray.count, 0) animated:NO];
            self.pageControl.currentPage=self.topScrollArray.count;
        }
        else
        {
            self.pageControl.currentPage=pageNum-1;
        }
    }
    
}

-(void)setTopScrollArray:(NSArray *)topScrollArray
{
    _topScrollArray=topScrollArray;
    for (int i=0; i<self.topScrollArray.count+2; i++) {
        UIImageView *cell=[[UIImageView alloc]init];
        cell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
        if (i==1) {

            cell.frame=CGRectMake(SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
        }
        if (i==0) {
            YLFamousTopModel *topModel=topScrollArray[self.topScrollArray.count-1];
            [cell sd_setImageWithURL:[NSURL URLWithString:topModel.topImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        }else if (i==self.topScrollArray.count+1){
            YLFamousTopModel *topModel=topScrollArray[0];
            [cell sd_setImageWithURL:[NSURL URLWithString:topModel.topImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        }else{
            YLFamousTopModel *topModel=topScrollArray[i-1];
            [cell sd_setImageWithURL:[NSURL URLWithString:topModel.topImage] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];            cell.tag=2345+i;
        }
        cell.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [cell addGestureRecognizer:tap];
        [self.topScrollView addSubview:cell];
    }
    self.topScrollView.contentSize=CGSizeMake((self.topScrollArray.count+2)*SCREEN_WIDTH, 0);
    
    self.topScrollView.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
    
    if (self.pageControl) {
        [self.pageControl removeFromSuperview];
    }
    UIPageControl *pageContr=[[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.topScrollView.frame)-20, CGRectGetWidth(self.frame), 20)];
    self.pageControl=pageContr;
    self.pageControl.numberOfPages=self.topScrollArray.count;
    self.pageControl.pageIndicatorTintColor=[UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
    [self addSubview:self.pageControl];
    [self bringSubviewToFront:self.pageControl];
    [self setupTimer];
}

-(void)dealloc
{
    self.topScrollView.delegate=nil;
    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
}

-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [_delegate clickScrollViewItemWithIndex:tap.view.tag-2346];
}

@end
