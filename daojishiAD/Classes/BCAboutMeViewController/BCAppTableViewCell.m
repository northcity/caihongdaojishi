//
//  BCAppTableViewCell.m
//  northcitytools
//
//  Created by 北城 on 2018/12/14.
//  Copyright © 2018年 com.beicheng1. All rights reserved.
//

// *  iPhoneX判断
//
//#ifndef PNCisIPHONEX
//#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO))
//#endif
//
////定义屏幕宽度
//#define ScreenWidth [UIScreen mainScreen].bounds.size.width
////定义屏幕高度
//#define ScreenHeight [UIScreen mainScreen].bounds.size.height
////#pragma mark ====== 适配 ======
//
//#define KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
//#define kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
//#define kAUTOWIDTH(_hei)      (PNCisIPHONEX ? _hei * 1 : _hei * ScreenHeight / 667.0)
//
//////定义RGB值
//#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
//#define RGB(r, g, b) RGBA(r, g, b, 1.f)

#import "BCAppTableViewCell.h"
#import "BCHeader.h"

@implementation BCAppTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview{
    
    _appIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), kAUTOWIDTH(20), kAUTOWIDTH(60), kAUTOWIDTH(60))];
    //    iconImage.image = [UIImage imageNamed:@"iconcheng"];
    [self.contentView addSubview:_appIconImageView];
    _appIconImageView.layer.cornerRadius = kAUTOWIDTH(8);
    _appIconImageView.layer.masksToBounds = YES;
    _appIconLayer = [CALayer layer];
    CGRect fixframe=_appIconImageView.layer.frame;
    _appIconLayer.frame = fixframe;
    _appIconLayer.cornerRadius = kAUTOWIDTH(8);
    _appIconLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _appIconLayer.masksToBounds=NO;
    _appIconLayer.shadowColor=[UIColor grayColor].CGColor;
    _appIconLayer.shadowOffset=CGSizeMake(0,5);
    _appIconLayer.shadowOpacity = 0.6f;
    _appIconLayer.shadowRadius = 8;
    [self.contentView.layer insertSublayer:_appIconLayer below:_appIconImageView.layer];
    
    _appNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_appIconImageView.frame) + kAUTOWIDTH(20),kAUTOWIDTH(25),kAUTOWIDTH(150),kAUTOWIDTH(25))];
    _appNameLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15];
    _appNameLabel.textAlignment = NSTextAlignmentLeft;
    _appNameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_appNameLabel];
    
    _appDetailNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_appIconImageView.frame) + kAUTOWIDTH(20),CGRectGetMaxY(_appNameLabel.frame) + kAUTOWIDTH(5),kAUTOWIDTH(150),kAUTOWIDTH(18))];
    _appDetailNameLabel.font = [UIFont fontWithName:@"HeiTi SC" size:12];
    _appDetailNameLabel.textAlignment = NSTextAlignmentLeft;
    _appDetailNameLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_appDetailNameLabel];
    
    _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _getButton.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(98), kAUTOWIDTH(35.f), kAUTOWIDTH(70), kAUTOWIDTH(30));
    [_getButton setBackgroundColor:RGBA(238, 241, 249, 1)];
    [_getButton setTitleColor:RGBA(41, 130, 251, 1) forState:UIControlStateNormal];
    [_getButton setTitle:@"获取" forState:UIControlStateNormal];
    _getButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
    [_getButton addTarget:self action:@selector(awakeOrGetApp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview: _getButton];
    _getButton.layer.masksToBounds = YES;
    _getButton.layer.cornerRadius = kAUTOWIDTH(15);
    NSLog(@"===%@===",[self getCurrentAppUrlScheme]);
    
    _appVersionLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_getButton.frame),CGRectGetMaxY(_getButton.frame),kAUTOWIDTH(70),kAUTOWIDTH(15))];
    _appVersionLabel.font = [UIFont fontWithName:@"HeiTi SC" size:8];
    _appVersionLabel.textAlignment = NSTextAlignmentCenter;
    _appVersionLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_appVersionLabel];
}

