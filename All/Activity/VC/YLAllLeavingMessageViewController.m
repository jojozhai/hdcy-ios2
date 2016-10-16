//
//  YLAllLeavingMessageViewController.m
//  hdcy
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLAllLeavingMessageViewController.h"
#import "YLCommentModel.h"
#import "YLActiConsultTableViewCell.h"
#import "YLConsultRightTableViewCell.h"
@interface YLAllLeavingMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *cellHeightArray;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong)NSMutableArray *Source;

@end

@implementation YLAllLeavingMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBar];
    [self createView];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"全部留言";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
    
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

//查找全部评论
-(void)requestDataWithPage:(NSInteger)pageNum
{
    [self.hud showAnimated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(pageNum),@"size":@"20",@"sort":@"createdTime,desc",@"targetId":self.contentModel.Id,@"target":@"activity"};
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if (self.page==0) {
            [self.Source removeAllObjects];
            [self.cellHeightArray removeAllObjects];
            [self.dataArray removeAllObjects];
        }
        
        NSArray *contentArray=json[@"content"];
        if (contentArray.count==0) {
            [MBProgressHUD showMessage:@"没有更多数据了"];
        }else{
            
            for (NSDictionary *dic in contentArray) {
                YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:dic error:nil];
                [self.dataArray addObject:model];
            }
            [self calculateCells];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

-(void)createView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,70, SCREEN_WIDTH,SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [self.tableView registerClass:[YLActiConsultTableViewCell class] forCellReuseIdentifier:@"actiConsult"];
    [self.tableView registerClass:[YLActiConsultTableViewCell class] forCellReuseIdentifier:@"rightConsult"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    //下拉刷新
    MJRefreshNormalHeader *header =
    [[MJRefreshNormalHeader alloc]init];
    [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader:)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉加载
    MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
    [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter:)];
    self.tableView.mj_footer=footer;
    
}

-(void)refreshWithHeader:(MJRefreshHeader *)header
{
    self.page=0;
    [self requestDataWithPage:self.page];
    
}

-(void)refreshFooter:(MJRefreshAutoFooter *)footer
{
    NSInteger currentPage=self.page;
    [self requestDataWithPage:++currentPage];
    self.page=currentPage;
}

#pragma --------------------UITableViewDelegate,UITableViewDataSource------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.Source.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    NSObject *model=self.Source[indexPath.row];
    if ([model isKindOfClass:[YLCommentModel class]]) {
        YLCommentModel *commentModel=(YLCommentModel *)model;
        YLActiConsultTableViewCell *cell=[[YLActiConsultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actiConsult"];
        
        cell.model=commentModel;
        return cell;
    }else{
        YLCommentReplyModel *replyModel=(YLCommentReplyModel *)model;
        YLConsultRightTableViewCell *cell=[[YLConsultRightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightConsult"];
        cell.model=replyModel;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeightArray[indexPath.row] integerValue];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeightArray[indexPath.row] integerValue];
}

-(void)calculateCells
{
    NSInteger cellheight=0;
    for (int i=0; i<self.dataArray.count; i++) {
        YLCommentModel *model=self.dataArray[i];
        CGSize constrained=CGSizeMake(200, 1000);
        CGSize commentlabelsize = [model.content boundingRectWithSize:constrained options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT_SYS(13)} context:nil].size;
        cellheight=commentlabelsize.height+80;
        [self.cellHeightArray addObject:@(cellheight)];
        [self.Source addObject:model];
        
        NSArray *replyArray=model.replys;
        if (replyArray.count!=0) {
            for (int j=0; j<replyArray.count; j++) {
                YLCommentReplyModel *replyModel=[[YLCommentReplyModel alloc]initWithDictionary:model.replys[j] error:nil ];
                
                CGSize replylabelsize = [replyModel.content boundingRectWithSize:constrained options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT_SYS(13)} context:nil].size;
                cellheight=replylabelsize.height+80;
                [self.cellHeightArray addObject:@(cellheight)];
                [self.Source addObject:replyModel];
            }
            
        }
    }
    [self.tableView reloadData];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray=[NSMutableArray array];
    }
    return _cellHeightArray;
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

-(NSMutableArray *)Source
{
    if (!_Source) {
        _Source=[NSMutableArray array];
    }
    return _Source;
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
