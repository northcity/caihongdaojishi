 //
//  DaoJiShiViewController.m
//  daojishi
//
//  Created by 北城 on 2018/9/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "DaoJiShiViewController.h"
#import "DaoJiShiTableViewCell.h"
#import "DaoJiShiModel.h"
#import "NewDaoJiShiViewController.h"
#import "KaiShiJiShiViewController.h"
#import "XRDragTableView.h"

#import "UIViewController+HHTransition.h"
#import "UIView+HHLayout.h"

#import "SettingViewController.h"
#import "LZiCloud.h"

#import "RBDMuteSwitch.h"
#import "DaojiShiShouTableViewCell.h"
#import <StoreKit/StoreKit.h>


#define DaoJiShiCellID @"DaoJiShiTableViewCell"
@interface DaoJiShiViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIViewControllerPreviewingDelegate,RBDMuteSwitchDelegate,UIGestureRecognizerDelegate>{
    BOOL _isJingYin;
}
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic, strong)UIButton *daoJiShiButton;
@property (nonatomic, assign) CGPoint touchPoint;

//模糊视图图层
@property(nonatomic,strong)UIVisualEffectView *effectView;
@property(nonatomic,strong)UIBlurEffect *effect;
@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, copy) NSString *nowStyleString;
@property (nonatomic, assign) NSInteger isNowNumber;
@property (nonatomic,strong)NSTimer *timer;

//@property(nonatomic,strong)APAdBanner * banner;

@end

@implementation DaoJiShiViewController

//- (void)createAD{
//
//    self.banner = [[APAdBanner alloc] initWithSlot:@"YGLnYYmx" withSize:APAdBannerSize320x50 delegate:self currentController:self];
//    [self.view addSubview:self.banner];
//    [self.banner setInterval:2];
//    [self.banner load];
//    [self.banner setPosition:CGPointMake(ScreenWidth/2, ScreenHeight - kAUTOWIDTH(30))];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];


    self.nowStyleString = [[NSUserDefaults standardUserDefaults] objectForKey:@"STYLE_STRING"]?:@"1";


    if (PNCisIOS13Later) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];

    }else{
        self.view.backgroundColor = [UIColor whiteColor];

    }
    
    [self createDataSource];
    [self createSubViews];
    [self initOtherUI];
    [self createXiaLaView];
    self.automaticallyAdjustsScrollViewInsets = false;
    [self createNewDaoJiShiButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"RELOAD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshfirst) name:@"firstRELOAD" object:nil];


//    [self tongBuiCloud];
//    [self showAppStoreReView];
    
    NSString *isVip = [BCUserDeafaults objectForKey:IS_NO_AD];
    if ([isVip isEqualToString:@"1"]) {
//        [self.rightBtn setTitle:@"已去广告" forState:UIControlStateNormal];
    }else{
//        [self createAD];
    }

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

#pragma mark Timer methods
- (void)beginDetection {
    [[RBDMuteSwitch sharedInstance] setDelegate:self];
    [[RBDMuteSwitch sharedInstance] detectMuteSwitch];
}

#pragma mark RBDMuteSwitchDelegate methods
- (void)isMuted:(BOOL)muted {
    if (muted) {
        _isJingYin = YES;
    }
    else {
        _isJingYin = NO;
    }
}


- (void)tongBuiCloud{
    
    NSString *path = [LZSqliteTool LZCreateSqliteWithName:LZSqliteDataTableName];
    NSLog(@"我是路径 === %@",path);
    [LZiCloud uploadToiCloud:path resultBlock:^(NSError *error) {
        if (error == nil) {
            NSLog(@"=====同步成功====");
        } else {
            NSLog(@"=====同步失败====");
        }
    }];
}
- (void)refresh{
    [self createDataSource];
}

- (void)refreshfirst{
    [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    [self createDataSource];
}

- (void)createNewDaoJiShiButton{
    
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 100, ScreenHeight - 120, 60, 60)];
    [self.view addSubview:buttonView];
    buttonView.backgroundColor = PNCColorWithHex(0xff5a71);
    buttonView.alpha = 1;
    buttonView.layer.cornerRadius = 30;
    buttonView.layer.masksToBounds = YES;
    
    // 毛玻璃视图
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = buttonView.bounds;
    [buttonView addSubview:effectView];
    
    CALayer * subLayer=[CALayer layer];
    CGRect fixframe=buttonView.layer.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 30;
    subLayer.backgroundColor=[[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    //    _subLayer.shadowColor=[UIColor grayColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,4);
    subLayer.shadowOpacity=0.3f;
    subLayer.shadowRadius=7;
    [self.view.layer insertSublayer:subLayer below:buttonView.layer];
    
    
    self.daoJiShiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonView addSubview:self.daoJiShiButton];
    self.daoJiShiButton.frame = CGRectMake(10,10,40,40);
    [self.daoJiShiButton setBackgroundImage:[UIImage imageNamed:@"添加add"] forState:UIControlStateNormal];
    [self.daoJiShiButton addTarget:self  action:@selector(pushNewDaoJiShiWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    self.daoJiShiButton.backgroundColor = [UIColor clearColor];
//    self.daoJiShiButton.layer.cornerRadius = ;
//    self.daoJiShiButton.layer.masksToBounds = YES;
}

- (void)pushNewDaoJiShiWithAnimation{
    [BCShanNianKaPianManager maDaQingZhenDong];
    CGPoint touchPoint = CGPointMake(ScreenWidth - 100, ScreenHeight - 100);
    NewDaoJiShiViewController *circleVC = [[NewDaoJiShiViewController alloc]init];
    [self hh_presentCircleVC:circleVC point:touchPoint completion:nil];
}

#pragma mark ====== 生命周期 ======
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createDataSource];
    [self beginDetection];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
//进入下个页面或者返回上一个页面时，启用侧滑手势：
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];

}


