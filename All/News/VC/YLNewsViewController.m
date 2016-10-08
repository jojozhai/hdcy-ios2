//
//  YLNewsViewController.m
//  hdcy
//
//  Created by mac on 16/9/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLNewsViewController.h"
#import "YLOptionBtnView.h"
#import "UIView+AZView.h"
#import "YLNewsListModel.h"
#import "YLNewsAdImageTableViewCell.h"
#import "YLNewsAdNomalTableViewCell.h"
#import "YLNewsTopNomalTableViewCell.h"
#import "YLNewsListNomalTableViewCell.h"
#import "YLNewsListTopAdTableViewCell.h"
#import "YLNewsInfoViewController.h"
@interface YLNewsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray  *ViewArray;
@property (nonatomic, strong) YLOptionBtnView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) int page;
@property (nonatomic, strong)NSMutableArray *topArray;
@property (nonatomic,strong)MBProgressHUD *hud;
@property (nonatomic,strong)NSMutableArray *dataSource;
//判断是否滑动到那一页
@property (nonatomic,assign)NSInteger isScrollPage;
//判断是否有网络
@property (nonatomic,assign)BOOL isOnline;
@end

@implementation YLNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor redColor];
    // 创建scrollView
    self.page=0;
    [self monitorNet];
}

-(void)monitorNet
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status==AFNetworkReachabilityStatusNotReachable) {
            [MBProgressHUD showMessage:@"当前没有网络"];
            [self.dataSource removeAllObjects];
            self.isOnline=NO;
        }else{
            self.isOnline=YES;
            [self requestTopTitle];
        }
    }
     ];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


//请求头部title
-(void)requestTopTitle
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/tag/child"];
    [YLHttp get:urlString params:nil success:^(id json) {
        NSArray *array=json;
        for (int i=0; i<array.count; i++) {
            NSDictionary *dict=array[i];
            NSMutableDictionary *tempD=[[NSMutableDictionary alloc]init];
            [tempD setObject:dict[@"name"] forKey:@"name"];
            [tempD setObject:dict[@"id"] forKey:@"id"];
            [self.topArray addObject:tempD];
            [self.titleArray addObject:dict[@"name"]];
        }
        NSString *allStr=@"全部";
        [self.titleArray insertObject:allStr atIndex:0];
        NSMutableDictionary *tempD=[[NSMutableDictionary alloc]init];
        [tempD setObject:@"全部" forKey:@"name"];
        [tempD setObject:@"" forKey:@"id"];
        [self.topArray insertObject:tempD atIndex:0];
        [self setupTopBtnView];
        [self setupScrollView];
    } failure:^(NSError *error) {
        
    }];
    
}


//添加顶部滚动视图
- (void)setupTopBtnView {
    YLOptionBtnView *topView = [[YLOptionBtnView alloc] initWithFrame:CGRectMake(0,0, self.view.size.width, self.topHeight)];
    topView.backgroundColor=_topBackgroudColor;
    topView.titleArray = self.titleArray;
    [self.view addSubview:topView];
    self.topView=topView;
    topView.buttonStyle=YLButtonStyleLine;
    if (self.selectedButtonColor) {
        NSArray *array=self.topView.subviews;
        for (UIView *view in array) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button=(UIButton *)view;
                [button setTitleColor:self.selectedButtonColor forState:UIControlStateSelected];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"news_button"] forState:UIControlStateNormal];
            }
            if (self.selectedButtonColor) {
                NSArray *array=self.topView.subviews;
                for (UIView *view in array) {
                    if ([view isKindOfClass:[UIButton class]]) {
                        UIButton *button=(UIButton *)view;
                        [button setTitleColor:self.selectedButtonColor forState:UIControlStateSelected];
                        [button setBackgroundImage:[UIImage imageNamed:@"news_button_selected"] forState:UIControlStateSelected];
                        for (UIView *sub in view.subviews) {
                            if([sub isKindOfClass:[UIView class]]&&sub.frame.size.height==2) {
                                
                                sub.backgroundColor=self.selectedButtonColor;
                            }
                        }
                    }
                }
            }
        }
    }
    //    点击上面的button
    topView.operation = ^(NSInteger index) {
        [self.dataSource removeAllObjects];
        CGFloat contentOffsetX = self.view.width * index;
        self.isScrollPage=index;
        self.page=0;
        self.scrollView.contentOffset = CGPointMake(contentOffsetX, 0);
        [self requestDataWithPage:0 tagID:[self.topArray[index] objectForKey:@"id"] Index:index+1024];
        
    };
    
}



