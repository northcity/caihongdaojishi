//
//  AppDelegate.m
//  daojishi
//
//  Created by 北城 on 2018/9/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "AppDelegate.h"
#import "DaoJiShiViewController.h"
#import "NewDaoJiShiViewController.h"
#import "KaiShiJiShiViewController.h"
#import "LaunchViewController.h"

// 10.18
#import "LZGestureTool.h"
#import "LZGestureScreen.h"
#import "TouchIdUnlock.h"
#import "TouchIDScreen.h"

#import "LZSqliteTool.h"
#import "LZiCloud.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)showFristMessage{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstnewLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstnewLaunch"];
        [SVProgressHUD setMinimumDismissTimeInterval:12];
    
    }
}

- (void)jiaZaiVc{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    LaunchViewController *Lvc = [[LaunchViewController alloc]init];
    UINavigationController*nav = [[UINavigationController alloc]initWithRootViewController:Lvc];
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    if (PNCisIOS11Later) {
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    }
}

//创建本地通知
- (void)requestAuthor
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 设置通知的类型可以为弹窗提示,声音提示,应用图标数字提示
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        // 授权通知
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//  1436797708
    [self createMoBiWuSiAD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self showFristMessage];
    });
//    [self updateFromiCloud];
    [self verifyPassword];
    [self chuShiHuaBomb];
    [self jiaZaiVc];
    [self requestAuthor];
    [self createSqlite];
    // Override point for customization after application launch.
    [self setup3DTouch:application];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self createSqlite];
//    });

    return YES;
}

- (void)createMoBiWuSiAD{
    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
    }];
//    [[APSDK sharedInstance] initWithAppId:@"EqXZMByljeARexpY-YyAA8y"];
}


- (void)chuShiHuaBomb{
    
    [Bmob registerWithAppKey:@"075c9e426a01a48a81aa12305924e532"];
    
//                        //往GameScore表添加一条playerName为小明，分数为78的数据
//                        BmobObject *gameScore = [BmobObject objectWithClassName:@"appKaiGuan"];
//                        [gameScore setObject:@"开" forKey:@"caihgong_DAOJISHI"];
//                        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//    
//                        }];
    
    
    NSString *nowStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"KaiGuanShiFouDaKai"];
    
    if ([nowStatus isEqualToString:@"开"]) {
        
    }else{
        //查找GameScore表
        BmobQuery   *bquery = [BmobQuery queryWithClassName:@"appKaiGuan"];
        //查找GameScore表里面id为0c6db13c的数据
        [bquery getObjectInBackgroundWithId:@"6313080653" block:^(BmobObject *object,NSError *error){
            if (error){
                //进行错误处理
            }else{
                //表里有id为0c6db13c的数据
                if (object) {
                    //得到playerName和cheatMode
                    NSString *KaiGuanStatus = [object objectForKey:@"caihgong_DAOJISHI"];
                    NSLog(@"%@=========",KaiGuanStatus);
                    [[NSUserDefaults standardUserDefaults] setObject:KaiGuanStatus forKey:@"KaiGuanShiFouDaKai"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
        }];
    }
}


- (void)createSqlite {
    [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];
    [LZSqliteTool LZDefaultDataBase];
    [LZSqliteTool LZCreateDataTableWithName:LZSqliteDataTableName];
    [LZSqliteTool LZCreateGroupTableWithName:LZSqliteGroupTableName];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstCreateiCloud"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstCreateiCloud"];
        [self createData];
        
    }
    
}