- (void)createXiaLaView{
    
}

- (void)initOtherUI{
    self.navigationController.navigationBar.hidden = YES;

    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.3f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    
    if (@available(iOS 13.0, *)) {
           _titleView.backgroundColor = [UIColor systemBackgroundColor];
       } else {
           _titleView.backgroundColor = [UIColor whiteColor];
       }
       [self.view addSubview:_titleView];
       
     if (@available(iOS 13.0, *)) {
           UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                   if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                       return PNCColorWithHexA(0xdcdcdc, 0.9);
                   }else {
                       return PNCColorWithHexA(0xffffff, 0.9);
                   }
               }];
               
              _titleView.layer.shadowColor = backViewColor.CGColor;

           } else {
               _titleView.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
           }
       
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(5), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    _navTitleLabel.text = @"RAINBOW TIMER";
    _navTitleLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
    _navTitleLabel.adjustsFontSizeToFitWidth = YES;
    _navTitleLabel.textColor = PNCColorWithHex(0xFB409C);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];

 
    
    YQMotionShadowView *showLabel = [YQMotionShadowView fromView:_navTitleLabel];
    [_titleView addSubview:showLabel];

    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"RAINBOW TIMER"];
    NSRange range1 = [[str string] rangeOfString:@"R"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0xFF0000) range:range1];
    NSRange range2 = [[str string] rangeOfString:@"A"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0xFF7F00)  range:range2];
    NSRange range3 = [[str string] rangeOfString:@"I"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0xFFFF00)  range:range3];
   
    NSRange range4 = [[str string] rangeOfString:@"N"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0x00FF00)  range:range4];
    NSRange range5 = [[str string] rangeOfString:@"B"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0x00FFFF)  range:range5];
    NSRange range6 = [[str string] rangeOfString:@"O"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0x0000FF)  range:range6];
    NSRange range7 = [[str string] rangeOfString:@"W"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0x8B00FF) range:range7];
    
   
    NSRange range8 = [[str string] rangeOfString:@"TIMER"];
    [str addAttribute:NSForegroundColorAttributeName value:PNCColorWithHex(0x515151) range:range8];
    
    
    _navTitleLabel.attributedText = str;
    
    
    
    
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - 45, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(changeStyle:)];
    [_backBtn setImage:[UIImage imageNamed:@"票务信息"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(ScreenWidth - 45, 50, 25, 25);
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(27), kAUTOWIDTH(150), kAUTOHEIGHT(66));
    }
    
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
         _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, kAUTOHEIGHT(16), kAUTOWIDTH(180), kAUTOHEIGHT(66));
    }
