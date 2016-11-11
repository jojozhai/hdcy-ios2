//
//  YLSignUpViewController.m
//  hdcy
//
//  Created by mac on 16/10/13.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLSignUpViewController.h"
#import "YLNotiModel.h"
#import "YLCommentModel.h"
@interface YLSignUpViewController ()<UITextViewDelegate>
{
    UITextView *_TextView;
    YLNotiModel *Nmodel;
    UILabel *_leastLable;
    UILabel *_showLabel;
    UIButton *_signUpButton;
}
@end

@implementation YLSignUpViewController

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
    self.titleLabel.text=@"写留言";
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

-(void)deliverAction
{
    //判断是否为空及空格开头
    if (_TextView.text.length==0||_TextView.text==nil||[_TextView.text isEqual:@""]||[_TextView.text hasPrefix:@" "]) {
        [MBProgressHUD showMessage:@"请输入正确的内容"];
    }else{
        NSString *urlString=[NSString stringWithFormat:@"%@/activityParticipator",URL];
        NSDictionary *paraDict=@{@"activityId":self.contentModel.Id,@"message":_TextView.text};
        NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:BASE64CONTENT];
        [YLHttp post:urlString token:token params:paraDict success:^(id json) {
            [MBProgressHUD showMessage:@"报名成功"];
            self.messageBlock(@(YES));
            [_signUpButton setTitle:@"已报名" forState:UIControlStateNormal];
            _signUpButton.enabled=NO;
        } failure:^(NSError *error) {
            [MBProgressHUD showMessage:@"报名已结束"];
            self.messageBlock(@(NO));
        }];
        _TextView.text=@"";
        _showLabel.hidden=NO;
        _leastLable.text=[NSString stringWithFormat:@"%ld",70-_TextView.text.length];
        [_TextView resignFirstResponder];
        
        CATransition * animation = [CATransition animation];
        animation.duration = 0.8;    //  时间
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
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
    _leastLable.text=_leastLable.text=[NSString stringWithFormat:@"%ld",70-_TextView.text.length];;
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
    
    _signUpButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _signUpButton.frame=CGRectMake(12*SCREEN_MUTI, 260, 351*SCREEN_MUTI, 40);
    [_signUpButton setTitle:@"立即报名" forState:UIControlStateNormal];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpButton setBackgroundImage:[UIImage imageNamed:@"baoming"] forState:UIControlStateNormal];
    [_signUpButton addTarget:self action:@selector(deliverAction) forControlEvents:UIControlEventTouchUpInside];
    [backgroudView addSubview:_signUpButton];
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
    if ([textView.text length]>70) {
        textView.text = [textView.text substringToIndex:70];
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
    if (range.location>=70)
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
        if (_TextView.text.length<=70) {
            _leastLable.text=[NSString stringWithFormat:@"%ld",70-_TextView.text.length];
        }
    }
}

-(void)dealloc
{
    
    [Nmodel removeObserver:self forKeyPath:@"changeText"];
}- (void)didReceiveMemoryWarning {
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
