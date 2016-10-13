//
//  YLActivityOffLineViewController.m
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActivityOffLineViewController.h"
#import "YLActivityOffInfoModel.h"
#import "YLActiInfoTableVIew.h"
#import "YLActivityTopView.h"
#import "YLCommentModel.h"
#import "YLCommentViewController.h"
#import "SDCycleScrollView.h"
#import "YLPhoneCallView.h"
#import "UMSocial.h"
#import "YLCommunicateView.h"
#import "YLSignUpViewController.h"
#import "YLReplyViewController.h"
@interface YLActivityOffLineViewController ()<topViewHeightChangeDelegate,UITextViewDelegate,UMSocialUIDelegate,clickAllButtonDelegate,imageViewClickDelegate,SDCycleScrollViewDelegate>
{
    /**
     底部的view
     */
    UIView *bottomView;
    /**
     顶部view
     */
    YLActivityTopView *topView;
    /**
     中间tableview
     */
    YLActiInfoTableVIew *infotableView;
    /**
     整个滚动式图
     */
    UIScrollView *scrollView;
    /**
     蒙板
     */
    UIView *coverView;
    /**
     电话面板
     */
    YLPhoneCallView *callView;
    /**
     报名按钮
     */
    UIButton *signButton;

    YLCommunicateView *commucationView;
    NSInteger communicationHeight;
}

//此页面的数据字典
@property (nonatomic,strong)NSMutableDictionary *modelDict;
//全部评论
@property (nonatomic,strong)NSMutableArray *communicationArray;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation YLActivityOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    [self createNavigationBar];
    [self requestUrl];
    [self isEnroll];
    [self createBottom];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)createCoverView
{
    //添加蒙板
    coverView=[[UIView alloc]initWithFrame:self.view.bounds];
    
    coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    [self.view addSubview:coverView];
    coverView.hidden=YES;
}

-(void)createClearCoverView
{
    UIButton *commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame=CGRectMake(12, SCREEN_HEIGHT-95-50, 60*SCREEN_MUTI, 60*SCREEN_MUTI) ;
    [commentButton setImage:[UIImage imageNamed:@"content-button-edit-default"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentButton];
    [self.view insertSubview:commentButton aboveSubview:scrollView];
}

-(void)writeComment//跳转评论页
{
    YLReplyViewController *writeVC=[[YLReplyViewController alloc]init];
    writeVC.changeItemBlock=^(YLCommentModel *model){
        if (self.communicationArray.count>=5) {
            [self.communicationArray removeLastObject];
        }
        [self.communicationArray insertObject:model atIndex:0];
        for (UIView *view in commucationView.subviews) {
            [view removeFromSuperview];
        }
        commucationView.dataSource=self.communicationArray;
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(topView.frame)+commucationView.frame.size.height+186);
        communicationHeight=commucationView.frame.size.height;
    };
    writeVC.Id=self.contentModel.Id;
    writeVC.target=@"activity";
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:writeVC animated:YES completion:nil];
}


-(void)isEnroll
{
    NSString *urlString=[NSString stringWithFormat:@"%@/participator/member",URL];
    NSDictionary *paraDict=@{@"participationId":self.contentModel.Id};
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if ([json[@"content"] isEqual:@(false)]) {
            if (self.isFinish==YES) {
                [signButton setTitle:@"已结束" forState:UIControlStateNormal];
                signButton.backgroundColor=[UIColor grayColor];
                signButton.enabled=NO;
            }else{
                [signButton setTitle:@"立即报名" forState:UIControlStateNormal];
                signButton.backgroundColor=[UIColor orangeColor];
            }
        }else{
            if (self.isFinish==YES) {
                [signButton setTitle:@"已结束" forState:UIControlStateNormal];
                signButton.backgroundColor=[UIColor grayColor];
                signButton.enabled=NO;
            }else{
                [signButton setTitle:@"已报名" forState:UIControlStateNormal];
                signButton.backgroundColor=[UIColor grayColor];
                signButton.enabled=NO;
            }
            
        }
    } failure:^(NSError *error) {
        
    }];

}
//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"活动详情";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
    //分享，暂不做
    
    [self addRightBarButtonItemWithImageName:@"nav-icon-share-default@2x" title:nil target:self selector:@selector(shareAction)];
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

-(void)shareAction
{
    NSString *urlString=[NSString stringWithFormat:@"%@/activityDetails.html?id=%@",URL,self.contentModel.Id];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.contentModel.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
    [UMSocialData defaultData].extConfig.title = self.contentModel.name;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:self];
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

