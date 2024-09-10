//
//  NewDaoJiShiViewController.m
//  daojishi
//
//  Created by 北城 on 2018/9/13.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "NewDaoJiShiViewController.h"
#import "LZQSelectTime.h"
#import "UIViewController+HHTransition.h"
#import "UIView+HHLayout.h"
#import "SelectSongViewController.h"

#define DAMPING  12
#define STIFFNESS 100
#define MASS   1
#define  INITIALVE   1
#define Dur_Time  1

@interface NewDaoJiShiViewController ()<LZQPickerDelegate>
@property (nonatomic,strong)LZQSelectTime *picker;

@end

@implementation NewDaoJiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 13.0, *)) {
           self.view.backgroundColor = [UIColor systemBackgroundColor];
       } else {
           self.view.backgroundColor = [UIColor whiteColor];
       }
         
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self createSubViews];
        [BCShanNianKaPianManager maDaZhongJianZhenDong];
    });
    
    [self initOtherUI];
}

- (void)initOtherUI{
    self.navigationController.navigationBar.hidden = YES;
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    if (@available(iOS 13.0, *)) {
          _titleView.backgroundColor = [UIColor systemBackgroundColor];
      } else {
          _titleView.backgroundColor = [UIColor whiteColor];
      }    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
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
    if (PNCisIPHONEX) {
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(25), kAUTOWIDTH(200), kAUTOHEIGHT(66));
    }
    _navTitleLabel.text = @"NEW TIMER";
    _navTitleLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
    _navTitleLabel.textColor = PNCColorWithHex(0xFB409C);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    YQMotionShadowView *showLabel = [YQMotionShadowView fromView:_navTitleLabel];
    [_titleView addSubview:showLabel];
    
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}

- (void)createSubViews{
    
    _picker = [[LZQSelectTime alloc] initWithFrame:CGRectMake(0, PCTopBarHeight + 15, ScreenWidth, ScreenHeight - PCTopBarHeight - 15) andDelegate:self];
   
    if (_isFromHistory) {
        self.picker.model = self.model;
        _picker.isFromHistory = @"YES";
    }
    
    [_picker showWithFatherView:self.view];
    
  
    PNCWeakSelf(weakSelf);
    _picker.cancaleBlock = ^{
        
        CGPoint touchPoint = CGPointMake(ScreenWidth/2 - 100, ScreenHeight - 50);
        [weakSelf hh_dismissWithPoint:touchPoint completion:nil];

        [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOAD" object:nil];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    _picker.selectSongBlock = ^{
        SelectSongViewController *svc = [[SelectSongViewController alloc]init];
        svc.songBlock = ^(NSString *songName) {
            weakSelf.picker.songName = songName;
            weakSelf.picker.selectedSongLabel.text = songName;
            
            LZDataModel *model3 = [[LZDataModel alloc]init];

        };
        svc.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:svc animated:YES completion:nil];
    };
    
    _picker.sureBlock = ^(NSString *title,NSString *time, NSInteger timeValue, NSString *bgColor1, NSString *bgColor2 ,NSString *songName) {
       
        if (weakSelf.isFromHistory) {
            weakSelf.model.colorString = bgColor1;
            weakSelf.model.nickName = bgColor2;
            weakSelf.model.pcmData = time;
            weakSelf.model.urlString = [NSString stringWithFormat:@"%ld",(long)timeValue];
            weakSelf.model.dsc = @"0";
            weakSelf.model.titleString =title;//倒计时标题
            weakSelf.model.contentString = songName;//歌的名字

            [LZSqliteTool BCUpdateTable:LZSqliteDataTableName model:weakSelf.model];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOAD" object:nil];

        }else{
            LZDataModel *model3 = [[LZDataModel alloc]init];
            model3.colorString = bgColor1;//背景色1
            model3.nickName = bgColor2;//背景色2
            model3.pcmData = time;//时间
            model3.urlString = [NSString stringWithFormat:@"%ld",(long)timeValue];//秒数
            model3.dsc = @"0";
            model3.groupName = title;//倒计时标题
            model3.titleString =title;//倒计时标题
            model3.contentString = songName;//歌的名字
            [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RELOAD" object:nil];
        }
};
    
    
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"bounds"];
    //    springAnimation.fromValue = [NSValue valueWithCGRect:_yuLanTuImageView.frame];
    
    
    if (PNCisIPHONEX) {
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(30, 104, ScreenWidth - 60, ScreenHeight - 174)];
    }else{
        springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(-20, -20, ScreenWidth + 40, ScreenHeight +40)];
    }
    springAnimation.initialVelocity = INITIALVE;
    springAnimation.damping = DAMPING;
    springAnimation.stiffness = STIFFNESS;
    springAnimation.mass = MASS;
    springAnimation.duration = Dur_Time;
    
    //            springAnimation.additive = NO;
//    springAnimation.removedOnCompletion = NO;
//    springAnimation.fillMode = kCAFillModeForwards;
//    [self.picker.layer addAnimation:springAnimation forKey:@"positionAnimation"];
//    [self.yuLanTuImageView.layer addAnimation:springAnimation forKey:@"positionAnimation"];
    
    
    // 先缩小
    self.picker.transform = CGAffineTransformMakeScale(0.9, 0.9);
    
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.3 options:0 animations:^{
        // 放大
        self.picker.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
