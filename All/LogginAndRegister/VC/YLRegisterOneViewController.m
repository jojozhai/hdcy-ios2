//
//  YLRegisterOneViewController.m
//  hdcy
//
//  Created by mac on 16/10/31.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLRegisterOneViewController.h"
#import "YLAddressViewController.h"
#import "YLRegisterSecondViewController.h"
#import "YLRegisterMessage.h"
#import "YLAboutWebViewController.h"
@interface YLRegisterOneViewController ()
{
    UIView *whiteView;
    UIButton *chooseButton;
    NSString *_userNameString;
    NSString *_sexString;
    NSString *_addressSring;
}
@end

@implementation YLRegisterOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self cusView];
    [self createNavigationBar];
}

//设置navbar
-(void)createNavigationBar
{
    self.titleLabel.text=@"注册";
    self.cusNavigationView.backgroundColor=[UIColor clearColor];
    self.statusView.backgroundColor=[UIColor clearColor];
    //添加返回命令
    [self addLeftBarButtonItemWithImageName:@"nav-icon-back-default-" target:self selector:@selector(backAction)];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

//返回
-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)tapAction
{
    UITextField *textF=[whiteView viewWithTag:8844];
    [textF resignFirstResponder];
}

-(void)cusView
{
    UIImageView *backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImageView.image=[UIImage imageNamed:@"register_background@2x"];
    [self.view addSubview:backImageView];
    [self.view bringSubviewToFront:self.cusNavigationView];
    whiteView=[[UIView alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI, SCREEN_WIDTH-76*SCREEN_MUTI, 150)];
    whiteView.backgroundColor=[UIColor whiteColor];
    whiteView.layer.cornerRadius=5;
    whiteView.layer.masksToBounds=YES;
    [self.view addSubview:whiteView];
    NSArray *array=@[@"性别",@"地区"];
    for (int i=0; i<2; i++) {
        UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 50*i, 150, 0.5)];
        lineLabel.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [whiteView addSubview:lineLabel];
        
        UILabel *Label=[[UILabel alloc]initWithFrame:CGRectMake(17, 68+50*i, 40, 16)];
        Label.text=array[i];
        Label.textColor=[UIColor grayColor];
        Label.font=FONT_SYS(15);
        [whiteView addSubview:Label];
    }
    
    UITextField *userTextField=[[UITextField alloc]initWithFrame:CGRectMake(17, 18, SCREEN_WIDTH-110*SCREEN_MUTI, 16)];
    userTextField.tag=8844;
    userTextField.placeholder=@"请输入用户名";
    userTextField.textColor=[UIColor grayColor];
    userTextField.borderStyle=UITextBorderStyleNone;
    [whiteView addSubview:userTextField];
    
    UISegmentedControl *segCtl=[[UISegmentedControl alloc]initWithItems:@[@"女",@"男"]];
    segCtl.frame=CGRectMake(SCREEN_WIDTH-76*SCREEN_MUTI-90, 62, 80, 26);
    [segCtl addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    segCtl.tintColor = BGColor;
    segCtl.selectedSegmentIndex = 1;
    _sexString=@"1";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor grayColor], NSForegroundColorAttributeName,nil];
    [segCtl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [segCtl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    [whiteView addSubview:segCtl];
    
    chooseButton=[UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame=CGRectMake(SCREEN_WIDTH-76*SCREEN_MUTI-46, 118,36, 12);
    chooseButton.titleLabel.font=FONT_SYS(12);
    [chooseButton setTitle:@"请选择" forState:UIControlStateNormal];
    [chooseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:chooseButton];
    
    UIButton *nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+175, SCREEN_WIDTH-76*SCREEN_MUTI, 40);
    [nextButton setBackgroundImage:[UIImage imageNamed:@"password-button-default@2x"] forState:UIControlStateNormal];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    for (int i=0; i<3; i++) {
        UILabel *numLabel=[[UILabel alloc]initWithFrame:CGRectMake(147*SCREEN_MUTI+22*SCREEN_MUTI*i, 179*SCREEN_MUTI+290, 17*SCREEN_MUTI, 17*SCREEN_MUTI)];
        numLabel.text=[NSString stringWithFormat:@"%d",i+1];
        if (i==0) {
            numLabel.backgroundColor=BGColor;
        }else{
            numLabel.backgroundColor=[UIColor grayColor];
        }
        numLabel.textColor=[UIColor whiteColor];
        numLabel.layer.cornerRadius=17*SCREEN_MUTI/2;
        numLabel.layer.masksToBounds=YES;
        numLabel.font=FONT(11);
        numLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:numLabel];
    }
    
    UILabel *negotiate=[[UILabel alloc]initWithFrame:CGRectMake(38*SCREEN_MUTI, 179*SCREEN_MUTI+240, 200, 12)];
    negotiate.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(negotiatetapClcik)];
    [negotiate addGestureRecognizer:tap];
    negotiate.attributedText=[self getAttributedString];
    negotiate.font=FONT_SYS(12);
    negotiate.textAlignment=NSTextAlignmentLeft;
    [self.view addSubview:negotiate];
}

