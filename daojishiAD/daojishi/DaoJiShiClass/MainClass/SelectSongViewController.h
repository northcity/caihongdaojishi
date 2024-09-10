//
//  SelectSongViewController.h
//  daojishi
//
//  Created by 北城 on 2018/11/22.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelecteSongBlock)(NSString *songName);

@interface SelectSongViewController : UIViewController

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *sureBtn;

@property(nonatomic,copy)SelecteSongBlock songBlock;
@end
