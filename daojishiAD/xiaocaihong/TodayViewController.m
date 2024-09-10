//
//  TodayViewController.m
//  xiaocaihong
//
//  Created by 2345 on 2019/6/4.
//  Copyright © 2019 com.beicheng. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TodayModel.h"
#import <AVFoundation/AVFoundation.h>
#import "SystemSound.h"

#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO))
#define KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define kAUTOHEIGHT(_hei)      (PNCisIPHONEX ? _hei * 1 : _hei * ScreenHeight / 667.0)
#define PNCColorWithHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface TodayViewController () <NCWidgetProviding,AVAudioPlayerDelegate>{
    AVAudioPlayer *_avAudioPlayer; // 播放器palyer
}
@property (nonatomic, strong) UIView *oneView;

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UILabel *timeLabel;
//@property(nonatomic,strong) YQMotionShadowView *showLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *countLabel;

@property (nonatomic,strong) CAGradientLayer * gradientLayer;

@property (nonatomic,strong)CALayer *subLayer;

@property (nonatomic,copy)NSString *bgColor1;
@property (nonatomic,copy)NSString *bgColor2;

@property (nonatomic,strong)UIButton *beginButton;
@property (nonatomic,strong)UIView *buttonView;
@property (nonatomic,strong)UIBlurEffect *blurEffect;
@property (nonatomic,strong)CALayer *btnSubLayer;
@property (nonatomic,strong)UIVisualEffectView *effectView;

//创建定时器(因为下面两个方法都使用,所以定时器拿出来设置为一个属性)
@property(nonatomic,strong)NSTimer*countDownTimer;
@property (nonatomic,assign)NSInteger secondsCountDown;
@property (nonatomic,strong)UILocalNotification *localNotification;

@property (nonatomic,copy)NSString *contentString;
@property (nonatomic,copy)NSString *urlString;

@end

BOOL flag = YES;

@implementation TodayViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //该处目前只能设置NCWidgetDisplayModeCompact，界面初始显示的时候，只能是收缩状态
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
}

-(void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize{
    if (self.extensionContext.widgetActiveDisplayMode == NCWidgetDisplayModeCompact) {
        self.preferredContentSize = CGSizeMake(0, 150);
        [self setMinView];
    }else{
        self.preferredContentSize = CGSizeMake(0, 300);
        [self setMaxView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];




    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.caihongdaojishi"];
    NSString *nickName = [userDefault objectForKey:@"group.dyTodayExtension.nickName"];
    NSString *colorString = [userDefault objectForKey:@"group.dyTodayExtension.colorString"];
    NSString *password = [userDefault objectForKey:@"group.dyTodayExtension.password"];
    NSString *titleString = [userDefault objectForKey:@"group.dyTodayExtension.titleString"];
    NSString *dsc = [userDefault objectForKey:@"group.dyTodayExtension.dsc"];
    NSString *urlString = [userDefault objectForKey:@"group.dyTodayExtension.urlString"];

    NSString *pcmData = [userDefault objectForKey:@"group.dyTodayExtension.pcmData"];

    _contentString =  [userDefault objectForKey:@"group.dyTodayExtension.contentString"];

    TodayModel *model = [[TodayModel alloc]init];
    model.colorString = colorString;
    model.nickName = nickName;
    model.pcmData = pcmData;
    model.titleString = titleString;
    model.dsc = dsc;
    model.urlString = urlString;
    _urlString = urlString;
    _secondsCountDown = [model.urlString integerValue];

//    [self createSubViews];
    [self setMinView];
    [self cellSetContentViewWithModel:model];

}

- (void)cellSetContentViewWithModel:(TodayModel *)model{
    self.bgColor2 = model.colorString ;
    self.bgColor1= model.nickName;
    self.timeLabel.text = model.pcmData;
    self.titleLabel.text = model.titleString;
    if ([model.dsc isEqualToString:@"0"]) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"已完成%@次",model.dsc];
        self.countLabel.hidden = NO;
    }
    self.gradientLayer.colors =  self.gradientLayer.colors = @[(id)[TodayViewController toUIColorByStr:self.bgColor1].CGColor, (id)[TodayViewController toUIColorByStr:self.bgColor2].CGColor];

    _subLayer.shadowColor = [TodayViewController toUIColorByStr:self.bgColor1].CGColor;

}


