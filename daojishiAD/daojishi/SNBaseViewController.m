//
//  SNBaseViewController.m
//  MyMemoryDebris
//
//  Created by 2345 on 2019/8/5.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import "SNBaseViewController.h"

@interface SNBaseViewController ()

@end

@implementation SNBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeZhiTiBaiSe) name:SN_BaiZHUTi object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeZhiTiHeiSe) name:SN_HeiZHUTi object:nil];


    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)changeZhiTiBaiSe{
//    self.titleView.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)changeZhiTiHeiSe{
//    self.view.backgroundColor = [UIColor blackColor];
//    self.titleView.backgroundColor = [UIColor blackColor];
}

- (void)initOtherUI{

    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.4f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];

    CGFloat shiPeiH = 0;
    if (PNCisIPHONEX) {
        shiPeiH = 8;
    }
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(150)/2, 22 + shiPeiH, kAUTOWIDTH(150), PCTopBarHeight - 22)];
    _navTitleLabel.text = @"标题党啥";
    _navTitleLabel.font = [UIFont boldSystemFontOfSize:kAUTOWIDTH(16)];
    _navTitleLabel.textColor = PNCColorWithHex(0x222222);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];

    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _leftBtn.frame = CGRectMake(20, 22 + shiPeiH + (PCTopBarHeight - 22)/2 - 12.5, 25, 25);
    [_titleView addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];

    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    _rightBtn.frame = CGRectMake(ScreenWidth - 20 - 25, 22 + shiPeiH + (PCTopBarHeight - 22)/2 - 12.5, 25, 25);
    [_titleView addSubview:_rightBtn];
    [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    
     if (@available(iOS 13.0, *)) {
         _titleView.backgroundColor = [UIColor systemBackgroundColor];
           UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                   if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                       return PNCColorWithHexA(0xdcdcdc, 0.9);
                   }else {
                       return PNCColorWithHexA(0xffffff, 0.5);
                   }
               }];
               
              _titleView.layer.shadowColor = backViewColor.CGColor;
         _navTitleLabel.textColor = [UIColor labelColor];

           } else {
               _titleView.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
               _titleView.backgroundColor = [UIColor whiteColor];
               _navTitleLabel.textColor = PNCColorWithHex(0x222222);

           }
}

- (void)backAction{

}

- (void)rightAction{

}

@end
