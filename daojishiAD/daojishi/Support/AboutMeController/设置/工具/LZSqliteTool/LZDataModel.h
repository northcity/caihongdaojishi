//
//  LZDataModel.h
//  SqliteTest
//
//  Created by Artron_LQQ on 16/4/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LZDataModel : NSObject

@property (copy, nonatomic) NSString *nickName;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *urlString;//是否完成
@property (copy, nonatomic) NSString *dsc;//是否喜欢
@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *groupID;
@property (copy, nonatomic) NSString *email;

@property (copy, nonatomic) NSString *titleString;
@property (copy, nonatomic) NSString *contentString;
@property (copy, nonatomic) NSString *colorString;
@property (copy, nonatomic) NSString *pcmData;

@end
