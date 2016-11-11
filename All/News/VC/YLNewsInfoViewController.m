//
//  YLNewsInfoViewController.m
//  hdcy
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLNewsInfoViewController.h"
#import "YLCommentModel.h"
#import "YLCommentTableViewCell.h"
#import "YLWriteCommentView.h"
#import "YLNotiModel.h"
#import "YLCommentViewController.h"
#import "UMSocial.h"
#import "YLReplyViewController.h"

#define  kTableViewCellIdentifier @"commentReply"
@interface YLNewsInfoViewController ()<UIWebViewDelegate,UITextFieldDelegate,UITextViewDelegate,UMSocialUIDelegate,clickLabelWithIndexPathAndIndexDelegate,clickMoreDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIWebView *_webView;
    UIView *coverView;
    YLNotiModel *Nmodel;
    NSString *_replyToId;
    YLWriteCommentView *writeCommentView;
    /*
     *tableView的indexpath
     */
    NSIndexPath *_indexpath;
    /*
     *大的滚动式图
     */
    UIScrollView *mainScrollView;
    UILabel *textlabel;
    /*
     *评论数
     */
    NSString *commentCount;
}
@property (nonatomic,strong)UITableView *tableView;
//数据源
@property (nonatomic,strong)NSMutableArray *dataSource;
//是否展开数组
@property (nonatomic,strong)NSMutableArray *boolAray;
// 数据备份
@property (nonatomic,strong)NSMutableArray *dataAray;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation YLNewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Id=self.listModel.Id;
    [self requestUrl];
    [self createNavigationBar];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
/*
 *创建编辑按钮
 */
-(void)createClearCoverView
{
    UIButton *commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame=CGRectMake(12, SCREEN_HEIGHT-95-50, 60*SCREEN_MUTI, 60*SCREEN_MUTI) ;
    [commentButton setImage:[UIImage imageNamed:@"content-button-edit-default"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentButton];
    [self.view insertSubview:commentButton aboveSubview:mainScrollView];
}

-(void)writeComment//跳转评论页
{
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    if (token.length==0||token==nil) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"您没有登录，点击我的登录"                                                                             message: nil                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction: [UIAlertAction actionWithTitle: @"确定" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self backAction];
        }]];
        [self presentViewController:alertController animated: NO completion: nil];
    }else{
        YLReplyViewController *writeVC=[[YLReplyViewController alloc]init];
        writeVC.changeItemBlock=^(YLCommentModel *model){
            textlabel.text=[NSString stringWithFormat:@"评论(%ld)",commentCount.integerValue+1];
            commentCount=[NSString stringWithFormat:@"%ld",commentCount.integerValue+1];
            if (self.dataSource.count==5) {
                [self.dataSource removeLastObject];
            }
            [self.dataSource insertObject:model atIndex:0];
            if (!model.replys) {
                model.replys=@[];
            }
            [self.dataAray insertObject:model.replys atIndex:0];
            NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
            [boolDict setObject:@(NO) forKey:@"bool"];
            [self.boolAray insertObject:boolDict atIndex:0];
            
            [self.tableView reloadData];
        };
        writeVC.Id=self.listModel.Id;
        writeVC.target=@"article";
        CATransition * animation = [CATransition animation];
        animation.duration = 0.8;    //  时间
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:writeVC animated:YES completion:nil];
    }
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"资讯详情";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
    [self addRightBarButtonItemWithImageName:@"nav-icon-share-default@2x" title:nil target:self selector:@selector(shareAction)];
    [self addSecondRightBarButtonItemWithImageName:@"nav-icon-information-default@2x" title:nil target:self selector:@selector(infoAction)];
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
/*
 *分享
 */
-(void)shareAction
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/views/articleDetail.html?id=%@",self.listModel.Id]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.listModel.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
    [UMSocialData defaultData].extConfig.title = self.listModel.title;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
}
/*
 *跳转评论浏览页
 */
-(void)infoAction
{
    [self presentCommentVC];
}
#pragma ----------------UMSocialUIDelegate-------------------------------
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


