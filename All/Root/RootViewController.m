//
//  RootViewController.m
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "RootViewController.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.statusView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    self.statusView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.statusView];
    [self cusNavigationBar];
    [self monitorNet];
}

-(void)monitorNet
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable) {
            [MBProgressHUD showMessage:@"当前没有网络"];
            
        }else{
            
        }
    }
     ];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)cusNavigationBar
{
    //添加自定义导航栏
    self.cusNavigationView=[[UIView alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, 50)];
    self.cusNavigationView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.cusNavigationView];
    
    self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 15, 200, 20)];
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
    self.titleLabel.textColor=[UIColor whiteColor];
    self.titleLabel.font=FONT_SYS(16);
    [self.cusNavigationView addSubview:self.titleLabel];
}


-(void)addLeftBarButtonItemWithImageName:(NSString *)imageName
                                  target:(id)target
                                selector:(SEL)selector
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(2,5, 40, 40)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:selector];
    [backView addGestureRecognizer:tap];
    [self.cusNavigationView addSubview:backView];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10,10, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [backView addSubview:button];
}

-(void)addRightBarButtonItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                 selector:(SEL)selector
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42, 5, 40, 40)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:selector];
    [backView addGestureRecognizer:tap];
    [self.cusNavigationView addSubview:backView];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(10, 10, 20, 20);
    if (title!=nil) {
         button.frame=CGRectMake(0, 10, 40, 20);
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
}

-(void)addSecondRightBarButtonItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                 selector:(SEL)selector
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-85, 5, 40, 40)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:selector];
    [backView addGestureRecognizer:tap];
    [self.cusNavigationView addSubview:backView];
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button];
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
