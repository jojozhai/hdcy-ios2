//
//  EquipmentInFheader.h
//  hdcy
//
//  Created by mac on 16/8/9.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#ifndef EquipmentInFheader_h
#define EquipmentInFheader_h


#define   IsIOS7  ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0)
#define   IsIOS8  ([[UIDevice currentDevice] systemVersion].floatValue >= 8.0)
#define   IS_CH_SYMBOL(chr) ((int)(chr)>127)
#if DEBUG
#define logtrace() NSLog(@"%s():%d ", __func__, __LINE__)
#define logdebug(format, ...) NSLog(@"%s():%d " format, __func__, __LINE__, ##__VA_ARGS__)
#else
#define logdebug(format, ...)
#define logtrace()
#endif

#define Window_Height [[UIScreen mainScreen] bounds].size.height
#define Window_Width [[UIScreen mainScreen] bounds].size.width

//网络
//static NSString *URL= @"http://app.haoduocheyou.com/app2";
static NSString *URL= @"http://dev.haoduocheyou.com/app2";
//定义屏幕的宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width<[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)
//定义屏幕的高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height)

#define SCREEN_MUTI  (SCREEN_WIDTH/375)
//判断是否是Pad
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//字体
#define FONT_SYS_BIG [UIFont systemFontOfSize:18]
#define FONT_SYS_NORMAL [UIFont systemFontOfSize:14]
#define FONT_SYS_TITTLE [UIFont boldSystemFontOfSize:16]
#define FONT_SYS_HEADTITLE [UIFont systemFontOfSize:15]
#define FONT_SYS_DETAIL [UIFont systemFontOfSize:13]
#define FONT_SYS_WARN [UIFont systemFontOfSize:12]
#define FONT_SYS_ANNOTATE [UIFont systemFontOfSize:11]
#define FONT_SYS(x) [UIFont systemFontOfSize:x]
#define FONT_BOLD(x) [UIFont boldSystemFontOfSize:x]
#define FONT_BOLD_BIG [UIFont boldSystemFontOfSize:18]
 
//路径
#define DOC_PATH [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


//bug
#define BUGLOG_TXT @"buglog.txt"
#define BUGLOG_PATH [NSString stringWithFormat:@"%@/%@",DOC_PATH,BUGLOG_TXT]



#define RECT(x,y,w,h) CGRectMake(x, y, w, h)

//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define CCOLOR [UIColor clearColor]
//#define GreenColor [UIColor colorWithRed:30.0/255.0 green:200.0/255.0 blue:0.0 alpha:1]
#define GreenColor [UIColor colorWithRed:0.0/255.0 green:180.0/255.0 blue:127.0/255.0 alpha:1]
#define NameColor [UIColor colorWithRed:104.0/255.0 green:147.0/255.0 blue:197.0/255.0 alpha:1]
#define MainColor [UIColor colorWithRed:253.0/255.0 green:115.0/255.0 blue:0.0/255.0 alpha:1]
#define AditionalColor [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1]
#define BGColor RGBCOLOR(34,63,86)

#define FONT(x) [UIFont systemFontOfSize:x]
#define FONT_SYSTEM(x) [UIFont systemFontOfSize:x]

#define ShowAlertMsg(msg) [[[UIAlertView alloc] initWithTitle:@"温馨提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show]
/**
 *  userName password
 */
#define USERNAME_REMBER @"1"
#define PASSWORD_REMBER @"123456"

//第三方
static NSString *UmengAppID= @"57cf7901e0f55afb1d001250";
static NSString *WeChatAppID=@"wx6619f92e0cc550da";
static NSString *WeChatAppSecret=@"431c26c014b6ea3c4aab0b1d8016b2b9";

#endif /* EquipmentInFheader_h */
