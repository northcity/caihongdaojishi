//
//  BCAppViewModel.m
//  northcitytools
//
//  Created by chenxi on 2018/12/20.
//  Copyright © 2018 com.beicheng1. All rights reserved.
//

#import "BCAppViewModel.h"
#import "BCAppModel.h"
#import "SVProgressHUD.h"
#import <BmobSDK/Bmob.h>

@implementation BCAppViewModel

+(void)requestToGetAppDataWithBlock:(requestBlock)requestblock{
    [Bmob registerWithAppKey:@"075c9e426a01a48a81aa12305924e532"];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"app_list"];
    bquery.limit = 100;
    bquery.skip = 0;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            if (requestblock) {
                requestblock(nil,NO);
            }
        }else{
        
        NSMutableArray *tmpArray = [NSMutableArray array];
        tmpArray = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
        for (int i  = 0; i < tmpArray.count; i ++ ) {
            BCAppModel *model = [[BCAppModel alloc]init];
            BmobObject *obj = tmpArray[i];
            model.appName  = [obj objectForKey:@"appName"];
            model.appDetailName = [obj objectForKey:@"appDetailName"];
            model.appVersion = [obj objectForKey:@"appVersion"];
            model.appIconName = [obj objectForKey:@"appIconName"];
            model.appUrlScheme = [obj objectForKey:@"appUrlScheme"];
            model.appid = [obj objectForKey:@"appid"];
            [returnArray addObject:model];
        }
        if (requestblock) {
            requestblock(returnArray,YES);
        }
        }
    }];
}
@end
