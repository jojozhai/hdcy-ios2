//
//  YLCommunicateView.m
//  hdcy
//
//  Created by mac on 16/10/12.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLCommunicateView.h"
#import "YLActivityInfoHeaderView.h"
#import "YLCommentModel.h"
#import "YLActiConsultTableViewCell.h"
#import "YLConsultRightTableViewCell.h"
@interface YLCommunicateView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *cellHeightArray;
@property (nonatomic,assign)NSInteger totelHeight;
@end
@implementation YLCommunicateView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
    
    }
    return self;
}

-(void)createView
{
    YLActivityInfoHeaderView *infoHeader=[[YLActivityInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    infoHeader.infoImageView.image=[UIImage imageNamed:@"content-icon-communication-default"];
    infoHeader.titleLabel.text=@"活动交流";
    
    self.frame=CGRectMake(0, 0, SCREEN_WIDTH, self.totelHeight);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,self.totelHeight) style:UITableViewStylePlain];
    self.tableView.scrollEnabled=NO;
    [self.tableView registerClass:[YLActiConsultTableViewCell class] forCellReuseIdentifier:@"actiConsult"];
    [self.tableView registerClass:[YLActiConsultTableViewCell class] forCellReuseIdentifier:@"rightConsult"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    self.tableView.tableHeaderView=infoHeader;
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame=CGRectMake(SCREEN_WIDTH/2-45, 8, 90, 34);
    [moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    moreButton.layer.cornerRadius=17;
    moreButton.layer.borderColor= RGBCOLOR(28, 103, 145).CGColor;
    moreButton.layer.borderWidth=0.5;
    moreButton.layer.masksToBounds=YES;
    [footerView addSubview:moreButton];
    self.tableView.tableFooterView=footerView;
}

-(void)moreAction
{
    [_delegate clickMoreButton];
}
#pragma --------------------UITableViewDelegate,UITableViewDataSource------------------

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    NSObject *model=self.dataArray[indexPath.row];
    if ([model isKindOfClass:[YLCommentModel class]]) {
        YLCommentModel *commentModel=(YLCommentModel *)model;
        YLActiConsultTableViewCell *cell=[[YLActiConsultTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actiConsult"];
        
        cell.model=commentModel;
        return cell;
    }else{
        YLCommentReplyModel *replyModel=(YLCommentReplyModel *)model;
        YLConsultRightTableViewCell *cell=[[YLConsultRightTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightConsult"];
        cell.model=replyModel;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellHeightArray[indexPath.row] integerValue];
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource=dataSource;
    NSInteger cellheight=0;
    [self.dataArray removeAllObjects];
    [self.cellHeightArray removeAllObjects];
    for (int i=0; i<dataSource.count; i++) {
        
        YLCommentModel *model=dataSource[i];
        
        CGSize constrained=CGSizeMake(200, 1000);
        CGSize commentlabelsize = [model.content boundingRectWithSize:constrained options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT_SYS(13)} context:nil].size;
        cellheight=commentlabelsize.height+80;
        [self.cellHeightArray addObject:@(cellheight)];
        
        [self.dataArray addObject:model];
        NSArray *replyArray=model.replys;
        if (replyArray.count!=0) {
            for (int j=0; j<replyArray.count; j++) {
                YLCommentReplyModel *replyModel=[[YLCommentReplyModel alloc]initWithDictionary:model.replys[j] error:nil ];
                
                CGSize replylabelsize = [replyModel.content boundingRectWithSize:constrained options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : FONT_SYS(13)} context:nil].size;
                cellheight=replylabelsize.height+80;
                [self.cellHeightArray addObject:@(cellheight)];
                
                [self.dataArray addObject:replyModel];
            }
            
        }
    }
    //计算总高度
    self.totelHeight=100;
    for (int i=0; i<self.cellHeightArray.count; i++) {
        self.totelHeight=self.totelHeight+[self.cellHeightArray[i] integerValue];
    }
    [self createView];
}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray=[NSMutableArray array];
    }
    return _cellHeightArray;
}

@end
