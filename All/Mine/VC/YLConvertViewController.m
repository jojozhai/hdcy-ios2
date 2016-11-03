//
//  YLConvertViewController.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLConvertViewController.h"
#import "YLConvertTableViewCell.h"
#import "YLConvertModel.h"
#import "YLConvertDetailViewController.h"
@interface YLConvertViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation YLConvertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"礼品兑换";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
}
//返回
-(void)backAction
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)createTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,70,SCREEN_WIDTH,SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [tableView registerClass:[YLConvertTableViewCell class] forCellReuseIdentifier:@"convert"];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
    
    NSDictionary *dict=@{@"page":@(page),@"size":@"15",@"sort":@"used,desc"};
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/gift"];
    [YLHttp get:urlString params:dict success:^(id json) {
        if (self.page==0) {
            [self.dataSource removeAllObjects];
        }
        NSArray *contentArr=json[@"content"];
        for (NSDictionary *dict in contentArr) {
            YLConvertModel *model=[[YLConvertModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        [self.hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
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
    YLConvertTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"convert"];
    if (!cell) {
        cell=[[YLConvertTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"convert"];
    }
    YLConvertModel *model=self.dataSource[indexPath.row];
    cell.model=model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 323;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLConvertDetailViewController *convertDetail=[[YLConvertDetailViewController alloc]init];
    YLConvertModel *model=self.dataSource[indexPath.row];
    convertDetail.model=model;
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:convertDetail animated:YES completion:nil];
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
