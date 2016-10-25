//
//  YLFamousDetailModel.h
//  hdcy
//
//  Created by mac on 16/10/24.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface YLFamousDetailModel : JSONModel
@property (nonatomic,copy)NSString <Optional>*Id;
@property (nonatomic,copy)NSString <Optional>*image;
@property (nonatomic,copy)NSString <Optional>*intro;
@property (nonatomic,copy)NSString <Optional>*level;
@property (nonatomic,copy)NSString <Optional>*name;
@property (nonatomic,copy)NSString <Optional>*status;
@property (nonatomic,copy)NSString <Optional>*slogan;
@property (nonatomic,copy)NSString <Optional>*tags;
@property (nonatomic,assign)BOOL top;
@property (nonatomic,copy)NSString <Optional>*topImage;
@property (nonatomic,copy)NSString <Optional>*topIndex;
@property (nonatomic,copy)NSString <Optional>*userId;
@property (nonatomic,copy)NSString <Optional>*organ;
@property (nonatomic,assign)BOOL enable;
@end
