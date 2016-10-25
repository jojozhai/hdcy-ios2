//
//  YLVideoViewController.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLVideoViewController.h"
#import "YLVideoTopModel.h"
#import "YLLiveVideoCell.h"
#import "YLVideoDetailViewController.h"
#import "UIView+MJExtension.h"
#import "YLVideoListModel.h"
#import "YLVideoTopView.h"

@interface YLVideoViewController ()<UITableViewDelegate,UITableViewDataSource,scrollViewClickDelegate>
{
    YLVideoTopView *_headerView;
    UITableView *_tableView;
    
    NSInteger _page;
    
    MJRefreshNormalHeader *_header;
    
    MJRefreshAutoNormalFooter *_footer;

}
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSMutableArray *headerArray;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation YLVideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _page = 0;
    
    [self initTableView];
    
    [self requestTop];
    
    [self requestList];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //下拉刷新
    _header = [[MJRefreshNormalHeader alloc]init];
    [_header setRefreshingTarget:self refreshingAction:@selector(requestList)];
    _tableView.mj_header = _header;
    
    //上拉加载
    _footer=[[MJRefreshAutoNormalFooter alloc]init];
    [_footer setRefreshingTarget:self refreshingAction:@selector(requestMore)];
    _tableView.mj_footer=_footer;
    [self.view addSubview:_tableView];
    [_footer setTitle:@"暂无数据" forState:MJRefreshStateNoMoreData];
    
    _headerView=[[YLVideoTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    _headerView.delegate=self;
    _headerView.backgroundColor=BGColor;
    _tableView.tableHeaderView=_headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225*SCREEN_MUTI;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    YLLiveVideoCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[YLLiveVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.model=self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLVideoListModel *m = self.dataSource[indexPath.row];
    YLVideoDetailViewController *detail = [[YLVideoDetailViewController alloc] init];
    detail.Id = [m id];
        
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detail animated:YES completion:nil];
}

-(void)clickScrollViewWithIndex:(NSInteger)index
{
    YLVideoListModel *m = self.headerArray[index];
    YLVideoDetailViewController *detail = [[YLVideoDetailViewController alloc] init];
    detail.Id = [m id];
    
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detail animated:YES completion:nil];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark - request

-(void)requestTop
{
    [self requestTop:YES];
}

- (void)requestMore
{
    _page++;
    [self requestTop:NO];
}

-(void)requestList
{
     _page = 0;
    [self requestTop:NO];
}

- (void)requestTop:(BOOL)isTop
{
    [self.hud showAnimated:YES];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/video"];
    NSDictionary *paraDict=@{@"page":@(_page),@"size":@"20",@"sort":@"createdTime,desc",@"enable":@(YES),@"top":@(isTop)};
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        [self.hud hideAnimated:YES];
        NSArray *contentArray=json[@"content"];
        if (isTop)
        {
            for (NSDictionary *topDict in contentArray) {
                YLVideoTopModel *topmodel=[[YLVideoTopModel alloc]init];
                topmodel.id=topDict[@"id"];
                topmodel.name=topDict[@"name"];
                topmodel.image=topDict[@"image"];
                topmodel.startTime=topDict[@"startTime"];
                topmodel.live=topDict[@"live"];
                topmodel.liveState=topDict[@"liveState"];
                if (topmodel.startTime==nil) {
                    topmodel.startTime=@"";
                }
                [self.headerArray addObject:topmodel];
            }
            _headerView.topScrollArray=self.headerArray;
        }
        else
        {
            for (NSDictionary *topDict in contentArray) {
                
                YLVideoTopModel *topmodel=[[YLVideoTopModel alloc]init];
                topmodel.id=topDict[@"id"];
                topmodel.name=topDict[@"name"];
                topmodel.image=topDict[@"image"];
                topmodel.startTime=topDict[@"startTime"];
                topmodel.live=topDict[@"live"];
                topmodel.liveState=topDict[@"liveState"];
                if (topmodel.startTime==nil) {
                    topmodel.startTime=@"";
                }
                [self.dataSource addObject:topmodel];
            }
            
            if ([_tableView.mj_header isRefreshing]) {
                [_tableView.mj_header endRefreshing];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.label.text=@"正在加载";
        [self.view addSubview:_hud];
    }
    return _hud;
}

-(NSMutableArray *)headerArray
{
    if (!_headerArray) {
        _headerArray=[NSMutableArray array];
    }
    return _headerArray;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[NSMutableArray array];
    }
    return _dataSource;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
