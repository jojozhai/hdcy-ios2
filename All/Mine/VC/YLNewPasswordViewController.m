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
        passwordTextField.tag=8888+i;
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
    UITextField *otf=[self.view viewWithTag:8888];
    [otf resignFirstResponder];
    UITextField *nof=[self.view viewWithTag:8889];
    [nof resignFirstResponder];
    
}

-(void)deliverAction
{
    UITextField *otf=[self.view viewWithTag:8888];
    UITextField *nof=[self.view viewWithTag:8889];
    NSString *urlstring=[NSString stringWithFormat:@"%@/user/password",URL];
    NSDictionary *padict=@{@"oldPassword":otf.text,@"newPassword":nof.text};
    [YLHttp put:urlstring userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:padict success:^(id json) {
        
    } failure:^(NSError *error) {
        
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
