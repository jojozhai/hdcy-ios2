//
//  YLLiveVideoModel.h
//  hdcy
//
//  Created by Nemo on 16/9/13.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface YLVideoTopModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *liveState;
//@property (nonatomic, strong) NSString<Ignore> *streamId;
@property (nonatomic, strong) NSString<Optional> *image;
//@property (nonatomic, strong) NSString<Ignore> *length;
@property (nonatomic, strong) NSString<Optional> *name;
//@property (nonatomic, strong) NSString<Ignore> *url;
//@property (nonatomic, strong) NSString<Ignore> *url2;
//@property (nonatomic, strong) NSString<Ignore> *desc;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger enable;
@property (nonatomic, assign) NSString<Optional> *id;
@property (nonatomic, strong) NSNumber *live;
@property (nonatomic, assign) NSString *startTime;
@property (nonatomic, assign) NSInteger top;
@property (nonatomic, assign) NSInteger viewCount;
@property (nonatomic, assign) NSInteger viewCountPlus;
@property (nonatomic, assign) NSString *endTime;
//@property (nonatomic,copy)NSString <Ignore>*sponsorId;
//@property (nonatomic,copy)NSString <Ignore>*sponsorName;
//@property (nonatomic,copy)NSString <Ignore>*sponsorImage;
@end
