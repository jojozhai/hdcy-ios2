//
//  YLFamousDetailViewController.m
//  hdcy
//
//  Created by mac on 16/10/20.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLFamousDetailViewController.h"
#import "UMSocial.h"
#import "YLFamousDetailModel.h"
@interface YLFamousDetailViewController ()
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    UILabel *_levelLabel;
    UILabel *_sloganLabel;
    UILabel *_tagLabel;
    YLFamousDetailModel *_model;
}
@end

@implementation YLFamousDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self createNavigationBar];
    [self requestURL];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"大咖详情";
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
/*
 *分享
 */
-(void)shareAction
{
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,[NSString stringWithFormat:@"/views/leaderDetail.html?id=%@",self.Id]];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:_model.image]];
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeWeb url:urlString];
    [UMSocialData defaultData].extConfig.title = _model.name;
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppID
                                      shareText:nil
                                     shareImage:[UIImage imageWithData:data]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline]
                                       delegate:nil];
}

-(void)requestURL
{
    NSString *famousString=[NSString stringWithFormat:@"%@/leader/%@",URL,self.Id];
    [YLHttp get:famousString params:nil success:^(id json) {
        _model=[[YLFamousDetailModel alloc]initWithDictionary:json error:nil];
        [self createUpView];
    } failure:^(NSError *error) {
        
    }];
}

-(void)createUpView
{
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 190)];
    backView.backgroundColor=BGColor;
    [self.view addSubview:backView];
    
    _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 60, 60)];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:_model.image] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
    _headImageView.layer.cornerRadius=30;
    _headImageView.layer.masksToBounds=YES;
    [backView addSubview:_headImageView];
    
    _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(92, 60, 100, 20)];
    _nameLabel.text=_model.name;
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.font=FONT_BOLD(17);
    _nameLabel.textAlignment=NSTextAlignmentLeft;
    [backView addSubview:_nameLabel];
    
    _levelLabel=[[UILabel alloc]initWithFrame:CGRectMake(195, 60, 40, 20)];
    _levelLabel.text=[NSString stringWithFormat:@"LV%@",_model.level];
    _levelLabel.textColor=[UIColor whiteColor];
    _levelLabel.font=FONT_SYS(12);
    _levelLabel.textAlignment=NSTextAlignmentCenter;
    [backView addSubview:_levelLabel];
    
    _sloganLabel=[[UILabel alloc]initWithFrame:CGRectMake(92, 96, 200, 14)];
    _sloganLabel.text=_model.slogan;
    _sloganLabel.textColor=RGBCOLOR(200, 200, 200);
    _sloganLabel.textAlignment=NSTextAlignmentLeft;
    _sloganLabel.font=FONT_SYS(12);
    [backView addSubview:_sloganLabel];
    
    NSArray *tagArray=[_model.tags componentsSeparatedByString:@","];
    NSInteger labelWidth=0;
    for (int i=0; i<tagArray.count; i++) {
        _tagLabel=[[UILabel alloc]init];
        _tagLabel.text=tagArray[i];
        _tagLabel.numberOfLines=0;
        CGSize size = CGSizeMake(SCREEN_WIDTH, 1000);
        CGSize tagLabelSize = [_tagLabel.text boundingRectWithSize:size
                                                        options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     attributes:@{ NSFontAttributeName:FONT_SYS(10)}
                                                        context:nil].size;
        _tagLabel.frame=CGRectMake(92+labelWidth, 128, tagLabelSize.width+5, tagLabelSize.height+5);
        _tagLabel.backgroundColor=RGBCOLOR(31, 59, 82);
        _tagLabel.textColor=RGBCOLOR(200, 200, 200);
        _tagLabel.textAlignment=NSTextAlignmentCenter;
        _tagLabel.font=FONT_SYS(10);
        [backView addSubview:_tagLabel];
        labelWidth=labelWidth+tagLabelSize.width+20;
    }
    
    UIScrollView *introView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, SCREEN_HEIGHT-260)];
    introView.alwaysBounceVertical=YES;
    introView.showsVerticalScrollIndicator=NO;
    introView.showsHorizontalScrollIndicator=NO;
    introView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:introView];
    
    UILabel *verticleLine=[[UILabel alloc]initWithFrame:CGRectMake(12, 22, 3, 18)];
    verticleLine.backgroundColor=[UIColor blackColor];
    [introView addSubview:verticleLine];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(22, 22, 120, 18)];
    label.text=@"个人简介";
    label.textColor=[UIColor blackColor];
    label.font=FONT_BOLD(15);
    [introView addSubview:label];
    
    UILabel *introLabel=[[UILabel alloc]init];
    introLabel.numberOfLines=0;
    introLabel.font=FONT_SYS(14);
    introLabel.textColor=[UIColor blackColor];
    introLabel.text=_model.intro;
    CGSize introLabelSize = [_model.intro boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT)
                                                    options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{ NSFontAttributeName:FONT_SYS(14)}
                                                context:nil].size;
    introLabel.frame=CGRectMake(12, 60, SCREEN_WIDTH-24, introLabelSize.height+20);
    introView.contentSize=CGSizeMake(SCREEN_WIDTH, 80+introLabelSize.height);
    [introView addSubview:introLabel];
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
