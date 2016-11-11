//
//  ViewController.m
//  GuidePage-OC
//
//  Created by 聚财通 on 16/6/2.
//  Copyright © 2016年 付正. All rights reserved.
//

#import "ViewController.h"
#import "GrayPageControl.h"
#import "UIView+SDAutoLayout.h"
#import "LoginViewController.h"

#define ScreenWidth self.view.bounds.size.width
#define ScreenHeight self.view.bounds.size.height
//#define DEVICE_IS_IPHONE6P ([[UIScreen mainScreen] bounds].size.height == 736)
#define DEVICE_IS_IPHONE6P ([[UIScreen mainScreen] bounds].size.height == 960)
#define DEVICE_IS_IPHONE6S ([[UIScreen mainScreen] bounds].size.height == 667)
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)
#define DEVICE_IS_IPHONE4 ([[UIScreen mainScreen] bounds].size.height == 480)
// 获取RGB颜色
#define XXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XXNewfeatureImageCount 5
#define kRadianToDegrees(radian) (radian* 180.0 )/(M_PI)

@interface ViewController ()<UIScrollViewDelegate>
{
    CGFloat offsetX;
    
    UIScrollView *_scrollView;
    
    UIImageView *pageoneImage1;
    UIImageView *pageoneImage2;
    UIImageView *pageoneImage3;
    UIImageView *pageoneImage4;
    UIImageView *pageoneImage5;
    
    UIImageView *pagetwoImage1;
    UIImageView *pagetwoImage2;
    UIImageView *pagetwoImage3;
    UIImageView *pagetwoImage4;
    UIImageView *pagetwoImage5;

    
    UIImageView *pagethreeImage1;
    UIImageView *pagethreeImage2;
    UIImageView *pagethreeImage3;
    UIImageView *pagethreeImage4;
    UIImageView *pagethreeImage5;
    UIImageView *pagethreeImage6;
    
    
    UIImageView *pagefourImage1;
    UIImageView *pagefourImage2;
    UIImageView *pagefourImage3;
    
    
    UIImageView *pagefiveImage1;
    UIImageView *pagefiveImage2;
    UIImageView *pagefiveImage3;
    UIImageView *pagefiveImage4;
    
    UIImageView *imgView;
    UIButton * btnAction;
    
    
    NSMutableArray * imagesArray;
    
    Boolean isLastPage;
}
@property (nonatomic, retain) GrayPageControl *pageControl;
@property(assign)Boolean scrollLeftOrRight;
@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScrollView];
    
    [self setupPageControl];
    
    [self createUI];
}

-(void)createUI
{
    //1
    float width;
    
    width = ScreenWidth-132;
    pageoneImage1 = [UIImageView new];
    pageoneImage1.image = [UIImage imageNamed:@"VIDEOS"];
    pageoneImage1.contentMode = UIViewContentModeScaleAspectFill;
    //    pageoneImage1.alpha=0;
    [_scrollView addSubview:pageoneImage1];
    
    pageoneImage2 = [UIImageView new];
    pageoneImage2.image = [UIImage imageNamed:@"视频"];
    pageoneImage2.contentMode = UIViewContentModeScaleAspectFill;
    //    pageoneImage2.alpha=0;
    [_scrollView addSubview:pageoneImage2];
    
    pageoneImage3 = [UIImageView new];
    pageoneImage3.image = [UIImage imageNamed:@"网罗全球精彩汽车运动视频"];
    pageoneImage3.contentMode = UIViewContentModeScaleAspectFill;
    //    pageoneImage3.alpha=0;
    [_scrollView addSubview:pageoneImage3];
    
    pageoneImage4 = [UIImageView new];
    pageoneImage4.image = [UIImage imageNamed:@"1-video-renwu"];
    pageoneImage4.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pageoneImage4];
    
    pageoneImage5 = [UIImageView new];
    pageoneImage5.image = [UIImage imageNamed:@"1-video-yuansu"];
