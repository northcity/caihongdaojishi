//
//  DaoJiShiTableViewCell.h
//  daojishi
//
//  Created by 北城 on 2018/9/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoJiShiModel.h"
#import "LZDataModel.h"
//倒计时总的秒数
//static NSInteger  secondsCountDown = 86400;

@interface DaojiShiShouTableViewCell : UITableViewCell

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong) YQMotionShadowView *showLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *countLabel;

@property (nonatomic,strong) CAGradientLayer * gradientLayer;

@property (nonatomic,strong)CALayer *subLayer;

@property (nonatomic,copy)NSString *bgColor1;
@property (nonatomic,copy)NSString *bgColor2;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong)NSTimer*countDownTimer;

- (void)cellSetContentViewWithModel:(LZDataModel *)model;
@end
