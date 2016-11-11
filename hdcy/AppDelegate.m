//
//  AppDelegate.m
//  hdcy
//
//  Created by mac on 16/9/25.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "YLMainViewController.h"
#import "YLVideoViewController.h"
#import "YLNewsViewController.h"
#import "YLActivityViewController.h"
#import "YLFamousViewController.h"
#import "YLMineViewController.h"
#import "YLInLetterViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "LoginViewController.h"
#import "ViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor clearColor];
    [self.window makeKeyWindow];
    
    if (![[NSUserDefaults standardUserDefaults]valueForKey:FIRSTLOGGIN]) {
        ViewController *vc=[[ViewController alloc]init];
        self.window.rootViewController=vc;
        [[NSUserDefaults standardUserDefaults]setValue:@(YES) forKey:FIRSTLOGGIN];
    }else{
        
        YLMainViewController *main=[[YLMainViewController alloc]init];
        self.window.rootViewController=main;
        
        YLVideoViewController *video=[[YLVideoViewController alloc]init];
        YLNewsViewController *news=[[YLNewsViewController alloc]init];
        news.topHeight=40;
        news.selectedButtonColor=[UIColor whiteColor];
        news.topBackgroudColor=RGBCOLOR(143, 175, 202);
        YLActivityViewController *activity=[[YLActivityViewController alloc]init];
        YLFamousViewController *famous=[[YLFamousViewController alloc]init];
        
        video.title=@"视频";
        news.title=@"资讯";
        activity.title=@"活动";
        famous.title=@"大咖";
        main.viewControllers=@[video,news,activity,famous];
        main.topHeight=50;
        main.selectedButtonColor=RGBCOLOR(0, 254, 252);
        
        YLMineViewController *mine=[[YLMineViewController alloc]init];
        main.mineVC=mine;
        YLInLetterViewController *inletter=[[YLInLetterViewController alloc]init];
        main.inletterVC=inletter;
        
    }
    [UMSocialData setAppKey:UmengAppID];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    [UMSocialWechatHandler setWXAppId:WeChatAppID appSecret:WeChatAppSecret url:nil];
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

/**
 *  异常捕获
 *  程序出现异常，将会跳转到用户手机邮件界面用于向我们提交问题
 *  @param exception 异常
 */
void UncaughtExceptionHandler(NSException *exception){
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    NSString *crashLogInfo = [NSString stringWithFormat:@"exception type : %@ \n crash reason : %@ \n call stack info : %@", name, reason, arr];
    NSString *username = [[NSUserDefaults standardUserDefaults]valueForKey:USERNAME_REMBER];
    //发送的详情
    NSString *postInfo = [NSString stringWithFormat:@"iOS异常报告--Time:%@\n用户详情:%@\n错误详情:\n%@",[YLGetTime getYYMMDDWithDate2:[NSDate date]],username,crashLogInfo];
    logdebug(@"%@",postInfo);
    logdebug(@"保存bug%d",
             [postInfo writeToFile:BUGLOG_PATH atomically:YES encoding:NSUTF8StringEncoding error:nil]);
    //发邮件
    NSString *urlStr = [NSString stringWithFormat:@"mailto://2712906839@qq.com?subject=提交异常报告&body=感谢您的配合!\n%@",postInfo];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
