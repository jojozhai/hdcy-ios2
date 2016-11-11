//
//  YLInterestViewController.m
//  hdcy
//
//  Created by mac on 16/10/28.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLInterestViewController.h"
#import "YLGTRChooseView.h"
@interface YLInterestViewController ()<YLGTRChooseDelegate>
{
    UIView *_buttonBackView;
    UIView *_coverView;
}
@property (nonatomic,strong)NSArray *interestArray;
@property (nonatomic,strong)NSMutableArray *chooseInterestArray;
@end

@implementation YLInterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self customView];
}

-(void)customView
{
    UIButton *XButton=[UIButton buttonWithType:UIButtonTypeCustom];
    XButton.frame=CGRectMake(12, 24, 20, 20);
    [XButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [XButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XButton];
    
    UILabel *hotLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 72, 200, 15)];
    hotLabel.text=@"选择您的喜好（最多4个）";
    hotLabel.textColor=[UIColor whiteColor];
    hotLabel.font=FONT_SYS(14);
    [self.view addSubview:hotLabel];
    
    _buttonBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, 182)];
    [self.view addSubview:_buttonBackView];
    
    for (int i=0; i<self.interestArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(12*SCREEN_MUTI+103*SCREEN_MUTI*(i%3), 38*(i/3), 95*SCREEN_MUTI, 30);
        button.tag=i+888;
        [button setTitle:self.interestArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseInterest:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"car_style_nomal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"car_style_selected"] forState:UIControlStateSelected];
        button.selected=NO;
        [_buttonBackView addSubview:button];
        
    }

    NSArray *tagArray=[self.tagString componentsSeparatedByString:@","];
    for (NSString *tag in tagArray) {
        for (UIButton *btn in _buttonBackView.subviews) {
            if ([tag isEqualToString:btn.titleLabel.text]) {
                btn.selected=YES;
                [self.chooseInterestArray addObject:tag];
            }
        }
        
    }
    
    //添加蒙板
    _coverView=[[UIView alloc]initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    _coverView.hidden=YES;
    [self.view addSubview:_coverView];
    
    YLGTRChooseView *GTRView=[[YLGTRChooseView alloc]initWithFrame:CGRectMake(30*SCREEN_MUTI, 208, 315*SCREEN_MUTI, 250*SCREEN_MUTI)];
    GTRView.delegate=self;
    [_coverView addSubview:GTRView];
}

-(void)isDeserveButton:(NSInteger)tag
{
    if (tag==1) {
        UIButton *button=_buttonBackView.subviews[3];
        button.selected=YES;
        [self.chooseInterestArray addObject:self.interestArray[3]];
        _coverView.hidden=YES;
    }else{
        _coverView.hidden=YES;
    }
}

-(void)dismissAction
{
    [self.chooseInterestArray removeAllObjects];
    for (UIButton *button in _buttonBackView.subviews) {
        if (button.selected==YES) {
            [self.chooseInterestArray addObject:self.interestArray[button.tag-888]];
        }
    }
    NSString *valueString=[self.chooseInterestArray componentsJoinedByString:@","];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
    NSDictionary *paraDict=@{@"name":@"tags",@"value":valueString};
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    [YLHttp put:urlString token:token params:paraDict success:^(id json) {
        CATransition * animation = [CATransition animation];
        animation.duration = 0.8;    //  时间
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        self.interestBlock(valueString);
    } failure:^(NSError *error) {
        CATransition * animation = [CATransition animation];
        animation.duration = 0.8;    //  时间
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

-(void)chooseInterest:(UIButton *)btn
{
    if (self.chooseInterestArray.count>=4) {
        btn.selected=NO;
    }else{
        if (btn.tag-888==3&&btn.selected==NO) {
            _coverView.hidden=NO;
        }else{
            if (btn.selected==YES) {
                btn.selected=NO;
            }else{
                btn.selected=YES;
            }
        }
    }
    [self.chooseInterestArray removeAllObjects];
    for (UIButton *button in _buttonBackView.subviews) {
        if (button.selected==YES) {
            [self.chooseInterestArray addObject:self.interestArray[button.tag-888]];
        }
    }
}

-(NSArray *)interestArray
{
    if (!_interestArray) {
        _interestArray=@[@"竞速",@"极速",@"卡丁车",@"GTR",@"F1",@"漂移",@"改装",@"遥控模型",@"发烧友",@"飙车族",@"引擎控",@"资深车手",@"改装大神",@"数据党",@"其他"];
    }
    return _interestArray;
}

-(NSMutableArray *)chooseInterestArray
{
    if (!_chooseInterestArray) {
        _chooseInterestArray=[[NSMutableArray alloc]init];
    }
    return _chooseInterestArray;
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