//    pageoneImage5.alpha=0;
    pageoneImage5.contentMode = UIViewContentModeScaleAspectFill;
    [pageoneImage4 addSubview:pageoneImage5];
    
    
    //2
    pagetwoImage1 = [UIImageView new];
    pagetwoImage1.image = [UIImage imageNamed:@"INFORMATION"];
    pagetwoImage1.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagetwoImage1];
    
    pagetwoImage2 = [UIImageView new];
    pagetwoImage2.image = [UIImage imageNamed:@"资讯"];
    pagetwoImage2.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagetwoImage2];
    
    pagetwoImage3 = [UIImageView new];
    pagetwoImage3.image = [UIImage imageNamed:@"我们只拿汽车运动说事- "];
    pagetwoImage3.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagetwoImage3];
    
    pagetwoImage4 = [UIImageView new];
    pagetwoImage4.image = [UIImage imageNamed:@"2-information-player"];
    pagetwoImage4.contentMode = UIViewContentModeScaleAspectFill;
    //    pagetwoImage4.alpha=0;
    [_scrollView addSubview:pagetwoImage4];
    
    pagetwoImage5 = [UIImageView new];
    pagetwoImage5.image = [UIImage imageNamed:@"2-information-reporter"];
    pagetwoImage5.contentMode = UIViewContentModeScaleAspectFill;
    //    pagetwoImage5.alpha=0;
    [_scrollView addSubview:pagetwoImage5];
    
    
    
    //3
    width = ScreenWidth-132;
    pagethreeImage1 = [UIImageView new];
    pagethreeImage1.image = [UIImage imageNamed:@"ACTIVITY"];
    pagethreeImage1.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagethreeImage1];
    
    pagethreeImage2 = [UIImageView new];
    pagethreeImage2.image = [UIImage imageNamed:@"活动"];
    pagethreeImage2.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagethreeImage2];
    
    pagethreeImage3 = [UIImageView new];
    pagethreeImage3.image = [UIImage imageNamed:@"这里有汽车运动的新玩法"];
    pagethreeImage3.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagethreeImage3];
    
    pagethreeImage4= [UIImageView new];
    pagethreeImage4.image = [UIImage imageNamed:@"3-activity-racing"];
    pagethreeImage4.contentMode = UIViewContentModeScaleAspectFill;
    //    pagethreeImage4.alpha=0;
    [_scrollView addSubview:pagethreeImage4];
    
    pagethreeImage5 = [UIImageView new];
    pagethreeImage5.image = [UIImage imageNamed:@"3-activity-people"];
    pagethreeImage5.contentMode = UIViewContentModeScaleAspectFill;
    //    pagethreeImage5.alpha=0;
    [_scrollView addSubview:pagethreeImage5];
    
    pagethreeImage6 = [UIImageView new];
    pagethreeImage6.image = [UIImage imageNamed:@"4-bigshot-vip"];
    pagethreeImage6.contentMode = UIViewContentModeScaleAspectFill;
    //    pagethreeImage6.alpha=0;
    [_scrollView addSubview:pagethreeImage6];
    
    
    //4
    width = ScreenWidth-242;
    pagefourImage1= [UIImageView new];
    pagefourImage1.image = [UIImage imageNamed:@"VIP"];
    pagefourImage1.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefourImage1];
    
    pagefourImage2 = [UIImageView new];
    pagefourImage2.image = [UIImage imageNamed:@"大咖"];
    pagefourImage2.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefourImage2];
    
    pagefourImage3 = [UIImageView new];
    pagefourImage3.image = [UIImage imageNamed:@"业界的大咖和牛人都在这"];
    pagefourImage3.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefourImage3];
    
    
    
    //5
    
    pagefiveImage1= [UIImageView new];
    pagefiveImage1.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefiveImage1];
    
    pagefiveImage2= [UIImageView new];
    pagefiveImage2.backgroundColor = [UIColor blackColor];
    pagefiveImage2.alpha=0;
    [_scrollView addSubview:pagefiveImage2];
    
    pagefiveImage3= [UIImageView new];
    pagefiveImage3.alpha=0;
    pagefiveImage3.image = [UIImage imageNamed:@"6-logo"];
    pagefiveImage3.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefiveImage3];
    
    pagefiveImage4= [UIImageView new];
    pagefiveImage4.alpha=0;
    pagefiveImage4.image = [UIImage imageNamed:@"6-汽车运动，从你不一样"];
    pagefiveImage4.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:pagefiveImage4];
    
    
    //添加多图
    NSString * imageName=@"";
    int row = 0;
    int cloumn=0;
    
    imagesArray = [NSMutableArray new];
    
    
    UIImageView * tempImgView;
    for(int i=1;i<19;i++)
    {
        imageName = [NSString stringWithFormat:@"img%d",i];
        
        //初始化
        UIImageView * imageView = [UIImageView new];
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:imageName];
        //添加到背景视图
        [pagefiveImage1 addSubview:imageView];
        
        if(i<16)
        {
            //约束
            if(i==1 && row==0)
            {
                imageView.sd_layout
                .leftSpaceToView(pagefiveImage1,0)
                .topSpaceToView(pagefiveImage1,0)
                .widthRatioToView(pagefiveImage1,0.33333333)
                .heightEqualToWidth();
            }else{
                if ((i-1)%3==0) {
                    imageView.sd_layout
                    .leftSpaceToView(pagefiveImage1,0)
                    .topSpaceToView(tempImgView,0)
                    .widthRatioToView(tempImgView,1)
                    .heightEqualToWidth();
                }else{
                    imageView.sd_layout
                    .topEqualToView(tempImgView)
                    .leftSpaceToView(tempImgView,0)
                    .widthRatioToView(tempImgView,1)
                    .heightEqualToWidth();
                }
                
            }
            
        }else{
            //约束
            if(i==16)
            {
                imageView.sd_layout
                .leftSpaceToView(pagefiveImage1,0)
                .topSpaceToView(tempImgView,0)
                .widthRatioToView(pagefiveImage1,0.33333333)
                .autoHeightRatio(0.5);
            }else{
                imageView.sd_layout
                .leftSpaceToView(tempImgView,0)
                .topEqualToView(tempImgView)
                .widthRatioToView(tempImgView,1)
                .autoHeightRatio(0.5);
            }
        }
        
        if (i%3==0) {
            row++;
            cloumn=0;
        }else{
            cloumn++;
        }
        
        imageView.alpha=0;
        tempImgView = imageView;
        
        [imagesArray addObject:imageView];
    }
    //
    btnAction = [UIButton new];
    btnAction.alpha=0;
    [btnAction setUserInteractionEnabled:YES];
    [btnAction setTitle:@"立即体验" forState:UIControlStateNormal];
    [btnAction.layer setCornerRadius:22.5];
    [btnAction.layer setBorderWidth:1];
    [btnAction.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [btnAction setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAction addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:btnAction];
    
    
    //第一页设定约束
    pageoneImage2.sd_layout
    .leftSpaceToView(_scrollView,132)
    .topSpaceToView(_scrollView,45)
    .rightSpaceToView(_scrollView,132)
    .heightIs(45);
    
    pageoneImage1.sd_layout
    .leftSpaceToView(_scrollView,66)
    .topSpaceToView(_scrollView,87)
    .rightSpaceToView(_scrollView,66)
    .heightIs(45);
    
    pageoneImage3.sd_layout
    .leftSpaceToView(_scrollView,68)
    .topSpaceToView(_scrollView,126)
    .rightSpaceToView(_scrollView,69)
    .heightIs(20);
    
    if(DEVICE_IS_IPHONE5)
    {
        pageoneImage4.sd_layout
        .leftSpaceToView(_scrollView,ScreenWidth*0.0426666)
        .topSpaceToView(_scrollView,230)
        .widthIs(ScreenWidth*0.908)
        .heightIs(ScreenWidth*0.92533333);
    }else{
        pageoneImage4.sd_layout
        .leftSpaceToView(_scrollView,ScreenWidth*0.0426666)
        .topSpaceToView(_scrollView,260)
        .widthIs(ScreenWidth*0.908)
        .heightIs(ScreenWidth*0.92533333);
    }
    
    pageoneImage5.sd_layout
    .leftSpaceToView(pageoneImage4,ScreenWidth*0.2533333)
    .topSpaceToView(pageoneImage4,40)
    .widthIs(ScreenWidth*0.208)
    .heightIs(ScreenWidth*0.224);
    
    
    //第二页设定约束
    pagetwoImage2.sd_layout
    .leftSpaceToView(_scrollView,ScreenWidth+132)
    .topEqualToView(pageoneImage2)
    .widthRatioToView(pageoneImage2,1)
    .heightIs(45);
    
    pagetwoImage1.sd_layout
    .leftSpaceToView(_scrollView,ScreenWidth+19)
    .topSpaceToView(_scrollView,87)
    .widthRatioToView(_scrollView,0.9)
    .heightIs(30);
    
    pagetwoImage3.sd_layout
    .leftSpaceToView(_scrollView,ScreenWidth+68)
    .topSpaceToView(_scrollView,126)
    .widthRatioToView(_scrollView,0.6)
    .heightIs(20);
    
//    pagetwoImage4.sd_layout
//    .leftSpaceToView(_scrollView,ScreenWidth+231)
//    .topSpaceToView(_scrollView,295)
//    .widthIs(70.5)
//    .heightIs(66.5);
//    
//    pagetwoImage5.sd_layout
//    .leftSpaceToView(_scrollView,ScreenWidth+23.75)
//    .topSpaceToView(_scrollView,275)
//    .widthIs(326.5)
//    .heightIs(337.5);
    
    
    
    pagethreeImage2.sd_layout
    .leftSpaceToView(_scrollView,2*ScreenWidth+132)
    .topSpaceToView(_scrollView,45)
    .widthRatioToView(pageoneImage2,1)
    .heightIs(45);
    
    pagethreeImage1.sd_layout
    .leftSpaceToView(_scrollView,2*ScreenWidth+66)
    .topSpaceToView(_scrollView,87)
    .widthRatioToView(_scrollView,0.65)
    .heightIs(45);
    
    pagethreeImage3.sd_layout
    .leftSpaceToView(_scrollView,2*ScreenWidth+68)
    .topSpaceToView(_scrollView,126)
    .widthRatioToView(_scrollView,0.6)
    .heightIs(20);
    
//    pagethreeImage4.sd_layout
//    .leftSpaceToView(_scrollView,2*ScreenWidth+20)
//    .topSpaceToView(_scrollView,300)
//    .widthIs(346)
//    .heightIs(229)
//    ;
    
//    pagethreeImage5.sd_layout
//    .leftSpaceToView(_scrollView,2*ScreenWidth+15)
//    .topSpaceToView(_scrollView,260)
//    .widthIs(223.5)
//    .heightIs(324);
    
    
    
    
    pagefourImage2.sd_layout
    .leftSpaceToView(_scrollView,3*ScreenWidth+132)
    .topSpaceToView(_scrollView,45)
    .widthRatioToView(pageoneImage2,1)
    .heightIs(45);
    
    pagefourImage1.sd_layout
    .leftSpaceToView(_scrollView,3*ScreenWidth+ScreenWidth*0.365333)
    .topSpaceToView(_scrollView,87)
    .widthRatioToView(_scrollView,0.27)
    .heightIs(45);
    
    pagefourImage3.sd_layout
    .leftSpaceToView(_scrollView,3*ScreenWidth+68)
    .topSpaceToView(_scrollView,126)
    .widthRatioToView(_scrollView,0.6)
    .heightIs(20);
    
    
    
    pagefiveImage1.sd_layout
    .leftSpaceToView(_scrollView,4*ScreenWidth)
    .topEqualToView(_scrollView)
    .widthRatioToView(_scrollView,1)
    .heightRatioToView(_scrollView,1);
    
    pagefiveImage2.sd_layout
    .leftSpaceToView(_scrollView,4*ScreenWidth)
    .topEqualToView(_scrollView)
    .widthRatioToView(_scrollView,1)
    .heightRatioToView(_scrollView,1);
    
    pagefiveImage3.sd_layout
    .leftSpaceToView(_scrollView,4*ScreenWidth+ScreenWidth*0.2)
    .topSpaceToView(_scrollView,100)
    .widthIs(ScreenWidth*0.6)
    .heightIs(120.5);
    
    if(DEVICE_IS_IPHONE5)
    {
        pagefiveImage4.sd_layout
        .leftSpaceToView(_scrollView,4*ScreenWidth+ScreenWidth*0.25)
        .topSpaceToView(pagefiveImage3,50)
        .widthIs(ScreenWidth*0.5)
        .heightIs(25.5);
    }else{
        pagefiveImage4.sd_layout
        .leftSpaceToView(_scrollView,4*ScreenWidth+ScreenWidth*0.2)
        .topSpaceToView(pagefiveImage3,50)
        .widthIs(ScreenWidth*0.6)
        .heightIs(28.5);
    }
    
    
    btnAction.sd_layout
    .leftSpaceToView(_scrollView,4*ScreenWidth+ScreenWidth*0.3)
    .bottomSpaceToView(_scrollView,80)
    .widthRatioToView(_scrollView,0.4)
    .heightIs(45);
    
    
    //    //执行动画
    //    [self actionAnimation];
}