//    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //        rotationAnimation.fromValue =[NSNumber numberWithFloat: 0M_PI_4];
        
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
//        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
    });

                                    [_titleView addSubview:_backBtn];
    self.setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.setBtn setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    [self.setBtn setTitle:@"设置" forState:UIControlStateNormal];
    self.setBtn.frame = CGRectMake(15, 28, 25, 25);
    //    self.setBtn.layer.masksToBounds = YES;
    //    self.setBtn.layer.cornerRadius = 25;
    [self.titleView addSubview:self.setBtn];
    [self.setBtn addTarget:self action:@selector(pushSettingViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:_setBtn];
    _setBtn.alpha = 1;
    if (PNCisIPHONEX) {
        self.setBtn.frame = CGRectMake(15, 50, 25, 25);
    }
    PNCWeakSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:2 animations:^{
            weakSelf.setBtn.alpha = 1;
        }];
    });
}

- (void)changeStyle:(UIButton *)sender{

    [BCShanNianKaPianManager maDaZhongJianZhenDong];
    
    
    
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
    } completion:nil];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.alpha = 0;
    }completion:^(BOOL finished) {
        if ([self.nowStyleString isEqualToString:@"1"]) {
            self.nowStyleString = @"0";
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"STYLE_STRING"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }else{
            self.nowStyleString = @"1";
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"STYLE_STRING"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }

        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.alpha = 1;
        } completion:^(BOOL finished) {

        }];
    }];




}

- (void)pushSettingViewController:(UIButton *)sender{
    [BCShanNianKaPianManager maDaQingZhenDong];
    sender.transform = CGAffineTransformMakeScale(0.8, 0.8);    // 先缩小
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        sender.transform = CGAffineTransformMakeScale(1, 1);        // 放大
    } completion:nil];
    SettingViewController *svc = [[SettingViewController alloc]init];
//    [self presentViewController:svc animated:YES completion:nil];
    [self.navigationController pushViewController:svc animated:YES];
}

- (void)createDataSource{
 
    self.dataSource = [[NSMutableArray alloc]init];
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    self.dataSource= [NSMutableArray arrayWithArray:array];


    LZDataModel *model = array[0];

    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.caihongdaojishi"];
    [userDefault setObject:model.nickName forKey:@"group.dyTodayExtension.nickName"];
    [userDefault setObject:model.colorString forKey:@"group.dyTodayExtension.colorString"];
    [userDefault setObject:model.pcmData forKey:@"group.dyTodayExtension.password"];
    [userDefault setObject:model.titleString forKey:@"group.dyTodayExtension.titleString"];
    [userDefault setObject:model.dsc forKey:@"group.dyTodayExtension.dsc"];
    [userDefault setObject:model.urlString forKey:@"group.dyTodayExtension.urlString"];
    [userDefault setObject:model.contentString forKey:@"group.dyTodayExtension.contentString"];

    
    [userDefault synchronize];


    [self.tableView reloadData];
    
//    for (int i = 0; i < 3; i ++) {
//        DaoJiShiModel *model1 = [[DaoJiShiModel alloc]init];
//        model1.bgColor1 = @"#60D6FF";
//        model1.bgColor2 = @"#26B8F5";
//        model1.timeString = @"23:30:00";
//        model1.secondsCountDown = 86400;
//        DaoJiShiModel *model2 = [[DaoJiShiModel alloc]init];
////        model2.bgColor1 = @"#F98DB3";
//        model2.bgColor1 = @"#E39FBC";
//        model2.bgColor1 = @"#FCA2C1";
////        model2.bgColor2 = @"#FA5590";
////        model2.bgColor2 = @"#E06F9E";
//        model2.bgColor2 = @"#FD71A1";
//        model2.timeString = @"23:30:00";
//        model2.secondsCountDown = 86400;
//
//        DaoJiShiModel *model3 = [[DaoJiShiModel alloc]init];
//        model3.bgColor1 = @"#FEC66C";
//        model3.bgColor2 = @"#FD985F";
//        model3.timeString = @"00:00:30";
//        model3.secondsCountDown = 30;
//
//        [self.dataSource addObject:model1];
//        [self.dataSource addObject:model2];
//        [self.dataSource addObject:model3];
//
//    }
}
- (void)createSubViews{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 13.0, *)) {
           self.tableView.backgroundColor = [UIColor systemBackgroundColor];
       } else {
           self.tableView.backgroundColor = [UIColor whiteColor];
       }
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    //    iOS 11 适配
    if (PNCisIOS11Later) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
    }
    //    iOS 11 适配
    if (PNCisIOS11Later) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }

    UIPinchGestureRecognizer *pinTap = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinView:)];
    [self.tableView addGestureRecognizer:pinTap];




}