- (void)createData{
    
        LZDataModel *model3 = [[LZDataModel alloc]init];
        model3.colorString = @"#60D6FF";
        model3.nickName = @"#26B8F5";
        model3.pcmData = @"00:05:00";
        model3.password = @"23:59:59";

    model3.urlString = @"300";
    
        model3.dsc = @"0";
        model3.groupName = @"煮鸡蛋";
        //    model3.groupID = group.identifier;
        model3.titleString = @"煮鸡蛋";
        model3.contentString = @"1";
        model3.email = @"";
//        model3.pcmData = @"";
        [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model3];
    
    
    LZDataModel *model2 = [[LZDataModel alloc]init];
    model2.colorString = @"#E39FBC";
    model2.nickName = @"#FD71A1";
    model2.pcmData = @"00:30:00";
    model2.password = @"23:59:59";

    model2.urlString = @"1800";
    
    model2.dsc = @"0";
    model2.groupName = @"打坐";
    //    model3.groupID = group.identifier;
    model2.titleString = @"打坐";
    model2.contentString = @"2";
    model2.email = @"";
//    model2.pcmData = @"";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model2];
    
    LZDataModel *model1 = [[LZDataModel alloc]init];
    model1.colorString =@"#FEC66C";
    model1.nickName = @"#FD985F";
    model1.pcmData = @"00:15:00";
    model1.password = @"23:59:59";

    model1.urlString = @"900";
    
    model1.dsc = @"0";
    model1.groupName = @"看书";
    //    model3.groupID = group.identifier;
    model1.titleString = @"看书";
    model1.contentString = @"3";
    model1.email = @"";
//    model1.pcmData = @"";
    [LZSqliteTool LZInsertToTable:LZSqliteDataTableName model:model1];
    
    
    
}

- (void)tongBuiCloud{
    
    NSString *path = [LZSqliteTool LZCreateSqliteWithName:LZSqliteDataTableName];
    NSLog(@"我是路径 === %@",path);
    [LZiCloud uploadToiCloud:path resultBlock:^(NSError *error) {
        if (error == nil) {
            NSLog(@"=====同步成功====");
        } else {
            NSLog(@"=====同步失败====");
        }
    }];
}

