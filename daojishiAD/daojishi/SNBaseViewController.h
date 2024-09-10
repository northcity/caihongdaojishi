//
//  SNBaseViewController.h
//  MyMemoryDebris
//
//  Created by 2345 on 2019/8/5.
//  Copyright © 2019 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SNBaseViewController : UIViewController

@property(nonatomic,strong)UILabel *navTitleLabel;
@property(nonatomic,strong)UIView *titleView;
@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;
- (void)initOtherUI;
@end

