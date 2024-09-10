//
//  KaiShiJiShiViewController.h
//  daojishi
//
//  Created by 北城 on 2018/9/13.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaoJiShiModel.h"
@interface KaiShiJiShiViewController : UIViewController

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;

@property (nonatomic,strong) CAGradientLayer * gradientLayer;
@property (nonatomic,strong)CALayer *subLayer;

@property (nonatomic,strong)LZDataModel *model;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong)NSTimer*countDownTimer;

@property (nonatomic,assign)NSInteger secondsCountDown;
@property (nonatomic,strong)UILocalNotification *localNotification;

@property (nonatomic,assign)BOOL isPushlocalNotification;


@property (nonatomic,copy)NSString *isFromAppDelegate;

@end
