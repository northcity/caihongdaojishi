//
//  KaiShiJiShiViewController.m
//  daojishi
//
//  Created by 北城 on 2018/9/13.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "KaiShiJiShiViewController.h"
#import "XMAutoScrollTextView.h"
#import <AVFoundation/AVFoundation.h>
#import "SystemSound.h"
#import <StoreKit/StoreKit.h>

@interface KaiShiJiShiViewController ()<AVAudioPlayerDelegate>{
    AVAudioPlayer *_avAudioPlayer; // 播放器palyer
}
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)XMAutoScrollTextView *lableView;
@property(nonatomic,strong)UILabel *lable;

//时间戳
@property (nonatomic, assign) NSTimeInterval timestamp;

@property (nonatomic,assign)CGFloat currentLiangDu;
@end

@implementation KaiShiJiShiViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}



//弹出星星评论
- (void)showAppStoreReView{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    //仅支持iOS10.3+（需要做校验） 且每个APP内每年最多弹出3次评分alart
    if ([systemVersion doubleValue] > 10.3) {
        if (@available(iOS 10.3, *)) {
            if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
                //防止键盘遮挡
                [[UIApplication sharedApplication].keyWindow endEditing:YES];
                [SKStoreReviewController requestReview];
            }
        }
    }
}

-(BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLiangDu = [UIScreen mainScreen].brightness;

    if (self.currentLiangDu > 0.8) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[UIScreen mainScreen] setBrightness:0.5];
        });
    }

    
    if (@available(iOS 13.0, *)) {
           self.view.backgroundColor = [UIColor systemBackgroundColor];
       } else {
           self.view.backgroundColor = [UIColor whiteColor];
       }
    
    [self ceateView];
    [self initOtherUI];
    _isPushlocalNotification = NO;
    [SystemSound accessSystemSoundsList];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        [UIView animateWithDuration:1.5 animations:^{
            self.titleView.alpha = 0;
        } completion:^(BOOL finished) {
            self.titleView.hidden = YES;
        }];
    });
    
    [self observeApplicationActionNotification];
    [self initPlayer];
}


-(void)initPlayer{
    @try {
        // (1)从boudle路径下读取音频文件 陈小春 - 独家记忆文件名，mp3文件格式
        
        NSString *songName = [[self.model.contentString componentsSeparatedByString:@"乐"] lastObject];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"caf"];
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

- (void)observeApplicationActionNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [_countDownTimer invalidate];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidEnterBackground {
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    _timestamp = [NSDate date].timeIntervalSince1970;
    _countDownTimer.fireDate = [NSDate distantFuture];

    if (!_isPushlocalNotification && _secondsCountDown > 0) {
        [self createLocationNotificationWith:_secondsCountDown];
    }
    _isPushlocalNotification = YES;
}

- (void)applicationDidBecomeActive {
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    if ([_isFromAppDelegate isEqualToString:@"NO"]) {
        
    NSLog(@"=====================%f",_timestamp);
    NSTimeInterval timeInterval = [NSDate date].timeIntervalSince1970-_timestamp;
    _timestamp = 0;
    
    
    NSTimeInterval ret = _secondsCountDown-timeInterval;
    
    NSLog(@"=====%ld======%f=======%f",(long)_secondsCountDown,timeInterval,ret);
    
    if (ret>0) {
        _secondsCountDown = ret;
        [_countDownTimer setFireDate:[NSDate distantPast]];
    } else if(ret <  0) {
        _secondsCountDown = 0;
//        [self countDownAction];
//        [self createLocationNotificationWith:0];
        [_countDownTimer invalidate];
        _isPushlocalNotification = NO;
        
        //重新计算 时/分/秒
        NSString *str_hour = [NSString stringWithFormat:@"%02ld",_secondsCountDown/3600];
        
        NSString *str_minute = [NSString stringWithFormat:@"%02ld",(_secondsCountDown%3600)/60];
        
        NSString *str_second = [NSString stringWithFormat:@"%02ld",_secondsCountDown%60];
        
        NSString *format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
        //修改倒计时标签及显示内容
        self.lable.text=[NSString stringWithFormat:@"%@",format_time];
        
        LZDataModel *model = [[LZDataModel alloc]init];
        model = self.model;
        model.dsc = [NSString stringWithFormat:@"%d",([model.dsc intValue] + 1)];
        NSLog(@"%@",model);
        
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        
    }
    }
}

- (void)initOtherUI{
    self.navigationController.navigationBar.hidden = YES;
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    if (@available(iOS 13.0, *)) {
        _titleView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.3f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    if (@available(iOS 13.0, *)) {
           UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                   if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                       return PNCColorWithHexA(0xdcdcdc, 0.9);
                   }else {
                       return PNCColorWithHexA(0xffffff, 0.5);
                   }
               }];
               
              _titleView.layer.shadowColor = backViewColor.CGColor;

           } else {
               _titleView.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
           }
    
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(5), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    _navTitleLabel.text = self.model.groupName;
    _navTitleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(14)];
//    _navTitleLabel.textColor = PNCColorWithHex(0xFB409C);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
//    YQMotionShadowView *showLabel = [YQMotionShadowView fromView:_navTitleLabel];
//    [_titleView addSubview:showLabel];
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth/2 - 12.5, CGRectGetMaxY(_bgView.frame) + 15, 30, 30) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(backAction)];
    [_backBtn setImage:[UIImage imageNamed:@"关闭11"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(ScreenWidth/2 - 12.5, CGRectGetMaxY(_bgView.frame) + 15, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
        
    }
    [self.view addSubview:_backBtn];
    
    
    //    _doneBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - 45, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(saveToDb)];
    //    [_doneBtn setImage:[UIImage imageNamed:@"dkw_完成"] forState:UIControlStateNormal];
    //    if (PNCisIPHONEX) {
    //        _doneBtn.frame = CGRectMake(ScreenWidth - 45, 48, 25, 25);
    //    }
    //    [_titleView addSubview:_doneBtn];
    
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];
        
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}

