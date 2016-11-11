//
//  YLVideoDetailViewController.m
//  hdcy
//
//  Created by mac on 16/10/16.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLVideoDetailViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "YLWriteCommentView.h"
#import "YLNotiModel.h"
#import "YLCommentModel.h"
#import "YLCommentTableViewCell.h"
#import "UMSocial.h"
#import "YLMoviePlayerController.h"
#import "YLVideoListModel.h"
#import "YLVideoBroadCastView.h"
#import "YLReplyViewController.h"
#import "YLLiveView.h"
@interface YLVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,clickLabelWithIndexPathAndIndexDelegate,clickMoreDelegate,clickEnlargeButtonDelegate,UIWebViewDelegate>
{
    NSString *_url;
    UIWebView *_webView;
    UITableView *_tableView;
    UIView *_segBar;
    UIButton *_backBut;
    UIButton *_shareBut;
    UIButton *_commentButton;
    UIView *bottomView;
    //    蒙板
    UIView *coverView;
    NSString *_replyToId;
    //    写评论view
    YLWriteCommentView *writeCommentView;
    NSIndexPath *_indexpath;
    NSString *articleId;//资讯ID
    YLNotiModel *_Nmodel;
    YLVideoListModel *_videoModel;
    YLVideoBroadCastView *_broadCastView;
    YLLiveView *_liveView;
    UIView *_playerView;
    UIView *_introView;
    UIScrollView *_WebTableView;
    UIView *_darkView;
    UILabel *_commentlabel;
    UILabel *_commentCountLabel;
    UILabel *showLabel;
    NSString *_commentC;
}

#define  kTableViewCellIdentifier @"commentReply"
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)NSMutableArray *boolAray;
// 数据备份
@property (nonatomic,strong)NSMutableArray *dataAray;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic, strong)YLMoviePlayerController *moviePlayer;

@property (nonatomic,strong)NSMutableArray *praiseArray;

@end

