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

@property (nonatomic,strong)NSMutableArray *praiseArray;
@end

@implementation YLNewsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.Id=self.listModel.Id;
    //设置model，kvo监听
    Nmodel=[[YLNotiModel alloc]init];
    [Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    //监听键盘变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
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
    YLReplyViewController *writeVC=[[YLReplyViewController alloc]init];
    writeVC.changeItemBlock=^(YLCommentModel *model){
        textlabel.text=[NSString stringWithFormat:@"评论(%ld)",commentCount.integerValue+1];
        
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
        [self.praiseArray insertObject:@(0) atIndex:0];
        
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
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/articleDetails.html?id=%@&show=YES",self.listModel.Id]];
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

-(void)createCommentView
{
    //添加蒙板
    coverView=[[UIView alloc]initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    [self.view addSubview:coverView];
    coverView.hidden=YES;
    //加载评论
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"YLWriteCommentView" owner:self options:nil];
    //得到第一个UIView
    writeCommentView= [nib objectAtIndex:0];
    writeCommentView.tag=99;
    writeCommentView.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    writeCommentView.commentTextView.text=@"";
    writeCommentView.commentTextView.delegate=self;
    [writeCommentView.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [writeCommentView.dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:writeCommentView];
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
        [self createCommentView];
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
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/articleDetails.html?id=%@",self.listModel.Id]];
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 300)];
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
    //获取内容实际高度（像素）
    _webView.frame=CGRectMake(0, 0, SCREEN_WIDTH,webViewHeight);
    [_webView sizeToFit];
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
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
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
            //添加点赞状态
            NSString *urlString=[NSString stringWithFormat:@"%@/comment/praise",URL];
            [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
                for (int i=0; i<[json count]; i++) {
                    [self.praiseArray addObject:json[i]];
                }
                [self prepareTableView];
            } failure:^(NSError *error) {
                
                
            }];
            
        }
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
        [self.praiseArray insertObject:@(0) atIndex:0];
    
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
    
    if ([self.praiseArray[indexPath.row] isEqual:@(1)]) {
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-pressed"] forState:UIControlStateNormal];
    }else{
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-default-"] forState:UIControlStateNormal];
    }
    [cell.praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseButton.tag=3456+indexPath.row;
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLCommentModel *model=self.dataSource[indexPath.row];
    coverView.hidden=NO;
    _replyToId=model.Id;
    self.Id=self.listModel.Id;
    writeCommentView.reCommentLabel.text=@"回复";
    writeCommentView.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    _indexpath=indexPath;
}
/*
 *点赞状态
 */
-(void)praiseAction:(UIButton *)button
{
    button.enabled=NO;
    YLCommentModel *model=self.dataSource[button.tag-3456];
    if ([self.praiseArray[button.tag-3456] isEqual:@(0)]) {
        [self praiseAddwithModel:model index:button.tag];
    }else{
        [self praiseDeletewithModel:model index:button.tag];
    }
    
}

-(void)praiseAddwithModel:(YLCommentModel *)model index:(NSInteger)index
{
    YLCommentTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index-3456 inSection:0]];
    UIButton *button=[cell.contentView viewWithTag:index];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/praise"];
    NSDictionary *paraDict=@{@"target":@"comment",@"targetId":model.Id};
    [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if ([json[@"result"] isEqualToString:@"ok"]) {
            if ([json[@"content"] isEqual:@(YES)]) {
                [button setImage:[UIImage imageNamed:@"content-icon-zambia-pressed"] forState:UIControlStateNormal];
                model.praiseCount=[NSString stringWithFormat:@"%ld",model.praiseCount.integerValue+1];
                [button setTitle:model.praiseCount forState:UIControlStateNormal];
                self.praiseArray[index-3456]=@(1);
            }else{
                [MBProgressHUD showMessage:@"您已经点过赞了"];
            }
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
    }];
    button.enabled=YES;
    
}
//取消点赞
-(void)praiseDeletewithModel:(YLCommentModel *)model index:(NSInteger)index
{
    
    UIButton *button=[self.tableView viewWithTag:index];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/praise"];
    NSDictionary *paraDict=@{@"target":@"comment",@"targetId":model.Id};
    [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if ([json[@"result"] isEqualToString:@"ok"]) {
            if ([json[@"content"] isEqual:@(YES)]) {
                [button setImage:[UIImage imageNamed:@"content-icon-zambia-default-"] forState:UIControlStateNormal];
                model.praiseCount=[NSString stringWithFormat:@"%ld",model.praiseCount.integerValue-1];
                [button setTitle:model.praiseCount forState:UIControlStateNormal];
                self.praiseArray[index-3456]=@(0);
            }else{
                [MBProgressHUD showError:@"您已经取消"];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
    button.enabled=YES;
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




-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict=noti.userInfo;
    // 获取键盘升起/落下的时间
    CGFloat duration=[dict[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    NSValue *value=dict[UIKeyboardFrameEndUserInfoKey];
    CGRect frame=value.CGRectValue;
    CGFloat height=frame.size.height;
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    
    //键盘升起
    [UIView animateWithDuration:duration animations:^{
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195-height, SCREEN_WIDTH, 195);
    }];
}

-(void)keyboardWillHide
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    coverView.hidden=YES;
    [wcv.commentTextView resignFirstResponder];
    wcv.commentTextView.text=@"";
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
}


//发送按钮
-(void)sendAction
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    if (wcv.commentTextView.text.length==0||wcv.commentTextView.text==nil||[wcv.commentTextView.text isEqual:@""]||[wcv.commentTextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请正确输入内容"];
    }else{
        
        wcv.commentTextView.delegate=self;
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":@"article",@"targetId":self.listModel.Id,@"content":wcv.commentTextView.text};
        
        [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            textlabel.text=textlabel.text=[NSString stringWithFormat:@"评论(%ld)",commentCount.integerValue+1];
            
            YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:json error:nil];
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
            [self.praiseArray insertObject:@(0) atIndex:0];
            
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
            
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布失败";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
        }];
        coverView.hidden=YES;
        wcv.commentTextView.text=@"";
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
        wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        [wcv.commentTextView resignFirstResponder];
    }
}

//取消按钮
-(void)dismissClick
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    wcv.commentTextView.text=@"";
    [wcv.commentTextView resignFirstResponder];
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
    coverView.hidden=YES;
}

#pragma UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextField *)textField
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    [wcv.commentTextView becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    Nmodel.changeText=textView.text;
    if ([textView.text length]>250) {
        textView.text = [textView.text substringToIndex:250];
    }
}
//限制字数为50字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=250)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}



//kvo监听textView字数变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    if ([keyPath isEqualToString:@"changeText"]) {
        if (wcv.commentTextView.text.length<=250) {
            wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        }
    }
}

-(void)dealloc
{
    
    [Nmodel removeObserver:self forKeyPath:@"changeText"];
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

-(NSMutableArray *)praiseArray
{
    if (!_praiseArray) {
        _praiseArray=[[NSMutableArray alloc]init];
    }
    return _praiseArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
