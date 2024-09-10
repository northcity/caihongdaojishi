//
//  BCAboutMeViewController.m
//  northcitytools
//
//  Created by 北城 on 2018/12/14.
//  Copyright © 2018年 com.beicheng1. All rights reserved.
//


#import "BCAboutMeViewController.h"
#import "BCCardView.h"
#import "BCAppTableViewCell.h"
#import "BCAppViewModel.h"

@interface BCAboutMeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) BCCardView *bcCardView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation BCAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMyTableView];
    [self initDataSource];
    [self createBackButton];
}

- (void)createBackButton{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(30), NC_kAUTOWIDTH(20), NC_kAUTOWIDTH(20));
    if (PNCisIPHONEX) {
        _backButton.frame = CGRectMake(NC_kAUTOWIDTH(15), NC_kAUTOWIDTH(42), NC_kAUTOWIDTH(20), NC_kAUTOWIDTH(20));
    }
    [_backButton setBackgroundImage:[UIImage imageNamed:@"northcityBundle.bundle/guanbi"] forState:UIControlStateNormal];
    _backButton.layer.cornerRadius = NC_kAUTOWIDTH(15);
    [_backButton addTarget:self action:@selector(dismissVc) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

- (void)dismissVc{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initDataSource{
    [BCAppViewModel requestToGetAppDataWithBlock:^(NSMutableArray *dataSource, BOOL success) {
        if (success) {
            self.dataSource = [[NSMutableArray alloc]init];
            self.dataSource = dataSource;
            [self.myTableView reloadData];
        }else{
            self.myTableView.hidden = YES;
        }
    }];
}

- (void)initMyTableView{
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:self.myTableView];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView registerClass:[BCAppTableViewCell class] forCellReuseIdentifier:@"BCAPPCELL"];

    if (@available(iOS 11.0, *)) {
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;

    self.bcCardView = [[BCCardView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NC_kAUTOWIDTH(284))];
    self.myTableView.tableHeaderView = self.bcCardView;
    self.bcCardView.blogButtonClickBlock = ^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.northcity.top/"]options:@{} completionHandler:nil];
    };

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return NC_kAUTOWIDTH(100);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierString = @"BCAPPCELL";
    BCAppTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierString forIndexPath:indexPath];
    BCAppModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    [cell setCellContentWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CATransform3D  transform;
    cell.transform = CGAffineTransformMakeScale(0.95f, 0.95f);
    // 弹簧动画，参数分别为：时长，延时，弹性（越小弹性越大），初始速度
    [UIView animateWithDuration: 0.7 delay:0.2 usingSpringWithDamping:0.3 initialSpringVelocity:0.3 options:0 animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
