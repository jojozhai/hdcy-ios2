//
//  YLRegisterMessage.m
//  hdcy
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLRegisterMessage.h"

@implementation YLRegisterMessage
@synthesize username=_username;
@synthesize password=_password;
@synthesize sex=_sex;
@synthesize city=_city;
@synthesize nickname=_nickname;
+(YLRegisterMessage *)sharedRegisterMessage
{
    static YLRegisterMessage *_register=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _register=[[self alloc]init];
    });
    return _register;
}














@end