-(NSMutableAttributedString *)getAttributedString{
    //创建一个NSMutableAttributedString
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:@"点击下一步,表示同意《用户协议》"];
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor whiteColor].CGColor
                        range:NSMakeRange(0, 10)];
    [attriString addAttribute:(NSString *)NSForegroundColorAttributeName
                        value:(id)[UIColor blueColor].CGColor
                        range:NSMakeRange(10, 6)];
    [attriString addAttribute:(NSString *)NSFontAttributeName
                        value:(id)FONT_SYS(12)
                        range:NSMakeRange(0, 15)];
    return attriString;
}

-(void)negotiatetapClcik
{
    YLAboutWebViewController *negotiate=[[YLAboutWebViewController alloc]init];
    negotiate.row=2;
    [self presentViewController:negotiate animated:NO completion:nil];
}

-(void)change:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        _sexString=@"2";
    }else if (sender.selectedSegmentIndex == 1){
        _sexString=@"1";
    }
}

-(void)addressAction
{
    YLAddressViewController *address=[[YLAddressViewController alloc]init];
    address.addressBlock=^(NSString *address){
        _addressSring=address;
        [chooseButton setTitle:address forState:UIControlStateNormal];
        CGSize chooseButtonSize = [address boundingRectWithSize:CGSizeMake(MAXFLOAT, 12)
                                                           options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        attributes:@{ NSFontAttributeName:FONT_SYS(12)}
                                                           context:nil].size;
        chooseButton.frame=CGRectMake(SCREEN_WIDTH-76*SCREEN_MUTI-chooseButtonSize.width-6, 118,chooseButtonSize.width, 12);
    };
    [self presentViewController:address animated:YES completion:nil];
}

-(void)nextStep
{
    UITextField *textfield=[whiteView viewWithTag:8844];
    if (textfield.text.length==0||textfield.text==nil) {
        [MBProgressHUD showMessage:@"请输入用户名"];
        return;
    }
    if (textfield.text.length>25) {
        [MBProgressHUD showMessage:@"请输入25个字符以内"];
        return;
    }
    if (_addressSring.length==0||_addressSring==nil) {
        [MBProgressHUD showMessage:@"请选择城市"];
        return;
    }
    YLRegisterSecondViewController *second=[[YLRegisterSecondViewController alloc]init];
    [self presentViewController:second animated:NO completion:nil];
    
    [[YLRegisterMessage sharedRegisterMessage]setNickname:textfield.text];
    [[YLRegisterMessage sharedRegisterMessage]setSex:_sexString];
    [[YLRegisterMessage sharedRegisterMessage]setCity:_addressSring];
    
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
