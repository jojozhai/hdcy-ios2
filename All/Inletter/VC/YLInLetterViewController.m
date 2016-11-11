//
//  YLInLetterViewController.m
//  hdcy
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLInLetterViewController.h"
#import "YLInLetterTableViewCell.h"
#import "YLInletterDetailViewController.h"
@interface YLInLetterViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)NSArray *dataSource;
@property (nonatomic,strong)UITableView *tableView;
@end

@implementation YLInLetterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createTableView];
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [self.tableView registerClass:[YLInLetterTableViewCell class] forCellReuseIdentifier:@"inletter"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=BGColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.view addSubview:self.tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLInLetterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"inletter"];
    if (!cell) {
        cell=[[YLInLetterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inletter"];
    }
    cell.backgroundColor=DarkBGColor;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.dict=self.dataSource[indexPath.row];
    cell.textLabel.textColor=[UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLInletterDetailViewController *detail=[[YLInletterDetailViewController alloc]init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:detail animated:NO completion:nil];
}

-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=@[@{@"name":@"好多车友",@"image":@"hdcy@2x",@"detail":@"人与车交互"}];
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
