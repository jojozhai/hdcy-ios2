//
//  YLActivityTopView.m
//  hdcy
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityTopView.h"
#define imageViewBaseTag 954
@interface YLActivityTopView()<UIWebViewDelegate>
{
    UIWebView * web;
    UIScrollView *PicScrollView;
    UIButton *button;
    NSInteger webHeight;
    BOOL open;
}
@end
@implementation YLActivityTopView
-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        open=NO;
        [self createView];
    }
    return self;
}

-(void)createView
{
    web=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90*SCREEN_MUTI)];
    web.delegate=self;
    web.scrollView.scrollEnabled=NO;
    [self addSubview:web];
    
    PicScrollView=[[UIScrollView alloc]init];
    PicScrollView.alwaysBounceHorizontal=YES;
    [self addSubview:PicScrollView];
    
    button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.size=CGSizeMake(18*SCREEN_MUTI, 18*SCREEN_MUTI);
    button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
    [button setImage:[UIImage imageNamed:@"content-icon-open1-default"] forState:UIControlStateNormal];
    [self addSubview:button];
    
    [self setContenSize];
}

-(void)setContenSize
{
    PicScrollView.sd_layout
    .topSpaceToView(web,18)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(80*SCREEN_MUTI);
    
    button.sd_layout
    .topSpaceToView(PicScrollView,12)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(20*SCREEN_MUTI);

}
-(void)setPicArray:(NSArray *)picArray
{
    _picArray=picArray;
    for (int i=0; i<picArray.count; i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(8+108*i, 0, 100, 80*SCREEN_MUTI)];
        imageView.userInteractionEnabled=YES;
        imageView.tag=i+imageViewBaseTag;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageEnlargeAction:)];
        [imageView addGestureRecognizer:tap];
        [imageView sd_setImageWithURL:picArray[i] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRetryFailed];
        [PicScrollView addSubview:imageView];
    }
    PicScrollView.contentSize=CGSizeMake(108*picArray.count+8, 80*SCREEN_MUTI);
    PicScrollView.showsHorizontalScrollIndicator=NO;
    PicScrollView.scrollEnabled=YES;
    
}
-(void)setDescip:(NSString *)descip
{
    _descip=descip;
     [web loadHTMLString:self.descip baseURL:nil];
}

-(void)buttonClick:(UIButton *)btn
{
    if (open==YES) {
        web.frame=CGRectMake(0, 0, SCREEN_WIDTH, 90*SCREEN_MUTI);
        self.frame=CGRectMake(0,40*SCREEN_MUTI, SCREEN_WIDTH, 225*SCREEN_MUTI);
        [_delegate topViewChangeViewHeight:225*SCREEN_MUTI];
        [button setImage:[UIImage imageNamed:@"content-icon-open1-default"] forState:UIControlStateNormal];
        open=NO;
    }else{
        web.frame=CGRectMake(0, 0, SCREEN_WIDTH, webHeight);
        self.frame=CGRectMake(0, 40*SCREEN_MUTI, SCREEN_WIDTH, 225*SCREEN_MUTI-90*SCREEN_MUTI+webHeight);
        [_delegate topViewChangeViewHeight:225*SCREEN_MUTI-90*SCREEN_MUTI+webHeight];
        [button setImage:[UIImage imageNamed:@"content-icon-close-default-"] forState:UIControlStateNormal];
        open=YES;
    }
    
}

-(void)imageEnlargeAction:(UITapGestureRecognizer *)tap
{
    [_iDelegate imageViewClickWithIndex:tap.view.tag-imageViewBaseTag];
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat webViewHeight = webView.scrollView.contentSize.height;
    webHeight=webViewHeight;
    NSLog(@"结束加载");
    //    隐藏加载
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}
@end