-(void)doAction
{
    LoginViewController * controller = [[LoginViewController alloc]init];
    [self presentViewController:controller animated:NO completion:nil];
}

-(void)actionAnimation
{
    
    
    //    [UIView animateWithDuration:1.2 animations:^{
    //
    //        pageoneImage5.alpha=1;
    //
    //        pageoneImage1.alpha=1;
    //        pageoneImage2.alpha=1;
    //        pageoneImage3.alpha=1;
    //
    //    }];
}


-(void)operateAnimate:(int)index
{
    if(index<imagesArray.count)
    {
        UIImageView * imageView  = [imagesArray objectAtIndex:index];
        __block int i = index;
        
        [UIView animateWithDuration:0.1 animations:^{
            imageView.alpha=1;
        } completion:^(BOOL finished) {
            [self operateAnimate:++i];
        }];
    }else{
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            pagefiveImage2.alpha=0.8;
            
            [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; //InOut 表示进入和出去时都启动动画
            [UIView setAnimationDuration:2.0f];//动画时间
            pagefiveImage3.transform=CGAffineTransformMakeTranslation(0, -10);
            pagefiveImage4.transform=CGAffineTransformMakeTranslation(0, -10);
            
            pagefiveImage3.alpha=1;
            pagefiveImage4.alpha=1;
            
            [UIView commitAnimations]; //启动动画
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:3  animations:^{
                btnAction.alpha=1;
            }];
        }];
    }
    
    
}
-(void)doImagesAnimation
{
    
    btnAction.alpha=0;
    pagefiveImage2.alpha=0;
    pagefiveImage3.alpha=0;
    pagefiveImage4.alpha=0;
    pagefiveImage3.transform=CGAffineTransformMakeTranslation(0, 10);
    pagefiveImage4.transform=CGAffineTransformMakeTranslation(0, 10);
    
    [self operateAnimate:0];
    
}



