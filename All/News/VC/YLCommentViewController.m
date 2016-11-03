//
//  YLCommentViewController.m
//  hdcy
//
//  Created by mac on 16/8/14.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLCommentViewController.h"
#import "YLCommentModel.h"
#import "YLCommentTableViewCell.h"
#import "YLWriteCommentView.h"
#import "YLNotiModel.h"
#import "YLReplyViewController.h"
#define  kTableViewCellIdentifier @"commentReply"
@interface YLCommentViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,clickLabelWithIndexPathAndIndexDelegate,clickMoreDelegate>
{
//    蒙板
    UIView *coverView;
    NSString *_replyToId;
//    写评论view
    YLWriteCommentView *writeCommentView;
    NSIndexPath *_indexpath;
    NSString *articleId;//资讯ID
    YLNotiModel *Nmodel;

}
@property (nonatomic,assign)int page;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
//是否展开数组
@property (nonatomic,strong)NSMutableArray *boolAray;
// 数据备份
@property (nonatomic,strong)NSMutableArray *dataAray;

@property (nonatomic,strong)MBProgressHUD *hud;

@property (nonatomic,strong)NSMutableArray *praiseArray;
@end
@implementation YLCommentViewController
- (void)viewDidLoad {
    
    self.page=0;
    articleId=self.Id;
    [super viewDidLoad];
     Nmodel=[[YLNotiModel alloc]init];
    [Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [self createNavigationBar];
    [self prepareTableView];
    [self createCommentView];
    [self createClearCoverView];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
}

-(void)createClearCoverView
{
    UIButton *commentButton=[UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame=CGRectMake(12, SCREEN_HEIGHT-95-50, 60*SCREEN_MUTI, 60*SCREEN_MUTI) ;
    [commentButton setImage:[UIImage imageNamed:@"content-button-edit-default"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(writeComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentButton];
    [self.view insertSubview:commentButton aboveSubview:self.tableView];
}

-(void)writeComment
{
    YLReplyViewController *writeVC=[[YLReplyViewController alloc]init];
    writeVC.changeItemBlock=^(YLCommentModel *model){
        
        [self.dataSource insertObject:model atIndex:0];
        if (!model.replys) {
            model.replys=@[];
        }
        [self.dataAray insertObject:model.replys atIndex:0];
        NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
        [boolDict setObject:@(NO) forKey:@"bool"];
        [self.boolAray insertObject:boolDict atIndex:0];
        [self.praiseArray insertObject:@(0) atIndex:0];
        
        [self.tableView reloadData];
    };
    writeVC.Id=self.Id;
    writeVC.target=@"article";
    CATransition * animation = [CATransition animation];
    animation.duration = 0.8;    //  时间
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:animation forKey:nil];
    [self presentViewController:writeVC animated:YES completion:nil];

}

-(void)createCommentView
{
    //添加蒙板
    coverView=[[UIView alloc]initWithFrame:self.view.bounds];
 
    coverView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.290];
    [self.view addSubview:coverView];
    coverView.hidden=YES;
    //加载评论
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"YLWriteCommentView" owner:self options:nil];
    //得到第一个UIView
    writeCommentView= [nib objectAtIndex:0];
    writeCommentView.tag=99;
    writeCommentView.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    writeCommentView.commentTextView.text=@"";
    writeCommentView.commentTextView.delegate=self;
    [writeCommentView.sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [writeCommentView.dismissButton addTarget:self action:@selector(dismissClick) forControlEvents:UIControlEventTouchUpInside];
    [coverView addSubview:writeCommentView];
}

//设置navbar
-(void)createNavigationBar
{
    
    self.titleLabel.text=@"全部评论";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
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
//查找全部评论
-(void)requestUrl
{
    [self.hud showAnimated:YES];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comments"];
    NSDictionary *paraDict=@{@"page":@(self.page),@"size":@"30",@"sort":@"createdTime,desc",@"targetId":self.Id,@"target":self.target};
    //首个请求的是评论列表
    [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        NSArray *contentArray=json[@"content"];
        if (self.page==0) {
            [self.dataAray removeAllObjects];
            [self.dataSource removeAllObjects];
        }
        //判断是否有评论
        if (contentArray.count==0) {
            
            [MBProgressHUD showMessage:@"已经没有更多评论了"];
        }else{
            //添加数据
            for (NSDictionary *commentDic in contentArray) {
                YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:commentDic error:nil];
                [self.dataSource addObject:model];
                [self.dataAray addObject:model.replys];
            }
            //添加点赞状态
            NSString *urlString=[NSString stringWithFormat:@"%@/comment/praise",URL];
            [YLHttp get:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
                for (int i=0; i<[json count]; i++) {
                    [self.praiseArray addObject:json[i]];
                }
                
            } failure:^(NSError *error) {
                if ([self.tableView.mj_header isRefreshing]) {
                    [self.tableView.mj_header endRefreshing];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }];
            
        }
        //添加是否展开的数组及数组中的元素
        if (self.dataSource.count!=0) {
            [self.boolAray removeAllObjects];
            for (int i=0; i<self.dataSource.count; i++) {
                
                NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
                [boolDict setObject:@(NO) forKey:@"bool"];
                [self.boolAray addObject:boolDict];
            }
            
            for (YLCommentModel *model in self.dataSource) {
                if (model.replys.count>2) {
                    NSMutableArray *addArr=[[NSMutableArray alloc]init];
                    for (int i=0; i<2; i++) {
                        [addArr addObject:model.replys[i]];
                    }
                    [model setValue:addArr forKey:@"replys"];
                }
            }
        }
        //取消刷新
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        [self.hud hideAnimated:YES];
        
    } failure:^(NSError *error) {
        [self.hud hideAnimated:YES];
    }];
    //无网络取消刷新
//    if (self.isOnline==NO) {
//        if ([self.tableView.mj_header isRefreshing]) {
//            [self.tableView.mj_header endRefreshing];
//        }else{
//            [self.tableView.mj_footer endRefreshing];
//        }
//        [self.hud hide:YES];
//    }
}

-(void)prepareTableView
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    [self.tableView registerClass:[YLCommentTableViewCell class] forCellReuseIdentifier:kTableViewCellIdentifier];
    
    //下拉刷新
    MJRefreshNormalHeader *header =
    [[MJRefreshNormalHeader alloc]init];
    [header setRefreshingTarget:self refreshingAction:@selector(refreshWithHeader)];
    self.tableView.mj_header = header;
    [header beginRefreshing];
    
    //上拉加载
    MJRefreshAutoFooter *footer=[[MJRefreshAutoFooter alloc]init];
    [footer setRefreshingTarget:self refreshingAction:@selector(refreshFooter)];
    self.tableView.mj_footer=footer;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
}

