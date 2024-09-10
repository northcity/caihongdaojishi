//
//  LZQSelectTime.h
//  SelectTimeTest
//
//  Created by 路准晴 on 16/10/18.
//  Copyright © 2016年 luzhunqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LZDataModel.h"

typedef void(^SureBlock)(NSString *title, NSString *time,NSInteger timeValue,NSString *bgColor1,NSString *bgColor2,NSString *songName);

typedef NS_ENUM(NSInteger, colorStyle) {
    colorStyleOne = 0,
    colorStyleTwo,
    colorStyleThree,
    colorStyleFour,
    colorStyleFive
};
@protocol LZQPickerDelegate <NSObject>
@optional
//这几个方法任意选择 determin两个选择其中一个即可

//改变了
- (void)changeTime:(NSString *)time;
//确定选择 返回时间字符串
- (void)determinSelected:(NSString *)time;
//确定选择  返回秒数
- (void)determinReturnSencond:(NSInteger)count;
@end

@interface LZQSelectTime : UIView<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>

@property (nonatomic,assign)id<LZQPickerDelegate> delegate;
//时间选择View
@property(nonatomic,strong)UIPickerView *pickerView;
@property(nonatomic,strong)CALayer *subLayer;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *cancleButton;
@property (nonatomic,strong)UIButton *determineButton;
@property (nonatomic,copy)NSArray   *hoursArray;
@property (nonatomic,copy)NSArray   *minuteArray;
@property (nonatomic,copy)NSArray   *secondArray;
@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UIImageView *imageView3;
@property(nonatomic,strong)UIImageView *imageView4;
@property(nonatomic,strong)UIImageView *imageView5;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic, strong)CAGradientLayer *gradientLayer;
@property(nonatomic,copy)NSString *bgColor1;
@property(nonatomic,copy)NSString *bgColor2;
@property(nonatomic,strong)UILabel *titleHeaderaLabel;
@property(nonatomic,strong)UITextField *timeThingTextField;
@property (nonatomic,strong)UILabel *songLabel;
@property (nonatomic,strong)UILabel *selectedSongLabel;
//选择的歌曲的名字
@property (nonatomic,copy)NSString *songName;
@property(nonatomic,copy)SureBlock sureBlock;
@property(nonatomic,copy)dispatch_block_t cancaleBlock;
//选择歌曲block
@property(nonatomic,copy)dispatch_block_t selectSongBlock;
@property(nonatomic,copy)NSString *isFromHistory;
//传进来的历史数据
@property(nonatomic,strong)LZDataModel *model;

//类方法创建
+(instancetype)datePickerViewWithDelegate:(id)delegate;
//实例方法创建
- (instancetype)initWithFrame:(CGRect)frame  andDelegate:(id)delegate;
- (void)showWithFatherView:(UIView *)view;

@end
