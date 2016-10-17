//
//  YLFamousTopModel.h
//  hdcy
//
//  Created by mac on 16/10/17.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YLFamousTopModel : JSONModel
@property (nonatomic,copy)NSString <Optional>*Id;
@property (nonatomic,copy)NSString <Optional>*headimgurl;
@property (nonatomic,copy)NSString <Optional>*intro;
@property (nonatomic,copy)NSString <Optional>*level;
@property (nonatomic,copy)NSString <Optional>*nickname;
@property (nonatomic,assign)NSNumber *participationCount;
@property (nonatomic,copy)NSString <Optional>*status;
@property (nonatomic,copy)NSString <Optional>*tags;
@property (nonatomic,assign)BOOL top;
@property (nonatomic,copy)NSString <Optional>*topImage;
@property (nonatomic,copy)NSString <Optional>*topIndex;
@property (nonatomic,copy)NSString <Optional>*userId;
@end