-(void)refreshWithHeader
{
    
    self.page=0;
    [self requestUrl];
    
}

-(void)refreshFooter
{
    self.page++;
    [self requestUrl];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLCommentTableViewCell *cell = [[YLCommentTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kTableViewCellIdentifier];
 
    cell.indexPath=indexPath;
    cell.delegate=self;
    cell.mDelegate=self;
    cell.isOpen=YES;
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    if ([self.praiseArray[indexPath.row] isEqual:@(1)]) {
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-pressed"] forState:UIControlStateNormal];
    }else{
        [cell.praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-default-"] forState:UIControlStateNormal];
    }
    [cell.praiseButton addTarget:self action:@selector(praiseAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.praiseButton.tag=3456+indexPath.row;
    
    cell.model=self.dataSource[indexPath.row];
    cell.timeLable.text=[YLGetTime getTimeWithSice1970TimeString:[NSString stringWithFormat:@"%@",cell.model.createdTime]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // >>>>>>>>>>>>>>>>>>>>> * cell自适应 * >>>>>>>>>>>>>>>>>>>>>>>>
    id model = self.dataSource[indexPath.row];
    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[YLCommentTableViewCell class] contentViewWidth:[self cellContentViewWith]];

}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLCommentModel *model=self.dataSource[indexPath.row];
    coverView.hidden=NO;
    _replyToId=model.Id;
    self.Id=articleId;
    writeCommentView.reCommentLabel.text=@"回复";
    _indexpath=indexPath;
 
}

-(void)praiseAction:(UIButton *)button
{
    button.enabled=NO;
    YLCommentModel *model=self.dataSource[button.tag-3456];
    if ([self.praiseArray[button.tag-3456] isEqual:@(0)]) {
        [self praiseAddwithModel:model index:button.tag];
    }else{
        [self praiseDeletewithModel:model index:button.tag];
    }
    
}

-(void)praiseAddwithModel:(YLCommentModel *)model index:(NSInteger)index
{
    YLCommentTableViewCell *cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index-3456 inSection:0]];
    UIButton *button=[cell.contentView viewWithTag:index];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/praise"];
    NSDictionary *paraDict=@{@"target":@"comment",@"targetId":model.Id};
    [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if ([json[@"result"] isEqualToString:@"ok"]) {
            if ([json[@"content"] isEqual:@(YES)]) {
                [button setImage:[UIImage imageNamed:@"content-icon-zambia-pressed"] forState:UIControlStateNormal];
                model.praiseCount=[NSString stringWithFormat:@"%ld",model.praiseCount.integerValue+1];
                [button setTitle:model.praiseCount forState:UIControlStateNormal];
                self.praiseArray[index-3456]=@(1);
            }else{
                [MBProgressHUD showMessage:@"您已经点过赞了"];
            }
            
        }else{
            
        }
            
    } failure:^(NSError *error) {
        
    }];
    button.enabled=YES;
 
}
//取消点赞
-(void)praiseDeletewithModel:(YLCommentModel *)model index:(NSInteger)index
{
    
    UIButton *button=[self.tableView viewWithTag:index];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/praise"];
    NSDictionary *paraDict=@{@"target":@"comment",@"targetId":model.Id};
    [YLHttp put:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
        if ([json[@"result"] isEqualToString:@"ok"]) {
            if ([json[@"content"] isEqual:@(YES)]) {
                [button setImage:[UIImage imageNamed:@"content-icon-zambia-default-"] forState:UIControlStateNormal];
                model.praiseCount=[NSString stringWithFormat:@"%ld",model.praiseCount.integerValue-1];
                [button setTitle:model.praiseCount forState:UIControlStateNormal];
                self.praiseArray[index-3456]=@(0);
            }else{
                [MBProgressHUD showError:@"您已经取消"];
            }

        }
    } failure:^(NSError *error) {
        
    }];
    button.enabled=YES;
}


