//
//  YLVideoListModel.h
//  hdcy
//
//  Created by Nemo on 16/9/16.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface YLVideoListModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *liveState;
@property (nonatomic, strong) NSString<Optional> *streamId;
@property (nonatomic, strong) NSString<Optional> *image;
@property (nonatomic, strong) NSString<Optional> *length;
@property (nonatomic, strong) NSString<Optional> *name;
@property (nonatomic, strong) NSString<Optional> *url;
@property (nonatomic, strong) NSString<Optional> *url2;
@property (nonatomic, strong) NSString<Optional> *desc;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSString<Optional> *id;
@property (nonatomic, strong) NSNumber *live;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger viewCountPlus;
@property (nonatomic, assign)NSTimeInterval endTime;
@property (nonatomic,copy)NSString <Optional>*sponsorId;
@property (nonatomic,copy)NSString <Optional>*sponsorName;
@property (nonatomic,copy)NSString <Optional>*sponsorImage;
@end
