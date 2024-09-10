//
//  XMAutoScrollTextView.m
//  AlphaGoFinancial
//
//  Created by 千锋 on 16/6/27.
//  Copyright © 2016年 wxm. All rights reserved.
//

#import "XMAutoScrollTextView.h"
#import "NgBpsBCFilterHelper.h"

#define LABEL_TAG_INIT 10

//滚动时间间隔
#define SCROLL_TIME_INTERVAL 10

//每次滚动距离
#define SCROLL_DISTANCE 2

@implementation XMAutoScrollTextView

- (instancetype)initWithFrame:(CGRect)frame WithText:(NSString *)textString WithTextColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        _fontOfSize = 120;
        _textString = textString;
        _textColor = textColor;
        _fontName = @"DBLCDTempBlack";
        [self createContentOfScrollViewNew];
        //************自动滚动timer************
        self.contentOffset=CGPointMake(ScreenWidth, ScreenHeight);
//        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:SCROLL_TIME_INTERVAL target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//        //立即启动定时器
//        [timer setFireDate:[NSDate date]];
//        self.timer=timer;
        
//        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoScroll)];
//        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)layoutSubviews{
    CGFloat labelWidth = [NgBpsBCFilterHelper getWidthByText:_textString font: [UIFont fontWithName:_fontName size:_fontOfSize]] + kAUTOWIDTH(30);
                          _textLabel.frame = CGRectMake(0, 0, labelWidth , ScreenWidth);
}

-(void)createContentOfScrollViewNew{
    
    //创建contentView
    self.contentSize=CGSizeMake(ScreenHeight,ScreenWidth);
    //偏移量初值设为0
    self.contentOffset=CGPointMake(0, 0);
    //关闭指示条
    self.showsHorizontalScrollIndicator=NO;
    //创建label
    CGFloat labelY=0;
    CGFloat labelW=ScreenHeight;
    CGFloat labelH=ScreenWidth;
    //添加两次一样的内容，无限循环使用
    
    _textLabel=[[UILabel alloc] initWithFrame:CGRectMake(0 , 0, labelW, labelH)];
    _textLabel.text=self.textString;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor=self.textColor;
    _textLabel.font = [UIFont fontWithName:_fontName size:_fontOfSize];
//    _textLabel.font=[UIFont systemFontOfSize:self.fontOfSize];
    CGFloat labelWidth = [NgBpsBCFilterHelper getWidthByText:_textString font: [UIFont fontWithName:_fontName size:_fontOfSize]] + kAUTOWIDTH(30);
    _textLabel.frame = CGRectMake(ScreenHeight, 0, labelWidth , labelH);
    [self addSubview:_textLabel];
    _textLabel.backgroundColor = [UIColor clearColor];
    
    _jingZhiTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(labelW, 0, labelW, labelH)];
    _jingZhiTextLabel.text=self.textString;
    _jingZhiTextLabel.textAlignment = NSTextAlignmentCenter;
    _jingZhiTextLabel.textColor=self.textColor;
    _jingZhiTextLabel.numberOfLines = 0;
    _jingZhiTextLabel.font=[UIFont fontWithName:_fontName size:_fontOfSize];
    _jingZhiTextLabel.adjustsFontSizeToFitWidth = YES;
//    CGFloat labelWidth = [NgBpsBCFilterHelper getWidthByText:_textString font:[UIFont systemFontOfSize:_fontOfSize]];
//    _textLabel.frame = CGRectMake(ScreenHeight, 0, labelWidth , labelH);
    [self addSubview:_jingZhiTextLabel];
//    _jingZhiTextLabel.backgroundColor = [UIColor orangeColor];
    _jingZhiTextLabel.hidden = YES;
    
}

-(void)setFontOfSize:(CGFloat)fontOfSize{
    _fontOfSize = fontOfSize;
}


//自动滚动
- (void)autoScroll{
    
    //滚动速度
    CGFloat offSet=self.displayLinkDistance;
    
    //若果字幕滚动到第二部分重复的部分则把偏移置0，设为第一部分,实现无限循环
    if (self.contentOffset.x>=ScreenHeight + self.textLabel.frame.size.width) {
        self.contentOffset=CGPointMake(0, 0);
    }
//    NSLog(@"%lf",ScreenHeight + self.textLabel.frame.size.width);
    //切割每次动画滚动距离
    
//    [UIView animateWithDuration:SCROLL_TIME_INTERVAL delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
    self.contentOffset=CGPointMake(self.contentOffset.x+offSet, 0);
//    } completion:nil];
}
@end
