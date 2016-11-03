//
//  YLCarStyleViewController.m
//  hdcy
//
//  Created by mac on 16/10/27.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLCarStyleViewController.h"

@interface YLCarStyleViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *carButtonArray;
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)NSMutableArray *indexArray;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLCarStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=BGColor;
    [self customView];
}

-(void)customView
{
    UIButton *XButton=[UIButton buttonWithType:UIButtonTypeCustom];
    XButton.frame=CGRectMake(12, 24, 20, 20);
    [XButton setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [XButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XButton];
    
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 194)];
    
    UILabel *hotLabel=[[UILabel alloc]initWithFrame:CGRectMake(12, 0, 50, 15)];
    hotLabel.text=@"热门";
    hotLabel.textColor=[UIColor whiteColor];
    hotLabel.font=FONT_SYS(14);
    [headerView addSubview:hotLabel];
    
    UIView *buttonBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 35, SCREEN_WIDTH, 144)];
    [headerView addSubview:buttonBackView];
    
    for (int i=0; i<self.carButtonArray.count; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(12*SCREEN_MUTI+100*SCREEN_MUTI*(i%3), 38*(i/3), 92*SCREEN_MUTI, 30);
        button.tag=i+738;
        [button setTitle:self.carButtonArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseCarStyle:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"car_style_nomal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"car_style_selected"] forState:UIControlStateSelected];
        button.selected=NO;
        [buttonBackView addSubview:button];
    }
    
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

-(void)dismissAction
{
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)chooseCarStyle:(UIButton *)btn
{
    NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
    NSDictionary *paraDict=@{@"name":@"car",@"value":self.carButtonArray[btn.tag-738]};
    [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        [self dismissAction];
        self.carStyleBlock(self.carButtonArray[btn.tag-738]);
    } failure:^(NSError *error) {
        
    }];
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
    NSDictionary *dict=self.dataSource[section];
    NSArray *array=dict[@"cars"];
    return [array count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"carStyle"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carStyle"];
    }
    NSDictionary *dict=self.dataSource[indexPath.section];
    NSDictionary *carDict=[dict[@"cars"] objectAtIndex:indexPath.row];
    cell.textLabel.text=carDict[@"name"];
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
    NSDictionary *dict=self.dataSource[section];
    UILabel *header=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, 50, 20)];
    header.text=dict[@"title"];
    header.textColor=[UIColor whiteColor];
    header.font=FONT_SYS(20);
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict=self.dataSource[indexPath.section];
    NSDictionary *carDict=[dict[@"cars"] objectAtIndex:indexPath.row];
    NSString *name=carDict[@"name"];
    NSString *urlString=[NSString stringWithFormat:@"%@/user/property",URL];
    NSDictionary *paraDict=@{@"name":@"car",@"value":name};
    [YLHttp put:urlString userName:nil passeword:nil params:paraDict success:^(id json) {
        [self dismissAction];
        self.carStyleBlock(name);
    } failure:^(NSError *error) {
        
    }];
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

-(NSArray *)carButtonArray
{
    if (!_carButtonArray) {
        _carButtonArray=@[@"宝马",@"奥迪",@"奔驰",@"路虎",@"保时捷",@"本田",@"北京现代",@"比亚迪",@"大众",@"法拉利",@"兰博基尼",@"福特"];
    }
    return _carButtonArray;
}

-(NSMutableArray *)indexArray
{
    if (!_indexArray) {
        _indexArray=[NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<self.dataSource.count; i++) {
           NSDictionary *dict=self.dataSource[i];
            [_indexArray addObject:dict[@"title"]];
        }
        
    }
    return _indexArray;
}

-(NSArray *)dataSource
{
    if (!_dataSource) {
        NSString * carsPath = [[NSBundle mainBundle] pathForResource:@"cars" ofType:@"plist"];
        _dataSource=[[NSArray array]initWithContentsOfFile:carsPath];

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
