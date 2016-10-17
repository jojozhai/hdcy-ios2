//
//  YLOutLinkViewController.m
//  hdcy
//
//  Created by mac on 16/10/16.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLOutLinkViewController.h"

@interface YLOutLinkViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
}
@end

@implementation YLOutLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setWebView];
    [self createNavigationBar];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
}
//返回
-(void)backAction
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setWebView
{
    
    //创建webview
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    _webView.delegate=self;
    //_webView.scrollView.scrollEnabled = NO;
    //[_webView sizeToFit];
    _webView.scalesPageToFit = YES;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
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
     
    NSLog(@"结束加载");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
