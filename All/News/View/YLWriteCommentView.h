//
//  YLWriteCommentView.h
//  hdcy
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLWriteCommentView : UIView
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *leastLable;
@property (weak, nonatomic) IBOutlet UILabel *reCommentLabel;

@end
