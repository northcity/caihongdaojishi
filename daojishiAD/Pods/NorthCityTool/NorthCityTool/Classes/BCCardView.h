//
//  BCCardView.h
//  northcitytools
//
//  Created by 北城 on 2018/12/14.
//  Copyright © 2018年 com.beicheng1. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define NC_KAUTOSIZE(_wid,_hei)   CGSizeMake(_wid * ScreenWidth / 375.0, _hei * ScreenHeight / 667.0)
#define NC_kAUTOWIDTH(_wid)  _wid * ScreenWidth / 375.0
#define NC_kAUTOHEIGHT(_hei)      ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO) ? _hei * 1 : _hei * ScreenHeight / 667.0)
#define NC_PNCColor(r,g,b) NC_PNCColorRGBA(r,g,b,1.0)
#define NC_PNCColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#ifndef PNCisIPHONEX
#define PNCisIPHONEX  ((CGRectGetHeight([[UIScreen mainScreen] bounds]) >=812.0f)? (YES):(NO))
#endif

#ifndef PNCisIPAD
#define PNCisIPAD  ([[UIDevice currentDevice].model isEqualToString:@"iPad"]? (YES):(NO))
#endif
@interface BCCardView : UIView

@property (nonatomic, copy) dispatch_block_t  blogButtonClickBlock;
@end
