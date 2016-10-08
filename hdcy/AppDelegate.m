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
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor clearColor];
    [self.window makeKeyWindow];
    
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
   // main.topBackgroudColor=[UIColor blackColor];
    main.topHeight=50;
    main.selectedButtonColor=RGBCOLOR(0, 254, 252);
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    return YES;
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
