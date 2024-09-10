//
//  BCAppTableViewCell.h
//  northcitytools
//
//  Created by 北城 on 2018/12/14.
//  Copyright © 2018年 com.beicheng1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BCAppModel.h"

@interface BCAppTableViewCell : UITableViewCell

@property(nonatomic ,strong)UIImageView *appIconImageView;
@property(nonatomic ,strong)CALayer *appIconLayer;
@property(nonatomic ,strong)UILabel *appNameLabel;
@property(nonatomic ,strong)UILabel *appDetailNameLabel;
@property(nonatomic ,strong)UILabel *appVersionLabel;
//按钮
@property(nonatomic ,strong)UIButton *getButton;

@property(nonatomic, strong)BCAppModel *model;
- (void)setCellContentWithModel:(BCAppModel *)model;
@end
