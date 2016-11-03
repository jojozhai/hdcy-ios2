//
//  YLAboutWebViewController.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLAboutWebViewController.h"

@interface YLAboutWebViewController ()
{
    UIWebView *_webView;
}
@end

@implementation YLAboutWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self createNavigationBar];
    NSString *urlString=[NSString stringWithFormat:@"%@",URL];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    //_webView.scrollView.scrollEnabled = NO;
    //[_webView sizeToFit];
    _webView.scalesPageToFit = YES;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"关于我们";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
}
//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
