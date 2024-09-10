//
//  HeaderDefines.h
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/12.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#ifndef HeaderDefines_h
#define HeaderDefines_h

//#import "YLGIFImage.h"
//#import "YLImageView.h"
#import "Factory.h"
#import "UIImage+ImageEffects.h"
#import <BmobSDK/Bmob.h>
//#import <GTSDK/GeTuiSdk.h>
#import "Masonry.h"

//#import "iCloudHandle.h"
//#import "IFlyMSC/IFlyMSC.h"
#import "ThirdPathKey.h"
#import <Social/Social.h> // 导入苹果自带分享的头文件
#import "LZSqliteTool.h"
#import "LZDataModel.h"
#import "BCShanNianKaPianManager.h"
//#import "ChuLiImageManager.h"

#import "UIColor+ColorHelper.h"
#import "UILabel+Extension.h"
#import "SDiPhoneVersion.h"
#import "YQMotionShadowView.h"

// iOS10 及以上需导  UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif


    //定义RGB值
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.f)
#define RandomColor RGB(arc4random()%256, arc4random()%256, arc4random()%256)

//44是一个特殊的常量，默认行高和NavigationBar的高度为44
#define Default 44
//距离左边边距为10
#define LeftDistance 10
//控件间的距离
#define ControlDistance 20
//定义屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - Color
#define WhiteColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]
#define BlueColor [UIColor blueColor]
#define YellowColor [UIColor yellowColor]
#define GreenColor [UIColor greenColor]
#define OrangeColor [UIColor orangeColor]
#define ClearColor [UIColor clearColor]
#define GrayColor [UIColor grayColor]
#define CyanColor [UIColor cyanColor]
#define SkyColor RGB(38, 187, 251)
#define RedColor [UIColor redColor]
#define FenSeColor RGB(255,189,180)


//  Color
//////////////////////////////////////////////////

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


/*
 *  iPhoneX判断
 */
#ifndef PNCisIPHONEX
#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO))
#endif

#ifndef PNCisIPAD
#define PNCisIPAD  ([[UIDevice currentDevice].model isEqualToString:@"iPad"]? (YES):(NO))
#endif


#define KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define kAUTOHEIGHT(_hei)      (PNCisIPHONEX ? _hei * 1 : _hei * ScreenHeight / 667.0)


// NSLocalizedString(key, comment) 本质
// NSlocalizeString 第一个参数是内容,根据第一个参数去对应语言的文件中取对应的字符串，第二个参数将会转化为字符串文件里的注释，可以传nil，也可以传空字符串@""。
#define NSLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define BCUserDeafaults [NSUserDefaults standardUserDefaults]














#define LZWeakSelf(ws) __weak typeof(self) ws = self;

#define LZWeak(sf, value) __weak typeof(value) sf = value;
//判断是否是ipad
#define isIpad ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

//判断是否是iphone6plus (高度)
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone6 (高度)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是iphone5(s) (高度)
#define iPhone5 isIphone5
//判断是否是iphone4 (高度)
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断是否是iphone5 (高度)
#define isIphone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define LZSCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define LZSCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

// Hex色值
#define LZColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//R G B 颜色
#define LZColorFromRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

//008e14 三叶草绿
//09c628
#define LZColorBase LZColorFromHex(0xffffff)
#define LZFontDefaulte [UIFont systemFontOfSize:14]
#define LZColorGray LZColorFromHex(0x555555)

#define LZNavigationHeight 64
#define LZTabBarHeight 49

//数据库表格
#define CXMEBDSJ  @"liebiao"
#define LZSqliteName @"userData"
#define LZSqliteDataTableName @"newUserAccountData"
#define LZSqliteGroupTableName @"userAccountGroup"
#define LZSqliteDataPasswordKey @"passwordKey"
//数据库数据有更新的通知key
#define LZSqliteValuesChangedKey @"sqliteValuesChanged"

#import "Masonry.h"
#import "MFSideMenuContainerViewController.h"
#import "SVProgressHUD.h"
#import "MainContentCell.h"

//是否ios7编译环境
#define BuildWithIOS7Flag YES

#ifndef PNCisIOS7Later
#define PNCisIOS7Later  !([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] == NSOrderedAscending)
#endif

#define PCTopBarHeight                      (PNCisIPHONEX ?88.0f:((BuildWithIOS7Flag && PNCisIOS7Later) ?64.0f:44.0f))


#define current_SS   @"currentSouSuo"

#define SOU_SUO  @"SOUSUO"

#define current_ZHUTI   @"currentzhuti"

#define current_BEIJING @"ZHUTIBEIJING"

#define current_XIANSHILIEBIAO @"daiwanchengliebiao"

#ifdef DEBUG
#define LZLog(s, ... ) NSLog( @"[%@：in line: %d]-->[message: %@]", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define LZLog(s, ... )
#endif


/**
 适配 给定4.7寸屏尺寸，适配4和5.5寸屏尺寸
 */
#define Suit55Inch           1.104
#define Suit4Inch            1.171875

/**
 适配 给定5.5寸屏尺寸，适配4和4.7寸屏尺寸
 */
//#define Suit47Inch           1.104
//#define Suit4Inch            1.29375

// 系统判定
#define IOS_VERSION    [[[UIDevice currentDevice]systemVersion]floatValue]
#define IS_IOS8        (IOS_VERSION>=8.0)
#define IS_IOS7        (IOS_VERSION>=7.0)
#define Is_IOS9        (IOS_VERSION>=9.0 && IOS_VERSION<10)

// 屏幕判定
#define IS_IPHONE35INCH  ([SDiPhoneVersion deviceSize] == iPhone35inch ? YES : NO)//4, 4S
#define IS_IPHONE4INCH  ([SDiPhoneVersion deviceSize] == iPhone4inch ? YES : NO)//5, 5C, 5S, SE
#define IS_IPHONE47INCH  ([SDiPhoneVersion deviceSize] == iPhone47inch ? YES : NO)//6, 6S, 7
#define IS_IPHONE55INCH ([SDiPhoneVersion deviceSize] == iPhone55inch ? YES : NO)//6P, 6SP, 7P


#define PNCisIOS11Later  (([[[UIDevice currentDevice] systemVersion] floatValue] >=11.0)? (YES):(NO))

/**
 *  定义弱引用
 */
#define PNCWeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self

/**
 *  定义弱、强引用
 */
#define kWeakSelf __weak typeof(self) weakSelf = self;
#define kStrongSelf __strong __typeof(&*weakSelf) strongSelf = weakSelf;


#endif /* HeaderDefines_h */