//创建底部view
-(void)createBottom
{
    
    bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
    bottomView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:bottomView];
    
    UIButton *phoneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"tab-button-customerservice-default"] forState:UIControlStateNormal];
    [phoneButton setTitle:@"客服" forState:UIControlStateNormal];
    [phoneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:phoneButton];
    
    signButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [signButton setTitle:@"立即报名" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signButton setBackgroundImage:[UIImage imageNamed:@"jianbian"] forState:UIControlStateNormal];
    [signButton addTarget:self action:@selector(signUpAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:signButton];
    
    
    phoneButton.sd_layout
    .leftSpaceToView(bottomView,16)
    .topSpaceToView(bottomView,2)
    .bottomSpaceToView(bottomView,3)
    .widthIs(22);
 
    signButton.sd_layout
    .rightEqualToView(bottomView)
    .topEqualToView(bottomView)
    .bottomEqualToView(bottomView)
    .widthIs(310*SCREEN_MUTI);
    
    phoneButton.titleEdgeInsets = UIEdgeInsetsMake(22, -phoneButton.titleLabel.bounds.size.width-22, 0, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    phoneButton.titleLabel.font=[UIFont systemFontOfSize:8];
    phoneButton.imageEdgeInsets=UIEdgeInsetsMake(-11, 0, 0, 0);

}

//打电话
-(void)phoneCall
{
    coverView.hidden=NO;
    YLActivityOffInfoModel *offInfoModel=_modelDict[@"offInfo"];
    callView=[[YLPhoneCallView alloc]init];
    callView.translatesAutoresizingMaskIntoConstraints=NO;
    [coverView addSubview:callView];
    [callView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(coverView.mas_left).offset(30);
        make.top.equalTo(coverView.mas_top).offset(231);
        make.right.equalTo(coverView.mas_right).offset(-30);
        make.height.equalTo(@(205));
    }];
    callView.model=offInfoModel;
    [callView.callDialButton addTarget:self action:@selector(callDialAction) forControlEvents:UIControlEventTouchUpInside];
    [callView.callCancelButton addTarget:self action:@selector(callCancelAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)callDialAction
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",[self.modelDict[@"offInfo"] valueForKey:@"contactPhone"]];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [callView removeFromSuperview];
    coverView.hidden=YES;
}

-(void)callCancelAction
{
    [callView removeFromSuperview];
    coverView.hidden=YES;
}

-(void)signUpAction
{
    YLSignUpViewController *signUpVC=[[YLSignUpViewController alloc]init];
    signUpVC.messageBlock=^(){
        [signButton setTitle:@"已报名" forState:UIControlStateNormal];
    };
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    YLActivityListContentModel *model=self.contentModel;
    signUpVC.contentModel=model;
    [self presentViewController:signUpVC animated:YES completion:nil];
}

-(void)requestUrl
{
    [self.hud showAnimated:YES];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/activity/%@",URL,self.contentModel.Id];
    [YLHttp get:urlString params:nil success:^(id json) {
        
        YLActivityOffInfoModel *offInfoModel=[[YLActivityOffInfoModel alloc]initWithDictionary:json error:nil];
        _modelDict=[[NSMutableDictionary alloc]initWithDictionary:@{@"offInfo":offInfoModel}];
        [self createView];
     } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
}

-(void)createView
{
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70-49)];
    scrollView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    scrollView.alwaysBounceVertical=YES;
    scrollView.contentOffset=CGPointMake(0, 0);
    scrollView.bounces=NO;
    [self.view addSubview:scrollView];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40*SCREEN_MUTI)];
    nameLabel.backgroundColor=[UIColor whiteColor];
    nameLabel.text=[self.modelDict[@"offInfo"] valueForKey:@"name"];
    nameLabel.textColor=[UIColor blackColor];
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel.font=FONT_BOLD(16);
    [scrollView addSubview:nameLabel];
    
    topView=[[YLActivityTopView alloc]initWithFrame:CGRectMake(0,40*SCREEN_MUTI, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    topView.delegate=self;
    topView.iDelegate=self;
    topView.backgroundColor=[UIColor whiteColor];
    topView.descip=[self.modelDict[@"offInfo"] valueForKey:@"desc"];
    topView.picArray=[self.modelDict[@"offInfo"] valueForKey:@"images"];
    [scrollView addSubview:topView];
    
    
    
    infotableView=[[YLActiInfoTableVIew alloc]initWithFrame:CGRectZero];
    [scrollView addSubview:infotableView];
    infotableView.sd_layout
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .topSpaceToView(topView,8)
    .heightIs(168);
    
    YLActivityOffInfoModel *offInfoModel=_modelDict[@"offInfo"];
    NSMutableArray *infoTArray=[[NSMutableArray alloc]init];
    NSMutableArray *firstArr=[[NSMutableArray alloc]init];
    [firstArr addObject:offInfoModel.hot];
    [infoTArray addObject:firstArr];
    NSMutableArray *secondArray=[NSMutableArray array];
    if (offInfoModel.sponsorName==nil) {
        [secondArray addObject:@" "];
    }else{
        [secondArray addObject:offInfoModel.sponsorName];
    }
    [secondArray addObject:[YLGetTime getYYMMDDWithDate2:[NSDate dateWithTimeIntervalSince1970:offInfoModel.startTime.doubleValue/1000]]];
    [secondArray addObject:offInfoModel.address];
    [secondArray addObject:offInfoModel.price];
    [infoTArray addObject:secondArray];
    infotableView.sourceArray=infoTArray;

    [self requestCommunication];
    [self createClearCoverView];
    [self createCoverView];
}

//查找全部评论
-(void)requestCommunication
{
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(0),@"size":@"10",@"sort":@"createdTime,desc",@"targetId":self.contentModel.Id,@"target":@"activity"};
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        NSArray *contentArray=json[@"content"];
        if (contentArray.count==0) {
    
        }else{
            if (contentArray.count>5) {
                for (int i=0;i<5;i++) {
                    YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:contentArray[i] error:nil];
                    [self.communicationArray addObject:model];
                    
                }
            }else{
                for (NSDictionary *dic in contentArray) {
                    YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:dic error:nil];
                    [self.communicationArray addObject:model];
                }
            }
            
           
        }
 
        [self.hud hideAnimated:YES];
        [self createCommunicationView];
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
    
    
}
//创建留言界面
-(void)createCommunicationView
{
    commucationView=[[YLCommunicateView alloc]init];
    commucationView.delegate=self;
    [scrollView addSubview:commucationView];
    commucationView.sd_layout
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .topSpaceToView(infotableView,8);

    

    commucationView.dataSource=self.communicationArray;
//    如果没有留言
    if (self.communicationArray.count==0) {
        commucationView.sd_layout
        .leftEqualToView(scrollView)
        .rightEqualToView(scrollView)
        .topSpaceToView(infotableView,8)
        .heightIs(200);
        UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 48*SCREEN_MUTI, SCREEN_WIDTH, 200-48*SCREEN_MUTI)];
        showLabel.text=@"暂无留言";
        showLabel.textColor=[UIColor lightGrayColor];
        showLabel.backgroundColor=[UIColor whiteColor];
        showLabel.textAlignment=NSTextAlignmentCenter;
        showLabel.font=[UIFont systemFontOfSize:20];
        [commucationView addSubview:showLabel];
        
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(topView.frame)+410);
    }else{
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(topView.frame)+commucationView.frame.size.height+186);
    }
    communicationHeight=commucationView.frame.size.height;
}



