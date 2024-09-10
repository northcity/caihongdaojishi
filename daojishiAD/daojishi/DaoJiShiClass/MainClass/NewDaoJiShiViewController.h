//
//  NewDaoJiShiViewController.h
//  daojishi
//
//  Created by 北城 on 2018/9/13.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"

@interface NewDaoJiShiViewController : UIViewController
@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;
//是否需要展示
@property (nonatomic, assign) BOOL isNeedShow;
//传进来的model
@property(nonatomic,strong)LZDataModel *model;
@property(nonatomic,assign) BOOL isFromHistory;

@end
