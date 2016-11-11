//
//  YLCommentView.m
//  hdcy
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLCommentView.h"
#import "MLLinkLabel.h"
#import "YLCommentTableViewCell.h"
#import "YLCommentModel.h"
@interface YLCommentView()<MLLinkLabelDelegate>
@property (nonatomic, strong) NSMutableArray *commentLabelsArray;
@property (nonatomic, strong) NSArray *commentItemsArray;
@property (nonatomic, strong) UIImageView *bgImageView;
@end
@implementation YLCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews
{
    _bgImageView = [UIImageView new];
    UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _bgImageView.image = bgImage;
    _bgImageView.backgroundColor = [UIColor clearColor];
    [self addSubview:_bgImageView];
    
    _bgImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
}

- (void)setCommentItemsArray:(NSArray *)commentItemsArray
{
    _commentItemsArray = commentItemsArray;
    
    long originalLabelsCount = self.commentLabelsArray.count;
    long needsToAddCount = commentItemsArray.count > originalLabelsCount ? (commentItemsArray.count - originalLabelsCount) : 0;
    for (int i = 0; i < needsToAddCount; i++) {
        MLLinkLabel *label = [MLLinkLabel new];

        UIColor *highLightColor = [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0];
        label.linkTextAttributes = @{NSForegroundColorAttributeName : highLightColor};
        label.font = [UIFont systemFontOfSize:12];
        label.tag=i+99;
        label.delegate=self;
        [self addSubview:label];
        [self.commentLabelsArray addObject:label];
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labelClick:)];
        [label addGestureRecognizer:tap];
    }
    
    for (int i = 0; i < commentItemsArray.count; i++) {
        YLCommentReplyModel *model = [[YLCommentReplyModel alloc]initWithDictionary:commentItemsArray[i] error:nil];
        MLLinkLabel *label = self.commentLabelsArray[i];
        if (!model.attributedContent) {
            model.attributedContent = [self generateAttributedStringWithCommentItemModel:model];
        }
        label.attributedText = model.attributedContent;
    }
}


-(void)labelClick:(UITapGestureRecognizer *)tap
{
    [_delegate clickLableWithIndex:tap.view.tag];
}

#pragma mark - private actions

- (NSMutableAttributedString *)generateAttributedStringWithCommentItemModel:(YLCommentReplyModel *)model
{
    NSString *text = model.createrName;
    if (model.replyToName.length) {
        text = [text stringByAppendingString:[NSString stringWithFormat:@"回复%@", model.replyToName]];
    }
    text = [text stringByAppendingString:[NSString stringWithFormat:@"：%@", model.content]];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
    [attString setAttributes:@{NSLinkAttributeName : model.createrName} range:[text rangeOfString:model.createrName]];
    if (model.replyToName) {
        [attString setAttributes:@{NSLinkAttributeName : model.replyToName} range:[text rangeOfString:model.replyToName]];
    }
    return attString;
}


- (void)setupcommentItemsArray:(NSArray *)commentItemsArray
{
    self.commentItemsArray = commentItemsArray;
    
    if (self.commentLabelsArray.count) {
        [self.commentLabelsArray enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
            [label sd_clearAutoLayoutSettings];
            label.hidden = YES; //重用时先隐藏所以评论label，然后根据评论个数显示label
        }];
    }
    
     UIView *lastTopView = nil;
    
    if (!commentItemsArray.count) {
        self.fixedWidth = @(0); // 如果没有评论，设置commentview的固定宽度为0（设置了fixedWith的控件将不再在自动布局过程中调整宽度）
        self.fixedHeight = @(0); // 如果没有评论，设置commentview的固定高度为0（设置了fixedHeight的控件将不再在自动布局过程中调整高度）
        return;
    } else {
        self.fixedHeight = nil; // 取消固定宽度约束
        self.fixedWidth = nil; // 取消固定高度约束
        
        for (int i = 0; i < self.commentItemsArray.count; i++) {
            UILabel *label = (UILabel *)self.commentLabelsArray[i];
            label.hidden = NO;
            CGFloat topMargin = (i == 0) ? 10 : 5;
            label.sd_layout
            .leftSpaceToView(self, 8)
            .rightSpaceToView(self, 5)
            .topSpaceToView(lastTopView, topMargin)
            .autoHeightRatio(0);
            
            label.isAttributedContent = YES;
            lastTopView = label;
        }
        
    }
    
 
    [self setupAutoHeightWithBottomView:lastTopView bottomMargin:6];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

#pragma mark - MLLinkLabelDelegate

- (void)didClickLink:(MLLink *)link linkText:(NSString *)linkText linkLabel:(MLLinkLabel *)linkLabel
{
    NSLog(@"%@", link.linkValue);
    
}

- (NSMutableArray *)commentLabelsArray
{
    if (!_commentLabelsArray) {
        _commentLabelsArray = [NSMutableArray new];
    }
    return _commentLabelsArray;
}

@end
