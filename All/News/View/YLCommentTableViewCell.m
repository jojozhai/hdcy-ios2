//
//  YLCommentTableViewCell.m
//  hdcy
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 haoduocheyou.cn. All rights reserved.
//

#import "YLCommentTableViewCell.h"
CGFloat maxContentLabelHeight = 0; // 根据具体font而定
#import "YLCommentView.h"
#import "YLButton.h"
@interface YLCommentTableViewCell()<clickLableWithIndexDelegate>
{
    YLCommentView *_commentReplyView;
    UIView *_moreView;
    YLButton *_moreButton;
}
@end
@implementation YLCommentTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor clearColor];
        _userHeaderImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 30, 30)];
        _userHeaderImage.layer.cornerRadius=15;
        _userHeaderImage.layer.masksToBounds=YES;
        [self.contentView addSubview:_userHeaderImage];
        
        _userNameLbl=[[UILabel alloc]initWithFrame:CGRectMake(59, 5, SCREEN_WIDTH-150, 17)];
        _userNameLbl.font=[UIFont systemFontOfSize:14];
        _userNameLbl.textColor=RGBCOLOR(101, 147, 197);
        [self.contentView addSubview:_userNameLbl];
        
        _timeLable=[[UILabel alloc]initWithFrame:CGRectMake(59, 22, SCREEN_WIDTH-150, 15)];
        _timeLable.font=[UIFont systemFontOfSize:10];
        _timeLable.textColor=[UIColor grayColor];
        [self.contentView addSubview:_timeLable];
        
        _praiseButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _praiseButton.frame=CGRectMake(SCREEN_WIDTH-100, 10, 88, 20);
        [_praiseButton setImage:[UIImage imageNamed:@"content-icon-zambia-default"] forState:UIControlStateNormal];
        [_praiseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_praiseButton];
//    评论label
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        if (maxContentLabelHeight == 0) {
            maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
        }
//     回复view
        _commentReplyView = [YLCommentView new];
        _commentReplyView.delegate=self;
        [self.contentView addSubview:_commentReplyView];

        
        CGFloat margin = 10;
        
        _contentLabel.sd_layout
        .leftEqualToView(_userNameLbl)
        .topSpaceToView(_timeLable, margin)
        .rightSpaceToView(self.contentView, margin)
        .autoHeightRatio(0);
        
        
        _commentReplyView.sd_layout
        .leftEqualToView(_contentLabel)
        .rightSpaceToView(self.contentView, margin)
        .topSpaceToView(_contentLabel, margin); // 已经在内部实现高度自适应所以不需要再设置高度
        
     
 
    }
    return self;
}

-(void)tapaction
{
    [_mDelegate refreshUIWithIndexPath:self.indexPath];
}

-(void)setModel:(YLCommentModel *)model
{
    
    _model=model;
    [_commentReplyView setupcommentItemsArray:model.replys];
    [_userHeaderImage sd_setImageWithURL:[NSURL URLWithString:model.createrHeadimgurl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRefreshCached];
    _timeLable.text=[YLGetTime getTimeWithSice1970TimeString:model.createdTime];
    _contentLabel.text=model.content;
    _userNameLbl.text=model.createrName;
    [_praiseButton setTitle:model.praiseCount forState:UIControlStateNormal];
    
    if (model.replys.count>=2) {
        //      更多view
        _moreView=[UIView new];
        [self.contentView addSubview:_moreView];
        _moreView.sd_layout
        .leftEqualToView(_contentLabel)
        .rightSpaceToView(self.contentView,10)
        .heightIs(13)
        .topSpaceToView(_commentReplyView,10);
        
        //添加更多按钮
        _moreButton=[YLButton buttonWithType:UIButtonTypeCustom];
        [_moreButton customButtonWithFrame:CGRectMake(0, 0, 96, 13) title:@"查看更多回复" rightImage: [UIImage imageNamed:@"content-icon-open-right"]];
        _moreButton.titleLabel.font=[UIFont systemFontOfSize:12];
        [_moreButton addTarget:self action:@selector(tapaction) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_moreView addSubview:_moreButton];
        

    }
    
    UIView *bottomView;
     if (model.replys.count==0) {
        bottomView = _contentLabel;
        //_moreView.hidden=YES;
    } else {
        if (!_moreView) {
            bottomView=_commentReplyView;
        }else{
            bottomView = _moreView;
        }
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];

}

-(void)clickLableWithIndex:(NSInteger)index
{
    [_delegate clickLabelWithIndexPath:self.indexPath Index:index];
}


-(void)setIsOpen:(BOOL)isOpen
{
    _isOpen=isOpen;
}


@end
