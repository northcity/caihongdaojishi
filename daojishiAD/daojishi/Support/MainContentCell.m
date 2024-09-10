//
//  MainContentCell.m
//  NewRevenue
//
//  Created by 北城 on 16/8/31.
//  Copyright © 2016年 com.beicheng. All rights reserved.
//

#import "MainContentCell.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define DEF_UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MainContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label = [[UIView alloc]initWithFrame:CGRectMake(10, 5, ScreenWidth-20, 50)];
        if (@available(iOS 13.0, *)) {
            _label.backgroundColor = [UIColor systemBackgroundColor];
        } else {
            _label.backgroundColor = [UIColor whiteColor];
        }
        _label.layer.cornerRadius= 6;
//        _label.layer.shadowColor=[UIColor grayColor].CGColor;
        _label.layer.shadowOffset=CGSizeMake(0, 4);
        _label.layer.shadowOpacity=0.6f;
        _label.layer.shadowRadius=12;
        [self.contentView addSubview:_label];
        _label.alpha = 0.8;
        self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:13.f];
        if (@available(iOS 13.0, *)) {
            self.textLabel.textColor = [UIColor labelColor];
        } else {
            self.textLabel.textColor = PNCColorWithHexA(0x222222, 1);
        }
        
        
        if (@available(iOS 13.0, *)) {
                UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                       if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                           return PNCColorWithHexA(0xdcdcdc, 1);
                       }else {
                           return PNCColorWithHexA(0xffffff, 0.5);
                       }
                   }];
                   
                  _label.layer.shadowColor = backViewColor.CGColor;

               } else {
                   _label.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 1).CGColor;
               }
        
        
        self.redPointView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(110), 25 -5, 10, 10)];
        if (iPhone5) {
        self.redPointView.frame =CGRectMake(kAUTOWIDTH(130), 25 -5, 10, 10);

        }
        CAGradientLayer * gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 10, 10);
        gradientLayer.colors = @[(id)PNCColorWithHex(0xff5a71).CGColor, (id)PNCColorWithHex(0xff3554).CGColor];
        gradientLayer.locations = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.cornerRadius = 5;
        [self.redPointView.layer addSublayer:gradientLayer];
        [_label addSubview:self.redPointView];
        self.redPointView.hidden = YES;

        self.vipImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 63, 15, 20, 20)];
        self.vipImageView.image = [UIImage imageNamed:@"huiyuan-"];
        self.vipImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_label addSubview:self.vipImageView];
        self.vipImageView.hidden = YES;
        
        
        self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 15, 80, 20)];
        self.detailLabel.font = [UIFont systemFontOfSize:12];
        if (@available(iOS 13.0, *)) {
            self.detailLabel.textColor = [UIColor labelColor];
        } else {
            self.detailLabel.textColor = [UIColor blackColor];
        }
        [self.label addSubview:self.detailLabel];
        self.detailLabel.hidden = YES;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
