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
#import "YLAllLeavingMessageViewController.h"
@interface YLActivityOffLineViewController ()<topViewHeightChangeDelegate,UITextViewDelegate,clickAllButtonDelegate,imageViewClickDelegate,SDCycleScrollViewDelegate>
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
    /*
     *留言面板
     */
    YLCommunicateView *commucationView;
    NSInteger communicationHeight;
    
    /*
     *留言总数
     */
    NSString *totalElements;
    
}

//此页面的数据字典
@property (nonatomic,strong)NSMutableDictionary *modelDict;
//评论
@property (nonatomic,strong)NSMutableArray *communicationArray;

@property (nonatomic,strong)MBProgressHUD *hud;

@end

@implementation YLActivityOffLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.view.backgroundColor=[UIColor whiteColor];
    [self createNavigationBar];
    
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
    [self.view insertSubview:commentButton aboveSubview:scrollView];
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
            if (self.communicationArray.count>=5) {
                [self.communicationArray removeLastObject];
            }
            [self.communicationArray insertObject:model atIndex:0];
            for (UIView *view in commucationView.subviews) {
                [view removeFromSuperview];
            }
            commucationView.dataSource=self.communicationArray;
            UITableView *tv=commucationView.subviews[0];
            [scrollView addSubview:commucationView];
            commucationView.sd_layout
            .leftEqualToView(scrollView)
            .rightEqualToView(scrollView)
            .topSpaceToView(infotableView,8)
            .heightIs(tv.frame.size.height);
            scrollView.contentSize=CGSizeMake(SCREEN_WIDTH, CGRectGetMaxY(topView.frame)+commucationView.frame.size.height+186);
            communicationHeight=commucationView.frame.size.height;
            totalElements=[NSString stringWithFormat:@"%d",totalElements.intValue+1];
            commucationView.infoHeader.titleLabel.text=[NSString stringWithFormat:@"活动咨询(%@)",totalElements];
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
}

/*
 *判断活动状态
 */