@implementation YLVideoDetailViewController

 
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _Nmodel=[[YLNotiModel alloc]init];
    [_Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.target=@"video";
    articleId=self.Id;

    [self requestTopData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([_videoModel.liveState isEqualToString:@"直播中"]){
        [super viewWillDisappear:animated];
        [self.playerManager.mediaPlayer.player stop];
        [_liveView removeFromSuperview];
        self.playerManager.view = nil;
        self.playerManager.viewContorller = nil;
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    }
}

-(void)requestTopData
{
    NSString *urlString=[NSString stringWithFormat:@"%@/video/%@",URL,self.Id];
    [YLHttp get:urlString params:nil success:^(id json) {
       // _videoModel=[[YLVideoListModel alloc]initWithDictionary:json error:nil];
        _videoModel=[[YLVideoListModel alloc]init];
        NSMutableDictionary *jsdict=[[NSMutableDictionary alloc]initWithDictionary:json];
        if ([jsdict[@"commentCount"] isKindOfClass:[NSNull class]]) {
            _videoModel.commentCount=@"";;
        }else{
            _videoModel.commentCount=jsdict[@"commentCount"];
            _commentC=jsdict[@"commentCount"];
        }
        if ([jsdict[@"desc"] isKindOfClass:[NSNull class]]) {
            _videoModel.desc=@"";;
        }else{
            _videoModel.desc=jsdict[@"desc"];
        }
        if ([jsdict[@"desc"] isKindOfClass:[NSNull class]]) {
            _videoModel.desc=@"";;
        }else{
            _videoModel.desc=jsdict[@"desc"];
        }
        _videoModel.enable=[jsdict[@"enable"] boolValue];
        if ([jsdict[@"endTime"] isKindOfClass:[NSNull class]]) {
            _videoModel.endTime=@"";;
        }else{
            _videoModel.endTime=jsdict[@"endTime"];
        }
        if ([jsdict[@"image"] isKindOfClass:[NSNull class]]) {
            _videoModel.image=@"";;
        }else{
            _videoModel.image=jsdict[@"image"];
        }
        if ([jsdict[@"length"] isKindOfClass:[NSNull class]]) {
            _videoModel.length=@"";;
        }else{
            _videoModel.length=jsdict[@"length"];
        }

        _videoModel.live=jsdict[@"live"];
        _videoModel.liveState=jsdict[@"liveState"];
        _videoModel.name=jsdict[@"name"];
        
        if ([jsdict[@"sponsorId"] isKindOfClass:[NSNull class]]) {
            _videoModel.sponsorId=@"";
        }else{
            _videoModel.sponsorId=jsdict[@"sponsorId"];
        }
        if ([jsdict[@"sponsorName"] isKindOfClass:[NSNull class]]) {
            _videoModel.sponsorName=@"";
        }else{
            _videoModel.sponsorName=jsdict[@"sponsorName"];
        }
        if ([jsdict[@"sponsorImage"] isKindOfClass:[NSNull class]]) {
            _videoModel.sponsorImage=@"";
        }else{
            _videoModel.sponsorImage=jsdict[@"sponsorImage"];
        }
        if ([jsdict[@"startTime"] isKindOfClass:[NSNull class]]) {
            _videoModel.startTime=@"";;
        }else{
            _videoModel.startTime=jsdict[@"startTime"];
        }
        if ([jsdict[@"streamId"] isKindOfClass:[NSNull class]]) {
            _videoModel.streamId=@"";;
        }else{
            _videoModel.streamId=jsdict[@"streamId"];
        }
        _videoModel.top=[jsdict[@"top"] boolValue];
        if ([jsdict[@"url"] isKindOfClass:[NSNull class]]) {
            _videoModel.url=@"";;
        }else{
            _videoModel.url=jsdict[@"url"];
        }
        if ([jsdict[@"url2"] isKindOfClass:[NSNull class]]) {
            _videoModel.url2=@"";;
        }else{
            _videoModel.url2=jsdict[@"url2"];
        }
        _videoModel.viewCount=[jsdict[@"viewCount"] intValue];
        _videoModel.viewCountPlus=[jsdict[@"viewCountPlus"] intValue];
        _videoModel.id=jsdict[@"id"];
        [self createView];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)createView
{
    if (_videoModel.live.integerValue) {
        if ([_videoModel.liveState isEqualToString:@"预告"]) {
            _broadCastView=[[YLVideoBroadCastView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
            _broadCastView.model=_videoModel;
            [self.view addSubview:_broadCastView];
        }else if ([_videoModel.liveState isEqualToString:@"直播中"]){
            self.cusNavigationView.hidden=YES;
            self.statusView.hidden=YES;
            _playerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
            _playerView.backgroundColor=[UIColor blackColor];
            [self.view addSubview:_playerView];
            
            self.playerManager = [[PlayerManager alloc] init];
            self.playerManager.view = _playerView;
            self.playerManager.viewContorller = self;
            [self.playerManager setPortraitViewHeight:250];
            [self.playerManager buildMediaPlayer:_videoModel.streamId];
            [self.view sendSubviewToBack:_playerView];
            
            _liveView=[[YLLiveView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 250)];
            _liveView.model=_videoModel;
            _liveView.delegate=self;
            [self.playerManager.viewContorller.view addSubview:_liveView];
            
        }else{
            [self zoomVideoView];
        }
        
        _segBar=[[UIView alloc]initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 40)];
        [self.view addSubview:_segBar];
        
        NSArray *buttonTitle=@[@"直播介绍",@"直播交流"];
        for (int i=0; i<2; i++) {
            UIButton *segButton=[UIButton buttonWithType:UIButtonTypeCustom];
            segButton.frame=CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, 40);
            segButton.tag=333+i;
            if (i==0) {
                segButton.selected=YES;
                [segButton setTitle:buttonTitle[i] forState:UIControlStateNormal];
            }else{
                [segButton setTitle:[NSString stringWithFormat:@"%@(%@)",buttonTitle[i],_videoModel.commentCount] forState:UIControlStateNormal];
            }
            [segButton setBackgroundImage:[UIImage imageNamed:@"content-pressed"] forState:UIControlStateNormal];
            [segButton setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateSelected];
            [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [segButton setTitleColor:RGBCOLOR(143, 175, 202) forState:UIControlStateNormal];
            [segButton addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventTouchUpInside];
            [_segBar addSubview:segButton];
        }
        
        [self createTableView];
        
    }else{
        [self zoomVideoView];
        
        _WebTableView=[[UIScrollView alloc]init];
        _WebTableView.backgroundColor=BGColor;
        _WebTableView.contentOffset=CGPointMake(0, 0);
        _WebTableView.showsVerticalScrollIndicator=NO;
        _WebTableView.showsHorizontalScrollIndicator=NO;
        _WebTableView.alwaysBounceVertical=YES;
        [self.view addSubview:_WebTableView];
        
        _introView=[[UIView alloc]init];
        _introView.backgroundColor=BGColor;
        [_WebTableView addSubview:_introView];
        
        UILabel *Vlabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 12, 3, 15)];
        Vlabel.backgroundColor=[UIColor whiteColor];
        [_introView addSubview:Vlabel];
        
        UILabel *introLabel=[[UILabel alloc]initWithFrame:CGRectMake(32, 12, 40, 15)];
        introLabel.text=@"简介";
        introLabel.textColor=[UIColor whiteColor];
        introLabel.font=FONT_BOLD(15);
        [_introView addSubview:introLabel];
        
        _webView=[[UIWebView alloc]init];
        _webView.delegate=self;
        [_webView setBackgroundColor:BGColor];
        [_webView setOpaque:NO];
        [_webView loadHTMLString:_videoModel.desc baseURL:nil];
        [_introView addSubview:_webView];
        
        _darkView=[[UIView alloc]init];
        _darkView.backgroundColor=RGBCOLOR(28, 44, 60);
        [_WebTableView addSubview:_darkView];
        
        _commentlabel=[[UILabel alloc]init];
        _commentlabel.backgroundColor=[UIColor whiteColor];
        [_WebTableView addSubview:_commentlabel];
        
        _commentCountLabel=[[UILabel alloc]init];
        _commentCountLabel.text=[NSString stringWithFormat:@"评论(%@)",_videoModel.commentCount];
        _commentCountLabel.textColor=[UIColor whiteColor];
        _commentCountLabel.font=FONT_BOLD(15);
        [_WebTableView addSubview:_commentCountLabel];
        
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, SCREEN_HEIGHT-250) style:UITableViewStylePlain];
        self.tableView.backgroundColor=BGColor;
        self.tableView.hidden=NO;
        [self.tableView registerClass:[YLCommentTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
        self.tableView.tableFooterView=[[UIView alloc]init];
        
        showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 48*SCREEN_MUTI, SCREEN_WIDTH, 200-48*SCREEN_MUTI)];
        showLabel.text=@"暂无评论";
        showLabel.hidden=YES;
        showLabel.textColor=[UIColor lightGrayColor];
        showLabel.backgroundColor=BGColor;
        showLabel.textAlignment=NSTextAlignmentCenter;
        showLabel.font=[UIFont systemFontOfSize:20];
        [self.tableView addSubview:showLabel];
        
        //下拉刷新
        MJRefreshNormalHeader *header =
        [[MJRefreshNormalHeader alloc]init];
        [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader)];
        self.tableView.mj_header = header;
        [header beginRefreshing];
        
        //上拉加载
        MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
        [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
        self.tableView.mj_footer=footer;
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
        
    }
    
    [self createClearCoverView];
    [self initNavigationBar];
    [self createCommentView];
    if (_videoModel.live.integerValue) {
        _commentButton.hidden=YES;
    }else{
        _commentButton.hidden=NO;
    }
    

}

