//
//  YLMainViewController.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMainViewController.h"
#import "YLOptionBtnView.h"
#import "UIView+AZView.h"
#import "YLTrangleView.h"
@interface YLMainViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) YLOptionBtnView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation YLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 创建顶部按钮
    self.view.backgroundColor=[UIColor clearColor];
    [self setupTopBtnView];
    // 创建scrollView
    [self setupScrollView];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupTopBtnView {
    //添加自定义导航栏
    UIView *cusNavigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 50)];
    cusNavigationView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:cusNavigationView];
    //添加头部view
    YLOptionBtnView *topView = [[YLOptionBtnView alloc] initWithFrame:CGRectMake(0, 0, 210*SCREEN_MUTI, self.topHeight)];
    topView.scrollEnabled=NO;
    topView.buttonStyle=YLButtonStyleTriangle;
    topView.backgroundColor=_topBackgroudColor;
    topView.titleArray = self.titleArray;
    self.topView=topView;
    [cusNavigationView addSubview:topView];
    if (self.selectedButtonColor) {
        NSArray *array=self.topView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button=(UIButton *)view;
                [button setTitleColor:self.selectedButtonColor forState:UIControlStateSelected];
                
                    for (UIView *sub in view.subviews) {
                        if ([sub isKindOfClass:[YLTrangleView class]]) {
                            YLTrangleView *subV=(YLTrangleView *)sub;
                            subV.fillColor=self.selectedButtonColor;
                        }else if([sub isKindOfClass:[UIView class]]&&sub.frame.size.height==2) {
                            
                            sub.backgroundColor=self.selectedButtonColor;
                        }
                    }
                }
         }
    }
    //点击上部按钮
    topView.operation = ^(NSInteger index) {
        CGFloat contentOffsetX = self.view.width * index;
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        [self.scrollView addSubview:[self.viewControllers[index] view]];
    };
    //
    UIButton *letterButton=[UIButton buttonWithType:UIButtonTypeCustom];
    letterButton.frame=CGRectMake(SCREEN_WIDTH-97*SCREEN_MUTI, 10*SCREEN_MUTI, 30*SCREEN_MUTI, 30*SCREEN_MUTI);
    [letterButton setImage:[UIImage imageNamed:@"nav-button-information-default"] forState:UIControlStateNormal];
    [cusNavigationView addSubview:letterButton];
    //
    UIButton *mineButton=[UIButton buttonWithType:UIButtonTypeCustom];
    mineButton.frame=CGRectMake(SCREEN_WIDTH-42*SCREEN_MUTI, 10*SCREEN_MUTI, 30*SCREEN_MUTI, 30*SCREEN_MUTI);
    [mineButton setImage:[UIImage imageNamed:@"nav-button-personalcenter-default"] forState:UIControlStateNormal];
    [cusNavigationView addSubview:mineButton];
}


- (void)setupScrollView {
    // 创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,70, SCREEN_WIDTH, self.view.size.height-70)];
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    NSUInteger count = self.viewControllers.count;
    
    // 给滚动视图添加内容
    for (NSUInteger i = 0; i<count; i++) {
        UIViewController *new=self.viewControllers[i];
        new.view.x = scrollView.width * i;
        new.view.y = 0;
        new.view.width = scrollView.width;
        new.view.height = scrollView.height;
        if (i==0) {
            [scrollView addSubview:new.view];
        }
        
    }
    
    // 设置滚动视图的其他属性
    scrollView.contentSize = CGSizeMake(scrollView.width * count, scrollView.height);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
}

#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSUInteger page = scrollView.contentOffset.x / scrollView.width;
    
    // 四舍五入计算出页码
    [self.topView selectedBtnAtIndex:(int)(page + 0.5)];
    [self.scrollView addSubview:[self.viewControllers[page] view]];
    
}

-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray=[[NSMutableArray alloc]init];
        for (UIViewController *vc in self.viewControllers) {
            [_titleArray addObject:vc.title];
        }
    }
    return _titleArray;
}

-(NSArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers=[[NSArray alloc]init];
    }
    return _viewControllers;
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
