//
//  YLReplyViewController.m
//  hdcy
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLReplyViewController.h"
#import "YLNotiModel.h"

@interface YLReplyViewController ()<UITextViewDelegate>
{
    UITextView *_TextView;
    YLNotiModel *Nmodel;
    UILabel *_leastLable;
    UILabel *_showLabel;
}
@end

@implementation YLReplyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    Nmodel=[[YLNotiModel alloc]init];
    [Nmodel addObserver:self forKeyPath:@"changeText" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self createView];
    [self createNavigationBar];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"写评论";
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
    [self addRightBarButtonItemWithImageName:nil title:@"发送" target:self selector:@selector(deliverAction)];
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

-(void)deliverAction
{
    //判断是否为空及空格开头
    if (_TextView.text.length==0||_TextView.text==nil||[_TextView.text isEqual:@""]||[_TextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请输入正确的内容"];
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@%@",URL,@"/comment"];
        NSDictionary *paraDict=@{@"target":self.target,@"targetId":self.Id,@"content":_TextView.text};
        [YLHttp post:urlString userName:USERNAME_REMBER passeword:PASSWORD_REMBER params:paraDict success:^(id json) {
            YLCommentModel *model=[[YLCommentModel alloc]initWithDictionary:json error:nil];
            self.changeItemBlock(model);
            
            MBProgressHUD *hud=[[MBProgressHUD alloc]initWithView:self.view];
            hud.mode=MBProgressHUDModeText;
            hud.label.text=@"发布成功";
            [self.view addSubview:hud];
            [hud showAnimated:YES];
            [hud hideAnimated:YES afterDelay:1];
        } failure:^(NSError *error) {
            
        }];
        _TextView.text=@"";
        _showLabel.hidden=NO;
        _leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-_TextView.text.length];
        [_TextView resignFirstResponder];
    }
}

-(void)createView
{
    UIView *backgroudView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, SCREEN_HEIGHT-70)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignAction)];
    [backgroudView addGestureRecognizer:tap];
    backgroudView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.view addSubview:backgroudView];
    _TextView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    _TextView.font=FONT_SYS(17);
    _TextView.textColor= [UIColor grayColor];
    _TextView.delegate=self;
    _TextView.text=@"";
    [backgroudView addSubview:_TextView];
    
    _leastLable=[[UILabel alloc]initWithFrame:CGRectMake(0,200, SCREEN_WIDTH, 20)];
    _leastLable.text=_leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-_TextView.text.length];;
    _leastLable.textColor=[UIColor grayColor];
    _leastLable.textAlignment=NSTextAlignmentRight;
    _leastLable.backgroundColor=[UIColor whiteColor];
    [backgroudView addSubview:_leastLable];
    
    _showLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 20)];
    _showLabel.text=@"写点什么吧...";
    _showLabel.textColor=[UIColor grayColor];
    _showLabel.textAlignment=NSTextAlignmentLeft;
    _showLabel.backgroundColor=[UIColor whiteColor];
    [backgroudView addSubview:_showLabel];
}

-(void)resignAction
{
    [_TextView resignFirstResponder];
}

#pragma UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _showLabel.hidden=YES;
    [_TextView becomeFirstResponder];
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
        if (_TextView.text.length<=250) {
            _leastLable.text=[NSString stringWithFormat:@"还可以输入%ld字",250-_TextView.text.length];
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