/**
 *  初始化scrollView
 */
- (void)setupScrollView
{
    // 添加scrollView
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    CGFloat contentW = _scrollView.bounds.size.width * XXNewfeatureImageCount;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(contentW, 0);
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
}

/**
 *  跳转控制器
 */
- (void)getstart
{
    
}

/**
 *  初始化pageControl
 */
- (void)setupPageControl
{
    self.pageControl = [[GrayPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _pageControl.count = XXNewfeatureImageCount;
    _pageControl.currentIndex=0;
    
    CGFloat centerX = self.view.bounds.size.width * 0.5;
    CGFloat centerY = self.view.bounds.size.height - 22;
    _pageControl.center = CGPointMake(centerX, centerY);
    _pageControl.bounds = CGRectMake(0, 0, 200, 30);
    [self.view addSubview:_pageControl];
    self.pageControl = _pageControl;
}

#pragma mark - UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    offsetX = scrollView.contentOffset.x;
    int page = offsetX / scrollView.bounds.size.width + 0.5;
    
    static float newx = 0;
    static float oldIx = 0;
    newx= scrollView.contentOffset.x ;
    if (newx != oldIx ) {
        //Left-YES,Right-NO
        if (newx > oldIx) {
            self.scrollLeftOrRight = NO;
        }else if(newx < oldIx){
            self.scrollLeftOrRight = YES;
        }
        oldIx = newx;
    }
    
#pragma mark --- 此处写动画
    if (offsetX <= ScreenWidth/2) {
        [self firstPage];
    }
    else if (offsetX > ScreenWidth/2 && offsetX <= ScreenWidth+ScreenWidth/2) {
        [self secondPage];
    }
    else if (offsetX > ScreenWidth+ScreenWidth/2 && offsetX <= ScreenWidth*2+ScreenWidth/2) {
        [self thirdPage];
    }
    else if (offsetX > ScreenWidth*2+ScreenWidth/2 && offsetX <= ScreenWidth*3+ScreenWidth/2) {
        [self fourPage];
    }else if(offsetX > ScreenWidth*3+ScreenWidth/2 && offsetX <= ScreenWidth*4+ScreenWidth/2)
    {
        [self lastPage];
    }
    
    
    self.pageControl.currentIndex = page;
}

-(void)firstPage
{
    NSLog(@"1");
    //文字渐渐显示动画
    [UIView animateWithDuration:1 animations:^{
        pageoneImage1.alpha=1;
        pageoneImage2.alpha=1;
        pageoneImage3.alpha=1;
        pageoneImage4.alpha=1;
        pageoneImage5.alpha=1;
        
        pagetwoImage1.alpha=0;
        pagetwoImage2.alpha=0;
        pagetwoImage3.alpha=0;
        
    }];

    
    if(offsetX>ScreenWidth/4)
    {
        pagetwoImage4.alpha=1;
        pagetwoImage5.alpha=1;
    }else{
        pagetwoImage4.alpha=0;
        pagetwoImage5.alpha=0;
    }
    
    pageoneImage5.alpha = (ScreenWidth/2-offsetX)/(ScreenWidth/2);
    pageoneImage4.alpha = (ScreenWidth/2-offsetX)/(ScreenWidth/2);

    
    pagetwoImage4.frame = CGRectMake(offsetX+ScreenWidth*0.65,350-offsetX*0.3, offsetX*0.05, offsetX*0.2);
    pagetwoImage5.frame = CGRectMake(offsetX+ScreenWidth*0.08,350, offsetX*0.8, offsetX*0.3);

}

-(void)secondPage
{
    NSLog(@"2");
    pagethreeImage4.alpha=0;
    pagethreeImage5.alpha=0;
    pagetwoImage4.alpha=1;
    
    //文字渐渐显示动画
    [UIView animateWithDuration:1 animations:^{
        pageoneImage1.alpha=0;
        pageoneImage2.alpha=0;
        pageoneImage3.alpha=0;
        pageoneImage4.alpha=0;
        pageoneImage5.alpha=0;
        
        
        pagetwoImage1.alpha=1;
        pagetwoImage2.alpha=1;
        pagetwoImage3.alpha=1;
        
        pagethreeImage1.alpha=0;
        pagethreeImage2.alpha=0;
        pagethreeImage3.alpha=0;
        
    }];
    
    if(offsetX>ScreenWidth)
    {
        pagetwoImage4.frame = CGRectMake(pagetwoImage4.frame.origin.x,237.5+offsetX*0.01, (offsetX-ScreenWidth)+ScreenWidth*0.2, (offsetX-ScreenWidth)+ScreenWidth*0.18);
        
    }else{
        float offsetY;
        if (DEVICE_IS_IPHONE5) {
            offsetY = 335-offsetX*0.3;
        }else if (DEVICE_IS_IPHONE6S){
            offsetY = 350-offsetX*0.3;
        }else{
            offsetY = 365-offsetX*0.3;
        }
        if(offsetX==ScreenWidth)
        {
            //pagetwoImage4.frame = CGRectMake(offsetX+ScreenWidth*0.65,offsetY, offsetX*0.05, offsetX*0.2);
        }else{
            pagetwoImage4.frame = CGRectMake(offsetX+ScreenWidth*0.65,offsetY, offsetX*0.05, offsetX*0.2);
        }
        
        pagetwoImage5.frame = CGRectMake(offsetX+ScreenWidth*0.08,350, offsetX*0.8, offsetX*0.3);
    }

    
}

-(void)thirdPage
{
    
    NSLog(@"3");
    pagethreeImage4.alpha=1;
    pagethreeImage5.alpha=1;
    
    //文字渐渐显示动画
    [UIView animateWithDuration:1 animations:^{
        pagethreeImage1.alpha=1;
        pagethreeImage2.alpha=1;
        pagethreeImage3.alpha=1;
        
        pagetwoImage1.alpha=0;
        pagetwoImage2.alpha=0;
        pagetwoImage3.alpha=0;
        
//        pagetwoImage5.alpha=0;
        
        pagefourImage1.alpha=0;
        pagefourImage2.alpha=0;
        pagefourImage3.alpha=0;
    }];
    

    if(offsetX<=ScreenWidth*9/4)
    {
        pagetwoImage4.frame = CGRectMake(pagetwoImage4.frame.origin.x,237.5+offsetX*0.01, (offsetX-ScreenWidth)+ScreenWidth*0.188, (offsetX-ScreenWidth)+ScreenWidth*0.161333);
        
        [UIView animateWithDuration:0.05 animations:^{
            pagetwoImage4.alpha=0;
        }];
        
    }
    
    
    if(offsetX==2*ScreenWidth)
    {
        
//        pagethreeImage4.frame = CGRectMake((offsetX)+35,300, ScreenWidth*0.92266, ScreenWidth*0.610);
//        if (DEVICE_IS_IPHONE5) {
//             pagethreeImage5.frame = CGRectMake((offsetX)+35,250, ScreenWidth*0.596, ScreenWidth*0.864);
//        }else{
//            pagethreeImage5.frame = CGRectMake((offsetX)+35,260, ScreenWidth*0.596, ScreenWidth*0.864);
//        }
       
    }else if(offsetX>2*ScreenWidth){
        pagethreeImage4.frame = CGRectMake((2*ScreenWidth+20)-(offsetX-9*ScreenWidth/4)*1.65,300+(offsetX-2*ScreenWidth), ScreenWidth*0.22377, ScreenWidth*0.610);
        
        
        if (DEVICE_IS_IPHONE5) {
            pagethreeImage5.frame = CGRectMake((2*ScreenWidth+20)+(offsetX-2*ScreenWidth)*1.5,250,ScreenWidth*0.596, ScreenWidth*0.864);
        }else{
            pagethreeImage5.frame = CGRectMake((2*ScreenWidth+20)+(offsetX-2*ScreenWidth)*1.5,260,ScreenWidth*0.596, ScreenWidth*0.864);
        }
        
        if(DEVICE_IS_IPHONE5)
        {
             pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),250, ScreenWidth*0.596, ScreenWidth*0.864);
        }else{
            pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),260, ScreenWidth*0.596, ScreenWidth*0.864);
        }
        
       
        
        pagethreeImage6.alpha=(offsetX-2*ScreenWidth)/(2*ScreenWidth);

    }else{
        if (!self.scrollLeftOrRight) {
            
            if(DEVICE_IS_IPHONE5)
            {
                pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),250, ScreenWidth*0.596, ScreenWidth*0.864);
            }else{
                pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),260, ScreenWidth*0.596, ScreenWidth*0.864);
            }
            
            
            
            pagethreeImage6.alpha=(offsetX-2*ScreenWidth)/(2*ScreenWidth);
            
            
            if (DEVICE_IS_IPHONE5) {
                pagethreeImage5.frame = CGRectMake((offsetX)+35,250, ScreenWidth*0.596, ScreenWidth*0.864);
                pagethreeImage4.frame = CGRectMake((offsetX)+140,300,ScreenWidth*0.22377, ScreenWidth*0.610);
            }else{
                pagethreeImage5.frame = CGRectMake((offsetX)+35,260, ScreenWidth*0.596, ScreenWidth*0.864);
                pagethreeImage4.frame = CGRectMake((offsetX)+140,300,ScreenWidth*0.22377, ScreenWidth*0.610);
            }
            
        }else{
            
        }
    }
    
    
}

