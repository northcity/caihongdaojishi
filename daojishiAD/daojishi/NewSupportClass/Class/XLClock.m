//
//  XLClock.m
//  POP集成测试
//
//  Created by MengXianLiang on 2018/5/30.
//  Copyright © 2018年 mxl. All rights reserved.
//

#import "XLClock.h"
#import "XLClockHand.h"
#import "POP.h"

#define MAXTRANFROM 0.4
/**
 *    @brief    RGB颜色.
 */
#define PNCColor(r,g,b) PNCColorRGBA(r,g,b,1.0)

/**
 *    @brief    RGBA颜色.
 */
#define PNCColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/**
 *    @brief    颜色设置(UIColorFromRGB(0xffee00)).
 */
#define PNCColorWithHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define PNCColorWithHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface XLClock ()<POPAnimationDelegate> {
    XLClockHand *_hourHand;
    XLClockHand *_minuteHand;
    XLClockHand *_secondHand;
    UIImageView *_mid;
    
    NSTimer *_timer;
}
@end

@implementation XLClock

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        [self buildTimer];
        [self updateClockHand];
    }
    return self;
}

- (void)buildUI {
    
    //表盘
    UIImageView *clockBack = [[UIImageView alloc] initWithFrame:self.bounds];
    clockBack.contentMode = UIViewContentModeScaleAspectFit;
    clockBack.image = [UIImage imageNamed:@"xl_clock_back"];
    [self addSubview:clockBack];
    
    //12点 3点
    CGFloat hourH = self.bounds.size.width * 0.07;
    CGFloat hourSpace = self.bounds.size.height * 0.2;
    UIImageView *hour12 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xl_clock_hour_12"]];
    hour12.frame = CGRectMake(0, 0, hourH, hourH);
    hour12.center = CGPointMake(self.bounds.size.width/2.0f, hourSpace);
    [self addSubview:hour12];
    
    UIImageView *hour3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xl_clock_hour_3"]];
    hour3.frame = CGRectMake(0, 0, hourH, hourH);
    hour3.center = CGPointMake(self.bounds.size.width - hourSpace, self.bounds.size.height/2.0f);
    [self addSubview:hour3];
    
    CGFloat midHeignt = self.bounds.size.height * 0.15;
    CGFloat hourhandHeight = self.bounds.size.height * 0.44;
    CGFloat minutehandHeight = self.bounds.size.height * 0.59;
    CGFloat secondhandHeight = self.bounds.size.height * 0.65;
    CGPoint handCenter = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    
    //中间原点
    _mid = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, midHeignt, midHeignt)];
    _mid.center = handCenter;
    _mid.contentMode = UIViewContentModeScaleAspectFit;
    _mid.image = [UIImage imageNamed:@"xl_clock_mid"];
    
    //时针
    _hourHand = [[XLClockHand alloc] initWithFrame:CGRectMake(0, 0, hourhandHeight, hourhandHeight)];
    _hourHand.center = handCenter;
    _hourHand.handImage = [UIImage imageNamed:@"xl_clock_hourHand"];
    _hourHand.shadowImage = [UIImage imageNamed:@"xl_clock_hourHand_shadow"];
  
    _hourHand.layer.shadowOffset = CGSizeMake(0, 0);
    _hourHand.layer.shadowColor = [UIColor grayColor].CGColor;
    _hourHand.layer.shadowRadius = 1.5f;
    _hourHand.layer.shadowOpacity = 0.7;
    
    [self addSubview:_hourHand];
    
    //分针
    _minuteHand = [[XLClockHand alloc] initWithFrame:CGRectMake(0, 0, minutehandHeight, minutehandHeight)];
    _minuteHand.center = handCenter;
    _minuteHand.handImage = [UIImage imageNamed:@"xl_clock_minuteHand"];
    _minuteHand.shadowImage = [UIImage imageNamed:@"xl_clock_minuteHand_shadow"];
  
    _minuteHand.layer.shadowOffset = CGSizeMake(0, 0);
    _minuteHand.layer.shadowColor = [UIColor grayColor].CGColor;
    _minuteHand.layer.shadowRadius = 1.5f;
    _minuteHand.layer.shadowOpacity = 0.7;
    
    [self addSubview:_minuteHand];
    [self addSubview:_mid];
    
    //秒针
    _secondHand = [[XLClockHand alloc] initWithFrame:CGRectMake(0, 0, secondhandHeight, secondhandHeight)];
    _secondHand.center = handCenter;
    _secondHand.handImage = [UIImage imageNamed:@"xl_clock_secondHand"];
    _secondHand.shadowImage = [UIImage imageNamed:@"xl_clock_secondHand_shadow"];
    
    _secondHand.layer.shadowOffset = CGSizeMake(5, 0);
    _secondHand.layer.shadowColor = PNCColor(74, 73, 74).CGColor;
    _secondHand.layer.shadowRadius = 1.1f;
    _secondHand.layer.shadowOpacity = 0.25;
    
    [self.layer insertSublayer:_secondHand.layer atIndex:0];
    [self addSubview:_secondHand];
}

