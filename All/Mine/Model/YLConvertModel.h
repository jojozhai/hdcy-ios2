//
//  YLConvertModel.h
//  hdcy
//
//  Created by mac on 16/9/11.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "JSONModel.h"

@interface YLConvertModel : JSONModel
@property (nonatomic,copy)NSString<Optional> *Id;
@property (nonatomic,copy)NSString<Optional> *name;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,copy)NSString<Optional> *point;
@property (nonatomic,copy)NSString<Optional> *stock;
@property (nonatomic,copy)NSString<Optional> *used;
@property (nonatomic,copy)NSString<Optional> *desc;
@property (nonatomic,copy)NSString<Optional> *brandImage;
@property (nonatomic,copy)NSString<Optional> *beans;
@property (nonatomic,copy)NSString<Optional> *image;
@property (nonatomic,copy)NSString<Optional> *brand;
@property (nonatomic,copy)NSString<Optional> *brandDesc;
@end