-(void)createTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT-290) style:UITableViewStylePlain];
    self.tableView.backgroundColor=BGColor;
    self.tableView.hidden=YES;
    [self.tableView registerClass:[YLCommentTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    self.tableView.tableFooterView=[[UIView alloc]init];
    
    //下拉刷新
    MJRefreshNormalHeader *header =
    [[MJRefreshNormalHeader alloc]init];
    [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉加载
    MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
    [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    self.tableView.mj_footer=footer;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 48*SCREEN_MUTI, SCREEN_WIDTH, 200-48*SCREEN_MUTI)];
    showLabel.text=@"暂无评论";
    showLabel.hidden=YES;
    showLabel.textColor=[UIColor lightGrayColor];
    showLabel.backgroundColor=BGColor;
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.font=[UIFont systemFontOfSize:20];
    [self.tableView addSubview:showLabel];
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 290, SCREEN_WIDTH, SCREEN_HEIGHT-290)];
    [_webView setBackgroundColor:BGColor];
    [_webView setOpaque:NO];
    [_webView loadHTMLString:_videoModel.desc baseURL:nil];
    [self.view addSubview:_webView];
    
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
    
    NSUInteger webViewHeight = _webView.scrollView.contentSize.height;
    //获取内容实际高度（像素）
    _webView.frame=CGRectMake(0, 40, SCREEN_WIDTH,_webView.scrollView.contentSize.height+10);
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.background='#223F56'"];
    [_webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= 'white'"];
    [_webView sizeToFit];
    _introView.frame=CGRectMake(0, 0, SCREEN_WIDTH, _webView.scrollView.contentSize.height+50);
    _WebTableView.frame=CGRectMake(0,0,SCREEN_WIDTH,_webView.scrollView.contentSize.height+90);
    _darkView.frame=CGRectMake(0, 50+_webView.scrollView.contentSize.height, SCREEN_WIDTH, 8);
    _commentlabel.frame=CGRectMake(12, 50+_webView.scrollView.contentSize.height+20, 3, 15);
    _commentCountLabel.frame=CGRectMake(32, 50+_webView.scrollView.contentSize.height+20, 100, 15);
    _WebTableView.contentSize=CGSizeMake(SCREEN_WIDTH,_webView.scrollView.contentSize.height+90);
    self.tableView.tableHeaderView=_WebTableView;
    NSLog(@"结束加载%ld",(long)webViewHeight);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

#pragma clickEnlargeButtonDelegate
-(void)clickEnlargebutton:(BOOL)isZoom
{
    if (isZoom==NO) {
        //旋转屏幕，但是只旋转当前的Vie
        _segBar.hidden = NO;
        _webView.hidden = NO;
        _tableView.hidden = NO;
        _backBut.transform = CGAffineTransformRotate(_backBut.transform, -M_PI_2);
        _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, -M_PI_2);
        _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, -M_PI_2);
        _playerView.transform=CGAffineTransformRotate(_playerView.transform, -M_PI_2);
        
        _backBut.frame = CGRectMake(10, 28, 22, 22);
        _titlLabel.frame = CGRectMake((self.view.frame.size.width-150)/2.0, _backBut.frame.origin.y, 150, 20);
        _shareBut.frame = CGRectMake(self.view.frame.size.width-32, 28, 22, 22);
        _playerView.frame=CGRectMake(0,0, SCREEN_WIDTH, 250);
        
        [self.playerManager.mediaPlayer.player pause];
        [NSObject cancelPreviousPerformRequestsWithTarget:self.playerManager];
        [self.playerManager.mediaPlayer.player.view removeFromSuperview];
        [self.playerManager.controlVC.view removeFromSuperview];
        [self.playerManager.mediaPlayer.player shutdown];
        self.playerManager=nil;
        
        self.playerManager = [[PlayerManager alloc] init];
        self.playerManager.view = _playerView;
        self.playerManager.viewContorller = self;
        [self.playerManager setPortraitViewHeight:250];
        [self.playerManager buildMediaPlayer:_videoModel.streamId];
        [self.view sendSubviewToBack:_playerView];

    }else{
        //旋转屏幕，但是只旋转当前的View
        _segBar.hidden = YES;
        _webView.hidden = YES;
        _tableView.hidden = YES;
        
        _backBut.transform = CGAffineTransformRotate(_backBut.transform, M_PI_2);
        _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, M_PI_2);
        _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, M_PI_2);
        _playerView.transform=CGAffineTransformRotate(_playerView.transform, M_PI_2);
        
        _backBut.frame = CGRectMake((self.view.frame.size.width-32), 10, 22, 22);
        _titlLabel.frame = CGRectMake(self.view.frame.size.width-30, (self.view.frame.size.height-250)/2.0, 20, 250);
        _shareBut.frame = CGRectMake(self.view.frame.size.width-32, self.view.frame.size.height-32, 22, 22);
        _playerView.frame=CGRectMake(0,0, Window_Width, Window_Height);
        
        [self.playerManager.mediaPlayer.player pause];
        [NSObject cancelPreviousPerformRequestsWithTarget:self.playerManager];
        [self.playerManager.mediaPlayer.player.view removeFromSuperview];
        [self.playerManager.controlVC.view removeFromSuperview];
        [self.playerManager.mediaPlayer.player shutdown];
        self.playerManager=nil;
        
        self.playerManager = [[PlayerManager alloc] init];
        self.playerManager.view = _playerView;
        self.playerManager.viewContorller = self;
        [self.playerManager setPortraitViewHeight:Window_Height];
        [self.playerManager buildMediaPlayer:_videoModel.streamId];
        [self.view sendSubviewToBack:_playerView];
    }
    
}