//定时器
- (void)buildTimer {
    __weak typeof (self)weekSelf = self;
    _timer = [NSTimer timerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
        [weekSelf updateClockHand];
    }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

//更新时钟指针位置
- (void)updateClockHand {
    NSString *isHaveVoice = [BCUserDeafaults objectForKey:current_XIANSHILIEBIAO];
    if (isHaveVoice) {
//        [BCShanNianKaPianManager maDaQingZhenDong];
    }
    //获取日期
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    //时针动画
    CGFloat hourAngle = (dateComponent.hour + dateComponent.minute/60.0f) * M_PI*2/12.0f;
    POPBasicAnimation *hourPop = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    hourPop.fromValue = @(hourAngle);
    hourPop.toValue = @(hourAngle);
    [_hourHand.layer pop_addAnimation:hourPop forKey:@"hourPop"];
    
    //分针动画
    CGFloat minuteAngle = (dateComponent.minute + dateComponent.second/60.0f) * M_PI*2/60.0f;
    POPBasicAnimation *minitePop = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    minitePop.fromValue = @(minuteAngle);
    minitePop.toValue = @(minuteAngle);
    [_minuteHand.layer pop_addAnimation:minitePop forKey:@"minitePop"];
    
    //秒针动画
    CGFloat secondAngle = dateComponent.second * M_PI*2/60.0f;
    CGFloat lastSecondAngle = (dateComponent.second - 1) * M_PI*2/60.0f;
    POPSpringAnimation *secondpop = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    secondpop.springBounciness = 10;//回弹力
    secondpop.springSpeed = 20;//速度
    secondpop.fromValue = @(lastSecondAngle);
    secondpop.toValue = @(secondAngle);
    
    if ((long)dateComponent.second >= 0 && (long)dateComponent.second <=30) {
        if ((long)dateComponent.second >= 0 && (long)dateComponent.second <=15) {
            _secondHand.layer.shadowOffset = CGSizeMake( (long)dateComponent.second * MAXTRANFROM, 0);
        }else{
            _secondHand.layer.shadowOffset = CGSizeMake((30 - (long)dateComponent.second) * MAXTRANFROM ,0);
        }
    }else{
        if ((long)dateComponent.second > 30 && (long)dateComponent.second <=45) {
            _secondHand.layer.shadowOffset = CGSizeMake( -((long)dateComponent.second - 30) * MAXTRANFROM, 0);
        }else{
            _secondHand.layer.shadowOffset = CGSizeMake(-(60 - (long)dateComponent.second) * MAXTRANFROM, 0);
        }
    }
    
//    _secondHand.layer.shadowOffset = CGSizeMake(secondAngle, -5);
    
//    NSLog(@"%f====%ld",secondAngle,(long)dateComponent.second);
    [_secondHand.layer pop_addAnimation:secondpop forKey:@"secondpop"];
}

//开始动画
- (void)showStartAnimation {
    //获取日期
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    
    //时针动画
    CGFloat hourAngle = (dateComponent.hour + dateComponent.minute/60.0f) * M_PI*2/12.0f;
    POPBasicAnimation *hourPop = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    hourPop.fromValue = @(hourAngle - M_PI_4);
    hourPop.toValue = @(hourAngle);
    hourPop.duration = 1;
    [_hourHand.layer pop_addAnimation:hourPop forKey:@"hourPop"];
    [_hourHand pop_addAnimation:[self viewAlphaPop] forKey:@"viewAlphaPop"];
    
    //分针动画
    CGFloat minuteAngle = (dateComponent.minute + dateComponent.second/60.0f) * M_PI*2/60.0f;
    POPBasicAnimation *minitePop = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    minitePop.fromValue = @(minuteAngle - M_PI_4 * 2);
    minitePop.toValue = @(minuteAngle);
    minitePop.duration = 1.25;
    [_minuteHand.layer pop_addAnimation:minitePop forKey:@"minitePop"];
    [_minuteHand pop_addAnimation:[self viewAlphaPop] forKey:@"viewAlphaPop"];
    
    //秒针动画
    CGFloat secondPopDuration = 1.5;
    CGFloat secondAngle = (dateComponent.second + 1) * M_PI*2/60.0f;
    POPBasicAnimation *secondPop = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    secondPop.fromValue = @(secondAngle - M_PI_4 * 3);
    secondPop.toValue = @(secondAngle);
    secondPop.duration = secondPopDuration;
    secondPop.delegate = self;
    [_secondHand.layer pop_addAnimation:secondPop forKey:@"secondPop"];
    [_secondHand pop_addAnimation:[self viewAlphaPop] forKey:@"viewAlphaPop"];
    
    [_mid pop_addAnimation:[self viewAlphaPop] forKey:@"viewAlphaPop"];
}

//透明度动画
- (POPBasicAnimation *)viewAlphaPop {
    POPBasicAnimation *viewAlphaPop = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    viewAlphaPop.fromValue = @(0);
    viewAlphaPop.toValue = @(1);
    viewAlphaPop.duration = 1;
    return viewAlphaPop;
}

#pragma mark -
#pragma mark PopAnimationDelegate
//开始动画期间，不执行刷新方法
- (void)pop_animationDidStart:(POPAnimation *)anim {
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished {
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
}

@end
