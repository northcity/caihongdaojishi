//
//  NgBpsBCFilterHelper.m
//  BankOfCommunications
//
//  Created by chenxi on 2018/4/28.
//  Copyright © 2018年 P&C Information. All rights reserved.
//

#import "NgBpsBCFilterHelper.h"

@implementation NgBpsBCFilterHelper
/**
 获取高度
 
 @param width 宽度
 @param text 文字
 @param font 字体
 @return 高度
 */
+ (CGFloat)getHeightByText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = text;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

/**
 获取宽度
 
 @param text 文字
 @param font 字体
 @return 宽度
 */
+ (CGFloat)getWidthByText:(NSString *)text font:(UIFont *)font {
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAXFLOAT, 0)];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
}



@end

