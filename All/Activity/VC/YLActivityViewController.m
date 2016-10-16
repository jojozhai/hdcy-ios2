//
//  YLActivityViewController.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLActivityViewController.h"
#import "YLActiTableViewCell.h"
#import "YLActivityListContentModel.h"
#import "YLTableHeaderView.h"
#import "YLActivityListModel.h"
#import "YLActivityOffLineViewController.h"
@interface YLActivityViewController ()<UITableViewDataSource,UITableViewDelegate,scrollViewScrollClickDelegate,UIScrollViewDelegate>
//列表model
@property (nonatomic,strong)YLActivityListModel *listModel;
//页数
@property (nonatomic, assign) int page;
@property (nonatomic,strong)NSMutableArray *dataSource;
//轮播数据源
@property (nonatomic,strong)NSMutableArray *orderArray;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *headerArray;
@end

@implementation YLActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor blackColor];
    // 创建scrollView
    self.page=0;
    [self requestHeader];
}


-(void)requestHeader
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/participation"];
        NSDictionary *orderDic=@{@"enable":@YES,@"page":@(0),@"size":@"20",@"sort":@"createdTime,desc",@"top":@(YES)};
        [YLHttp get:urlString params:orderDic success:^(id json) {
            for (NSDictionary *dict in json[@"content"]) {
                YLActivityListContentModel *contentModel=[[YLActivityListContentModel alloc]initWithDictionary:dict error:nil];
                [self.headerArray addObject:contentModel];
            }
            [self createTableView];
            
        } failure:^(NSError *error) {
            
        }];
    });
}

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    tableView.backgroundColor=[UIColor whiteColor];
    self.tableView=tableView;
    //下拉刷新
    MJRefreshNormalHeader *header =
    [[MJRefreshNormalHeader alloc]init];
    [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader:)];
    tableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉加载
    MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
    [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter:)];
    tableView.mj_footer=footer;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    YLTableHeaderView *headerView=[[YLTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    headerView.backgroundColor=BGColor;
    headerView.topScrollArray=self.headerArray;
    self.tableView.tableHeaderView=headerView;
}

-(void)refreshWithHeader:(MJRefreshHeader *)header
{
    self.page=0;
    [self requestDataWithPage:self.page];
    
}

-(void)refreshFooter:(MJRefreshAutoFooter *)footer
{
    int currentPage=self.page;
    [self requestDataWithPage:++currentPage];
    self.page=currentPage;
}
//网络请求
-(void)requestDataWithPage:(int)page
{
    [self.hud showAnimated:YES];
    
    NSDictionary *dict=@{@"enable":@YES,@"page":@(page),@"size":@"20",@"sort":@"createdTime,desc",@"actType":@"ACTIVITY"};
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/participation"];
    
    [YLHttp get:urlString params:dict success:^(id json) {
        if (self.page==0) {
            [self.dataSource removeAllObjects];
        }
        self.listModel=[[YLActivityListModel alloc]initWithDictionary:json error:nil];
        if (self.listModel.totalPages<=self.page) {
            [MBProgressHUD showMessage:@"没有更多数据了"];
        }
        for (NSDictionary *dict in json[@"content"]) {
            YLActivityListContentModel *contentModel=[[YLActivityListContentModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:contentModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
            [self.tableView reloadData];
            [self.hud hideAnimated:YES];
            
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud hideAnimated:YES];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        });
        
    }];
    
    
//    if (self.isOnline==NO) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [self.hud hide:YES];
//        
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse=@"cell";
    
    YLActiTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell=[[YLActiTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.model=self.dataSource[indexPath.row];
    if (cell.model.finish==YES) {
        cell.endImageView.hidden=NO;
    }else{
        cell.endImageView.hidden=YES;
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225*SCREEN_MUTI;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLActivityListContentModel *model=self.dataSource[indexPath.row];
    YLActivityOffLineViewController *offline=[[YLActivityOffLineViewController alloc]init];
    offline.contentModel=model;
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:offline animated:YES completion:^{
        
    }];
}

-(void)clickScrollViewItemWithIndex:(NSInteger)index
{
    YLActivityListContentModel *model=self.headerArray[index];
    YLActivityOffLineViewController *offline=[[YLActivityOffLineViewController alloc]init];
    offline.contentModel=model;
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:offline animated:YES completion:^{
        
    }];
}


#pragma ---------------------------懒加载--------------------------------
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
        _headerArray=[[NSMutableArray alloc]init];
    }
    return _headerArray;
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