#pragma-------------------------topViewHeightChangeDelegate--------------------------------
-(void)topViewChangeViewHeight:(NSInteger)height
{
    if (self.communicationArray.count==0) {
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,height+430);
    }else{
        scrollView.contentSize=CGSizeMake(SCREEN_WIDTH,height+communicationHeight+220);
    }
    
}

#pragma ------------------------clickAllButtonDelegate-----------------------------------

-(void)clickMoreButton
{
  
}


#pragma --------------------------------imageViewClickDelegate---------------------------
-(void)imageViewClickWithIndex:(NSInteger)index
{
    YLActivityOffInfoModel *offInfoModel=_modelDict[@"offInfo"];
    self.navigationController.navigationBar.hidden=YES;
    coverView.hidden=NO;
    coverView.backgroundColor=[UIColor blackColor];
    // 滚动图片区
    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_WIDTH/100*80)];
    cycleScrollView.center=coverView.center;
    cycleScrollView.delegate=self;
    [coverView addSubview:cycleScrollView];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
    cycleScrollView.autoScroll=NO;
    cycleScrollView.imageURLStringsGroup = offInfoModel.images;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"资讯列表占位图"];
    //    当前点击图片
    cycleScrollView.currentIndex=index+0.5;
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    [cycleScrollView removeFromSuperview];
    coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    [coverView setHidden:YES];
    self.navigationController.navigationBar.hidden=NO;
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
}


#pragma -----------------------------懒加载－－－－－－－－－－－－－－－－－－－－－－－
 
-(NSMutableArray *)communicationArray
{
    if (!_communicationArray) {
        _communicationArray=[[NSMutableArray alloc]init];
        
    }
    return _communicationArray;
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
