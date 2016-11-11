//
//  YLBackCodeViewController.m
//  hdcy
//
//  Created by mac on 16/11/2.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLBackCodeViewController.h"

@interface YLBackCodeViewController ()
{
    UIButton *_deliverButton;
}
@end

@implementation YLBackCodeViewController

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
    self.titleLabel.text=@"找回密码";
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
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 185, SCREEN_WIDTH-76*SCREEN_MUTI, 1)];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self.view addSubview:lineLabel];
    
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"请输入新密码"];
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor grayColor].CGColor
                        range:NSMakeRange(0,6)];
    UITextField *phneTextField=[[UITextField alloc]initWithFrame:CGRectMake(57*SCREEN_MUTI, 161, 200, 15)];
    phneTextField.tag=8866;
    phneTextField.attributedPlaceholder=attriString;
    phneTextField.font=FONT_SYS(12);
    phneTextField.textColor=[UIColor grayColor];
    phneTextField.borderStyle=UITextBorderStyleNone;
    phneTextField.secureTextEntry=NO;
    [self.view addSubview:phneTextField];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAction)];
    [self.view addGestureRecognizer:tap];
    
    _deliverButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _deliverButton.frame=CGRectMake(38*SCREEN_MUTI, 220, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [_deliverButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [_deliverButton setTitle:@"完成" forState:UIControlStateNormal];
    [_deliverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deliverButton addTarget:self action:@selector(deliverAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deliverButton];
}

-(void)resignAction
{
    UITextField *tf=[self.view viewWithTag:8866];
    [tf resignFirstResponder];
    
}

-(void)deliverAction
{
    UITextField *tf=[self.view viewWithTag:8866];
    [tf resignFirstResponder];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/password/reset",URL];
    NSDictionary *dict=@{@"phone":self.mobile,@"password":tf.text};

    [YLHttp put:urlString token:nil params:dict success:^(id json) {
        [MBProgressHUD showMessage:@"修改成功"];
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
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
