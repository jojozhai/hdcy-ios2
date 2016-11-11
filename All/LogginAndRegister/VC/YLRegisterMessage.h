//
//  YLRegisterMessage.h
//  hdcy
//
//  Created by mac on 16/11/4.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLRegisterMessage : NSObject
@property (nonatomic,copy)NSString *username;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)NSString *sex;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *nickname;

+(YLRegisterMessage *)sharedRegisterMessage;
@end
