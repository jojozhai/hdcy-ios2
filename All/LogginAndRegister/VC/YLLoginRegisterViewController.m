//
//  YLLoginRegisterViewController.m
//  hdcy
//
//  Created by mac on 16/11/8.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLLoginRegisterViewController.h"
#import "CRMotionView.h"
#import "YLLogginViewController.h"
#import "YLRegisterOneViewController.h"
#import "YLMainViewController.h"
#import "YLVideoViewController.h"
#import "YLNewsViewController.h"
#import "YLActivityViewController.h"
#import "YLFamousViewController.h"
#import "YLMineViewController.h"
#import "YLInLetterViewController.h"
@interface YLLoginRegisterViewController ()
{
    CRMotionView *motionView;
    int  currentIndex;
}
@end

@implementation YLLoginRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    motionView = [[CRMotionView alloc] initWithFrame:self.view.bounds];
    //加载临时数据
    [self loadData];
    
    
    [self.view addSubview:motionView];
    
    UIButton * btnLogin = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 100, 120, 40)];
    [btnLogin setTitle:@"注册" forState:UIControlStateNormal];
    [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnLogin.layer setBorderWidth:1];
    [btnLogin.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnLogin addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [motionView addSubview:btnLogin];
    
    
    UIButton * btnRegist = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140, self.view.frame.size.height - 100, 120, 40)];
    [btnRegist setTitle:@"登录" forState:UIControlStateNormal];
    [btnRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnRegist.layer setBorderWidth:1];
    [btnRegist.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnRegist addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [motionView addSubview:btnRegist];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 20)];
    [titleLabel setText:@"摇一摇换背景"];
    [titleLabel setShadowOffset:CGSizeMake(0, 1.0f)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setShadowColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [motionView addSubview:titleLabel];
    
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
}

-(void)loginClick
{
    YLLogginViewController *loggin=[[YLLogginViewController alloc]init];
    [self presentViewController:loggin animated:NO completion:nil];
}

-(void)registerClick
{
    YLRegisterOneViewController *regist=[[YLRegisterOneViewController alloc]init];
    [self presentViewController:regist animated:NO completion:nil];
}
 
/***
 *临时填充数据方法
 *
 *
 */

-(void)loadData
{
    //初始化图片数组
    self.imagesArray = [[NSMutableArray alloc]init];
    NSMutableDictionary * dic = [NSMutableDictionary new];
    [dic setValue:@"1500" forKey:@"width"];
    [dic setValue:@"1000" forKey:@"height"];
    [dic setValue:@"Image" forKey:@"name"];
    [self.imagesArray addObject:dic];
    
    dic = [NSMutableDictionary new];
    [dic setValue:@"1500" forKey:@"width"];
    [dic setValue:@"1000" forKey:@"height"];
    [dic setValue:@"Image1" forKey:@"name"];
    [self.imagesArray addObject:dic];
    
    //初始化坐标数组
    self.dataArray = [NSMutableArray new];
    dic = [NSMutableDictionary new];
    [dic setValue:@"730.4" forKey:@"pos_x"];
    [dic setValue:@"530.4" forKey:@"pos_y"];
    [dic setValue:@"宝马MWB00" forKey:@"title"];
    
    [self.dataArray addObject:dic];
    
    dic = [NSMutableDictionary new];
    [dic setValue:@"330.4" forKey:@"pos_x"];
    [dic setValue:@"200.4" forKey:@"pos_y"];
    [dic setValue:@"羚锐X300" forKey:@"title"];
    
    [self.dataArray addObject:dic];
    
    currentIndex  = 0;
    
    motionView.imagesDic  = [self.imagesArray objectAtIndex:currentIndex];
    motionView.locationsArray = self.dataArray;
}
#pragma mark - 摇一摇相关方法
// 摇一摇开始摇动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    return;
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        if (currentIndex==0) {
            currentIndex = 1;
        }else{
            currentIndex=0;
        }
        
        
        [motionView setImagesDic:[self.imagesArray objectAtIndex:currentIndex]];
    }
    return;
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