- (void)setupScrollView {
    // 创建滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topHeight, self.view.width, self.view.size.height-self.topHeight)];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    self.scrollView.tag=1234;
    
    NSUInteger count = self.titleArray.count;
    
    // 给滚动视图添加内容
    for (NSUInteger i = 0; i<count; i++) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.topHeight) style:UITableViewStylePlain];
        tableView.tag = 1024 + i;
        [tableView registerClass:[YLNewsAdImageTableViewCell class ] forCellReuseIdentifier:@"YLNewsAdImageTableViewCell"];
        [tableView registerClass:[YLNewsAdNomalTableViewCell class] forCellReuseIdentifier:@"YLNewsAdNomalTableViewCell"];
        [tableView registerClass:[YLNewsTopNomalTableViewCell class] forCellReuseIdentifier:@"YLNewsTopNomalTableViewCell"];
        [tableView registerClass:[YLNewsListNomalTableViewCell class] forCellReuseIdentifier:@"YLNewsListNomalTableViewCell"];
        [tableView registerClass:[YLNewsListTopAdTableViewCell class] forCellReuseIdentifier:@"YLNewsListTopAdTableViewCell"];
        //下拉刷新
        MJRefreshNormalHeader *header =
        [[MJRefreshNormalHeader alloc]init];
        [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader:)];
        tableView.mj_header = header;
        //上拉加载
        MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
        [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter:)];
        tableView.mj_footer=footer;
        
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [_scrollView addSubview:tableView];
        
        
    }
    //加载第一页
    [self requestDataWithPage:0 tagID:[self.topArray[0] objectForKey:@"id"] Index:1024];
    // 设置滚动视图的其他属性
    scrollView.contentSize = CGSizeMake(scrollView.width * count, scrollView.height);
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.delegate = self;
}

-(void)refreshWithHeader:(MJRefreshHeader *)header
{
    [self requestDataWithPage:0 tagID:[self.topArray[header.superview.tag-1024] objectForKey:@"id"] Index:header.superview.tag];
}

