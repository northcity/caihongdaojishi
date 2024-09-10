//
//  BCAppModel.h
//  northcitytools
//
//  Created by chenxi on 2018/12/20.
//  Copyright © 2018 com.beicheng1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAppModel : NSObject
//app名字
@property (nonatomic, copy) NSString *appName;
//app副标题
@property (nonatomic, copy) NSString *appDetailName;
@property (nonatomic, copy) NSString *appIconName;
@property (nonatomic, copy) NSString *appVersion;

@property (nonatomic, copy) NSString *appUrlScheme;
@property (nonatomic, copy) NSString *appid;
@property (nonatomic, copy) NSString *shunxu;

@end
