//
//  YLRegisterThirdViewController.m
//  hdcy
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLRegisterThirdViewController.h"
#import "YLLogginViewController.h"
#import "YLRegisterMessage.h"
#import "YLJSONResponseSerializer.h"
@interface YLRegisterThirdViewController ()
{
    UIButton *reButton;
    UIView *whiteView;
}
@end

@implementation YLRegisterThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self redeliverAction:nil];
    [self createNavigationBar];
    [self cusView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"注册";
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapAction
{
    UITextField *textF=[whiteView viewWithTag:8800];
    [textF resignFirstResponder];
}
-(void)cusView
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImageView.image=[UIImage imageNamed:@"register_background@2x"];
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.cusNavigationView];
    
    whiteView=[[UIView alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 182*SCREEN_MUTI, SCREEN_WIDTH-76*SCREEN_MUTI, 50)];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.cornerRadius=5;
    whiteView.layer.masksToBounds=YES;
    [self.view addSubview:whiteView];
    
    UITextField *TextField=[[UITextField alloc]initWithFrame:CGRectMake(12*SCREEN_MUTI, 18,130*SCREEN_MUTI, 15)];
    TextField.tag=8800;
    TextField.placeholder=@"请输入验证码";
    TextField.font=FONT_SYS(15);
    TextField.textColor=[UIColor grayColor];
    TextField.keyboardType=UIKeyboardTypeNumberPad;
    TextField.borderStyle=UITextBorderStyleNone;
    TextField.secureTextEntry=NO;
    [whiteView addSubview:TextField];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+75, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    reButton=[UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame=CGRectMake(SCREEN_WIDTH-76*SCREEN_MUTI-50,18,45, 20);
    reButton.titleLabel.font=FONT_SYS(10);
    reButton.layer.borderColor=[UIColor grayColor].CGColor;
    reButton.layer.borderWidth=0.5;
    reButton.layer.cornerRadius=7.5;
    reButton.layer.masksToBounds=YES;
    reButton.backgroundColor=BGColor;
    [reButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [reButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(redeliverAction:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:reButton];
    
    for (int i=0; i<3; i++) {
        UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(147*SCREEN_MUTI+22*SCREEN_MUTI*i, 179*SCREEN_MUTI+250, 17*SCREEN_MUTI, 17*SCREEN_MUTI)];
        numLabel.text=[NSString stringWithFormat:@"%d",i+1];
        if (i==2) {
            numLabel.backgroundColor=BGColor;
        }else{
            numLabel.backgroundColor=[UIColor grayColor];
        }
        numLabel.textColor=[UIColor whiteColor];
        numLabel.layer.cornerRadius=17*SCREEN_MUTI/2;
        numLabel.layer.masksToBounds=YES;
        numLabel.font=FONT(11);
        numLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:numLabel];
    }
    
}

-(void)complete
{
    UITextField *CTF=[whiteView viewWithTag:8800];
    [CTF resignFirstResponder];
    NSString *nickname=[YLRegisterMessage sharedRegisterMessage].nickname;
    NSString *password=[YLRegisterMessage sharedRegisterMessage].password;
    NSString *sex=[YLRegisterMessage sharedRegisterMessage].sex;
    NSString *city=[YLRegisterMessage sharedRegisterMessage].city;
    NSString *mobile=[YLRegisterMessage sharedRegisterMessage].username;
   
    NSString *urlString=[NSString stringWithFormat:@"%@/sms/code/check",URL];
    NSDictionary *paraDict=@{@"phone":mobile,@"code":CTF.text};
    [YLHttp get:urlString params:paraDict success:^(id json) {
        NSString *reString=[NSString stringWithFormat:@"%@/user",URL];
        NSDictionary *dictionary=@{@"username":mobile,@"nickname":nickname,@"password":password,@"sex":sex,@"city":city};
        
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        //mgr.responseSerializer=[YLJSONResponseSerializer serializer];
        NSMutableURLRequest *request =
        [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:reString]];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json"
       forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil]];
        NSOperation *operation =
        [mgr HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         // 成功后的处理
                                         [MBProgressHUD showMessage:@"注册成功"];
                                         YLLogginViewController *loggin=[[YLLogginViewController alloc]init];
                                         [self presentViewController:loggin animated:NO completion:nil];
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         // 失败后的处理
                                         [MBProgressHUD showMessage:@"手机号已存在"];
                                     }];
        [mgr.operationQueue addOperation:operation];
        
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:@"验证信息失败"];
    }];
    
}

-(void)redeliverAction:(UIButton *)btn
{
    if (btn==nil) {
        
    }else{
        UITextField *otf=[self.view viewWithTag:8800];
        [otf resignFirstResponder];
        NSString *urlString=[NSString stringWithFormat:@"%@/sms/code",URL];
        NSDictionary *paraDict=@{@"phone":otf.text};
        [YLHttp get:urlString params:paraDict success:^(id json) {
            
        } failure:^(NSError *error) {
            
        }];
    }
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [reButton setTitle:@"重新发送" forState:UIControlStateNormal];
                reButton.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [reButton setTitle:[NSString stringWithFormat:@"%ds", seconds] forState:UIControlStateNormal];
                reButton.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
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
