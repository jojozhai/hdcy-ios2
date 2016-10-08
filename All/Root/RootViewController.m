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
    self.view.backgroundColor=[UIColor blackColor];
    [self cusNavigationBar];
}

-(void)cusNavigationBar
{
    //添加自定义导航栏
    self.cusNavigationView=[[UIView alloc]initWithFrame:CGRectMake(0,20, SCREEN_WIDTH, 50)];
    self.cusNavigationView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.cusNavigationView];
}


-(void)addLeftBarButtonItemWithImageName:(NSString *)imageName
                                  target:(id)target
                                selector:(SEL)selector
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(12,10, 30, 30)];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.cusNavigationView addSubview:button];
}

-(void)addRightBarButtonItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                 selector:(SEL)selector
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-42, 10, 30, 30)];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.cusNavigationView addSubview:button];
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
