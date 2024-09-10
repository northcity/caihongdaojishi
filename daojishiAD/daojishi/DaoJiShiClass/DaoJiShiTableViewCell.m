//
//  DaoJiShiTableViewCell.m
//  daojishi
//
//  Created by 北城 on 2018/9/11.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "DaoJiShiTableViewCell.h"

@implementation DaoJiShiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self updateFrame];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)createSubViews{

    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(15), 0, ScreenWidth - kAUTOWIDTH(30), kAUTOHEIGHT(120))];
    [self.contentView addSubview:self.bgView];
    
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bgView.frame;
    self.gradientLayer.colors = @[(id)[DaoJiShiTableViewCell toUIColorByStr:self.bgColor1].CGColor, (id)[DaoJiShiTableViewCell toUIColorByStr:self.bgColor2].CGColor];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = kAUTOHEIGHT(7);
    [self.contentView.layer insertSublayer:self.gradientLayer below:self.bgView.layer];
 
    _subLayer=[CALayer layer];
    CGRect fixframe=_bgView.layer.frame;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = 10;
    _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds=NO;
    _subLayer.shadowOffset=CGSizeMake(0,5);
    _subLayer.shadowOpacity=1.0f;
    _subLayer.shadowRadius=15;
    [self.contentView.layer insertSublayer:_subLayer below:self.gradientLayer];
//    DBLCDTempBlack
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(40)- (ScreenWidth - kAUTOWIDTH(80)), kAUTOHEIGHT(22), ScreenWidth - kAUTOWIDTH(80), kAUTOHEIGHT(40))];
    self.timeLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:36];
    self.timeLabel.textColor = WhiteColor;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.titleLabel.font = [UIFont fontWithName:@"FZSKBXKFW--GB1-0" size:18];
    self.titleLabel.textColor = WhiteColor;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 0;
    
    self.countLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    self.countLabel.font = [UIFont fontWithName:@"HeiTi SC" size:8];
    self.countLabel.alpha = 0.6 ;
    self.countLabel.textColor = WhiteColor;
    self.countLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.countLabel];
}

- (void)updateFrame{

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(kAUTOHEIGHT(22));
        make.left.mas_equalTo(self).offset(kAUTOWIDTH(40));
        make.width.mas_equalTo((ScreenWidth- kAUTOWIDTH(50))/2 - 10);
        make.height.mas_equalTo(kAUTOHEIGHT(44));
    }];

    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-kAUTOHEIGHT(25));
        make.left.mas_equalTo(self).offset(kAUTOWIDTH(40));
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(kAUTOHEIGHT(18));
    }];
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated: YES];
    
    if (editing) {
        
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString: @"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                      
                        UIImageView *iconImageView =  ((UIImageView *)subview);
                iconImageView.image = [UIImage imageNamed: @"排序4"];
                        iconImageView.frame = CGRectMake(0, -20, 25, 25);
                    }
                }
            }
        }
    }
}


- (void)cellSetContentViewWithModel:(LZDataModel *)model{
     self.bgColor2 = model.colorString ;
     self.bgColor1= model.nickName;

    self.timeLabel.text = model.pcmData;
    self.titleLabel.text = model.titleString;
    NSLog(@"%@=================我是",model.titleString);
    if (model.dsc.length == 0 || [model.dsc isEqualToString:@"0"]) {
        self.countLabel.hidden = YES;
    }else{
        self.countLabel.text = [NSString stringWithFormat:@"已完成%@次",model.dsc];
        self.countLabel.hidden = NO;
    }
    self.gradientLayer.colors =  self.gradientLayer.colors = @[(id)[DaoJiShiTableViewCell toUIColorByStr:self.bgColor1].CGColor, (id)[DaoJiShiTableViewCell toUIColorByStr:self.bgColor2].CGColor];
    
        _subLayer.shadowColor = [DaoJiShiTableViewCell toUIColorByStr:self.bgColor1].CGColor;

}

+ (UIColor*)toUIColorByStr:(NSString*)colorStr{
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
            green:((float) g / 255.0f)
            blue:((float) b / 255.0f) alpha:1.0f];
}

+(NSString*)toStrByUIColor:(UIColor*)color{
    
    CGFloat r, g, b, a;
    
    [color getRed:&r green:&g blue:&b alpha:&a];
    
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    
    return [NSString stringWithFormat:@"%06x", rgb];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
