//
//  YLNewsInfoViewController.m
//  hdcy
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLNewsInfoViewController.h"
#import "YLWriteCommentView.h"
#import "YLNotiModel.h"
#import "YLCommentViewController.h"
#import "UMSocial.h"
@interface YLNewsInfoViewController ()<UIWebViewDelegate,UITextFieldDelegate,UITextViewDelegate,UMSocialUIDelegate>
{
    UIWebView *_webView;
    UIView *bottomView;
    UIView *coverView;
    YLNotiModel *Nmodel;
    YLWriteCommentView *writeCommentView;
    
}

@end

@implementation YLNewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置model，kvo监听
    Nmodel=[[YLNotiModel alloc]init];
    [Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self request];
    [self requestUrl];
    [self createNavigationBar];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}
//放在这里，验证信息
-(void)request
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(0),@"size":@"5",@"sort":@"createdTime,desc",@"targetId":self.listModel.Id,@"target":@"article"};
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
 
        
    } failure:^(NSError *error) {
        
    }];
    
}

//设置navbar
-(void)createNavigationBar
{
//    self.view.backgroundColor=[UIColor whiteColor];
//    self.title=@"资讯详情";
//    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
//    //分享，暂不做
//    
//    [self addRightBarButtonItemWithImageName:@"nav-icon-share-default" title:nil target:self selector:@selector(shareAction)];
//    
//    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [button setBackgroundImage:[UIImage imageNamed:@"nav-icon-information-default"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(infoAction) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
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

-(void)shareAction
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/articleDetails.html?id=%@&show=YES",self.listModel.Id]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.listModel.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
    [UMSocialData defaultData].extConfig.title = self.listModel.title;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
}

-(void)infoAction
{

}
#pragma ----------------UMSocialUIDelegate-------------------------------
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

-(void)createCommentView
{
    //添加蒙板
    coverView=[[UIView alloc]initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    [self.view addSubview:coverView];
    coverView.hidden=YES;
    //加载评论
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"YLWriteCommentView" owner:self options:nil];
    //得到第一个UIView
    writeCommentView= [nib objectAtIndex:0];
    writeCommentView.tag=99;
    writeCommentView.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    writeCommentView.commentTextView.text=@"";
    writeCommentView.commentTextView.delegate=self;
    [writeCommentView.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [writeCommentView.dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:writeCommentView];
}


-(void)pushAction
{
    YLCommentViewController *comment=[[YLCommentViewController alloc]init];
    comment.Id=self.listModel.Id;
    comment.target=@"article";
    comment.changeBlock=^(){
        UIButton *button=[bottomView viewWithTag:6789];
        [button setTitle:[NSString stringWithFormat:@"%ld",self.listModel.commentCount.integerValue+1] forState:UIControlStateNormal];
        
        
        
    };
    [self.navigationController pushViewController:comment animated:YES];
}
#pragma mark----------------------可能会删－－－－－－－－－－－－－－－－－－－－－－－－－
-(void)requestUrl
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/article/%@",self.listModel.Id]];
    [YLHttp get:urlString params:nil success:^(id json) {
        [self setWebView];
        [self createCommentView];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)setWebView
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/articleDetails.html?id=%@",self.listModel.Id]];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 0)];
    _webView.delegate=self;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
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
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    
    //获取内容实际高度（像素）
    _webView.frame=CGRectMake(0, 70, SCREEN_WIDTH, webViewHeight);
    NSLog(@"结束加载");
//    隐藏加载
     
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

#pragma UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //取消textField的第一响应
    [textField resignFirstResponder];
    bottomView.hidden=YES;
    coverView.hidden=NO;
    
}

-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict=noti.userInfo;
    // 获取键盘升起/落下的时间
    CGFloat duration=[dict[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    NSValue *value=dict[UIKeyboardFrameEndUserInfoKey];
    CGRect frame=value.CGRectValue;
    CGFloat height=frame.size.height;
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    //键盘升起
    [UIView animateWithDuration:duration animations:^{
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195-height, SCREEN_WIDTH, 195);
    }];
}

-(void)keyboardWillHide
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    coverView.hidden=YES;
    [wcv.commentTextView resignFirstResponder];
    wcv.commentTextView.text=@"";
    bottomView.hidden=NO;
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
}


//发送按钮
-(void)sendAction
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    if (wcv.commentTextView.text.length==0||wcv.commentTextView.text==nil||[wcv.commentTextView.text isEqual:@""]||[wcv.commentTextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请正确输入内容"];
    }else{
        
        wcv.commentTextView.delegate=self;
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":@"article",@"targetId":self.listModel.Id,@"content":wcv.commentTextView.text};
        
        [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            UIButton *button=[bottomView viewWithTag:6789];
            [button setTitle:[NSString stringWithFormat:@"%ld",self.listModel.commentCount.integerValue+1] forState:UIControlStateNormal];
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
        } failure:^(NSError *error) {
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布失败";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
        }];
        coverView.hidden=YES;
        wcv.commentTextView.text=@"";
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
        wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        [wcv.commentTextView resignFirstResponder];
        bottomView.hidden=NO;
    }
}

//取消按钮
-(void)dismissClick
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    wcv.commentTextView.text=@"";
    [wcv.commentTextView resignFirstResponder];
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
    coverView.hidden=YES;
    bottomView.hidden=NO;
}

#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    Nmodel.changeText=textView.text;
    if ([textView.text length]>250) {
         textView.text = [textView.text substringToIndex:250];
    }
}
//限制字数为50字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=250)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}

 

//kvo监听textView字数变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    if ([keyPath isEqualToString:@"changeText"]) {
        if (wcv.commentTextView.text.length<=250) {
            wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        }
    }
}

-(void)dealloc
{
    
    [Nmodel removeObserver:self forKeyPath:@"changeText"];
}

#pragma mark-----------------------懒加载--------------------------------------------------


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end
