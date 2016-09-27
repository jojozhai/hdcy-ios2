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
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNav];
    [self monitorNet];
}

-(void)monitorNet
{
    self.isOnline=YES;
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable) {
            [MBProgressHUD showMessage:@"当前没有网络"];
            self.isOnline=NO;
        }else{
            self.isOnline=YES;
        }
    }
     ];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)setNav
{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
 
}

-(void)addLeftBarButtonItemWithImageName:(NSString *)imageName

                                  target:(id)target
                                selector:(SEL)selector
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 12, 20)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)addRightBarButtonItemWithImageName:(NSString *)imageName

                                  target:(id)target
                                selector:(SEL)selector
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
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