-(void)fourPage
{
    pagethreeImage4.alpha=0;
    _pageControl.alpha=1;
    
    
    //文字渐渐显示动画
    [UIView animateWithDuration:1 animations:^{
        pagethreeImage1.alpha=0;
        pagethreeImage2.alpha=0;
        pagethreeImage3.alpha=0;
        pagethreeImage5.alpha=0;
        
        pagethreeImage6.alpha=1;
        pagefourImage1.alpha=1;
        pagefourImage2.alpha=1;
        pagefourImage3.alpha=1;
        
        
    }];
    
    if(DEVICE_IS_IPHONE5)
    {
     pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),250, ScreenWidth*0.596, ScreenWidth*0.864);
    }else{
        pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),260, ScreenWidth*0.596, ScreenWidth*0.864);
    }
    if(offsetX<ScreenWidth*13/4){
        if(!self.scrollLeftOrRight)
        {
            pagethreeImage4.frame = CGRectMake((2*ScreenWidth+20)-(offsetX-2*ScreenWidth)/18,290+(offsetX-2*ScreenWidth), 346, 229);
            
            
            if(DEVICE_IS_IPHONE5)
            {
                pagethreeImage5.frame = CGRectMake((2*ScreenWidth+15)+(offsetX-2*ScreenWidth)*2,250, 223.5, 324);
            }else{
                pagethreeImage5.frame = CGRectMake((2*ScreenWidth+15)+(offsetX-2*ScreenWidth)*2,260, 223.5, 324);
            }
        }
    }
    
}

