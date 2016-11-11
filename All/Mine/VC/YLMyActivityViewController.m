//
//  YLMyActivityViewController.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMyActivityViewController.h"
#import "YLActivityListContentModel.h"
#import "YLActivityListModel.h"
#import "YLMyActivityTableViewCell.h"
#import "YLActivityOffLineViewController.h"
@interface YLMyActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    YLActivityListModel *listModel;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation YLMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=DarkBGColor;
    [self createNavigationBar];
    [self createTableView];
    
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"我的活动";
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
    [tableView registerClass:[YLMyActivityTableViewCell class] forCellReuseIdentifier:@"activity"];
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
    
    NSDictionary *dict=@{@"enable":@YES,@"page":@(page),@"size":@"20",@"sort":@"createdTime,desc"};
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/participator"];
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    [YLHttp get:urlString token:token  params:dict success:^(id json) {
        if (self.page==0) {
            [self.dataSource removeAllObjects];
        }
        listModel=[[YLActivityListModel alloc]initWithDictionary:json error:nil];
        for (NSDictionary *dict in json[@"content"]) {
            YLActivityListContentModel *contentModel=[[YLActivityListContentModel alloc]initWithDictionary:dict error:nil];
            [self.dataSource addObject:contentModel];
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
    static NSString *reuse=@"activity";
    YLActivityListContentModel *model=self.dataSource[indexPath.row];
    YLMyActivityTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell=[[YLMyActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    cell.backgroundColor=DarkBGColor;
    cell.model=model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    [self presentViewController:offline animated:YES completion:^{
        
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