- (void)setMinView{
    if (!self.oneView) {



    self.oneView = [[UIView alloc]initWithFrame:CGRectMake((15), (10), self.view.frame.size.width - (30), (50))];
    [self.view addSubview:self.oneView];

    self.bgView = [[UIView alloc]initWithFrame:self.oneView.bounds];
    [self.oneView addSubview:self.bgView];

    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bgView.frame;
    self.gradientLayer.colors = @[(id)[TodayViewController toUIColorByStr:self.bgColor1].CGColor, (id)[TodayViewController toUIColorByStr:self.bgColor2].CGColor];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = (4);
    [self.oneView.layer insertSublayer:self.gradientLayer below:self.bgView.layer];

    _subLayer=[CALayer layer];
    CGRect fixframe=_bgView.layer.frame;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = (6);
    _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds=NO;
    _subLayer.shadowOffset=CGSizeMake(0,5);
    _subLayer.shadowOpacity=1.0f;
    _subLayer.shadowRadius=15;
    [self.oneView.layer insertSublayer:_subLayer below:self.gradientLayer];

    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.oneView.frame.size.width - (90), 0, (80), (50))];
    self.timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:17];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.oneView addSubview:self.timeLabel];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((15),0,(100), (50))];
    self.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.oneView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;

    self.countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.countLabel.font = [UIFont fontWithName:@"HeiTi SC" size:8];
    self.countLabel.alpha = 0.6 ;
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    [self.oneView addSubview:self.countLabel];


//        self.beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.beginButton.frame = CGRectMake(self.view.frame.size.width/2 - 20, CGRectGetMidY(self.oneView.frame) + 10, 40, 40)；
//        self.begi





            self.buttonView = [[UIView alloc]initWithFrame: CGRectMake(self.view.frame.size.width/2 - 20, CGRectGetMaxY(self.oneView.frame) + 5, 40, 40)];
            [self.view addSubview:self.buttonView ];
            self.buttonView .backgroundColor = [UIColor redColor];
            self.buttonView .alpha = 0.6;
            self.buttonView .layer.cornerRadius = 20;
            self.buttonView .layer.masksToBounds = YES;

            // 毛玻璃视图
            self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
             self.effectView = [[UIVisualEffectView alloc] initWithEffect:self.blurEffect];
            self.effectView.frame = self.buttonView .bounds;
            [self.buttonView  addSubview:self.effectView];

            self.btnSubLayer=[CALayer layer];
            CGRect fixframebutton=self.buttonView .layer.frame;
            self.btnSubLayer.frame = fixframebutton;
            self.btnSubLayer.cornerRadius = 25;
            self.btnSubLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            self.btnSubLayer.masksToBounds=NO;
            //    _subLayer.shadowColor=[UIColor grayColor].CGColor;
            self.btnSubLayer.shadowOffset=CGSizeMake(0,5);
            self.btnSubLayer.shadowOpacity=0.6f;
            self.btnSubLayer.shadowRadius=10;
            [self.view.layer insertSublayer:self.btnSubLayer below:self.buttonView .layer];


            self.beginButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.buttonView  addSubview:self.beginButton];
        self.beginButton.frame = CGRectMake(7.5,7.5, 25, 25);
            [self.beginButton setBackgroundImage:[UIImage imageNamed:@"shalou"] forState:UIControlStateNormal];
            [self.beginButton addTarget:self  action:@selector(beginTimerClick:) forControlEvents:UIControlEventTouchUpInside];
            self.beginButton.backgroundColor = [UIColor clearColor];
            //    self.daoJiShiButton.layer.cornerRadius = ;
            //    self.daoJiShiButton.layer.masksToBounds = YES;


    }else{
        [UIView animateWithDuration:0.3 animations:^{

            self.oneView.frame = CGRectMake((15), (10), self.view.frame.size.width - (30), (50));
            self.bgView.frame = self.oneView.bounds;

            self.gradientLayer.frame = self.bgView.frame;
            self.gradientLayer.colors = @[(id)[TodayViewController toUIColorByStr:self.bgColor1].CGColor, (id)[TodayViewController toUIColorByStr:self.bgColor2].CGColor];
            self.gradientLayer.locations = @[@(0),@(1)];
            self.gradientLayer.startPoint = CGPointMake(0, 0.5);
            self.gradientLayer.endPoint = CGPointMake(1, 0.5);
            self.gradientLayer.cornerRadius = (4);
            [self.oneView.layer insertSublayer:self.gradientLayer below:self.bgView.layer];

            CGRect fixframe=self.bgView.layer.frame;
            self.subLayer.frame = fixframe;
            self.subLayer.cornerRadius = (6);
            self.subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
            self.subLayer.masksToBounds=NO;
            self.subLayer.shadowOffset=CGSizeMake(0,5);
            self.subLayer.shadowOpacity=1.0f;
            self.subLayer.shadowRadius=15;
            [self.oneView.layer insertSublayer:self.subLayer below:self.gradientLayer];

            self.timeLabel.frame = CGRectMake(self.oneView.frame.size.width - (90), 0, (80), (50));
            self.timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:17];

//            self.timeLabel.layer.anchorPoint = CGPointMake(0, 0);

            self.titleLabel.frame =CGRectMake((15),0,(100), (50));
            self.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:15];

            self.countLabel.frame = CGRectZero;




            self.buttonView.frame = CGRectMake(self.view.frame.size.width/2 - 20, CGRectGetMaxY(self.oneView.frame) + 5, 40, 40);
            self.buttonView .layer.cornerRadius = 20;
            self.buttonView .layer.masksToBounds = YES;

            // 毛玻璃视图
            self.effectView.frame = self.buttonView.bounds;

            CGRect fixframebutton=self.buttonView .layer.frame;
            self.btnSubLayer.frame = fixframebutton;
            self.btnSubLayer.cornerRadius = 25;


            self.beginButton.frame = CGRectMake(7.5,7.5, 25, 25);
            [self.beginButton setBackgroundImage:[UIImage imageNamed:@"shalou"] forState:UIControlStateNormal];
            [self.beginButton addTarget:self  action:@selector(beginTimerClick:) forControlEvents:UIControlEventTouchUpInside];
            self.beginButton.backgroundColor = [UIColor clearColor];

        }];
    }
}

