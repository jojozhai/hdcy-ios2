//
//  YLPickerView.m
//  hdcy
//
//  Created by mac on 16/10/30.
//  Copyright © 2016年 youngliu.cn. All rights reserved.
//

#import "YLPickerView.h"
@interface YLPickerView ()
{
    UIDatePicker *_datePicker;
}
@end
@implementation YLPickerView

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        [self cusDatePicker];
    }
    return self;
}

-(void)cusDatePicker
{
    UIView *topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 42)];
    [self addSubview:topView];
    
    UIButton *dismissButon=[UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButon setTitle:@"取消" forState:UIControlStateNormal];
    [dismissButon setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    dismissButon.frame=CGRectMake(27*SCREEN_MUTI, 13*SCREEN_MUTI, 40, 16);
    [dismissButon addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:dismissButon];
    
    UIButton *confirmButon=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmButon setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmButon.frame=CGRectMake(305*SCREEN_MUTI, 13*SCREEN_MUTI, 40, 16);
    [confirmButon addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:confirmButon];
    
    //日期选择器
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.frame = CGRectMake(0, 42, self.frame.size.width, 212);
    _datePicker.backgroundColor = [UIColor clearColor];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    _datePicker.locale = locale;
    NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
    [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
    NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
    formatter_minDate = nil;
    [_datePicker setMinimumDate:minDate];
    [self addSubview:_datePicker];
}

-(void)dismissAction
{
    [_delegate dismissVC];
}

-(void)confirmAction
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormatter stringFromDate:[_datePicker date]];
    [_delegate dateConfirmWithDate:date];
}

@end
