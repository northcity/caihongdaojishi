//
//  ShanNianSetTableViewCell.m
//  CutImageForYou
//
//  Created by chenxi on 2018/6/6.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import "ShanNianVoiceSetCell.h"

@implementation ShanNianVoiceSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(10), kAUTOWIDTH(5), ScreenWidth-kAUTOWIDTH(20), kAUTOWIDTH(50))];
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
            self.textLabel.font = [UIFont fontWithName:@"Heiti SC" size:kAUTOWIDTH(13)];
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
            
            
                                  
    [self createSubViews];
    [self updateSubViewsFrame];
    
}

- (void)createSubViews{
    self.selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ng_bps_fuceng_duigou"]];
    self.selectedImageView.hidden = YES;
    [self.label addSubview:self.selectedImageView];
}

- (void)updateSubViewsFrame {
    
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kAUTOWIDTH(10));
            make.width.mas_offset(40);
            make.height.mas_offset(21);
        }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(kAUTOWIDTH(-22));
        make.width.mas_offset(20);
        make.height.mas_offset(20);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
        if (selected) {
            self.selectedImageView.hidden = NO;
//            self.contentView.backgroundColor = PNCColorWithHex(0xF9FAFF);
    //        self.monthLabel.textColor = PNCColorWithHex(0x4586ff);
    
        }else{
            self.selectedImageView.hidden = YES;
    //        self.monthLabel.textColor = PNCColorWithHex(0x222222);
//            self.contentView.backgroundColor = PNCColorWithHex(0xFFFFFF);
    
        }
    // Configure the view for the selected state
}



@end