- (void)setMaxView{

    [UIView animateWithDuration:0.3 animations:^{

        self.oneView.frame = CGRectMake((15), (20), self.view.frame.size.width - (30), (120));
        self.bgView.frame = self.oneView.bounds;

        self.gradientLayer.frame = self.bgView.frame;
        self.gradientLayer.colors = @[(id)[TodayViewController toUIColorByStr:self.bgColor1].CGColor, (id)[TodayViewController toUIColorByStr:self.bgColor2].CGColor];
        self.gradientLayer.locations = @[@(0),@(1)];
        self.gradientLayer.startPoint = CGPointMake(0, 0.5);
        self.gradientLayer.endPoint = CGPointMake(1, 0.5);
        self.gradientLayer.cornerRadius = (7);
        [self.oneView.layer insertSublayer:self.gradientLayer below:self.bgView.layer];

        CGRect fixframe=self.bgView.layer.frame;
        self.subLayer.frame = fixframe;
        self.subLayer.cornerRadius = (7);
        self.subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        self.subLayer.masksToBounds=NO;
        self.subLayer.shadowOffset=CGSizeMake(0,5);
        self.subLayer.shadowOpacity=1.0f;
        self.subLayer.shadowRadius=15;
        [self.oneView.layer insertSublayer:self.subLayer below:self.gradientLayer];

        self.timeLabel.frame = CGRectMake(self.oneView.frame.size.width - 170, 22, 160, (50));
        self.timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:35];

        self.titleLabel.frame = CGRectMake((15),22,(130), (50));
        self.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:17];

        self.countLabel.frame = CGRectMake((15),self.oneView.frame.size.height - (18) - 20, (80), (18));







        self.buttonView.frame = CGRectMake(self.view.frame.size.width/2 - 30, CGRectGetMaxY(self.oneView.frame) + 35, 60, 60);
        self.buttonView .layer.cornerRadius = 30;
        self.buttonView .layer.masksToBounds = YES;

        // 毛玻璃视图
        self.effectView.frame = self.buttonView.bounds;

        CGRect fixframebutton=self.buttonView .layer.frame;
        self.btnSubLayer.frame = fixframebutton;
        self.btnSubLayer.cornerRadius = 30;

        self.beginButton.frame = CGRectMake(15,15, 30,30);
        [self.beginButton setBackgroundImage:[UIImage imageNamed:@"shalou"] forState:UIControlStateNormal];
        [self.beginButton addTarget:self  action:@selector(beginTimerClick:) forControlEvents:UIControlEventTouchUpInside];
        self.beginButton.backgroundColor = [UIColor clearColor];

    }];

}





- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    completionHandler(NCUpdateResultNewData);
}