- (void)setup3DTouch:(UIApplication *)application{
    /**
     type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    
    
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSMutableArray *dataSource = [[NSMutableArray alloc]init];
    dataSource =  array.mutableCopy;
    
    LZDataModel *model1 = [[LZDataModel alloc]init];
    LZDataModel *model2 = [[LZDataModel alloc]init];
    LZDataModel *model3 = [[LZDataModel alloc]init];

  if (dataSource.count >= 3){
         model1 = dataSource[0];
         model2 = dataSource[1];
         model3 = dataSource[2];
    }
  

    //    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"标签.png"];
    
        UIApplicationShortcutIcon * icon0 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"dianying1"];
//    UIApplicationShortcutIcon *cameraIcon0 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeTime];
    UIApplicationShortcutItem *cameraItem0 = [[UIApplicationShortcutItem alloc] initWithType:@"typeOne" localizedTitle:model1.groupName localizedSubtitle:@"" icon:icon0 userInfo:nil];
    
    UIApplicationShortcutIcon * icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"zhaoxiangji1"];
    //    UIApplicationShortcutIcon *cameraIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *cameraItem1 = [[UIApplicationShortcutItem alloc] initWithType:@"typeTwo" localizedTitle:model2.groupName localizedSubtitle:@"" icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon * icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"shuji4"];
//    UIApplicationShortcutIcon *cameraIcon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeTime];
    UIApplicationShortcutItem *cameraItem2 = [[UIApplicationShortcutItem alloc] initWithType:@"typeThree" localizedTitle:model3.groupName localizedSubtitle:@"" icon:icon2 userInfo:nil];
    
    application.shortcutItems = @[cameraItem0,cameraItem1,cameraItem2];
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler

{
    NSArray* array = [LZSqliteTool LZSelectAllElementsFromTable:LZSqliteDataTableName];
    NSMutableArray *dataSource = [[NSMutableArray alloc]init];
    dataSource =  array.mutableCopy;
    
    LZDataModel *model1 = dataSource[0];
    LZDataModel *model2 = dataSource[1];
    LZDataModel *model3 = dataSource[2];
    
    if (dataSource.count >=3) {
        
    
  

    // 方式一：type
    
    if ([shortcutItem.type isEqualToString:@"typeOne"]) {
        
        KaiShiJiShiViewController *videoVC= [KaiShiJiShiViewController new];
        videoVC.model = model1;
        videoVC.isFromAppDelegate = @"YES";
        [self.window.rootViewController presentViewController:videoVC animated:YES completion:nil];
        
        NSLog(@"点击了添加机会item");
//        [SVProgressHUD showWithStatus:@"打坐"];

    } else if ([shortcutItem.type isEqualToString:@"typeTwo"]) {
        KaiShiJiShiViewController *videoVC= [KaiShiJiShiViewController new];
        videoVC.model = model2;
        videoVC.isFromAppDelegate = @"YES";
        [self.window.rootViewController presentViewController:videoVC animated:YES completion:nil];
        NSLog(@"点击了添加小记item");
//        [SVProgressHUD showWithStatus:@"读书"];
        
    }else if ([shortcutItem.type isEqualToString:@"typeThree"]) {
        KaiShiJiShiViewController *videoVC= [KaiShiJiShiViewController new];
        videoVC.model = model3;
        videoVC.isFromAppDelegate = @"YES";
        [self.window.rootViewController presentViewController:videoVC animated:YES completion:nil];
        NSLog(@"点击了添加小记item");
        //        [SVProgressHUD showWithStatus:@"读书"];
    }
    else {
        NSLog(@"点击了搜索客户item");
    }
    }
}


- (void)verifyPassword {

    if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotByUser] && [LZGestureTool isGestureEnable]) {
        [[TouchIDScreen shared] show];
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                [[TouchIDScreen shared] dismiss];
                [BCShanNianKaPianManager maDaQingZhenDong];
            }];
        }
    }else if ([[TouchIdUnlock sharedInstance] isTouchIdEnabledOrNotByUser]){
        [[TouchIDScreen shared] show];
        if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
            [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                [[TouchIDScreen shared] dismiss];
                [BCShanNianKaPianManager maDaQingZhenDong];
            }];
        }
    }else if ( [LZGestureTool isGestureEnable]){
        [[LZGestureScreen shared] show];
                if ([[TouchIdUnlock sharedInstance] canVerifyTouchID]) {
                    [[TouchIdUnlock sharedInstance] startVerifyTouchID:^{
                        [[LZGestureScreen shared] dismiss];
                    }];
                }
    }
}

-(void)updateFromiCloud{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstiCloud"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstiCloud"];
        //第一次启动
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LZiCloud downloadFromiCloudWithBlock:^(id obj) {



                if (obj != nil) {

                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"检测到您的iCloud数据" message:@"是否同步到本地" preferredStyle:UIAlertControllerStyleAlert];



                    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            [self createSqlite];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter]postNotificationName:@"firstRELOAD" object:nil];
                        });
//                        [SVProgressHUD showWithStatus:@"加载中..."];

                        NSLog(@"点击取消");

                    }]];



                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {


                        NSData *data = (NSData *)obj;
                        [data writeToFile:[LZSqliteTool LZCreateSqliteWithName:LZSqliteDataTableName] atomically:YES];
//                        [SVProgressHUD showInfoWithStatus:@"同步成功"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"firstRELOAD" object:nil];

                    }]];


//
//                    [alertController addAction:[UIAlertAction actionWithTitle:@"警告" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//
//                        NSLog(@"点击警告");
//
//                    }]];



//                    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//
//                        NSLog(@"添加一个textField就会调用 这个block");
//
//                    }];



                    // 由于它是一个控制器 直接modal出来就好了

                    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
                    alertWindow.rootViewController = [[UIViewController alloc] init];
                    alertWindow.windowLevel = UIWindowLevelAlert + 1;
                    [alertWindow makeKeyAndVisible];
                    [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];


                } else {



                    [self createSqlite];

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"firstRELOAD" object:nil];
                    });

//                    [SVProgressHUD showErrorWithStatus:@"同步出错"];

                }
            }];
        });
    }
}
























- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self verifyPassword];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"daojishi"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
