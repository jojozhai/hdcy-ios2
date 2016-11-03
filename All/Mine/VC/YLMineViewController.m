//
//  YLMineViewController.m
//  hdcy
//
//  Created by mac on 16/10/26.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLMineViewController.h"
#import "YLMineUpView.h"
#import "YLButton.h"
#import "YLMyDataViewController.h"
#import "YLMineDataModel.h"
#import "YLMyActivityViewController.h"
#import "YLConvertViewController.h"
#import "YLAboutUsViewController.h"
@interface YLMineViewController ()
{
    YLMineUpView *_upView;
    YLMineDataModel *_model;
}
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation YLMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self requestUrl];
}

-(void)createView
{
    _upView=[[YLMineUpView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 225*SCREEN_MUTI)];
    [self.view addSubview:_upView];
    
    UIImageView *downImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 225*SCREEN_MUTI, SCREEN_WIDTH, SCREEN_HEIGHT-225*SCREEN_MUTI)];
    downImageView.image=[UIImage imageNamed:@"jianbian-1"];
    downImageView.userInteractionEnabled=YES;
    [self.view addSubview:downImageView];
    
    for (int i=0; i<self.dataSource.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame=CGRectMake(143*SCREEN_MUTI, 48*SCREEN_MUTI+68*SCREEN_MUTI*i,100, 20*SCREEN_MUTI);
        button.frame=CGRectMake(143*SCREEN_MUTI, 68*SCREEN_MUTI+80*SCREEN_MUTI*i,100, 20*SCREEN_MUTI);
        [button setImage:[UIImage imageNamed:self.dataSource[i][@"image"]] forState:UIControlStateNormal];
        button.tag=705+i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.dataSource[i][@"title"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [downImageView addSubview:button];
    }
}

-(void)buttonAction:(UIButton *)btn
{
    switch (btn.tag-705) {
        case 0:{
            YLMyDataViewController *myData=[[YLMyDataViewController alloc]init];
            myData.headimageBlock=^(NSString *head,NSString *name){
                if (name==nil) {
                    [_upView.headImageView sd_setImageWithURL:[NSURL URLWithString:head] placeholderImage:[UIImage imageNamed:@"placeholderImage"] options:SDWebImageRefreshCached];
                }
                if (head==nil) {
                    _upView.nameLabel.text=name;
                }
                
            };
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:myData animated:YES completion:nil];
        }
            break;
        case 1:{
            YLMyActivityViewController *myActivity=[[YLMyActivityViewController alloc]init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:myActivity animated:YES completion:nil];
        }
            break;
        case 2:{
//            YLConvertViewController *convert=[[YLConvertViewController alloc]init];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:convert animated:YES completion:nil];
            YLAboutUsViewController *aboutUs=[[YLAboutUsViewController alloc]init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aboutUs animated:YES completion:nil];
        }
            break;
        case 3:{
//            YLAboutUsViewController *aboutUs=[[YLAboutUsViewController alloc]init];
//             [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aboutUs animated:YES completion:nil];
        }
            break;
        case 4:{
            
        }
            break;
         
        default:
            break;
    }
}

-(void)requestUrl
{
    NSString *urlString=[NSString stringWithFormat:@"%@/user/current",URL];
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:nil success:^(id json) {
        _upView.userDictionary=json;
        _model=[[YLMineDataModel alloc]initWithDictionary:json error:nil];
    } failure:^(NSError *error) {
        
    }];
}

#pragma ---------------------------懒加载--------------------------------
-(NSArray *)dataSource
{
    if (!_dataSource) {
//        _dataSource=@[@{@"image":@"iconfont-gerenziliao",@"title":@"个人资料"},@{@"image":@"iconfont-huodong2",@"title":@"我的活动"},@{@"image":@"iconfont-lipin",@"title":@"礼品兑换"},@{@"image":@"iconfont-guanyu",@"title":@"关于我们"},@{@"image":@"iconfont-dengchu",@"title":@"退出登录"}];
        _dataSource=@[@{@"image":@"iconfont-gerenziliao",@"title":@"个人资料"},@{@"image":@"iconfont-huodong2",@"title":@"我的活动"},@{@"image":@"iconfont-guanyu",@"title":@"关于我们"},@{@"image":@"iconfont-dengchu",@"title":@"退出登录"}];
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