+ (UIColor*)toUIColorByStr:(NSString*)colorStr{
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f) alpha:1.0f];
}




- (void)beginTimerClick:(UIButton *)sender{
    if (flag) {
        [UIView animateWithDuration:0.5 animations:^{
            sender.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:^(BOOL finished) {
            flag = NO;
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            sender.transform = CGAffineTransformMakeRotation(-2*M_PI);
        } completion:^(BOOL finished) {
            flag = YES;
        }];
    }

    [SystemSound accessSystemSoundsList];

    [self initPlayer];

    //设置定时器
    if (!_countDownTimer) {
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    }
    //启动倒计时后会每秒钟调用一次方法 countDownAction

    //设置倒计时显示的时间
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];//时
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];//分
    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];//秒
    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",format_time];

}

-(void)initPlayer{
    @try {
        // (1)从boudle路径下读取音频文件 陈小春 - 独家记忆文件名，mp3文件格式
        NSString *path = [[NSBundle mainBundle] pathForResource:[self.contentString substringFromIndex:self.contentString.length - 1] ofType:@"caf"];
        // (2)把音频文件转化成url格式
        NSURL *url = [NSURL fileURLWithPath:path];
        // (3)初始化音频类 并且添加播放文件
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        // (4) 设置代理
        _avAudioPlayer.delegate = self;
        // (5) 设置初始音量大小 默认1，取值范围 0~1
        _avAudioPlayer.volume = 1;
        // (6)设置音乐播放次数 负数为一直循环，直到stop，0为一次，1为2次，以此类推
        _avAudioPlayer.numberOfLoops = 0;
        // (5)准备播放
        [_avAudioPlayer prepareToPlay];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);

    } @finally {
        NSLog(@"@finally");

    }

    // 2.播放本地音频文件


}

//- (void)createLocationNotificationWith:(NSTimeInterval )locationTimeInterval{
//    // 1.创建通知
//    _localNotification = [[UILocalNotification alloc] init];
//    // 2.设置通知的必选参数
//    // 设置通知显示的内容
//    _localNotification.alertBody = @"RAINBOW~ 倒计时结束啦！";
//    // 设置通知的发送时间,单位秒
//    _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:locationTimeInterval];
//    //解锁滑动时的事件
//    _localNotification.alertAction = @"倒计时结束啦！";
//    //收到通知时App icon的角标
//    _localNotification.applicationIconBadgeNumber = 1;
//    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
//    _localNotification.soundName = [NSString stringWithFormat:@"%@.caf",[self.model.contentString substringFromIndex:self.model.contentString.length - 1]];
//    // 3.发送通知(🐽 : 根据项目需要使用)
//    // 方式一: 根据通知的发送时间(fireDate)发送通知
//    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];
//
//}

#pragma mark ====倒计时结束放音乐=======
//实现倒计时动作
-(void)countDownAction{
    //倒计时-1
    _secondsCountDown--;

    //重新计算 时/分/秒
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];

    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];

    NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];

    NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    //修改倒计时标签及显示内容
    self.timeLabel.text=[NSString stringWithFormat:@"%@",format_time];


    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown<=0){

        [_countDownTimer invalidate];
        _countDownTimer = nil;
//        [SVProgressHUD showSuccessWithStatus:@"RainBow~，Over。"];

        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        label.center = self.view.center;
        label.text = @"RainBow~,结束啦！";
        label.font = [UIFont fontWithName:@"Avenir-Medium" size:9];
        label.backgroundColor = [UIColor whiteColor];
        label.layer.cornerRadius = 6;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor =PNCColorWithHexA(0x707070, 1);
        label.alpha = 0.8;
        [self.view addSubview:label];



        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [UIView animateWithDuration:2 animations:^{
                label.alpha = 0;
            } completion:^(BOOL finished) {
                [label removeFromSuperview];
            }];
        });


        [_avAudioPlayer play];

        NSArray *sounds = [SystemSound systemSounds];
        NSMutableArray *datasArray = [[NSMutableArray alloc]init];

        NSMutableArray *indexPaths = [NSMutableArray array];
        for (int i = 0; i < sounds.count; i++) {
//
            [datasArray addObject:sounds[i]];
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
//
        [SystemSound playWithSound:datasArray[sounds.count - 5]];



    _secondsCountDown = [_urlString integerValue];
    //设置倒计时显示的时间
     str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];//时
     str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];//分
     str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];//秒
     format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",format_time];
    }


}


@end
