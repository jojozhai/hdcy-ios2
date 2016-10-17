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
@interface YLVideoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    NSString *_url;
    UIWebView *_webView;
    UITableView *_tableView;
    UIView *_segBar;
    UIButton *_introBut;
    UIButton *_commentBut;
    UIButton *_backBut;
    UIButton *_shareBut;
    
    
    UIView *bottomView;
    //    蒙板
    UIView *coverView;
    NSString *_replyToId;
    //    写评论view
    YLWriteCommentView *writeCommentView;
    NSIndexPath *_indexpath;
    NSString *articleId;//资讯ID
    YLNotiModel *Nmodel;
    
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

@end

@implementation YLVideoDetailViewController

- (instancetype)initWithURL:(NSString *)url
{
    self = [super init];
    if (self) {
        //        url = [@"http://mediademo.ufile.ucloud.com.cn/ucloud_promo_140s.mp4" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        _url = @"http://mediademo.ufile.ucloud.com.cn/ucloud_promo_140s.mp4";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _url = _model.url2;
    self.moviePlayer = [[YLMoviePlayerController alloc] init];
    self.moviePlayer.contentURL = [NSURL URLWithString:_url];
    
    [self.view addSubview:self.moviePlayer.view];
    
    [self.moviePlayer zoomBlock:^(BOOL isZoom) {
        
        if (isZoom)
        {
            _segBar.hidden = YES;
            _webView.hidden = YES;
            _tableView.hidden = YES;
            bottomView.hidden = YES;
            
            _backBut.transform = CGAffineTransformRotate(_backBut.transform, M_PI_2);
            _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, M_PI_2);
            _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, M_PI_2);
            
            _backBut.frame = CGRectMake((self.view.frame.size.width-32), 10, 22, 22);
            _titlLabel.frame = CGRectMake(self.view.frame.size.width-30, (self.view.frame.size.height-250)/2.0, 20, 250);
            _shareBut.frame = CGRectMake(self.view.frame.size.width-32, self.view.frame.size.height-32, 22, 22);
            
        }
        else
        {
            
            _backBut.transform = CGAffineTransformRotate(_backBut.transform, -M_PI_2);
            _titlLabel.transform = CGAffineTransformRotate(_titlLabel.transform, -M_PI_2);
            _shareBut.transform = CGAffineTransformRotate(_shareBut.transform, -M_PI_2);
            
            _backBut.frame = CGRectMake(10, 28, 22, 22);
            _titlLabel.frame = CGRectMake((self.view.frame.size.width-150)/2.0, _backBut.frame.origin.y, 150, 20);
            _shareBut.frame = CGRectMake(self.view.frame.size.width-32, 28, 22, 22);
            
        }
        
    }];
    
    [self initNavigationBar];
    
    
}

-(void)initNavigationBar
{
    _backBut = [[UIButton alloc]initWithFrame:CGRectMake(10, 28, 22, 22)];
    [_backBut setBackgroundImage:[UIImage imageNamed:@"nav-video-back-default"] forState:UIControlStateNormal];
    [_backBut addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBut];
    
    _titlLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-150)/2.0, _backBut.frame.origin.y, 150, 20)];
    _titlLabel.textColor = [UIColor whiteColor];
    _titlLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titlLabel];
    _titlLabel.text = _model.name;
    _titlLabel.font = [UIFont systemFontOfSize:15];
    
    _shareBut=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-32, 28, 22, 22)];
    [_shareBut setBackgroundImage:[UIImage imageNamed:@"nav-video-share-default"] forState:UIControlStateNormal];
    [_shareBut addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_shareBut];
}

- (void)backAction
{
    _url = nil;
    _webView = nil;
    _tableView = nil;
    _segBar = nil;
    _introBut = nil;
    _commentBut = nil;
    bottomView = nil;
    coverView = nil;
    _replyToId = nil;
    //    写评论view
    writeCommentView = nil;
    _indexpath = nil;
    articleId = nil;
    Nmodel = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.moviePlayer invalidateTimer];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shareAction
{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.model.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:_model.url2];
    [UMSocialData defaultData].extConfig.title = self.model.name;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
