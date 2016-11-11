//
//  YLInletterDetailViewController.m
//  hdcy
//
//  Created by mac on 16/11/7.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLInletterDetailViewController.h"

@interface YLInletterDetailViewController ()

@end

@implementation YLInletterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self createNavigationBar];
    [self createLabel];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"站内信";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
}
//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createLabel
{
    UILabel *label=[[UILabel alloc]init];
    label.text=@"“好多车友”致力于打造移动端中国最大车友交互媒体平台。“好多车友”以同名APP（苹果及安卓版）、微信服务号为主要载体，以专业意见领袖入驻、车生活资讯播报、车主社群建设、线上线下全国性车主互动、高频率福利发放为主要内容。通过原创媒体内容引导，满足车主用户场景社交刚需的同时，建立平台口碑与影响力。";
    label.textColor=[UIColor whiteColor];
    CGSize labelsize = [label.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : label.font} context:nil].size;
    label.frame=CGRectMake(0, 70, labelsize.width, labelsize.height);
    label.numberOfLines=0;
    label.font=FONT_SYS(14);
    [self.view addSubview:label];
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
