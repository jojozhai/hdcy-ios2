//
//  YLConvertDetailViewController.m
//  hdcy
//
//  Created by mac on 16/10/27.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLConvertDetailViewController.h"
#import "SDCycleScrollView.h"
#import "UMSocial.h"
@interface YLConvertDetailViewController ()<SDCycleScrollViewDelegate>
{
    YLConvertModel *_convertModel;
    UILabel *_beansLabel;
    UILabel *_leftBeanLabel;
    UIView *_segBar;
    UIWebView *_business;
}
@end

@implementation YLConvertDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNavigationBar];
    [self requestData];
    [self createbottom];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"礼品详情";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-@2x" target:self selector:@selector(backAction)];
    
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
//    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/videoDetail.html?id=%@",self.listModel.Id]];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:self.listModel.image]];
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
//    [UMSocialData defaultData].extConfig.title = self.listModel.title;
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:UmengAppID
//                                      shareText:nil
//                                     shareImage:[UIImage imageWithData:data]
//                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
//                                       delegate:self];
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

-(void)createbottom
{
    UIButton *bottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bottomButton.frame=CGRectMake(0, SCREEN_HEIGHT-40, SCREEN_WIDTH, 40);
    bottomButton.backgroundColor=RGBCOLOR(67, 142, 187);
    [bottomButton setTitle:@"立即兑换" forState:UIControlStateNormal];
    [bottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(convertAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
}

-(void)convertAction:(UIButton *)btn
{
    [btn setTitle:@"余额不足" forState:UIControlStateNormal];
    btn.enabled=NO;
}

-(void)requestData
{
    NSString *urlString=[NSString stringWithFormat:@"%@/gift/%@",URL,self.model.Id];
    [YLHttp get:urlString params:nil success:^(id json) {
        _convertModel=[[YLConvertModel alloc]initWithDictionary:json error:nil];
        [self createView];
    } failure:^(NSError *error) {
        
    }];
}

-(void)createView
{
    // 滚动图片区
    SDCycleScrollView *cycle = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 70,SCREEN_WIDTH,200)];
    [self.view addSubview:cycle];
    cycle.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 分页控件位置
    cycle.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;// 分页控件风格
    cycle.autoScroll=YES;
    cycle.delegate=self;
    cycle.imageURLStringsGroup = _convertModel.images;
    cycle.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycle.placeholderImage = [UIImage imageNamed:@"placeholderImage"];
    
    UIView *beanView=[[UIView alloc]initWithFrame:CGRectMake(0, 160, SCREEN_WIDTH, 40)];
    beanView.backgroundColor=[UIColor colorWithWhite:0.3 alpha:0.3];
    [cycle addSubview:beanView];
    
    _beansLabel=[[UILabel alloc]initWithFrame:CGRectMake(24*SCREEN_MUTI, 10, 100*SCREEN_MUTI, 18)];
    _beansLabel.textAlignment=NSTextAlignmentLeft;
    _beansLabel.textColor=[UIColor whiteColor];
    _beansLabel.font=FONT_SYS(15);
    [beanView addSubview:_beansLabel];
    
    _leftBeanLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 10, 150*SCREEN_MUTI, 18)];
    _leftBeanLabel.textAlignment=NSTextAlignmentRight;
    _leftBeanLabel.textColor=[UIColor whiteColor];
    _leftBeanLabel.font=FONT_SYS(15);
    [beanView addSubview:_leftBeanLabel];
    
    _beansLabel.text=[NSString stringWithFormat:@"%@友豆",_convertModel.beans];
    _leftBeanLabel.text=[NSString stringWithFormat:@"剩余%@个",_convertModel.stock];
    
    _segBar=[[UIView alloc]initWithFrame:CGRectMake(0, 270, SCREEN_WIDTH, 40)];
    [self.view addSubview:_segBar];
    
    NSArray *buttonTitle=@[@"直播介绍",@"直播交流"];
    for (int i=0; i<2; i++) {
        UIButton *segButton=[UIButton buttonWithType:UIButtonTypeCustom];
        segButton.frame=CGRectMake(SCREEN_WIDTH/2*i, 0, SCREEN_WIDTH/2, 40);
        segButton.tag=333+i;
        [segButton setTitle:buttonTitle[i] forState:UIControlStateNormal];
        if (i==0) {
            segButton.selected=YES;
        }
        [segButton setBackgroundImage:[UIImage imageNamed:@"content-pressed"] forState:UIControlStateNormal];
        [segButton setBackgroundImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateSelected];
        [segButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [segButton setTitleColor:RGBCOLOR(143, 175, 202) forState:UIControlStateNormal];
        [segButton addTarget:self action:@selector(segSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_segBar addSubview:segButton];
    }
    
    _business=[[UIWebView alloc]initWithFrame:CGRectMake(0, 310, SCREEN_WIDTH, SCREEN_HEIGHT-350)];
    [_business setBackgroundColor:BGColor];
    [_business setOpaque:NO];
    [_business loadHTMLString:_convertModel.brandDesc baseURL:nil];
    [self.view addSubview:_business];
   
}

-(void)segSelected:(UIButton *)button
{
    if (button.tag-333==0) {
        UIButton *btn=[_segBar viewWithTag:334];
        btn.selected=NO;
        button.selected=YES;
         [_business loadHTMLString:_convertModel.brandDesc baseURL:nil];
 
    }else{
        UIButton *btn=[_segBar viewWithTag:333];
        btn.selected=NO;
        button.selected=YES;
         [_business loadHTMLString:_convertModel.desc baseURL:nil];
 
    }
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    
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
