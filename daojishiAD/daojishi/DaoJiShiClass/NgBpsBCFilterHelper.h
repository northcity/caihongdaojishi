//
//  NgBpsBCFilterHelper.h
//  BankOfCommunications
//
//  Created by chenxi on 2018/4/28.
//  Copyright © 2018年 P&C Information. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NgBpsBCFilterHelper : NSObject
/**
 获取高度
 
 @param width 宽度
 @param text 文字
 @param font 字体
 @return 高度
 */
+ (CGFloat)getHeightByText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;

/**
 获取宽度
 
 @param text 文字
 @param font 字体
 @return 宽度
 */
+ (CGFloat)getWidthByText:(NSString *)text font:(UIFont *)font;


@end

