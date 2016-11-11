//
//  YLAddressViewController.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLAddressViewController.h"

@interface YLAddressViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UIButton *currentButton;
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    NSString *_address;
}
@property (nonatomic,strong)NSMutableDictionary *dataSource;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MBProgressHUD *hud;
@end

@implementation YLAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self customView];
    [self locate];
}

-(void)customView
{
    UIButton *XButton=[UIButton buttonWithType:UIButtonTypeCustom];
    XButton.frame=CGRectMake(12, 24, 20, 20);
    [XButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [XButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XButton];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 96)];
    
    UILabel *hotLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 50, 15)];
    hotLabel.text=@"当前";
    hotLabel.textColor=[UIColor whiteColor];
    hotLabel.font=FONT_SYS(14);
    [headerView addSubview:hotLabel];
    
    currentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    currentButton.frame=CGRectMake(12, 38, 95*SCREEN_MUTI, 32);
    [currentButton setImage:[UIImage imageNamed:@"address@2x"] forState:UIControlStateNormal];
    [currentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    currentButton.titleLabel.font=FONT_SYS(13);
    [currentButton setBackgroundImage:[UIImage imageNamed:@"address_pressed@2x"] forState:UIControlStateNormal];
    [headerView addSubview:currentButton];

    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=BGColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //改变索引的颜色
    self.tableView.sectionIndexColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView=headerView;
}

-(void)locate
{
    [self.hud showAnimated:YES];
    //定位管理器
    _locationManager=[[CLLocationManager alloc]init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        [self.hud hideAnimated:YES];
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    //NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    _geocoder=[[CLGeocoder alloc]init];
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark=[placemarks firstObject];
        NSLog(@"详细信息:%@",placemark.addressDictionary);
        [currentButton setTitle:placemark.locality forState:UIControlStateNormal];
        _address=placemark.locality;
        [_hud hideAnimated:YES];
    }];
}

-(void)dismissAction
{
    self.addressBlock(_address);
    
    if ([_address isEqualToString:@"北京市"]) {
        NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
        NSDictionary *paraDict=@{@"name":@"city",@"value":@"北京市"};
        NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
        if (token.length==0||token==nil) {
            
        }else{
            [YLHttp put:urlString token:token params:paraDict success:^(id json) {
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arry=[self.dataSource objectForKey:self.indexArray[section]];
    return [arry count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"carStyle"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carStyle"];
    }
    NSArray *arry=[self.dataSource objectForKey:self.indexArray[indexPath.section]];
    cell.textLabel.text=arry[indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    if (indexPath.row%2) {
        UIImageView *back=[[UIImageView alloc]initWithFrame:cell.bounds];
        back.image=[UIImage imageNamed:@"nichengbeijing深"];
        cell.backgroundView=back;
    }else{
        UIImageView *back=[[UIImageView alloc]initWithFrame:cell.bounds];
        back.image=[UIImage imageNamed:@"xingmingbeijing浅"];
        cell.backgroundView=back;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title=self.indexArray[section];
    UILabel *header=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 50, 20)];
    header.text=title;
    header.textColor=[UIColor whiteColor];
    header.font=FONT_SYS(20);
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arry=self.dataSource[self.indexArray[indexPath.section]];
    NSString *name=arry[indexPath.row];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
    NSDictionary *paraDict=@{@"name":@"city",@"value":name};
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
    if (token.length==0||token==nil) {
        _address=name;
        [self dismissAction];
    }else{
        [YLHttp put:urlString token:token params:paraDict success:^(id json) {
            _address=name;
            [self dismissAction];
        } failure:^(NSError *error) {
            
        }];
    }
}

//返回索引数组
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.indexArray;
}

//响应点击索引时的委托方法
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    // 获取所点目录对应的indexPath值
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    // 让table滚动到对应的indexPath位置
    [tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    return index;
}


-(NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray=[NSMutableArray arrayWithCapacity:0];
        [_indexArray addObjectsFromArray:[[self.dataSource allKeys] sortedArrayUsingSelector:@selector(compare:)]];
         
    }
    return _indexArray;
}

-(NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        NSString * carsPath = [[NSBundle mainBundle] pathForResource:@"citydict" ofType:@"plist"];
        _dataSource=[[NSMutableDictionary alloc]initWithContentsOfFile:carsPath];
        
    }
    return _dataSource;
}

-(MBProgressHUD *)hud
{
    if (!_hud) {
        _hud=[[MBProgressHUD alloc]initWithView:self.view];
        _hud.label.text=@"加载中";
    }
    return _hud;
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
