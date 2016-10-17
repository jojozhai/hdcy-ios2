//
//  YLFamousViewController.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousViewController.h"
#import "YLFamousTopModel.h"
#import "YLFamousTopView.h"
#import "YLFamousListTableViewCell.h"
#import "YLFamousListSecondTableViewCell.h"
@interface YLFamousViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_topMainView;
    YLFamousTopView *_topView;
    UIView *_segmentView;
    NSInteger _page;
    NSString *_portString;
}
@property (nonatomic,strong)NSMutableArray *headerArray;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *portArray;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation YLFamousViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _portString=@"";
    [self createWholeView];
    [self requestWithTop];
}

-(void)createWholeView
{
    _topMainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI+40)];

    _topView=[[YLFamousTopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    _topView.backgroundColor=BGColor;
    [_topMainView addSubview:_topView];
    
    _segmentView=[[UIView alloc]initWithFrame:CGRectMake(0, 225*SCREEN_MUTI, SCREEN_WIDTH, 40)];
    [_topMainView addSubview:_segmentView];
    NSArray *buttonTitle=@[@"全部",@"个人",@"机构"];
    for (int i=0; i<3; i++) {
        UIButton *segButton=[UIButton buttonWithType:UIButtonTypeCustom];
        segButton.frame=CGRectMake(SCREEN_WIDTH/3*i, 0, SCREEN_WIDTH/3, 40);
        segButton.tag=397+i;
        [segButton setTitle:buttonTitle[i] forState:UIControlStateNormal];
        if (i==0) {
            segButton.selected=YES;
        }
        [segButton setBackgroundImage:[UIImage imageNamed:@"content-pressed"] forState:UIControlStateNormal];
        [segButton setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateSelected];
        [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [segButton setTitleColor:RGBCOLOR(143, 175, 202) forState:UIControlStateNormal];
        [segButton addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_segmentView addSubview:segButton];
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[YLFamousListTableViewCell class] forCellReuseIdentifier:@"leftFamousCell"];
    [self.tableView registerClass:[YLFamousListSecondTableViewCell class] forCellReuseIdentifier:@"rightFamousCell"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    _portString=self.portArray[0];
    //下拉刷新
    MJRefreshNormalHeader *header =
    [[MJRefreshNormalHeader alloc]init];
    [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    //上拉加载
    MJRefreshAutoNormalFooter *footer=[[MJRefreshAutoNormalFooter alloc]init];
    [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    self.tableView.mj_footer=footer;
    [footer setTitle:@"暂无数据" forState:MJRefreshStateNoMoreData];
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView=_topMainView;
}

-(void)refreshWithHeader
{
    _page=0;
    [self requestDataWithPortString:_portString];
}

-(void)refreshFooter
{
    _page++;
    [self requestDataWithPortString:_portString];
}

-(void)segSelected:(UIButton *)seg
{
    for (UIButton *button in _segmentView.subviews) {
        button.selected=NO;
    }
    seg.selected=YES;
    _page=0;
    _portString=self.portArray[seg.tag-397];
    [self refreshWithHeader];
}

-(void)requestWithTop
{
    NSString *famousString=[NSString stringWithFormat:@"%@/leader?top=YES",URL];
    [YLHttp get:famousString params:nil success:^(id json) {
        NSArray *contentArr=json[@"content"];
        for (NSDictionary *dict in contentArr) {
            YLFamousTopModel *topModel=[[YLFamousTopModel alloc]initWithDictionary:dict error:nil];
            [self.headerArray addObject:topModel];
        }
        _topView.topScrollArray=self.headerArray;
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestDataWithPortString:(NSString *)port
{
    [self.hud showAnimated:YES];
    NSDictionary *dict=@{@"enable":@YES,@"page":@(_page),@"size":@"20",@"sort":@"createdTime,desc",@"organ":port};
    NSString *famousString=[NSString stringWithFormat:@"%@/leader",URL];
    [YLHttp get:famousString params:dict success:^(id json) {
        NSArray *contentArr=json[@"content"];
        if (_page==0) {
            [self.dataSource removeAllObjects];
        }
        if (contentArr.count==0) {
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"没有更多数据了";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
            [hud removeFromSuperViewOnHide];
        }else{
            for (NSDictionary *dict in contentArr) {
                YLFamousTopModel *topModel=[[YLFamousTopModel alloc]initWithDictionary:dict error:nil];
                [self.dataSource addObject:topModel];
                
            }
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];

    
}

#pragma tableViewDelegate,tableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLFamousTopModel *Model=self.dataSource[indexPath.row];
    if (indexPath.row%2==0) {
        YLFamousListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"leftFamousCell"];
        if (!cell) {
            cell=[[YLFamousListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftFamousCell"];
        }
        cell.model=Model;
        return cell;
    }else{
        YLFamousListSecondTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"rightFamousCell"];
        if (!cell) {
            cell=[[YLFamousListSecondTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightFamousCell"];
        }
        cell.model=Model;
        return cell;
    }
}

#pragma 懒加载
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

-(NSArray *)portArray
{
    if (!_portArray) {
        _portArray=@[@"",@"NO",@"YES"];
    }
    return _portArray;
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