-(void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *dict=noti.userInfo;
    // 获取键盘升起/落下的时间
    CGFloat duration=[dict[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    NSValue *value=dict[UIKeyboardFrameEndUserInfoKey];
    CGRect frame=value.CGRectValue;
    CGFloat height=frame.size.height;
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    //键盘升起
    [UIView animateWithDuration:duration animations:^{
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195-height, SCREEN_WIDTH, 195);
    }];
}

-(void)keyboardWillHide
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    coverView.hidden=YES;
    [wcv.commentTextView resignFirstResponder];
    wcv.commentTextView.text=@"";
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
}

-(void)sendAction
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    //判断是否为空及空格开头
    if (wcv.commentTextView.text.length==0||wcv.commentTextView.text==nil||[wcv.commentTextView.text isEqual:@""]||[wcv.commentTextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请输入正确的内容"];
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":self.target,@"targetId":self.Id,@"replyToId":_replyToId,@"content":wcv.commentTextView.text};
        
        [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            //回复时
            if ([_replyToId isEqualToString:@""]==NO) {
                YLCommentModel *model=self.dataSource[_indexpath.row];
                NSArray *replyArr=model.replys;
                NSMutableArray *array=[NSMutableArray array];
                if (replyArr.count!=0) {
                    for (NSDictionary *dict in replyArr) {
                        [array addObject:dict];
                    }
                }
                [array insertObject:json atIndex:0];
                [model setValue:array forKey:@"replys"];
                [self.dataAray removeObjectAtIndex:_indexpath.row];
                [self.dataAray insertObject:array atIndex:_indexpath.row];
                
            }else{//评论时
                YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:json error:nil];
                [self.dataSource insertObject:model atIndex:0];
                if (!model.replys) {
                    model.replys=@[];
                }
                [self.dataAray insertObject:model.replys atIndex:0];
                NSMutableDictionary *boolDict=[NSMutableDictionary dictionary];
                [boolDict setObject:@(NO) forKey:@"bool"];
                [self.boolAray insertObject:boolDict atIndex:0];
                [self.praiseArray insertObject:@(0) atIndex:0];
                if ([self.target isEqualToString:@"activity"]) {
                    
                }else{
                    self.changeBlock(self.dataSource);
                }
            }
            
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            
        }];
        
        coverView.hidden=YES;
        wcv.commentTextView.text=@"";
        wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
        wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        [wcv.commentTextView resignFirstResponder];
    }
}

