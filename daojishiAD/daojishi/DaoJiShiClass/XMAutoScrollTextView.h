//
//  XMAutoScrollTextView.h
//  AlphaGoFinancial
//
//  Created by 千锋 on 16/6/27.
//  Copyright © 2016年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMAutoScrollTextView : UIScrollView

/*初始化*/
- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)text WithTextColor:(UIColor *)textColor;

//字体大小
@property(nonatomic,assign) CGFloat fontOfSize;
@property(nonatomic,copy) NSString * fontName;

//定时器
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) UILabel * textLabel;
@property(nonatomic,copy) NSString * textString;
@property(nonatomic,strong) UIColor * textColor;

@property(nonatomic,strong)CADisplayLink *displayLink;
@property(nonatomic,assign)CGFloat displayLinkDistance;

@property(nonatomic,strong) UILabel * jingZhiTextLabel;

@end
