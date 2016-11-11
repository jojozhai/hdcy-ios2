//
//  YLNewPasswordViewController.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLNewPasswordViewController.h"

@interface YLNewPasswordViewController ()
{
    UIButton *_deliverButton;
}
@end

@implementation YLNewPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self createNavigationBar];
    [self createView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"修改密码";
    self.cusNavigationView.backgroundColor=BGColor;
    self.statusView.backgroundColor=BGColor;
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

-(void)createView
{
    NSArray *passwordLabelArray=@[@"旧密码",@"新密码"];
    for (int i=0; i<2; i++) {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 165+50*i, SCREEN_WIDTH-76*SCREEN_MUTI, 1)];
        lineLabel.backgroundColor=[UIColor grayColor];
        [self.view addSubview:lineLabel];
        
        UILabel *PassWordLabel=[[UILabel alloc]initWithFrame:CGRectMake(59*SCREEN_MUTI, 141+50*i, 45, 15)];
        PassWordLabel.textColor=[UIColor grayColor];
        PassWordLabel.font=FONT_SYS(15);
        PassWordLabel.text=passwordLabelArray[i];
        [self.view addSubview:PassWordLabel];
        
        UITextField *passwordTextField=[[UITextField alloc]initWithFrame:CGRectMake(145*SCREEN_MUTI, 141+50*i, 144, 15)];
        passwordTextField.tag=8808+i;
        passwordTextField.font=FONT_SYS(12);
        passwordTextField.textColor=[UIColor grayColor];
        passwordTextField.borderStyle=UITextBorderStyleNone;
        passwordTextField.secureTextEntry=YES;
        [self.view addSubview:passwordTextField];
    }
    
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
    UITextField *otf=[self.view viewWithTag:8808];
    [otf resignFirstResponder];
    UITextField *nof=[self.view viewWithTag:8809];
    [nof resignFirstResponder];
    
}

-(void)deliverAction
{
    UITextField *otf=[self.view viewWithTag:8808];
    UITextField *nof=[self.view viewWithTag:8809];
    NSString *oldpass=[nof.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (otf.text.length==0||nof.text.length==0) {
        [MBProgressHUD showMessage:@"旧密码或新密码不能为空"];
        return;
    }
    if (nof.text.length<8||nof.text.length>12) {
        [MBProgressHUD showMessage:@"新密码在8～12位之间"];
        return;
    }
    NSString *urlstring=[NSString stringWithFormat:@"%@/user/password?oldPassword=%@&newPassword=%@",URL,otf.text,oldpass];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    [YLHttp put:urlstring token:token params:nil success:^(id json) {
        [MBProgressHUD showMessage:@"修改成功"];
        NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:USERNAME];
        NSString *urlS=[NSString stringWithFormat:@"%@/user/login",URL];
        NSDictionary *paraD=@{@"username":str,@"password":oldpass};
        [YLHttp post:urlS params:paraD success:^(id json) {
            if ([json[@"result"] isEqual:@(YES)]) {
                [[NSUserDefaults standardUserDefaults]setObject:json[@"content"] forKey:BASE64CONTENT];
            }
        } failure:^(NSError *error) {
            
        }];
    } failure:^(NSError *error) {
        [MBProgressHUD showMessage:@"旧密码错误"];
    }];
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