-(void)lastPage
{
    NSLog(@"5");
    //禁止滚动
    [_scrollView setScrollEnabled:NO];
    //文字渐渐显示动画
    [UIView animateWithDuration:1 animations:^{
        
        _pageControl.alpha=0;
    }];
    
    if(DEVICE_IS_IPHONE5)
    {
        pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),250, ScreenWidth*0.596, ScreenWidth*0.864);
    }else{
        pagethreeImage6.frame = CGRectMake(ScreenWidth*0.18666+(offsetX),260, ScreenWidth*0.596, ScreenWidth*0.864);
    }
    
    
    
    
    if(!isLastPage){
        [self doImagesAnimation];
        isLastPage=YES;
    }
    
    
}

#pragma mark --- UIImageView显示gif动画
- (void)tomAnimationWithName:(NSString *)name count:(NSInteger)count
{
    
    // 如果正在动画，直接退出
    if ([imgView isAnimating]) return;
    // 动画图片的数组
    NSMutableArray *arrayM = [NSMutableArray array];
    // 添加动画播放的图片
    for (int i = 0; i < count; i++) {
        // 图像名称
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", name, i+1];
        // ContentsOfFile需要全路径
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [arrayM addObject:image];
    }
    // 设置动画数组
    imgView.animationImages = arrayM;
    // 重复1次
    imgView.animationRepeatCount = 0;
    // 动画时长
    imgView.animationDuration = imgView.animationImages.count * 0.05;
    // 开始动画
    [imgView startAnimating];
}

#pragma mark --- 旋转动画
- (void)rotate360DegreeWithImageView:(UIImageView *)imageView
{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //围绕Z轴旋转，垂直与屏幕
    animation.toValue = [ NSValue valueWithCATransform3D:
                         CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    animation.duration = 5;
    //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width, imageView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [imageView.image drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageView.layer addAnimation:animation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