- (void)numerZengjia{
    self.isNowNumber ++;
    if (self.isNowNumber == 10) {
        self.isNowNumber = 0;
        [_timer invalidate];
    }
}

- (void)resettimer{
    self.isNowNumber = 0;

    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(numerZengjia) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }else{
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)pinView:(UIPinchGestureRecognizer *)pinGest{

//    [self resettimer];


    if (pinGest.state == UIGestureRecognizerStateEnded) {
                if (pinGest.scale < 1) {
                    self.nowStyleString = @"0";
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"STYLE_STRING"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.tableView reloadData];

                }else{
                    self.nowStyleString = @"1";
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"STYLE_STRING"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self.tableView reloadData];
                }

            pinGest.scale = 1;

    }

    

    //缩放的比例是一个"累加"过程
    NSLog(@"%s----%f",__func__,pinGest.scale);



#warning 放大图片后， 再次缩放的时候，马上回到原先的大小
    //self.imageView.transform = CGAffineTransformMakeScale(pinGest.scale, pinGest.scale);


//    self.imgView.transform = CGAffineTransformScale(self.imgView.transform, pinGest.scale, pinGest.scale);

    // 让比例还原，不要累加
    // 解决办法，重新设置scale
}


#pragma mark ====== tableview代理 ======
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight+ 20)];
//    view.backgroundColor = [UIColor redColor];
    
    self.xiaLaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(25/2), 0,kAUTOWIDTH(25), kAUTOHEIGHT(25))];
    self.xiaLaImageView.image = [UIImage imageNamed:@"沙漏"];
    [view addSubview:self.xiaLaImageView];
    
    self.xiaLaLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(50), CGRectGetMaxY(self.xiaLaImageView.frame), kAUTOWIDTH(100), kAUTOHEIGHT(20))];
    self.xiaLaLabel.font = [UIFont fontWithName:@"HeiTi SC" size:8];
    self.xiaLaLabel.alpha = 0.5;
    self.xiaLaLabel.textColor = [UIColor blackColor];
    self.xiaLaLabel.textAlignment = NSTextAlignmentCenter;
    self.xiaLaLabel.text = @"继续下拉创建新的计时器";
    [view addSubview:self.xiaLaLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return PCTopBarHeight + 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    UILabel *sologinLabel = [[UILabel alloc]initWithFrame: CGRectMake(0, 5, ScreenWidth, 44)];
    sologinLabel.backgroundColor = [UIColor clearColor];
    sologinLabel.text = @"RAINBOW TIMER";
    
    sologinLabel.textColor = PNCColorWithHex(0xdcdcdc);
    sologinLabel.textAlignment = NSTextAlignmentCenter;
    sologinLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:kAUTOWIDTH(15)];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:sologinLabel];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.nowStyleString isEqualToString:@"1"]) {
        return kAUTOHEIGHT(135);
    }else if ([self.nowStyleString isEqualToString:@"0"]){
        return kAUTOHEIGHT(70);
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.nowStyleString isEqualToString:@"1"]) {
        static NSString *cellIdentifier = @"daojishicell";
        DaoJiShiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[DaoJiShiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }

        LZDataModel *model = self.dataSource[indexPath.row];
        [cell cellSetContentViewWithModel:model];


        UISwipeGestureRecognizer * recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell.contentView addGestureRecognizer:recognizer];



        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([self respondsToSelector:@selector(traitCollection)]) {
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self registerForPreviewingWithDelegate:self sourceView:cell];
                }
            }
        }
        
        return cell;
    }else if ([self.nowStyleString isEqualToString:@"0"]){

        static NSString *cellIdentifier = @"daojishishoucell";
        DaojiShiShouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[DaojiShiShouTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        LZDataModel *model = self.dataSource[indexPath.row];
        [cell cellSetContentViewWithModel:model];


        UISwipeGestureRecognizer * recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [cell.contentView addGestureRecognizer:recognizer];



        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([self respondsToSelector:@selector(traitCollection)]) {
            if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self registerForPreviewingWithDelegate:self sourceView:cell];
                }
            }
        }
        return cell;

    }else{
        return nil;
    }






}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if (_tableView.editing == YES) {
        [_tableView setEditing:NO animated:YES];
    }else{
        [_tableView setEditing:YES animated:YES];

    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [BCShanNianKaPianManager maDaQingZhenDong];

    ///配置 CATransform3D 动画内容
    CATransform3D  transform;
    //    transform.m34 = 1.0/-800;
    
    //定义 Cell的初始化状态
    //    cell.layer.transform = transform;
    cell.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.5 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
    //定义Cell 最终状态 并且提交动画
    //    [UIView beginAnimations:@"transform" context:NULL];
    //    [UIView setAnimationDuration:1];
    //    cell.layer.transform = CATransform3DIdentity;
    //    cell.frame = CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    //    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_isJingYin) {
        [SVProgressHUD showInfoWithStatus:@"当前手机静音状态，计时结束可能听不到响铃哦"];
    }
    LZDataModel *model = self.dataSource[indexPath.row];
    KaiShiJiShiViewController *kVc = [[KaiShiJiShiViewController alloc]init];
    kVc.model = model;
    kVc.isFromAppDelegate = @"NO";
    [self.navigationController pushViewController:kVc animated:YES];
}


