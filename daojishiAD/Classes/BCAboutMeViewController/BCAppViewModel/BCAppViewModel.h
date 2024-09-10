//
//  BCAppViewModel.h
//  northcitytools
//
//  Created by chenxi on 2018/12/20.
//  Copyright © 2018 com.beicheng1. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^requestBlock)(NSMutableArray *dataSource,BOOL success);

@interface BCAppViewModel : NSObject

+(void)requestToGetAppDataWithBlock:(requestBlock)requestblock;

@end
