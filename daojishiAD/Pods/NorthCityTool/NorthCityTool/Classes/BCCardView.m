//
//  BCCardView.m
//  northcitytools
//
//  Created by 北城 on 2018/12/14.
//  Copyright © 2018年 com.beicheng1. All rights reserved.
//

#import "BCCardView.h"

@interface BCCardView()
//名片背景视图
@property(nonatomic, strong) UIView *cardBgView;
//渐变背景渲染
@property(nonatomic, strong) CAGradientLayer *bgGradientLayer;
//背景阴影
@property(nonatomic, strong) CALayer *bgSubLayer;
//头像
@property(nonatomic, strong) UIImageView *touXiangImageView;
//签名
@property(nonatomic, strong) UILabel *qianMingLabel;
//签名介绍
@property(nonatomic, strong) UILabel *qianMingELabel;
//姓名
@property(nonatomic, strong) UILabel *nameLabel;
//介绍自己
@property(nonatomic, strong) UILabel *jieShaoLabel ;
//邮箱
@property(nonatomic, strong) UILabel *youXianglLabel;
//博客
@property(nonatomic, strong) UILabel *blogLabel;
//博客
@property(nonatomic, strong) UILabel *weChatLabel;
//博客
@property(nonatomic, strong) UILabel *phoneLabel;
//进博客小按钮
@property(nonatomic, strong) UIButton *blogButton;
@end