/*
 *请求数据，基本和资讯列表页请求下来的相同
 */
-(void)requestUrl
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/article/%@",self.listModel.Id]];
    [YLHttp get:urlString params:nil success:^(id json) {
        commentCount=json[@"commentCount"];
        [self setWebView];
        [self createClearCoverView];
    } failure:^(NSError *error) {
        
    }];
    
}
/*
 *设置web view
 */
-(void)setWebView
{
    //创建大的scrollview
    mainScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    mainScrollView.scrollEnabled=YES;
    mainScrollView.showsVerticalScrollIndicator=NO;
    mainScrollView.showsHorizontalScrollIndicator=NO;
    mainScrollView.alwaysBounceVertical=YES;
    mainScrollView.contentOffset=CGPointMake(0, 0);
    mainScrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:mainScrollView];
    
    //创建webview
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/new-articleDetails.html?id=%@",self.listModel.Id]];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    _webView.delegate=self;
    //_webView.scrollView.scrollEnabled = NO;
    //[_webView sizeToFit];
    _webView.scalesPageToFit = YES;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [_webView loadRequest:request];
    [mainScrollView addSubview:_webView];
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading) {
        return;
    }
    
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"]floatValue];
    webViewHeight=webViewHeight*SCREEN_WIDTH/750;
    //获取内容实际高度（像素）
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH,webViewHeight);
    [_webView sizeToFit];
    mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,88+_webView.height);
    [self requestCommentUrl];
    NSLog(@"结束加载");

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