#pragma mark - UIViewControllerPreviewingDelegate
-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *index = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    LZDataModel *model = self.dataSource[index.row];
    
    NewDaoJiShiViewController *showVC = [[NewDaoJiShiViewController alloc]init];
    showVC.model = model;
    showVC.isFromHistory = YES;
    CGRect rect = CGRectMake(0, 0,  previewingContext.sourceView.width, previewingContext.sourceView.height);
    previewingContext.sourceRect = rect;
    
    return showVC;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
//    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static   BOOL is = NO;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offSetY = scrollView.contentOffset.y;
    NSLog(@"=====%f",offSetY);
    


    if (offSetY == -(PCTopBarHeight+50)) {
        [BCShanNianKaPianManager maDaQingZhenDong];
    }
    
    if (offSetY < -(PCTopBarHeight +50)) {
        self.xiaLaLabel.text = @"松手创建新的计时器";
        NSLog(@"%f++++",offSetY);
        is = YES;
//        [BCShanNianKaPianManager maDaQingZhenDong];
    }else{
        self.xiaLaLabel.text = @"继续下拉创建新的计时器";
        NSLog(@"%f-------",offSetY);
    }
    
    if (is) {
        if (offSetY == 0) {
//            [BCShanNianKaPianManager maDaQingZhenDong];
//            NewDaoJiShiViewController *nvc = [[NewDaoJiShiViewController alloc]init];
//            [self.navigationController pushViewController:nvc animated:YES];
            
            CGPoint touchPoint = CGPointMake(ScreenWidth/2, 20);
            NewDaoJiShiViewController *circleVC = [[NewDaoJiShiViewController alloc]init];
            //    circleVC.isNeedShow = YES;
            [self hh_presentCircleVC:circleVC point:touchPoint completion:nil];
            
            is = NO;
        }
        
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除
    UITableViewRowAction *copyRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LZDataModel *model = self.dataSource[indexPath.row];
        
//        [self copyStringToUIPasteboardWithString:model.titleString];
        NSLog(@"点击了复制");
//        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
        
          NewDaoJiShiViewController *showVC = [[NewDaoJiShiViewController alloc]init];
           showVC.model = model;
           showVC.isFromHistory = YES;
           

        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
                CGRect rect = [tableView convertRect:rectInTableView toView:[tableView superview]];
        
                CGPoint touchPoint = CGPointMake(rect.origin.x + rect.size.width/2,rect.origin.y + rect.size.height/2);
                [self hh_presentCircleVC:showVC point:touchPoint completion:nil];
        
    }];
    copyRowAction.backgroundColor = PNCColorWithHex(0x1e1e1e);
    
    //置顶
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"点击了删除置顶");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据删除后,不可恢复,是否确定删除?" preferredStyle:UIAlertControllerStyleAlert];
        
        LZWeakSelf(ws)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:[ws.dataSource objectAtIndex:indexPath.row]];
            [ws.dataSource removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // 当为0时 删除分组?
            //        if (self.dataArray == 0) {
            //
            //            [LZSqliteTool LZDeleteFromGroupTable:LZSqliteGroupTableName element:self.groupModel];
            //        }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    topRowAction.backgroundColor = [UIColor redColor];
    //标记为已读
    UITableViewRowAction *readedRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"切换完成状态" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSLog(@"点击了标记为已读");
        LZDataModel *model = self.dataSource[indexPath.row];
        if ([model.nickName isEqualToString:@"0"]) {
            model.nickName = @"1";
        }else if ([model.nickName isEqualToString:@"1"]){
            model.nickName = @"0";
        }else{
            model.nickName = @"1";
        }
        
        [LZSqliteTool LZUpdateTable:LZSqliteDataTableName model:model];
        [self createDataSource];
        [self.tableView reloadData];
    }];
    readedRowAction.backgroundColor = PNCColorWithHex(0xdcdcdc);
    
    //    if(indexPath.section == 0 && indexPath.row == 0)
    //    {
    //        return @[deleteRowAction];
    //    }
    //    else if(indexPath.section == 0 && indexPath.row == 1)
    //    {
    //        return @[deleteRowAction, readedRowAction];
    //    }
    //    else if (indexPath.section == 1 && indexPath.row == 0)
    //    {
    //        return @[topRowAction];
    //    }
    //    else
    //    {
    return @[copyRowAction,topRowAction];
    //    }
}







//必须把编辑模式改成None，默认的是delete

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleNone;
    
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark 排序当移动了某一行时候会调用

//编辑状态下，只要实现这个方法，就能实现拖动排序---右侧会出现三条杠，点击三条杠就能拖动

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath

{
    
    // 取出要拖动的模型数据
    
    id goods = self.dataSource[sourceIndexPath.row];
    
    //删除之前行的数据
    
    [self.dataSource removeObject:goods];
    
    // 插入数据到新的位置
    
    [self.dataSource insertObject:goods atIndex:destinationIndexPath.row];
    
    
    for (int i = 0; i < self.dataSource.count; i ++) {
        LZDataModel *model = self.dataSource[i];
        [LZSqliteTool LZDeleteFromTable:LZSqliteDataTableName element:model];
        [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end