- (BOOL)shouldAutorotate{
    return YES;
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)shutdownPlayer
{
    // 关闭重播放
    [NSObject cancelPreviousPerformRequestsWithTarget:self.playerManager];
    
    [self.playerManager.mediaPlayer.player.view removeFromSuperview];
    [self.playerManager.controlVC.view removeFromSuperview];
    [self.playerManager.mediaPlayer.player shutdown];
    self.playerManager.mediaPlayer = nil;
    
    {
        self.playerManager.supportInterOrtation = UIInterfaceOrientationMaskPortrait;
        [self.playerManager awakeSupportInterOrtation:self.playerManager.viewContorller completion:^{
            self.playerManager.supportInterOrtation = UIInterfaceOrientationMaskAllButUpsideDown;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UCloudMoviePlayerClickBack object:self.playerManager];
    
}

-(void)segSelected:(UIButton *)button
{
    if (button.tag-333==0) {
        UIButton *btn=[_segBar viewWithTag:334];
        btn.selected=NO;
        button.selected=YES;
        _webView.hidden=NO;
        self.tableView.hidden=YES;
        _commentButton.hidden=YES;
    }else{
        UIButton *btn=[_segBar viewWithTag:333];
        btn.selected=NO;
        button.selected=YES;
        _webView.hidden=YES;
        self.tableView.hidden=NO;
        _commentButton.hidden=NO;
    }
}

-(void)zoomVideoView
{
    _url = _videoModel.url2;
    self.moviePlayer = [[YLMoviePlayerController alloc] init];
    self.moviePlayer.contentURL = [NSURL URLWithString:_url];
    self.moviePlayer.model=_videoModel;
    [self.view addSubview:self.moviePlayer.view];
    
    [self.moviePlayer zoomBlock:^(BOOL isZoom) {
        
        if (isZoom)
        {
            _segBar.hidden = YES;
            _webView.hidden = YES;
            _tableView.hidden = YES;
            _WebTableView.hidden=YES;
            bottomView.hidden = YES;
            _commentButton.hidden=YES;
            
            _backBut.transform = CGAffineTransformRotate(_backBut.transform, M_PI_2);
            _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, M_PI_2);
            _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, M_PI_2);
            
            _backBut.frame = CGRectMake((self.view.frame.size.width-32), 10, 22, 22);
            _titlLabel.frame = CGRectMake(self.view.frame.size.width-30, (self.view.frame.size.height-250)/2.0, 20, 250);
            _shareBut.frame = CGRectMake(self.view.frame.size.width-32, self.view.frame.size.height-32, 22, 22);
            
        }
        else
        {
            _segBar.hidden = NO;
            _webView.hidden = NO;
            _tableView.hidden = NO;
            _WebTableView.hidden=NO;
            _commentButton.hidden=NO;
            
            _backBut.transform = CGAffineTransformRotate(_backBut.transform, -M_PI_2);
            _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, -M_PI_2);
            _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, -M_PI_2);
            
            _backBut.frame = CGRectMake(10, 28, 22, 22);
            _titlLabel.frame = CGRectMake((self.view.frame.size.width-150)/2.0, _backBut.frame.origin.y, 150, 20);
            _shareBut.frame = CGRectMake(self.view.frame.size.width-32, 28, 22, 22);
            
        }
        
    }];
}

