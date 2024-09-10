//
//  LZiCloudViewController.m
//  LZAccount
//
//  Created by Artron_LQQ on 2016/12/1.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZiCloudViewController.h"
#import "LZiCloud.h"
#import "LZSqliteTool.h"
#import "IATConfig.h"
//#import "LZiCloudDocument.h"

@interface LZiCloudViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)UITableView *tableView;

@property(nonatomic, assign)double chaZhi;
@end

@implementation LZiCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self setupNaviBar];
    [self initOtherUI];
    self.navTitleLabel.text = @"iCloud 设置";
    [self.leftBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];

    [self tableView];
    [self.view insertSubview:self.titleView aboveSubview:self.tableView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IATConfig *iaConfig = [IATConfig sharedInstance];
    iaConfig.laterIcoloudShiJianChuo = [LZiCloudViewController getNowTimeTimestamp];
    _chaZhi = [iaConfig.laterIcoloudShiJianChuo doubleValue] - [iaConfig.icoloudShiJianChuo doubleValue];
    NSLog(@"查的时间%f",_chaZhi);
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight, ScreenWidth, ScreenHeight - PCTopBarHeight) style:UITableViewStyleGrouped];
        
        table.delegate = self;
        table.dataSource = self;
        [self.view addSubview:table];
        _tableView = table;
        
        
//        [self.tableView registerNib:[UINib nibWithNibName:@"MainContentCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        if (@available(iOS 13.0, *)) {
              self.tableView.backgroundColor = [UIColor systemBackgroundColor];
          } else {
              self.tableView.backgroundColor = [UIColor whiteColor];
          }
            
    }
    
    return _tableView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_Height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cellid";
    MainContentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MainContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }

    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"同步到iCloud";
        
        if (!_shiJianChaLabel) {
            _shiJianChaLabel = [[UILabel alloc]init];
            _shiJianChaLabel.frame = CGRectMake(ScreenWidth - kAUTOWIDTH(65), 10, kAUTOWIDTH(50), 30);
            [cell.label addSubview:_shiJianChaLabel];
            NSString *text = [NSString stringWithFormat:@"%f",_chaZhi];
            _shiJianChaLabel.textAlignment = NSTextAlignmentRight;
            _shiJianChaLabel.font = [UIFont fontWithName:@"HeiTi SC" size:10];
//            _shiJianChaLabel.text = [NSString stringWithFormat:@"%@秒前自动同步",[text substringToIndex:5]];
            _shiJianChaLabel.adjustsFontSizeToFitWidth = YES;
            cell.imageView.image = [UIImage imageNamed:@"上传"];

        }
        
    } else {
        
        cell.textLabel.text = @"从iCloud同步";
        cell.imageView.image = [UIImage imageNamed:@"下载"];

    }
    
    return cell;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![LZiCloud iCloudEnable]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"iCloud不可用,请到\"设置--iCloud\"进行启用" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:ok];
//        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    if (indexPath.section == 0) {
        
        [SVProgressHUD show];
        
//        [LZiCloudDocument uploadToiCloudwithBlock:^(BOOL success) {
//            if (success) {
//                [SVProgressHUD showSuccessWithStatus:@"同步成功"];
//            } else {
//                [SVProgressHUD showErrorWithStatus:@"同步出错"];
//            }
//        }];
//        NSString *path = [LZSqliteTool LZCreateSqliteWithName:LZSqliteName];


        NSArray *pathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docPath = [pathArr firstObject];
        NSString *fileName = @"userData/userData.db";
        NSString *filePath = [docPath stringByAppendingPathComponent:fileName];
        
        [LZiCloud uploadToiCloud:filePath resultBlock:^(NSError *error) {
            if (error == nil) {
                [SVProgressHUD showInfoWithStatus:@"同步成功"];
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"同步出错"];
            }
            
        }];
    } else {
        
        [SVProgressHUD show];
//        [LZiCloudDocument downloadFromiCloudWithBlock:^(id obj) {
//            if (obj != nil) {
//
//                NSData *data = (NSData *)obj;
//
////                [data writeToFile:[LZSqliteTool LZCreateSqliteWithName:LZSqliteName] atomically:YES];
////                [data writeToFile:@"/Users/mac/Desktop/未命名文件夹/data.db" atomically:YES];
////                [SVProgressHUD showInfoWithStatus:@"同步成功"];
//                [SVProgressHUD showSuccessWithStatus:@"同步成功"];
//            } else {
//
//                [SVProgressHUD showErrorWithStatus:@"同步出错"];
//            }
//        }];
        [LZiCloud downloadFromiCloudWithBlock:^(id obj) {
            
            if (obj != nil) {
                
                NSData *data = (NSData *)obj;
                
                [data writeToFile:[LZSqliteTool LZCreateSqliteWithName:LZSqliteName] atomically:YES];
                [SVProgressHUD showInfoWithStatus:@"同步成功"];
            } else {
                
                [SVProgressHUD showErrorWithStatus:@"同步出错"];
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return @"注意: 同步到iCloud操作, 会覆盖已在iCloud的备份!";
    } else {
        
        return @"注意: 从iCloud同步到本地操作, 会覆盖本地已有的数据!";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