-(void)dismissClick
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    wcv.commentTextView.text=@"";
    [wcv.commentTextView resignFirstResponder];
    wcv.frame=CGRectMake(0, SCREEN_HEIGHT-195, SCREEN_WIDTH, 195);
    wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
    coverView.hidden=YES;
}

#pragma -------------------------clickLabelWithIndexPathAndIndexDelegate------------------------------------

-(void)clickLabelWithIndexPath:(NSIndexPath *)indexPath Index:(NSInteger)index
{
    YLCommentModel *model=self.dataSource[indexPath.row];
    NSArray *replyArray=model.replys;
    YLCommentReplyModel *replyModel=[[YLCommentReplyModel alloc]initWithDictionary:replyArray[index-99] error:nil];
    coverView.hidden=NO;
    _replyToId=replyModel.Id;
    self.Id=model.Id;
    writeCommentView.reCommentLabel.text=@"回复";
    _indexpath=indexPath;
}

-(void)refreshUIWithIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.boolAray[indexPath.row]objectForKey:@"bool"]isEqual:@(NO)]) {
        [self.boolAray[indexPath.row] setObject:@(YES) forKey:@"bool"];
        YLCommentModel *model=self.dataSource[indexPath.row];
        [model setValue:self.dataAray[indexPath.row] forKey:@"replys"];
        
    }else{
        [self.boolAray[indexPath.row] setObject:@(NO) forKey:@"bool"];
        YLCommentModel *dataModel=self.dataSource[indexPath.row];
    
            if ([_dataAray[indexPath.row] count]>2) {
                NSMutableArray *addArr=[[NSMutableArray alloc]init];
                for (int i=0; i<2; i++) {
                    [addArr addObject:self.dataAray[indexPath.row][i]];
                }
                [dataModel setValue:addArr forKey:@"replys"];
            }
        
        
    }
   [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    Nmodel.changeText=textView.text;
    if ([textView.text length]>250) {
        textView.text = [textView.text substringToIndex:250];
    }

}
//限制字数为50字
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=250)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
}
//kvo监听textView字数变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    YLWriteCommentView *wcv=[coverView viewWithTag:99];
    if ([keyPath isEqualToString:@"changeText"]) {
        if (wcv.commentTextView.text.length<=250) {
            wcv.leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-wcv.commentTextView.text.length];
        }
    }
}

-(void)dealloc
{
    
    [Nmodel removeObserver:self forKeyPath:@"changeText"];
}


#pragma mark========================懒加载===============================
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource=[[NSMutableArray alloc]init];
        
    }
    return _dataSource;
}


-(NSMutableArray *)boolAray
{
    if (!_boolAray) {
        _boolAray=[NSMutableArray array];
    }
    return _boolAray;
}

-(NSMutableArray *)dataAray
{
    if (!_dataAray) {
        _dataAray=[[NSMutableArray alloc]init];
    }
    return _dataAray;
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

-(NSMutableArray *)praiseArray
{
    if (!_praiseArray) {
        _praiseArray=[[NSMutableArray alloc]init];
    }
    return _praiseArray;
}

@end