-(void)initNavigationBar
{
    _backBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 22, 22)];
    [_backBut setBackgroundImage:[UIImage imageNamed:@"nav-icon-back-default-"] forState:UIControlStateNormal];
    [_backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBut];
    
    _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-150)/2.0, _backBut.frame.origin.y, 150, 20)];
    _titlLabel.textColor = [UIColor whiteColor];
    _titlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titlLabel];
    _titlLabel.text = _videoModel.name;
    _titlLabel.font = [UIFont systemFontOfSize:15];
    
    if ([_videoModel.liveState isEqualToString:@"直播中"]){
        
    }else{
        _shareBut=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-32, 28, 22, 22)];
        [_shareBut setBackgroundImage:[UIImage imageNamed:@"nav-icon-share-default"] forState:UIControlStateNormal];
        [_shareBut addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareBut];
    }
}

- (void)backAction
{
    _url = nil;
    _webView = nil;
    _tableView = nil;
    _segBar = nil;
    bottomView = nil;
    coverView = nil;
    _replyToId = nil;
    //    写评论view
    writeCommentView = nil;
    _indexpath = nil;
    articleId = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.moviePlayer invalidateTimer];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
 *创建编辑按钮
 */
-(void)createClearCoverView
{
    _commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _commentButton.frame=CGRectMake(12, SCREEN_HEIGHT-95-50, 60*SCREEN_MUTI, 60*SCREEN_MUTI) ;
    [_commentButton setImage:[UIImage imageNamed:@"content-button-edit-default"] forState:UIControlStateNormal];
    [_commentButton addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentButton];
    [self.view insertSubview:_commentButton aboveSubview:self.tableView];
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
-(void)writeComment//跳转评论页
{
    YLReplyViewController *writeVC=[[YLReplyViewController alloc]init];
    writeVC.disguise=@"video";
    writeVC.changeItemBlock=^(YLCommentModel *model){
        [self.dataSource insertObject:model atIndex:0];
        [self.dataAray insertObject:model.replys atIndex:0];
        NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
        [boolDict setObject:@(NO) forKey:@"bool"];
        [self.boolAray insertObject:boolDict atIndex:0];
        [self.praiseArray insertObject:@(0) atIndex:0];
        showLabel.hidden=YES;
        [self.tableView reloadData];
        _commentC=[NSString stringWithFormat:@"%ld",_commentC.integerValue+1];
        _commentCountLabel.text=[NSString stringWithFormat:@"评论(%ld)",_commentC.integerValue];
        
    };
    writeVC.Id=_videoModel.id;
    writeVC.target=@"video";
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:writeVC animated:YES completion:nil];
}