-(void)refreshFooter:(MJRefreshAutoFooter *)footer
{
    int currentPage=self.page;
    [self requestDataWithPage:++currentPage tagID:[self.topArray[footer.superview.tag-1024] objectForKey:@"id"] Index:footer.superview.tag];
    self.page=currentPage;
}
//网络请求
-(void)requestDataWithPage:(int)page  tagID:(NSString *)tagid Index:(long)index
{
    
    //取到滚动到的tableView
    UITableView *tableView=(UITableView *)[self.scrollView viewWithTag:index];
    [self.hud showAnimated:YES];
    
    NSDictionary *dict=@{@"enable":@YES,@"page":@(page),@"size":@"20",@"sort":@"createdTime,desc",@"tagId":tagid};
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/article"];
    [YLHttp get:urlString params:dict success:^(id json) {
        if ([json[@"content"] count]==0) {
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"没有更多数据了";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
            [hud removeFromSuperViewOnHide];
            
        }else{
            if (page==0) {
                [self.dataSource removeAllObjects];
            }
            NSArray *contentArray=json[@"content"];
            for (NSDictionary *cDict in contentArray) {
                YLNewsListModel *model=[[YLNewsListModel alloc]init];
                model.readCount=cDict[@"readCount"];
                model.createTime=[YLGetTime getTimeFromTimeString:[NSString stringWithFormat:@"%@",cDict[@"createdTime"]]];
                model.title=cDict[@"title"];
                model.commentCount=cDict[@"commentCount"];
                model.image=cDict[@"image"];
                if ([cDict[@"image"] isEqual:[NSNull null]]) {
                    model.image=@"";
                }
                model.displayType=cDict[@"displayType"];
                model.top=cDict[@"top"];
                model.Id=cDict[@"id"];
                model.tagInfos=cDict[@"tagInfos"];
                for (NSDictionary *dic in self.topArray) {
                    if ([dic[@"id"] isEqual:tagid]) {
                        model.tagID=dic[@"name"];
                    }
                }
                model.business=cDict[@"business"];
                [self.dataSource addObject:model];
            }
            
        }
        
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
        [tableView reloadData];
        [self.hud hideAnimated:YES];
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
    if (self.isOnline==NO) {
        [tableView reloadData];
        [tableView.mj_header endRefreshing];
        [tableView.mj_footer endRefreshing];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLNewsListModel *model=self.dataSource[indexPath.row];
    if ([model.top isEqual:@1]&&[model.business isEqual:@1]) {
        YLNewsListTopAdTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLNewsListTopAdTableViewCell"];
        if (!cell) {
            cell=[[YLNewsListTopAdTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLNewsListTopAdTableViewCell"];
        }
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        cell.titleLabel.text=model.title;
        
        return cell;
    }else if(![model.top isEqual:@1]&&[model.business isEqual:@1]&&[model.displayType isEqualToString:@"MIX"]){
        YLNewsAdNomalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLNewsAdNomalTableViewCell"];
        if (!cell) {
            cell=[[YLNewsAdNomalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLNewsAdNomalTableViewCell"];
        }
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        cell.titleLabel.text=model.title;
        
        return cell;
    }else if (![model.top isEqual:@1]&&[model.business isEqual:@1]&&[model.displayType isEqualToString:@"IMAGE"]){
        YLNewsAdImageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLNewsAdImageTableViewCell"];
        if (!cell) {
            cell=[[YLNewsAdImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLNewsAdImageTableViewCell"];
        }

        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        cell.titleLabel.text=model.title;
        
        return cell;
    }else if ([model.top isEqual:@1]&&![model.business isEqual:@1]){
        YLNewsTopNomalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLNewsTopNomalTableViewCell"];
        if (!cell) {
            cell=[[YLNewsTopNomalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLNewsTopNomalTableViewCell"];
        }

        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        cell.tagLabel.text=[model.tagInfos[0] objectForKey:@"name"];
        cell.timeLabel.text=model.createTime;
        cell.eyeLabel.text=[NSString stringWithFormat:@"%@",model.readCount];
        cell.titleLabel.text=model.title;
        
        return cell;
    }else{
        YLNewsListNomalTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YLNewsListNomalTableViewCell"];
        if (!cell) {
            cell=[[YLNewsListNomalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YLNewsListNomalTableViewCell"];
        }
        [cell.showImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
        cell.tagLabel.text=[model.tagInfos[0] objectForKey:@"name"];
        cell.timeLabel.text=model.createTime;
        cell.eyeLabel.text=[NSString stringWithFormat:@"%@",model.readCount];
        cell.titleLabel.text=model.title;
        
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 305*SCREEN_MUTI;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CATransition * animation = [CATransition animation];
    
    animation.duration = 0.8;    //  时间
    
    /**  type：动画类型
     *  pageCurl       向上翻一页
     *  pageUnCurl     向下翻一页
     *  rippleEffect   水滴
     *  suckEffect     收缩
     *  cube           方块
     *  oglFlip        上下翻转
     */
    
    /**  type：页面转换类型
     *  kCATransitionFade       淡出
     *  kCATransitionMoveIn     覆盖
     *  kCATransitionReveal     底部显示
     *  kCATransitionPush       推出
     */
    animation.type = kCATransitionMoveIn;
    //PS：type 更多效果请 搜索： CATransition
    
    /**  subtype：出现的方向
     *  kCATransitionFromRight       右
     *  kCATransitionFromLeft        左
     *  kCATransitionFromTop         上
     *  kCATransitionFromBottom      下
     */
    animation.subtype = kCATransitionFromRight;
    
    [self.view.window.layer addAnimation:animation forKey:nil];
    YLNewsInfoViewController *info=[[YLNewsInfoViewController alloc]init];
    info.listModel=self.dataSource[indexPath.row];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:info animated:YES completion:^{
        
    }];
}

#pragma mark - scrollView代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger page = scrollView.contentOffset.x / scrollView.width;
    if (scrollView.tag==1234) {
        self.page=0;
        // 四舍五入计算出页码
        [self.topView selectedBtnAtIndex:(int)(page + 0.5)];
        if (page!=self.isScrollPage) {
            [self requestDataWithPage:0 tagID:[self.topArray[page] objectForKey:@"id"] Index:page+1024];
        }
        
        self.isScrollPage=page;
    }
    
}


#pragma mark -----------------------懒加载---------------------------------

-(NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray=[[NSMutableArray alloc]init];
        
    }
    return _titleArray;
}

-(NSMutableArray *)ViewArray
{
    if (!_ViewArray) {
        _ViewArray=[[NSMutableArray alloc]init];
    }
    return _ViewArray;
}

-(NSMutableArray *)topArray
{
    if (!_topArray) {
        _topArray=[[NSMutableArray alloc]init];
        
    }
    return _topArray;
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

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
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
