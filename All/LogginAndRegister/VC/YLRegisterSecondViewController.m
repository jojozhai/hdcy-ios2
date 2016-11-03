//
//  YLRegisterSecondViewController.m
//  hdcy
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLRegisterSecondViewController.h"
#import "YLRegisterThirdViewController.h"
@interface YLRegisterSecondViewController ()
{
    UIView *whiteView;
}
@end

@implementation YLRegisterSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        TextField.secureTextEntry=YES;
        [whiteView addSubview:TextField];
    }
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+125, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"获得短信验证码" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(getMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    for (int i=0; i<3; i++) {
        UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(147*SCREEN_MUTI+22*SCREEN_MUTI*i, 179*SCREEN_MUTI+250, 17*SCREEN_MUTI, 17*SCREEN_MUTI)];
        numLabel.text=[NSString stringWithFormat:@"%d",i+1];
        if (i==1) {
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

-(void)getMessage
{
    YLRegisterThirdViewController *third=[[YLRegisterThirdViewController alloc]init];
    [self presentViewController:third animated:NO completion:nil];
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