-(void)shareAction
{
    if (_videoModel.live.integerValue) {
        if ([_videoModel.liveState isEqualToString:@"预告"]) {
            NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/views/livevideo.html?id=%@",self.Id]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.model.image]];
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
            [UMSocialData defaultData].extConfig.title = self.model.name;
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UmengAppID
                                              shareText:nil
                                             shareImage:[UIImage imageWithData:data]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                               delegate:nil];
        }else if ([_videoModel.liveState isEqualToString:@"直播中"]){
            
            
        }else{
            NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/views/videoDetail.html?id=%@",self.Id]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.model.image]];
            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
            [UMSocialData defaultData].extConfig.title = self.model.name;
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:UmengAppID
                                              shareText:nil
                                             shareImage:[UIImage imageWithData:data]
                                        shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                               delegate:nil];
        }
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/views/videoDetail.html?id=%@",self.Id]];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.model.image]];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
        [UMSocialData defaultData].extConfig.title = self.model.name;
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:UmengAppID
                                          shareText:nil
                                         shareImage:[UIImage imageWithData:data]
                                    shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                           delegate:nil];
        
    }
     
}


-(void)refreshWithHeader
{
    
    self.page=0;
    [self requestUrl];
    
}

-(void)refreshFooter
{
    self.page++;
    [self requestUrl];
}

