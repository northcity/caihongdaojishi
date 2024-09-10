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

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
    [SVProgressHUD showWithStatus:@"加载中..."];
    [Bmob registerWithAppKey:@"075c9e426a01a48a81aa12305924e532"];
    NSMutableArray *returnArray = [[NSMutableArray alloc]init];
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"app_list"];
    bquery.limit = 100;
    bquery.skip = 0;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        if (error) {
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
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
                model.shunxu = [obj objectForKey:@"shunxu"];
                [returnArray addObject:model];
            }
            NSArray *resultNumArray = [returnArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                BCAppModel *model1 = obj1;
                BCAppModel *model2 = obj2;
                NSNumber *number1 = [NSNumber numberWithInt:[model1.shunxu intValue]];
                NSNumber *number2 = [NSNumber numberWithInt:[model2.shunxu intValue]];
                NSComparisonResult result = [number1 compare:number2];

                return  result == NSOrderedDescending; // 升序
                //        return  result == NSOrderedSame; // 不变
                //        return result == NSOrderedAscending;  // 降序
            }];
            NSMutableArray *retuArr = [[NSMutableArray alloc]initWithArray:resultNumArray];
            if (requestblock) {
                requestblock(retuArr,YES);
            }
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        }
    }];
}
@end
