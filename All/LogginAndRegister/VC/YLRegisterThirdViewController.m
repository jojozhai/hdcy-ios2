//
//  YLRegisterThirdViewController.m
//  hdcy
//
//  Created by mac on 16/11/1.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLRegisterThirdViewController.h"
#import "YLLogginViewController.h"
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
    TextField.borderStyle=UITextBorderStyleNone;
    TextField.secureTextEntry=YES;
    [whiteView addSubview:TextField];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+75, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"完成" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    reButton=[UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame=CGRectMake(145*SCREEN_MUTI+120, 190,45, 17);
    reButton.titleLabel.font=FONT_SYS(10);
    reButton.layer.borderColor=[UIColor grayColor].CGColor;
    reButton.layer.borderWidth=0.5;
    reButton.layer.cornerRadius=7.5;
    reButton.layer.masksToBounds=YES;
    reButton.backgroundColor=BGColor;
    [reButton setTitle:@"重新发送" forState:UIControlStateNormal];
    [reButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [reButton addTarget:self action:@selector(redeliverAction) forControlEvents:UIControlEventTouchUpInside];
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
    YLLogginViewController *loggin=[[YLLogginViewController alloc]init];
    [self presentViewController:loggin animated:NO completion:nil];
}

-(void)redeliverAction
{
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