//查找全部评论
-(void)requestCommentUrl
{
    [self.hud showAnimated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(0),@"size":@"5",@"sort":@"createdTime,desc",@"targetId":self.Id,@"target":@"article"};
    //首个请求的是评论列表
    
    [YLHttp get:urlString params:paraDict success:^(id json) {
        NSArray *contentArray=json[@"content"];
        //判断是否有评论
        if (contentArray.count==0) {
            
            [MBProgressHUD showMessage:@"已经没有更多评论了"];
            
        }else{
            //添加数据
            for (NSDictionary *commentDic in contentArray) {
                YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:commentDic error:nil];
                [self.dataSource addObject:model];
                [self.dataAray addObject:model.replys];
            }
            
        }
        [self prepareTableView];
        //添加是否展开的数组及数组中的元素
        if (self.dataSource.count!=0) {
            [self.boolAray removeAllObjects];
            for (int i=0; i<self.dataSource.count; i++) {
                
                NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
                [boolDict setObject:@(NO) forKey:@"bool"];
                [self.boolAray addObject:boolDict];
            }
            
            for (YLCommentModel *model in self.dataSource) {
                if (model.replys.count>2) {
                    NSMutableArray *addArr=[[NSMutableArray alloc]init];
                    for (int i=0; i<2; i++) {
                        [addArr addObject:model.replys[i]];
                    }
                    [model setValue:addArr forKey:@"replys"];
                }
            }
        }
        [self.hud hideAnimated:YES];
        
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
    
}
/*
 *设置tableview
 */
-(void)prepareTableView
{
    //创建headerview
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    //创建淑贤
    UILabel *verticleLable=[[UILabel alloc]initWithFrame:CGRectMake(4, 12, 2, 18)];
    verticleLable.backgroundColor=[UIColor blackColor];
    [view addSubview:verticleLable];
    
    textlabel=[[UILabel alloc]initWithFrame:CGRectMake(8, 12, 80, 18)];
    
    textlabel.text=[NSString stringWithFormat:@"评论(%@)",commentCount];
    
    
    textlabel.font=[UIFont boldSystemFontOfSize:18];
    textlabel.textColor=[UIColor blackColor];
    [view addSubview:textlabel];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _webView.height+8, SCREEN_WIDTH, 1000) style:UITableViewStylePlain];
    [self.tableView registerClass:[YLCommentTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [mainScrollView addSubview:self.tableView];
    self.tableView.tableHeaderView=view;
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(SCREEN_WIDTH/2-45, 8, 90, 34);
    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(presentCommentVC) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreButton.layer.cornerRadius=17;
    moreButton.layer.borderColor= RGBCOLOR(28, 103, 145).CGColor;
    moreButton.layer.borderWidth=0.5;
    moreButton.layer.masksToBounds=YES;
    self.tableView.tableFooterView=footerView;
    [footerView addSubview:moreButton];
    
     
}
/*
 *跳转评论浏览页
 */
-(void)presentCommentVC
{
    YLCommentViewController *comment=[[YLCommentViewController alloc]init];
    comment.Id=self.listModel.Id;
    comment.target=@"article";
    /*
     *反向传回改变评论数的block
     */
    comment.changeBlock=^(NSArray *data){
        textlabel.text=[NSString stringWithFormat:@"评论(%ld)",commentCount.integerValue+1];
        commentCount=[NSString stringWithFormat:@"%ld",commentCount.integerValue+1];
        
        YLCommentModel *model=data[0];
        if (self.dataSource.count==5) {
            [self.dataSource removeLastObject];
        }
        [self.dataSource insertObject:model atIndex:0];
        if (!model.replys) {
            model.replys=@[];
        }
        [self.dataAray insertObject:model.replys atIndex:0];
        NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
        [boolDict setObject:@(NO) forKey:@"bool"];
        [self.boolAray insertObject:boolDict atIndex:0];
    
        [self.tableView reloadData];
        
    };
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:comment animated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLCommentTableViewCell *cell = [[YLCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellIdentifier];
    
    cell.indexPath=indexPath;
    cell.delegate=self;
    cell.mDelegate=self;
    cell.isOpen=YES;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.model=self.dataSource[indexPath.row];
    cell.timeLable.text=[YLGetTime getTimeWithSice1970TimeString:[NSString stringWithFormat:@"%@",cell.model.createdTime]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger height=116;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataSource[indexPath.row];
    NSInteger cellHeight=[self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YLCommentTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    mainScrollView.contentSize=CGSizeMake(SCREEN_WIDTH,88+[self.tableView cellsTotalHeight]+_webView.height);
    return cellHeight;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

#pragma -------------------------clickLabelWithIndexPathAndIndexDelegate--------------------------------

-(void)clickLabelWithIndexPath:(NSIndexPath *)indexPath Index:(NSInteger)index
{
    YLCommentModel *model=self.dataSource[indexPath.row];
    NSArray *replyArray=model.replys;
    YLCommentReplyModel *replyModel=[[YLCommentReplyModel alloc]initWithDictionary:replyArray[index-99] error:nil];
    coverView.hidden=NO;
    _replyToId=replyModel.Id;
    self.Id=model.Id;
    writeCommentView.reCommentLabel.text=@"回复";
    _indexpath=indexPath;
}

-(void)refreshUIWithIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.boolAray[indexPath.row]objectForKey:@"bool"]isEqual:@(NO)]) {
        [self.boolAray[indexPath.row] setObject:@(YES) forKey:@"bool"];
        YLCommentModel *model=self.dataSource[indexPath.row];
        [model setValue:self.dataAray[indexPath.row] forKey:@"replys"];
        
    }else{
        [self.boolAray[indexPath.row] setObject:@(NO) forKey:@"bool"];
        YLCommentModel *dataModel=self.dataSource[indexPath.row];
        
        if ([_dataAray[indexPath.row] count]>2) {
            NSMutableArray *addArr=[[NSMutableArray alloc]init];
            for (int i=0; i<2; i++) {
                [addArr addObject:self.dataAray[indexPath.row][i]];
            }
            [dataModel setValue:addArr forKey:@"replys"];
        }
        
        
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark-----------------------懒加载--------------------------------------------------
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}


-(NSMutableArray *)boolAray
{
    if (!_boolAray) {
        _boolAray=[NSMutableArray array];
    }
    return _boolAray;
}

-(NSMutableArray *)dataAray
{
    if (!_dataAray) {
        _dataAray=[[NSMutableArray alloc]init];
    }
    return _dataAray;
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



@end