-(void)isEnroll
{
    NSString *urlString=[NSString stringWithFormat:@"%@/participator/member",URL];
    NSDictionary *paraDict=@{@"participationId":self.contentModel.Id};
    [YLHttp get:urlString params:paraDict success:^(id json) {
        if ([json[@"content"] isEqual:@(YES)]) {
            [signButton setTitle:@"已报名" forState:UIControlStateNormal];
            signButton.backgroundColor=[UIColor grayColor];
            signButton.enabled=NO;
        }
        [self requestUrl];
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
    NSString *urlString=[NSString stringWithFormat:@"%@/views/activityDetail.html?id=%@",URL,self.contentModel.Id];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.contentModel.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
    [UMSocialData defaultData].extConfig.title = self.contentModel.name;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:nil];
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
    //[signButton setBackgroundImage:[UIImage imageNamed:@"jianbian"] forState:UIControlStateNormal];
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
    YLActivityOffInfoModel *model=_modelDict[@"offInfo"];
    NSDictionary *dict=model.waiterInfo;
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",dict[@"phone"]];
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
/*
 *报名，跳到报名页
 */
-(void)signUpAction
{
    YLSignUpViewController *signUpVC=[[YLSignUpViewController alloc]init];
    signUpVC.messageBlock=^(BOOL bo){
        if (bo==YES) {
            [signButton setTitle:@"已报名" forState:UIControlStateNormal];
            signButton.enabled=NO;
        }else{
            [signButton setTitle:@"已结束" forState:UIControlStateNormal];
            signButton.enabled=NO;
        }
        signButton.backgroundColor=[UIColor grayColor];
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
/*
 *网络请求，留言以上的部分
 */
-(void)requestUrl
{
    [self.hud showAnimated:YES];
    
    NSString *urlString=[NSString stringWithFormat:@"%@/activity/%@",URL,self.contentModel.Id];
    [YLHttp get:urlString params:nil success:^(id json) {
        
        YLActivityOffInfoModel *offInfoModel=[[YLActivityOffInfoModel alloc]init];
        
        offInfoModel.address=json[@"address"];
        offInfoModel.city=json[@"city"];
        offInfoModel.province=json[@"province"];
        offInfoModel.contactPhone=json[@"contactPhone"];
        offInfoModel.desc=json[@"desc"];
        offInfoModel.enable=[json[@"enable"] boolValue];
        offInfoModel.endTime=[NSNumber numberWithInteger:[json[@"endTime"] integerValue]];
        offInfoModel.finish=[json[@"finish"] boolValue];
        offInfoModel.hot=json[@"hot"];
        offInfoModel.hotPlus=[NSNumber numberWithInteger:[json[@"hotPlus"] integerValue]];
        offInfoModel.Id=json[@"id"];
        offInfoModel.image=json[@"image"];
        offInfoModel.images=json[@"images"];
        offInfoModel.name=json[@"name"];
        offInfoModel.peopleLimit=json[@"peopleLimit"];
        offInfoModel.price=[NSNumber numberWithInteger:[json[@"price"] integerValue]];
        offInfoModel.signCount=[NSNumber numberWithInteger:[json[@"signCount"] integerValue]];
        offInfoModel.signCountPlus=[NSNumber numberWithInteger:[json[@"signCountPlus"] integerValue]];
        offInfoModel.signEndTime=[NSNumber numberWithInteger:[json[@"signEndTime"] integerValue]];
        offInfoModel.signFinish=[json[@"signFinish"] boolValue];
        offInfoModel.signStartTime=[NSNumber numberWithInteger:[json[@"signStartTime"] integerValue]];
        offInfoModel.sponsorName=json[@"sponsorName"];
        offInfoModel.startTime=[NSNumber numberWithInteger:[json[@"startTime"] integerValue]];
        offInfoModel.state=json[@"state"];
        offInfoModel.type=json[@"type"];
        if ([json[@"waiterInfo"] isKindOfClass:[NSNull class]]) {
            offInfoModel.waiterInfo=@{};
        }else{
            offInfoModel.waiterInfo=json[@"waiterInfo"];
        }
        if ([signButton.titleLabel.text isEqualToString:@"已报名"]) {
            
        }else{
            if (offInfoModel.signFinish==YES) {
                [signButton setTitle:@"报名已截止" forState:UIControlStateNormal];
                signButton.backgroundColor=[UIColor grayColor];
                signButton.enabled=NO;
                
            }else{
                if ([offInfoModel.state isEqual:@"NOT_START"]) {
                    [signButton setTitle:@"立即报名" forState:UIControlStateNormal];
                    signButton.backgroundColor=BGColor;
                    
                }else if ([offInfoModel.state isEqual:@"FINISH"]) {
                    [signButton setTitle:@"已结束" forState:UIControlStateNormal];
                    signButton.backgroundColor=[UIColor grayColor];
                    signButton.enabled=NO;
                }
            }
        }
        _modelDict=[[NSMutableDictionary alloc]initWithDictionary:@{@"offInfo":offInfoModel}];
        [self createView];
     } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
}
/*
 *布局视图
 */
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
    [firstArr addObject:[NSString stringWithFormat:@"%d",offInfoModel.signCount.intValue+offInfoModel.signCountPlus.intValue]];
    [infoTArray addObject:firstArr];
    NSMutableArray *secondArray=[NSMutableArray array];
    if (offInfoModel.sponsorName==nil) {
        [secondArray addObject:@" "];
    }else{
        [secondArray addObject:offInfoModel.sponsorName];
    }
    [secondArray addObject:[YLGetTime getYYMMDDHHMMWithDate:[NSDate dateWithTimeIntervalSince1970:offInfoModel.startTime.doubleValue/1000]]];
    [secondArray addObject:[NSString stringWithFormat:@"%@%@%@",offInfoModel.province,offInfoModel.city,offInfoModel.address]];
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
    NSDictionary *paraDict=@{@"page":@(0),@"size":@"5",@"sort":@"createdTime,desc",@"targetId":self.contentModel.Id,@"target":@"activity"};
    [YLHttp get:urlString params:paraDict success:^(id json) {
        totalElements=json[@"totalElements"];
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
    commucationView.dataSource=self.communicationArray;
    commucationView.totalElements=totalElements;
    commucationView.delegate=self;
    //获取活动交流下的tableview
    UITableView *tv=commucationView.subviews[0];
    [scrollView addSubview:commucationView];
    commucationView.sd_layout
    .leftEqualToView(scrollView)
    .rightEqualToView(scrollView)
    .topSpaceToView(infotableView,8)
    .heightIs(tv.frame.size.height);
//    如果没有留言
    if (self.communicationArray.count==0) {
        commucationView.sd_layout
        .leftEqualToView(scrollView)
        .rightEqualToView(scrollView)
        .topSpaceToView(infotableView,8)
        .heightIs(200);
        UILabel *showLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 48*SCREEN_MUTI, SCREEN_WIDTH, 200-48*SCREEN_MUTI)];
        showLabel.text=@"暂无咨询";
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
    YLAllLeavingMessageViewController *leavingMessage=[[YLAllLeavingMessageViewController alloc]init];
    CATransition * animation = [CATransition animation];
    animation.duration = 0.5;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    YLActivityListContentModel *model=self.contentModel;
    leavingMessage.contentModel=model;
    [self presentViewController:leavingMessage animated:YES completion:nil];
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
    cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
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
