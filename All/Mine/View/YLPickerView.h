//
//  YLPickerView.h
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol datePickerDidPickDelegate <NSObject>
-(void)dateConfirmWithDate:(NSString *)date;
-(void)dismissVC;
@end
@interface YLPickerView : UIView
@property (nonatomic,assign)id<datePickerDidPickDelegate>delegate;
@end
