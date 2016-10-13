//
//  YLActiInfoTableVIew.m
//  hdcy
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLActiInfoTableVIew.h"
#import "YLActivityInfoListButtonCell.h"
#import "YLActivityInfoHeaderView.h"
#import "YLActivityOffInfoModel.h"
@interface YLActiInfoTableVIew()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)YLActivityInfoHeaderView *headerVew;
@property (nonatomic,strong)NSArray *dataSource;
@end

@implementation YLActiInfoTableVIew

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)createTableView
{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    self.tableView.scrollEnabled=NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"YLActivityInfoListButtonCell" bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self addSubview:self.tableView];
    
    self.headerVew=[[YLActivityInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48)];
    self.headerVew.infoImageView.image=[UIImage imageNamed:@"content-icon-activity-default"];
    self.headerVew.titleLabel.text=@"活动信息";
    [self.headerVew.ylbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.headerVew];
    self.tableView.tableHeaderView=self.headerVew;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLActivityInfoListButtonCell *cell=[tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dic=self.dataSource[indexPath.row];
    cell.myImageView.image=[UIImage imageNamed:dic[@"image"]];
    cell.holdLabel.text=dic[@"name"];
    if (!self.sourceArray) {
        
    }else{
        if (indexPath.row!=0) {
            [cell.nameLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        if ([[self.sourceArray[1] objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
            [cell.nameLabel setTitle:@"免费" forState:UIControlStateNormal];
        }else{
            [cell.nameLabel setTitle:[self.sourceArray[1] objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)setSourceArray:(NSArray *)sourceArray
{
    _sourceArray=sourceArray;
    [self createTableView];
    NSString *signString=[sourceArray[0] objectAtIndex:0];
    [self.headerVew.ylbutton setTitle:[NSString stringWithFormat:@"报名人数:%@人",signString] forState:UIControlStateNormal];
    NSString *content = self.headerVew.ylbutton.titleLabel.text;
    UIFont *font = self.headerVew.ylbutton.titleLabel.font;
    CGSize size = CGSizeMake(MAXFLOAT, 12);
    CGSize buttonSize = [content boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    self.headerVew.ylbutton.sd_layout
    .widthIs(buttonSize.width);
    [self.tableView reloadData];
}

#pragma -------------------------懒加载----------------------------
-(NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=@[@{@"image":@"content-icon-sponsor-default",@"name":@"主办方："},@{@"image":@"content-icon-activitytime-default",@"name":@"活动时间："},@{@"image":@"content-icon-place-default",@"name":@"活动地点："},@{@"image":@"content-icon-cost-default",@"name":@"活动费用："}];
    }
    return _dataSource;
}


@end
