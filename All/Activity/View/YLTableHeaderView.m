//
//  YLTableHeaderView.m
//  hdcy
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLTableHeaderView.h"
#import "YLActiTableViewCell.h"

@interface YLTableHeaderView()<UIScrollViewDelegate>

@property (nonatomic,weak)UIScrollView *topScrollView;
@property (nonatomic,weak)NSTimer *scrollTimer;
@property (nonatomic,weak)UIPageControl *pageControl;

@end
@implementation YLTableHeaderView
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
        //改变cell
        for (int i=0;i<self.topScrollView.subviews.count;i++) {
            YLActiTableViewCell *cell=self.topScrollView.subviews[i];
            cell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
        }
        YLActiTableViewCell *cell=self.topScrollView.subviews[number];
        cell.frame=CGRectMake(number*SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
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
            YLActiTableViewCell *cell=self.topScrollView.subviews[i];
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
        
        if (pageNum==self.topScrollArray.count+1) {
            pageNum=1;
        }else if (pageNum==0){
            pageNum=self.topScrollArray.count;
        }
        YLActiTableViewCell *cell=self.topScrollView.subviews[pageNum];
        cell.frame=CGRectMake(pageNum*SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{

    [self.scrollTimer invalidate];
    self.scrollTimer = nil;
    
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
        YLActiTableViewCell *cell=[[YLActiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        cell.frame=CGRectMake(i*SCREEN_WIDTH-30*SCREEN_MUTI, 17*SCREEN_MUTI,435*SCREEN_MUTI,  SCREEN_MUTI*190);
        if (i==1) {
             cell.frame=CGRectMake(SCREEN_WIDTH+38*SCREEN_MUTI, 0, 299*SCREEN_MUTI, 225*SCREEN_MUTI);
        }
        if (i==0) {
            cell.model=topScrollArray[self.topScrollArray.count-1];
        }else if (i==self.topScrollArray.count+1){
            cell.model=topScrollArray[0];
        }else{
            cell.model=topScrollArray[i-1];
            cell.tag=2345+i;
        }
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
}


-(void)tapAction:(UITapGestureRecognizer *)tap
{
    [_Sdelegate clickScrollViewItemWithIndex:tap.view.tag-2346];
}

@end