- (void)awakeOrGetApp{
    
    //判断是否是自己
    NSString *getCurrentAppScheme = [self getCurrentAppUrlScheme];
    //    如果本地scheme和其中一个数据的一样，说明是本身App，按钮变为去评价和获取。
    if ([getCurrentAppScheme containsString:self.model.appUrlScheme]) {
        NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",self.model.appid];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl] options:@{} completionHandler:nil];
    }else{
        
        if ([self.model.appUrlScheme isEqualToString:@"chenxishijianjiaonang"]) {
            [self openAppWithAppID:@"1358237203"];
        } else if ([self.model.appUrlScheme isEqualToString:@"comchenxishijianguihuaju"]){
            [self openAppWithAppID:@"1445103466"];
        }else if ([self.model.appUrlScheme isEqualToString:@"comchenxijiugongge"]){
            [self openAppWithAppID:@"1383797480"];
        }else if ([self.model.appUrlScheme isEqualToString:@"comchenxijiyisuipian"]){
            [self openAppWithAppID:@"1397149726"];
        }else if ([self.model.appUrlScheme isEqualToString:@"comchenxiwanghouyusheng"]){
            [self openAppWithAppID:@"1419939043"];
        }else if ([self.model.appUrlScheme isEqualToString:@"comchenxicaihongdaojishi"]){
            [self openAppWithAppID:@"1436797708"];
        }else if ([self.model.appUrlScheme isEqualToString:@"com.chenxi.paizhaoshihua"]){
            [self openAppWithAppID:@"1439881374"];
        }else if ([self.model.appUrlScheme isEqualToString:@"sinaweibo"]){
            NSString *customURL = @"sinaweibo://userinfo?uid=5227295178";
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:customURL]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL] options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id350962117?mt=8"] options:@{} completionHandler:nil];
            }
        }else if ([self.model.appUrlScheme isEqualToString:@"zhihu"]){
            NSString *customURL = @"zhihu://people/chen-xi-18-69-64";
            if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:customURL]]){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL] options:@{} completionHandler:nil];
            }else{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.zhihu.com/people/chen-xi-18-69-64/activities"] options:@{} completionHandler:nil];
            }
        }
    }
}

//点击按钮传入不通过的Appid进行跳转
- (void)openAppWithAppID:(NSString *)appid{
    NSString *customURL = [NSString stringWithFormat:@"%@://",self.model.appUrlScheme];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:customURL]]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL] options:@{} completionHandler:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8",appid]] options:@{} completionHandler:nil];
    }
}

//获取当前App的URL_scheme
- (NSString *)getCurrentAppUrlScheme{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSDictionary *bundleUrltypes = [[infoDic objectForKey:@"CFBundleURLTypes"] firstObject];
    NSString *urlSchemes = [NSString stringWithFormat:@"%@",[bundleUrltypes objectForKey:@"CFBundleURLSchemes"]];
    
    if ([urlSchemes containsString:@"("] || [urlSchemes containsString:@")"] || [urlSchemes containsString:@"\n"] || [urlSchemes containsString:@" "]) {
        urlSchemes = [urlSchemes stringByReplacingOccurrencesOfString:@" " withString:@""];
        urlSchemes = [urlSchemes stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        urlSchemes = [urlSchemes stringByReplacingOccurrencesOfString:@"(" withString:@""];
        urlSchemes = [urlSchemes stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    return urlSchemes;
}

//给model赋值
- (void)setCellContentWithModel:(BCAppModel *)model{
    _appNameLabel.text = model.appName;
    _appDetailNameLabel.text = model.appDetailName;
    _appIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"northcityBundle.bundle/%@",model.appIconName]];
    _appVersionLabel.text = [NSString stringWithFormat:@"Version : %@",model.appVersion];
    //判断本地是否有App
    NSURL * myURL_APP_A = [NSURL URLWithString: [NSString stringWithFormat:@"%@://",model.appUrlScheme]];
    NSString *getCurrentAppScheme = [self getCurrentAppUrlScheme];
    
    //    如果本地scheme和其中一个数据的一样，说明是本身App，按钮变为去评价和获取。
    if ([getCurrentAppScheme containsString:model.appUrlScheme]) {
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [_getButton setTitle:@"去评价" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [_getButton setTitle:@"获取" forState:UIControlStateNormal];
        }
    }else if ([model.appUrlScheme containsString:@"sina"]){
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [_getButton setTitle:@"去关注" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [_getButton setTitle:@"获取" forState:UIControlStateNormal];
        }
    }else if ([model.appUrlScheme containsString:@"zhihu"]){
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [_getButton setTitle:@"去关注" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [_getButton setTitle:@"获取" forState:UIControlStateNormal];
        }
    }else{
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            NSLog(@"canOpenURL");
            [_getButton setTitle:@"打开" forState:UIControlStateNormal];
        }else{
            NSLog(@"不显示");
            [_getButton setTitle:@"获取" forState:UIControlStateNormal];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    NSLog(@"1");
    // Configure the view for the selected state
}

@end

