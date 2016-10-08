//
//  YLWriteCommentViewController.m
//  hdcy
//
//  Created by mac on 16/10/7.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLWriteCommentViewController.h"
#import "YLNotiModel.h"
#import "YLCommentModel.h"
@interface YLWriteCommentViewController ()<UITextViewDelegate>
{
    UITextView *_commentTextView;
    YLNotiModel *Nmodel;
    UILabel *_leastLable;
    UILabel *_showLabel;
}
@end

@implementation YLWriteCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor grayColor];
    Nmodel=[[YLNotiModel alloc]init];
    [Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self createView];
}

//设置navbar
-(void)createNavigationBar
{
//    self.view.backgroundColor=[UIColor whiteColor];
//    self.title=@"写评论";
//    //添加返回命令
//    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default" target:self selector:@selector(backAction)];
//    [self addRightBarButtonItemWithImageName:nil title:@"发送" target:self selector:@selector(deliverAction)];
}

//返回
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deliverAction
{
    //判断是否为空及空格开头
    if (_commentTextView.text.length==0||_commentTextView.text==nil||[_commentTextView.text isEqual:@""]||[_commentTextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请输入正确的内容"];
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":self.target,@"targetId":self.Id,@"content":_commentTextView.text};
        [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
        } failure:^(NSError *error) {
            
        }];
        _commentTextView.text=@"";
        _showLabel.hidden=NO;
        _leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-_commentTextView.text.length];
        [_commentTextView resignFirstResponder];
    }
}

-(void)createView
{
    _commentTextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 300)];
    _commentTextView.font=FONT_SYS(13);
    _commentTextView.textColor= [UIColor grayColor];
    _commentTextView.delegate=self;
    _commentTextView.text=@"";
    [self.view addSubview:_commentTextView];
    
    _leastLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 364, SCREEN_WIDTH, 20)];
    _leastLable.text=@"250";
    _leastLable.textColor=[UIColor grayColor];
    _leastLable.textAlignment=NSTextAlignmentRight;
    _leastLable.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_leastLable];
    
    _showLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _showLabel.text=@"写点什么吧...";
    _showLabel.textColor=[UIColor grayColor];
    _showLabel.textAlignment=NSTextAlignmentLeft;
    _showLabel.backgroundColor=[UIColor whiteColor];
    [_commentTextView addSubview:_showLabel];
}

#pragma UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _showLabel.hidden=YES;
    [_commentTextView becomeFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    Nmodel.changeText=textView.text;
    if ([textView.text length]>250) {
        textView.text = [textView.text substringToIndex:250];
    }
    if (textView.text.length==0) {
        _showLabel.hidden=NO;
    }else{
        _showLabel.hidden=YES;
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

    if ([keyPath isEqualToString:@"changeText"]) {
        if (_commentTextView.text.length<=250) {
            _leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-_commentTextView.text.length];
        }
    }
}

-(void)dealloc
{
    
    [Nmodel removeObserver:self forKeyPath:@"changeText"];
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
