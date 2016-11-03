//
//  YLPhoneViewController.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLPhoneViewController.h"
#import "YLPhoneChangeViewController.h"
@interface YLPhoneViewController ()
{
    UIButton *_deliverButton;
}
@end

@implementation YLPhoneViewController

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
    self.titleLabel.text=@"手机号码";
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
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 87, SCREEN_WIDTH, 15)];
    label.text=@"更换手机号码后，下次登录可使用新手机号登录";
    label.textColor=[UIColor grayColor];
    label.font=FONT_SYS(14);
    label.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UITextField *phneTextField=[[UITextField alloc]initWithFrame:CGRectMake(59*SCREEN_MUTI, 161, 200, 15)];
    phneTextField.tag=8899;
    phneTextField.keyboardType=UIKeyboardTypeNumberPad;
    phneTextField.placeholder=@"请输入新手机号";
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
    [_deliverButton setTitle:@"提交" forState:UIControlStateNormal];
    [_deliverButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_deliverButton addTarget:self action:@selector(deliverAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_deliverButton];
}

-(void)resignAction
{
    UITextField *tf=[self.view viewWithTag:8899];
    [tf resignFirstResponder];
    
}

-(void)deliverAction
{
    UITextField *tf=[self.view viewWithTag:8899];
    [tf resignFirstResponder];
    if (![self valiMobile:tf.text]) {
        [MBProgressHUD showMessage:@"请输入正确的手机号格式"];
    }else{
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"编辑昵称"
                                                                                  message: [NSString stringWithFormat:@"我们将发送验证码到这个号码:%@",tf.text]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSString *urlString=[NSString stringWithFormat:@"%@/sms/code",URL];
            NSDictionary *paraDict=@{@"phone":tf.text};
            [YLHttp get:urlString params:paraDict success:^(id json) {
                YLPhoneChangeViewController *change=[[YLPhoneChangeViewController alloc]init];
                change.checkNum=tf.text;
                [self presentViewController:change animated:YES completion:nil];
            } failure:^(NSError *error) {
                
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
    }
   
}

//判断手机号码格式是否正确
-(BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
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
