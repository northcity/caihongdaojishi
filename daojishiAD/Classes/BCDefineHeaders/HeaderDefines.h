//
//  HeaderDefines.h
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/12.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#ifndef HeaderDefines_h
#define HeaderDefines_h


//第三方库

#import <BmobSDK/Bmob.h>
#import "SVProgressHUD.h"
#import "Masonry.h"
#import "MFSideMenuContainerViewController.h"
#import "MainContentCell.h"
#import "YQMotionShadowView.h"
#import "BCShanNianKaPianManager.h"
#import "Factory.h"
#import "LZDataModel.h"
#import "LZSqliteTool.h"
#import "UIImage+ImageEffects.h"
#import "SDiPhoneVersion.h"
#import "UIImage+ImageEffects.h"
#import <Social/Social.h> // 导入苹果自带分享的头文件
#import "LZSqliteTool.h"
#import "LZDataModel.h"
#import "BCShanNianKaPianManager.h"
#import "UIColor+ColorHelper.h"
#import "UILabel+Extension.h"
//#import <APSDK/APPch.h>

//  Color
//////////////////////////////////////////////////

























//数据库表格
#define LZSqliteName @"userData"
#define LZSqliteDataTableName @"newUserAccountData"
#define LZSqliteGroupTableName @"userAccountGroup"
#define LZSqliteDataPasswordKey @"passwordKey"
//数据库数据有更新的通知key
#define LZSqliteValuesChangedKey @"sqliteValuesChanged"



#define current_SS   @"currentSouSuo"

#define SOU_SUO  @"SOUSUO"

#define current_ZHUTI   @"currentzhuti"

#define current_BEIJING @"ZHUTIBEIJING"

#define current_XIANSHILIEBIAO @"daiwanchengliebiao"

#define IS_NO_AD @"IS_NO_AD"


#endif /* HeaderDefines_h */