@implementation BCCardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews{
    //    名片背景
    _cardBgView = [[UIView alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(65), ScreenWidth - NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(200))];
    _cardBgView.layer.cornerRadius= NC_kAUTOWIDTH(8);
    _cardBgView.layer.shadowColor=[UIColor grayColor].CGColor;
    _cardBgView.layer.shadowRadius=8;
    _cardBgView.layer.masksToBounds = YES;
    [self addSubview:_cardBgView];
    if (PNCisIPHONEX) {
        _cardBgView.frame = CGRectMake(NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(74), ScreenWidth - NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(200));
    }
    //    背景渐变色渲染
    _bgGradientLayer = [CAGradientLayer layer];
    _bgGradientLayer.frame = CGRectMake(0, 0, ScreenWidth, NC_kAUTOWIDTH(200));
    _bgGradientLayer.colors =  @[(id)NC_PNCColor(28, 148, 251).CGColor, (id)NC_PNCColor(105, 208, 253).CGColor];
    //      @[(id)NC_PNCColor(230, 0,  0).CGColor, (id)NC_PNCColor(230, 0, 0).CGColor];
    _bgGradientLayer.locations = @[@(0),@(1)];
    _bgGradientLayer.startPoint = CGPointMake(0, 0.2);
    _bgGradientLayer.endPoint = CGPointMake(1, 0.8);
    [_cardBgView.layer addSublayer:_bgGradientLayer];

    _bgSubLayer=[CALayer layer];
    CGRect fixBgframe=CGRectMake(NC_kAUTOWIDTH(30),CGRectGetMaxY(_cardBgView.frame) - NC_kAUTOWIDTH(30), ScreenWidth - NC_kAUTOWIDTH(60), NC_kAUTOWIDTH(30));
    //    _cardBgView.layer.frame;
    _bgSubLayer.frame = fixBgframe;
    _bgSubLayer.cornerRadius = 9;
    _bgSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _bgSubLayer.masksToBounds=NO;
    _bgSubLayer.shadowColor=[UIColor blueColor].CGColor;
    _bgSubLayer.shadowOffset=CGSizeMake(0,4);
    _bgSubLayer.shadowOpacity=0.6f;
    _bgSubLayer.shadowRadius= 10;
    [self.layer insertSublayer:_bgSubLayer below:_cardBgView.layer];

    _touXiangImageView = [[UIImageView alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(84), NC_kAUTOWIDTH(50), NC_kAUTOWIDTH(50))];
    [self addSubview:_touXiangImageView];
    _touXiangImageView.layer.cornerRadius = NC_kAUTOWIDTH(25);
    _touXiangImageView.image = [UIImage imageNamed:@"northcityBundle.bundle/authorImage"];
    _touXiangImageView.layer.borderWidth = 3.f;
    _touXiangImageView.contentMode = UIViewContentModeScaleAspectFill;
    _touXiangImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _touXiangImageView.layer.masksToBounds = YES;

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_touXiangImageView.frame) + NC_kAUTOWIDTH(30),NC_kAUTOWIDTH(84),NC_kAUTOWIDTH(150),NC_kAUTOWIDTH(30))];
    _nameLabel.text = @"北城以北";
    _nameLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.textColor = [UIColor whiteColor];
    [self addSubview:_nameLabel];

    if (PNCisIPHONEX) {
        _touXiangImageView.frame = CGRectMake(NC_kAUTOWIDTH(30), 106, NC_kAUTOWIDTH(50), NC_kAUTOWIDTH(50));
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_touXiangImageView.frame) + NC_kAUTOWIDTH(30),106,NC_kAUTOWIDTH(150),NC_kAUTOWIDTH(30));

    }

    if (PNCisIPAD) {
        _touXiangImageView.frame = CGRectMake(NC_kAUTOWIDTH(30),NC_kAUTOWIDTH(106), NC_kAUTOWIDTH(50), NC_kAUTOWIDTH(50));
        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_touXiangImageView.frame) + NC_kAUTOWIDTH(30),NC_kAUTOWIDTH(106),NC_kAUTOWIDTH(150),NC_kAUTOWIDTH(30));
    }

    _jieShaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_touXiangImageView.frame) + NC_kAUTOWIDTH(30), CGRectGetMaxY(_nameLabel.frame), NC_kAUTOWIDTH(150), NC_kAUTOWIDTH(20))];
    _jieShaoLabel.text = @"独立开发·专注开发精品App";
    _jieShaoLabel.font = [UIFont fontWithName:@"Heiti SC" size:10.f];
    _jieShaoLabel.textAlignment = NSTextAlignmentLeft;
    _jieShaoLabel.textColor = [UIColor whiteColor];
    [self addSubview:_jieShaoLabel];

    _youXianglLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(30), CGRectGetMaxY(_touXiangImageView.frame) + NC_kAUTOWIDTH(25), NC_kAUTOWIDTH(150), NC_kAUTOWIDTH(28))];
    _youXianglLabel.text = @"EMAIL : northcitytime@sina.com";
    _youXianglLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.f];
    _youXianglLabel.textAlignment = NSTextAlignmentRight;
    _youXianglLabel.textColor = [UIColor whiteColor];
    [_youXianglLabel sizeToFit];
    [self addSubview:_youXianglLabel];

    _blogLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(30), CGRectGetMaxY(_youXianglLabel.frame), NC_kAUTOWIDTH(150), NC_kAUTOWIDTH(28))];
    _blogLabel.text = @"BLOG : www.northcity.top";
    _blogLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.f];
    _blogLabel.textAlignment = NSTextAlignmentRight;
    _blogLabel.textColor = [UIColor whiteColor];
    [_blogLabel sizeToFit];
    [self addSubview:_blogLabel];

    _weChatLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(30), CGRectGetMaxY(_blogLabel.frame), NC_kAUTOWIDTH(150), NC_kAUTOWIDTH(28))];
    _weChatLabel.text = @"WECHAT : shine5211314";
    _weChatLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.f];
    _weChatLabel.textAlignment = NSTextAlignmentRight;
    _weChatLabel.textColor = [UIColor whiteColor];
    [_weChatLabel sizeToFit];
    [self addSubview:_weChatLabel];

    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(30), CGRectGetMaxY(_weChatLabel.frame), NC_kAUTOWIDTH(150), NC_kAUTOWIDTH(28))];
    _phoneLabel.text = @"PHONE : +8613203871661";
    _phoneLabel.font = [UIFont fontWithName:@"Avenir Next" size:10.f];
    _phoneLabel.textAlignment = NSTextAlignmentRight;
    _phoneLabel.textColor = [UIColor whiteColor];
    [_phoneLabel sizeToFit];
    [self addSubview:_phoneLabel];

    _qianMingLabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(10), CGRectGetMinY(_youXianglLabel.frame)+ NC_kAUTOWIDTH(10),self.frame.size.width - NC_kAUTOWIDTH(60), NC_kAUTOWIDTH(26))];
    _qianMingLabel.text = @"“希望，世界和平。” ";
    _qianMingLabel.textAlignment = NSTextAlignmentRight;
    _qianMingLabel.textColor = [UIColor whiteColor];
    _qianMingLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:16];
    [self addSubview:_qianMingLabel];

    _qianMingELabel = [[UILabel alloc]initWithFrame:CGRectMake(NC_kAUTOWIDTH(10), CGRectGetMaxY(_qianMingLabel.frame) , self.frame.size.width - NC_kAUTOWIDTH(60), NC_kAUTOWIDTH(18))];
    _qianMingELabel.text = @"I hope,the peace of the world.";
    _qianMingELabel.textAlignment = NSTextAlignmentRight;
    _qianMingELabel.textColor = [UIColor whiteColor];
    _qianMingELabel.font = [UIFont fontWithName:@"Avenir-Medium" size:10];
    [self addSubview:_qianMingELabel];

    _blogButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _blogButton.frame = CGRectMake(CGRectGetMaxX(_blogLabel.frame) + NC_kAUTOWIDTH(2), CGRectGetMaxY(_youXianglLabel.frame) + (_blogLabel.frame.size.height - NC_kAUTOWIDTH(10))/2, NC_kAUTOWIDTH(10), NC_kAUTOWIDTH(10));
    UIImage *image = [UIImage imageNamed:@"northcityBundle.bundle/bloglink"];
    [_blogButton addTarget:self action:@selector(blogButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    [_blogButton setImage:image forState:UIControlStateNormal];
    [self addSubview:_blogButton];
}

- (void)blogButtonClickAction{
    if (_blogButtonClickBlock) {
        _blogButtonClickBlock();
    }
}


@end