- (void)backAction{
    
    [self showAppStoreReView];

    
    [[UIApplication sharedApplication] cancelLocalNotification:_localNotification];
    
    if ([_isFromAppDelegate isEqualToString:@"NO"]) {
        [self.navigationController popViewControllerAnimated:YES];

    }else if ([_isFromAppDelegate isEqualToString:@"YES"]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)ceateView{
    
    _secondsCountDown = [self.model.urlString integerValue];
    
    CGFloat x = kAUTOWIDTH(20);
    CGFloat y = PCTopBarHeight + kAUTOHEIGHT(30);
    CGFloat width = ScreenHeight - kAUTOHEIGHT(60) - PCTopBarHeight - kAUTOHEIGHT(20);
    CGFloat height = ScreenWidth - kAUTOWIDTH(40);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 13.0, *)) {
            self.view.backgroundColor = [UIColor systemBackgroundColor];
       } else {
            self.view.backgroundColor = [UIColor whiteColor];
       }
    
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(x, y, width, height)];
//    self.bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview: self.bgView];
    
    
    self.lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,width, height)];
    self.lable.text = self.model.pcmData;
    self.lable.textAlignment = NSTextAlignmentCenter;
    self.lable.textColor = [UIColor whiteColor];
    self.lable.layer.shadowColor=[UIColor grayColor].CGColor;
     self.lable.layer.shadowOffset=CGSizeMake(0,3);
     self.lable.layer.shadowOpacity=0.4f;
     self.lable.layer.shadowRadius= 8;
//    self.lable.backgroundColor = [UIColor redColor];
    self.lable.font = [UIFont monospacedDigitSystemFontOfSize:100 weight:100];
    
    self.lable.font = [UIFont fontWithName:@"DBLCDTempBlack" size:100];

    if (PNCisIPAD) {
        self.lable.font = [UIFont fontWithName:@"DBLCDTempBlack" size:180];
    }
    
    self.lable.adjustsFontSizeToFitWidth = YES;
    [self.bgView addSubview:self.lable];
    
    CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_2);
    self.bgView.center = self.view.center;
    self.bgView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.bgView setTransform:transform];
    
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bgView.frame;
    self.gradientLayer.colors = @[(id)[KaiShiJiShiViewController toUIColorByStr:self.model.colorString].CGColor, (id)[KaiShiJiShiViewController toUIColorByStr:self.model.nickName].CGColor];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = kAUTOHEIGHT(7);
    [self.view.layer insertSublayer:self.gradientLayer below:self.bgView.layer];
    
    _subLayer=[CALayer layer];
    CGRect fixframe=_bgView.layer.frame;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = 10;
    _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds=NO;
    _subLayer.shadowColor=[UIColor grayColor].CGColor;
    _subLayer.shadowOffset=CGSizeMake(0,5);
    _subLayer.shadowOpacity=0.8f;
    _subLayer.shadowRadius= 8;
    [self.view.layer insertSublayer:_subLayer below:self.gradientLayer];
    
    
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
    self.lable.text = [NSString stringWithFormat:@"%@",format_time];

    
}
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
    self.lable.text=[NSString stringWithFormat:@"%@",format_time];
    
    //当倒计时到0时做需要的操作，比如验证码过期不能提交
    if(_secondsCountDown<=0){
        LZDataModel *model = [[LZDataModel alloc]init];
        model = self.model;
        model.dsc = [NSString stringWithFormat:@"%d",([model.dsc intValue] + 1)];
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        [self createLocationNotificationWith:0];
        [_countDownTimer invalidate];
        [SVProgressHUD showSuccessWithStatus:@"RainBow~，计时结束。"];
        [_avAudioPlayer play];
//        NSArray *sounds = [SystemSound systemSounds];
//        NSMutableArray *datasArray = [[NSMutableArray alloc]init];
//
//        NSMutableArray *indexPaths = [NSMutableArray array];
//        for (int i = 0; i < sounds.count; i++) {
//
//            [datasArray addObject:sounds[i]];
//            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
//        }
//
//        [SystemSound playWithSound:datasArray[sounds.count - 5]];

    }
    
}


- (void)createLocationNotificationWith:(NSTimeInterval )locationTimeInterval{
    // 1.创建通知
    _localNotification = [[UILocalNotification alloc] init];
    // 2.设置通知的必选参数
    // 设置通知显示的内容
    _localNotification.alertBody = @"RAINBOW~ 倒计时结束啦！";
    // 设置通知的发送时间,单位秒
    _localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:locationTimeInterval];
    //解锁滑动时的事件
    _localNotification.alertAction = @"倒计时结束啦！";
    //收到通知时App icon的角标
    _localNotification.applicationIconBadgeNumber = 1;
    //推送是带的声音提醒，设置默认的字段为UILocalNotificationDefaultSoundName
    
    NSString *songName = [[self.model.contentString componentsSeparatedByString:@"乐"] lastObject];
    _localNotification.soundName = [NSString stringWithFormat:@"%@.caf",songName];
    // 3.发送通知(🐽 : 根据项目需要使用)
    // 方式一: 根据通知的发送时间(fireDate)发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:_localNotification];

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
