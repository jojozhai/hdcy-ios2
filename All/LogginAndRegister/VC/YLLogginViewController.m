//
//  YLLogginViewController.m
//  hdcy
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLLogginViewController.h"
#import "YLPassWordBackViewController.h"
#import "YLMainViewController.h"
#import "YLVideoViewController.h"
#import "YLNewsViewController.h"
#import "YLActivityViewController.h"
#import "YLFamousViewController.h"
#import "YLMineViewController.h"
#import "YLInLetterViewController.h"
#import "YLAboutWebViewController.h"
@interface YLLogginViewController ()
{
    UIView *whiteView;
}
@end

@implementation YLLogginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBar];
    [self cusView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"登录";
    self.cusNavigationView.backgroundColor=[UIColor clearColor];
    self.statusView.backgroundColor=[UIColor clearColor];
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
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

-(void)tapAction
{
    UITextField *textF=[whiteView viewWithTag:8822];
    [textF resignFirstResponder];
    UITextField *textFi=[whiteView viewWithTag:8823];
    [textFi resignFirstResponder];
}

-(void)cusView
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImageView.image=[UIImage imageNamed:@"register_background@2x"];
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.cusNavigationView];
    whiteView=[[UIView alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 182*SCREEN_MUTI, SCREEN_WIDTH-76*SCREEN_MUTI, 100)];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.cornerRadius=5;
    whiteView.layer.masksToBounds=YES;
    [self.view addSubview:whiteView];
    NSArray *array=@[@"请输入手机号",@"请输入密码"];
    for (int i=0; i<2; i++) {
        UITextField *TextField=[[UITextField alloc]initWithFrame:CGRectMake(12*SCREEN_MUTI, 18+50*i,SCREEN_WIDTH-90*SCREEN_MUTI, 15)];
        TextField.tag=8822+i;
        TextField.placeholder=array[i];
        TextField.font=FONT_SYS(15);
        TextField.textColor=[UIColor grayColor];
        TextField.borderStyle=UITextBorderStyleNone;
        if (i==0) {
            TextField.secureTextEntry=NO;
            TextField.keyboardType=UIKeyboardTypeNumberPad;
        }else{
            TextField.secureTextEntry=YES;
        }
        [whiteView addSubview:TextField];
    }
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+125, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"登录" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(loggin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    UILabel *negotiate=[[UILabel alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+190, 200, 12)];
    negotiate.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(negotiatetapClcik)];
    [negotiate addGestureRecognizer:tap];
    negotiate.attributedText=[self getAttributedString];
    negotiate.font=FONT_SYS(12);
    negotiate.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:negotiate];
    
    UIButton *forget=[UIButton buttonWithType:UIButtonTypeCustom];
    forget.frame=CGRectMake(SCREEN_WIDTH-60-38*SCREEN_MUTI, 179*SCREEN_MUTI+190, 60, 15);
    [forget setTitle:@"忘记密码" forState:UIControlStateNormal];
    forget.titleLabel.font=FONT_SYS(15);
    [forget setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forget addTarget:self action:@selector(forgetAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forget];
    
}

-(void)negotiatetapClcik
{
    YLAboutWebViewController *negotiate=[[YLAboutWebViewController alloc]init];
    negotiate.row=2;
    [self presentViewController:negotiate animated:NO completion:nil];
}

-(void)forgetAction
{
    YLPassWordBackViewController *passBack=[[YLPassWordBackViewController alloc]init];
    [self presentViewController:passBack animated:NO completion:nil];
}

-(NSMutableAttributedString *)getAttributedString{
    //创建一个NSMutableAttributedString
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"点击下一步，表示同意《用户协议》"];
    //把this的字体颜色变为红色
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor whiteColor].CGColor
                        range:NSMakeRange(0, 10)];
    //把is变为黄色
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor blueColor].CGColor
                        range:NSMakeRange(10, 6)];
    return attriString;
}

-(void)loggin
{
    UITextField *UNTF=[whiteView viewWithTag:8822];
    [UNTF resignFirstResponder];
    UITextField *PWTF=[whiteView viewWithTag:8823];
    [PWTF resignFirstResponder];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/login",URL];
    NSDictionary *paraDict=@{@"username":UNTF.text,@"password":PWTF.text};
 
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json"
   forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:paraDict options:NSJSONWritingPrettyPrinted error:nil]];
    NSOperation *operation =
    [mgr HTTPRequestOperationWithRequest:request
                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                     // 成功后的处理
                                     [[NSUserDefaults standardUserDefaults]setValue:responseObject[@"content"] forKey:BASE64CONTENT];
                                     [[NSUserDefaults standardUserDefaults]setValue:UNTF.text forKey:USERNAME];
                                     [[NSUserDefaults standardUserDefaults] synchronize];
                                     
                                     if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[YLMainViewController class]]) {
                                         [[NSNotificationCenter defaultCenter]postNotificationName:MINENOTIFICATION object:nil];
                                         [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
                                     }else{
                                         YLMainViewController *main=[[YLMainViewController alloc]init];
                                         
                                         YLVideoViewController *video=[[YLVideoViewController alloc]init];
                                         YLNewsViewController *news=[[YLNewsViewController alloc]init];
                                         news.topHeight=40;
                                         news.selectedButtonColor=[UIColor whiteColor];
                                         news.topBackgroudColor=RGBCOLOR(143, 175, 202);
                                         YLActivityViewController *activity=[[YLActivityViewController alloc]init];
                                         YLFamousViewController *famous=[[YLFamousViewController alloc]init];
                                         
                                         video.title=@"视频";
                                         news.title=@"资讯";
                                         activity.title=@"活动";
                                         famous.title=@"大咖";
                                         main.viewControllers=@[video,news,activity,famous];
                                         main.topHeight=50;
                                         main.selectedButtonColor=RGBCOLOR(0, 254, 252);
                                         
                                         YLMineViewController *mine=[[YLMineViewController alloc]init];
                                         main.mineVC=mine;
                                         YLInLetterViewController *inletter=[[YLInLetterViewController alloc]init];
                                         main.inletterVC=inletter;
                                         [[UIApplication sharedApplication].keyWindow setRootViewController:main];
                                         [self presentViewController:main animated:YES completion:nil];
                                         
                                     }
                                 }
                                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     // 失败后的处理
                                     [MBProgressHUD showMessage:@"用户名或密码不正确"];
                                 }];
    [mgr.operationQueue addOperation:operation];
    

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
