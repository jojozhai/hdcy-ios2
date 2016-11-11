//
//  YLPhoneChangeViewController.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLPhoneChangeViewController.h"

@interface YLPhoneChangeViewController ()
{
    UIButton *reButton;
    UIButton *_deliverButton;
}
@end

@implementation YLPhoneChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self redeliverAction:nil];
    self.view.backgroundColor=BGColor;
    [self createNavigationBar];
    [self createView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"输入验证码";
    self.cusNavigationView.backgroundColor=BGColor;
    self.statusView.backgroundColor=BGColor;
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
}
//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createView
{
    NSArray *passwordLabelArray=@[@"手机号",@"验证码"];
    for (int i=0; i<2; i++) {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 165+50*i, SCREEN_WIDTH-76*SCREEN_MUTI, 1)];
        lineLabel.backgroundColor=[UIColor grayColor];
        [self.view addSubview:lineLabel];
        
        UILabel *PassWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(59*SCREEN_MUTI, 141+50*i, 45, 15)];
        PassWordLabel.textColor=[UIColor grayColor];
        PassWordLabel.font=FONT_SYS(15);
        PassWordLabel.text=passwordLabelArray[i];
        [self.view addSubview:PassWordLabel];
        
        UITextField *passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(145*SCREEN_MUTI, 141+50*i, 120, 15)];
        passwordTextField.tag=7788+i;
        if (i==0) {
            passwordTextField.text=self.checkNum;
        }
        passwordTextField.keyboardType=UIKeyboardTypeNumberPad;
        passwordTextField.font=FONT_SYS(12);
        passwordTextField.textColor=[UIColor grayColor];
        passwordTextField.borderStyle=UITextBorderStyleNone;
        passwordTextField.secureTextEntry=NO;
        [self.view addSubview:passwordTextField];
    }
    
    reButton=[UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame=CGRectMake(145*SCREEN_MUTI+120, 190,45, 17);
    reButton.titleLabel.font=FONT_SYS(10);
    reButton.layer.borderColor=[UIColor grayColor].CGColor;
    reButton.layer.borderWidth=0.5;
    reButton.layer.cornerRadius=7.5;
    reButton.layer.masksToBounds=YES;
    [reButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [reButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(redeliverAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reButton];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAction)];
    [self.view addGestureRecognizer:tap];
    
    _deliverButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _deliverButton.frame=CGRectMake(38*SCREEN_MUTI, 250, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [_deliverButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [_deliverButton setTitle:@"提交" forState:UIControlStateNormal];
    [_deliverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deliverButton addTarget:self action:@selector(deliverAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deliverButton];
}

-(void)resignAction
{
    UITextField *otf=[self.view viewWithTag:8888];
    [otf resignFirstResponder];
    UITextField *nof=[self.view viewWithTag:8889];
    [nof resignFirstResponder];
    
}

-(void)deliverAction
{
    
    UITextField *otf=[self.view viewWithTag:7788];
    [otf resignFirstResponder];
    UITextField *nof=[self.view viewWithTag:7789];
    [nof resignFirstResponder];
    NSString *urlString=[NSString stringWithFormat:@"%@/sms/code/check",URL];
    NSDictionary *paraDict=@{@"phone":otf.text,@"code":nof.text};
    [YLHttp get:urlString params:paraDict success:^(id json) {
        NSString *phoneString=[NSString stringWithFormat:@"%@/user/property",URL];
        NSDictionary *para=@{@"name":@"mobile",@"value":otf.text};
        NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
        [YLHttp put:phoneString token:token params:para success:^(id json) {
            [MBProgressHUD showMessage:@"修改手机号成功"];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        
    }];
}

-(void)redeliverAction:(UIButton *)btn
{
    if (btn==nil) {
        
    }else{
        UITextField *otf=[self.view viewWithTag:7788];
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