//查找全部评论
-(void)requestUrl
{
    [self.hud showAnimated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(self.page),@"size":@"20",@"sort":@"createdTime,desc",@"targetId":self.Id,@"target":self.target};
    //首个请求的是评论列表
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    //添加点赞状态
    NSString *urlS=[NSString stringWithFormat:@"%@/comment/praise",URL];
    [YLHttp get:urlS token:token params:paraDict success:^(id json) {
        if (self.page==0) {
            [self.dataAray removeAllObjects];
            [self.dataSource removeAllObjects];
            [self.praiseArray removeAllObjects];
        }
        for (int i=0; i<[json count]; i++) {
            [self.praiseArray addObject:json[i]];
        }
        
        [YLHttp get:urlString token:token params:paraDict success:^(id json) {
            NSArray *contentArray=json[@"content"];
            
            //判断是否有评论
            if (contentArray.count==0) {
                if (self.page==0) {
                    showLabel.hidden=NO;
                }else{
                    [MBProgressHUD showMessage:@"没有更多评论了"];
                    showLabel.hidden=YES;
                }
            }else{
                
                //添加数据
                for (NSDictionary *commentDic in contentArray) {
                    YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:commentDic error:nil];
                    [self.dataSource addObject:model];
                    [self.dataAray addObject:model.replys];
                }
                
            }
           // _commentC=
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
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            [self.hud hideAnimated:YES];
        }];
        [self.hud hideAnimated:YES];
        //取消刷新
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } failure:^(NSError *error) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
    
    
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
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambiablue-pressed"] forState:UIControlStateNormal];
    }else{
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-default-"] forState:UIControlStateNormal];
    }
    [cell.praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseButton.tag=3456+indexPath.row;
    
    cell.model=self.dataSource[indexPath.row];
    cell.timeLable.text=[YLGetTime getTimeWithSice1970TimeString:[NSString stringWithFormat:@"%@",cell.model.createdTime]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataSource[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YLCommentTableViewCell class] contentViewWidth:[self cellContentViewWith]];
    
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
    self.Id=articleId;
    writeCommentView.reCommentLabel.text=@"回复";
    _indexpath=indexPath;
    
}

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
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    [YLHttp post:urlString token:token params:paraDict success:^(id json) {
        if ([json[@"result"] isEqualToString:@"ok"]) {
            if ([json[@"content"] isEqual:@(YES)]) {
                [button setImage:[UIImage imageNamed:@"content-icon-zambiablue-pressed"] forState:UIControlStateNormal];
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
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    [YLHttp put:urlString token:token params:paraDict success:^(id json) {
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

-(void)sendAction
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    //判断是否为空及空格开头
    if (wcv.commentTextView.text.length==0||wcv.commentTextView.text==nil||[wcv.commentTextView.text isEqual:@""]||[wcv.commentTextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请输入正确的内容"];
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":self.target,@"targetId":self.Id,@"replyToId":_replyToId,@"content":wcv.commentTextView.text};
        NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
        [YLHttp post:urlString token:token params:paraDict success:^(id json) {
            //回复时
            if ([_replyToId isEqualToString:@""]==NO) {
                YLCommentModel *model=self.dataSource[_indexpath.row];
                NSArray *replyArr=model.replys;
                NSMutableArray *array=[NSMutableArray array];
                if (replyArr.count!=0) {
                    for (NSDictionary *dict in replyArr) {
                        [array addObject:dict];
                    }
                }
                [array insertObject:json atIndex:0];
                [model setValue:array forKey:@"replys"];
                [self.dataAray removeObjectAtIndex:_indexpath.row];
                [self.dataAray insertObject:array atIndex:_indexpath.row];
                
            }else{//评论时
                YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:json error:nil];
                [self.dataSource insertObject:model atIndex:0];
                if (!model.replys) {
                    model.replys=@[];
                }
                [self.dataAray insertObject:model.replys atIndex:0];
                NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
                [boolDict setObject:@(NO) forKey:@"bool"];
                [self.boolAray insertObject:boolDict atIndex:0];
                [self.praiseArray insertObject:@(0) atIndex:0];
            }
            
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
        coverView.hidden=YES;
        wcv.commentTextView.text=@"";
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
        wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        [wcv.commentTextView resignFirstResponder];
    }
}

-(void)dismissClick
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    wcv.commentTextView.text=@"";
    [wcv.commentTextView resignFirstResponder];
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
    coverView.hidden=YES;
}

#pragma -------------------------clickLabelWithIndexPathAndIndexDelegate------------------------------

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


#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    _Nmodel.changeText=textView.text;
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
    
    [_Nmodel removeObserver:self forKeyPath:@"changeText"];
}

#pragma mark - request



#pragma mark========================懒加载===============================
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
        _praiseArray=[NSMutableArray array];
    }
    return _praiseArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
