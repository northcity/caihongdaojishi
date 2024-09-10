//
//  LZQSelectTime.m
//  SelectTimeTest
//
//  Created by 路准晴 on 16/10/18.
//  Copyright © 2016年 luzhunqing. All rights reserved.
//

#import "LZQSelectTime.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height

#define HOUR @"时"
#define MINUTE @"分"
#define SECOND @"秒"

@implementation LZQSelectTime

+(instancetype)datePickerViewWithDelegate:(id)delegate{
    LZQSelectTime *selectTime = [[LZQSelectTime alloc] initWithFrame:[UIScreen mainScreen].bounds  andDelegate:delegate];
    return selectTime;
}

- (void)setModel:(LZDataModel *)model{
    _model = model;
}
- (void)setIsFromHistory:(NSString *)isFromHistory{
    if ([isFromHistory isEqualToString:@"YES"]) {
        self.bgColor1 = self.model.colorString;
        self.bgColor2 = self.model.nickName;
        self.songName = self.model.contentString;
        self.selectedSongLabel.text = self.model.contentString;
        
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
        self.timeThingTextField.text = self.model.titleString;
        NSLog(@"======%@======",self.model.password);
        NSInteger hour = [[self.model.pcmData substringWithRange:NSMakeRange(0, 2)] integerValue];
        NSInteger minute = [[self.model.pcmData substringWithRange:NSMakeRange(3, 2)] integerValue];
        NSInteger second = [[self.model.pcmData substringWithRange:NSMakeRange(6, 2)] integerValue];

        [self.pickerView selectRow:hour inComponent:0 animated:YES];
        [self.pickerView selectRow:minute inComponent:1 animated:YES];
        [self.pickerView selectRow:second inComponent:2 animated:YES];
        [self.pickerView reloadAllComponents];
    }else{
        self.bgColor1 = @"#60D6FF";
        self.bgColor2 = @"#26B8F5";
        self.songName = @"欢快的音乐1";
    }
}

- (instancetype)initWithFrame:(CGRect)frame  andDelegate:(id)delegate{
    if (frame.size.width>frame.size.height){
        float a = frame.size.height;
        frame.size.height = frame.size.width;
        frame.size.height = a;
    }
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor whiteColor];
        
        if (@available(iOS 13.0, *)) {
              self.backgroundColor = [UIColor systemBackgroundColor];
          } else {
              self.backgroundColor = [UIColor whiteColor];
          }
        
        self.bgColor1 = @"#60D6FF";
        self.bgColor2 = @"#26B8F5";
        self.songName = @"欢快的音乐1";
        self.delegate = delegate;
        [self initColorSelectedView];
        [self initializationPickerView];
        [self initializationTopView];
        [self initializationCancleButton];
        [self initializationDetermineButton];
        _hoursArray = [[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
         _minuteArray = [[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
         _secondArray = [[NSArray alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    }
    return self;
}

#pragma mark ====== 添加选择颜色视图 ======
- (void)initColorSelectedView{
    
    self.timeThingTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 15, ScreenWidth - 40, 44)];
    self.timeThingTextField.placeholder = @"请备注您的计时器";
    self.timeThingTextField.layer.shadowColor=[UIColor grayColor].CGColor;
     self.timeThingTextField.layer.shadowOffset=CGSizeMake(0,4);
     self.timeThingTextField.layer.shadowOpacity=0.4f;
     self.timeThingTextField.layer.shadowRadius= 12;
    self.timeThingTextField.layer.cornerRadius = 7;
    
    if (PNCisIOS13Later) {
        self.timeThingTextField.textColor = [UIColor labelColor];

    }else{
        self.timeThingTextField.textColor = PNCColorWithHex(0x1e1e1e);

    }
    self.timeThingTextField.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    [self addSubview:self.timeThingTextField];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kAUTOWIDTH(20), CGRectGetMaxY(self.timeThingTextField.frame) + kAUTOWIDTH(20), SCREEN_WIDTH - kAUTOWIDTH(40), kAUTOHEIGHT(128))];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.layer.cornerRadius = kAUTOWIDTH(7);
    self.imageView.layer.masksToBounds = YES;
    [self addSubview:self.imageView];
    CALayer *imageViewLayer = [CALayer layer];
    CGRect fixframe=self.imageView.layer.frame;
    imageViewLayer.frame = fixframe;
    imageViewLayer.cornerRadius =  kAUTOWIDTH(7);
    imageViewLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    imageViewLayer.masksToBounds=NO;
    imageViewLayer.shadowColor=[UIColor grayColor].CGColor;
    imageViewLayer.shadowOffset=CGSizeMake(0,4);
    imageViewLayer.shadowOpacity=0.4f;
    imageViewLayer.shadowRadius=  kAUTOWIDTH(12);
    [self.layer insertSublayer:imageViewLayer below:self.imageView.layer];
    
    for (int i = 0; i < 21; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.backgroundColor = [UIColor redColor];
        button.frame = CGRectMake(15 + 50 *i, (7) +(37) *(int)(i/7), (30), (30));
        if (i >= 7 ) {
            button.frame = CGRectMake((15) + (50) *(i - 7), (7) +(37) *(int)(i/7), (30), (30));
        }
        if (i >= 14) {
            button.frame = CGRectMake((15) + (50) *(i - 14), (7) +(37) *(int)(i/7), (30), (30));
        }
        
        if ([[UIScreen mainScreen] bounds].size.width == 375.0f) {
            button.frame = CGRectMake(kAUTOWIDTH(15) + kAUTOWIDTH(47)  *i, kAUTOWIDTH(7) +kAUTOWIDTH(37)  *(int)(i/7), kAUTOWIDTH(30), kAUTOHEIGHT(30));
            if (i >= 7 ) {
                button.frame = CGRectMake(kAUTOWIDTH(15)  + kAUTOWIDTH(47) *(i - 7), kAUTOWIDTH(7) +kAUTOWIDTH(37)  *(int)(i/7), kAUTOWIDTH(30), kAUTOHEIGHT(30));
            }
            if (i >= 14) {
                button.frame = CGRectMake(kAUTOWIDTH(15)  + kAUTOWIDTH(47) *(i - 14), kAUTOWIDTH(7) +kAUTOWIDTH(37) *(int)(i/7), kAUTOWIDTH(30), kAUTOHEIGHT(30));
            }
        }
//        适配iphone5
        if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
            button.frame = CGRectMake(kAUTOWIDTH(15) + kAUTOWIDTH(45) *i, kAUTOWIDTH(7) +kAUTOWIDTH(37) *(int)(i/7), 24, 24);
            if (i >= 7 ) {
                button.frame = CGRectMake(kAUTOWIDTH(15) + kAUTOWIDTH(45) *(i - 7), kAUTOWIDTH(7) +kAUTOWIDTH(37) *(int)(i/7), 24, 24);
            }
            if (i >= 14) {
                button.frame = CGRectMake(kAUTOWIDTH(15) + kAUTOWIDTH(45) *(i - 14), kAUTOWIDTH(7) +kAUTOWIDTH(37) *(int)(i/7), 24, 24);
            }
            button.layer.cornerRadius = 12;

        }
        
        
        
        button.layer.cornerRadius = kAUTOWIDTH(15);
      
        button.layer.masksToBounds = YES;
        button.tag = 200 + i;
        [button addTarget:self action:@selector(colorButtonClickWith:) forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:button];
        
        
        NSString *bgColor1 = @"";
        NSString *bgColor2 = @"";
        
        if (i == 0) {
            bgColor1 = @"#60D6FF";
            bgColor2 = @"#26B8F5";
        }
    
        if (i == 1) {
            bgColor1 = @"#FCA2C1";
            bgColor2 = @"#FD71A1";
        }
        
        if (i == 2) {
            bgColor1 = @"#FEC66C";
            bgColor2 = @"#FD985F";
        }
        if (i == 3) {
            bgColor1 = @"#ffdde1";
            bgColor2 = @"#ee9ca7";
        }
        if (i == 4) {
            bgColor1 = @"#e0eafc";
            bgColor2 = @"#cfdef3";
        }
    
        if (i == 5) {
            bgColor1 = @"#dae2f8";
            bgColor2 = @"#d6a4a4";
        }
        
        if (i == 6) {
            bgColor1 = @"#fdfc47";
            bgColor2 = @"#24fe41";
        }
        
        if (i == 7) {
            bgColor1 = @"#efefbb";
            bgColor2 = @"#d4d3dd";
        }
        
        if (i == 8) {
            bgColor1 = @"#00c9ff";
            bgColor2 = @"#92fe9d";
        }
        
#pragma mark - 20181130添加-
        if (i == 9) {
            bgColor1 = @"#EC8C69";
            bgColor2 = @"#ED6EA0";
        }
        if (i == 10) {
            bgColor1 = @"#FF9A9E";
            bgColor2 = @"#FAD0C4";
        }
        if (i == 11) {
            bgColor1 = @"#A18CD1";
            bgColor2 = @"#FBC2EB";
        } if (i == 12) {
            bgColor1 = @"#FAD0C4";
            bgColor2 = @"#FFD1FF";
        } if (i == 13) {
            bgColor1 = @"#A5C0EE";
            bgColor2 = @"#FBC5EC";
        } if (i == 14) {
            bgColor1 = @"#FF989C";
            bgColor2 = @"#FECFEF";
        } if (i == 15) {
            bgColor1 = @"#F5576C";
            bgColor2 = @"#F093FB";
        } if (i == 16) {
            bgColor1 = @"#DDD6F3";
            bgColor2 = @"#FAACA8";
        } if (i == 17) {
            bgColor1 = @"#000000";
            bgColor2 = @"#000000";
        } if (i == 18) {
            bgColor1 = @"#B721FF";
            bgColor2 = @"#21D4FD";
        } if (i == 19) {
            bgColor1 = @"#7873F5";
            bgColor2 = @"#EC77AB";
        } if (i == 20) {
            bgColor1 = @"#000000";
            bgColor2 = @"#434343";
        } if (i == 21) {
            bgColor1 = @"#000000";
            bgColor2 = @"#000000";
        }
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = button.frame;
        gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:bgColor2].CGColor];
        gradientLayer.locations = @[@(0),@(1)];
        gradientLayer.startPoint = CGPointMake(0, 0.5);
        gradientLayer.endPoint = CGPointMake(1, 0.5);
        gradientLayer.cornerRadius = 15;
        [self.imageView.layer insertSublayer:gradientLayer below:button.layer];
    
    
    }
}

- (void)colorButtonClickWith:(UIButton *)button{
    if (button.tag == 200) {
        self.bgColor1 = @"#60D6FF";
        self.bgColor2 = @"#26B8F5";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag == 201) {
       self.bgColor1 = @"#FCA2C1";
        self.bgColor2 = @"#FCA2C1";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag == 202) {
        self.bgColor1 = @"#FEC66C";
        self.bgColor2 = @"#FD985F";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    if (button.tag == 203) {
        self.bgColor1 = @"#ffdde1";
        self.bgColor2 = @"#ee9ca7";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    
    if (button.tag == 204) {
        self.bgColor1 = @"#e0eafc";
        self.bgColor2 = @"#cfdef3";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag == 205) {
        self.bgColor1 = @"#dae2f8";
        self.bgColor2 = @"#d6a4a4";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag  == 206) {
        self.bgColor1 = @"#fdfc47";
        self.bgColor2 = @"#24fe41";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag  == 207) {
        self.bgColor1 = @"#efefbb";
        self.bgColor2 = @"#d4d3dd";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];

    }
    
    if (button.tag  == 208) {
        self.bgColor1 = @"#00c9ff";
        self.bgColor2 = @"#92fe9d";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    
#pragma mark ====新添加颜色=====
    if (button.tag  == 209) {
        self.bgColor1 = @"#EC8C69";
        self.bgColor2 = @"#ED6EA0";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    
    if (button.tag  == 210) {
        self.bgColor1 = @"#FF9A9E";
        self.bgColor2 = @"#FAD0C4";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }

    
    
    if (button.tag  == 211) {
        self.bgColor1 = @"#A18CD1";
        self.bgColor2 = @"#FBC2EB";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 212) {
        self.bgColor1 = @"#FAD0C4";
        self.bgColor2 = @"#FFD1FF";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 213) {
        self.bgColor1 = @"#A5C0EE";
        self.bgColor2 = @"#FBC5EC";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 214) {
        self.bgColor1 = @"#FF989C";
        self.bgColor2 = @"#FECFEF";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 215) {
        self.bgColor1 = @"#F5576C";
        self.bgColor2 = @"#F093FB";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 216) {
        self.bgColor1 = @"#DDD6F3";
        self.bgColor2 = @"#FAACA8";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 217) {
        self.bgColor1 = @"#000000";
        self.bgColor2 = @"#000000";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 218) {
        self.bgColor1 = @"#B721FF";
        self.bgColor2 = @"#21D4FD";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 219) {
        self.bgColor1 = @"#7873F5";
        self.bgColor2 = @"#EC77AB";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 220) {
        self.bgColor1 = @"#000000";
        self.bgColor2 = @"#434343";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
    if (button.tag  == 221) {
        self.bgColor1 = @"#000000";
        self.bgColor2 = @"#000000";
        self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    }
}

- (int)showColorWithColorStyle:(colorStyle)colorStyle{
    switch (colorStyle) {
        case colorStyleOne:
            return 0;
            break;
        case colorStyleTwo:
            return 1;
            break;
        case colorStyleThree:
            return 2;
            break;
        case colorStyleFour:
            return 3;
            break;
        case colorStyleFive:
            return 4;
            break;
        default:
            break;
    }
    return 0;
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

- (void)initializationPickerView
{
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 30, VIEW_WIDTH - 40, 188)];
    if ([[UIScreen mainScreen] bounds].size.height == 568.0f) {
     self.pickerView.frame = CGRectMake(20, CGRectGetMaxY(self.imageView.frame) + 30, VIEW_WIDTH - 40, kAUTOHEIGHT(188));
    }
    
 
  

    
    _pickerView.delegate = self;
//    _pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.layer.cornerRadius = 12;
    self.pickerView.layer.masksToBounds = YES;
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.pickerView.frame;
    [self changeSpearatorLineColor];
 
    self.gradientLayer.colors = @[(id)[LZQSelectTime toUIColorByStr:self.bgColor1].CGColor, (id)[LZQSelectTime toUIColorByStr:self.bgColor2].CGColor];
    self.gradientLayer.locations = @[@(0),@(1)];
    self.gradientLayer.startPoint = CGPointMake(0, 0.5);
    self.gradientLayer.endPoint = CGPointMake(1, 0.5);
    self.gradientLayer.cornerRadius = 12;
    [self.layer insertSublayer:self.gradientLayer below:self.pickerView.layer];
    
    _subLayer=[CALayer layer];
    CGRect fixframe=self.pickerView.layer.frame;
    _subLayer.frame = fixframe;
    _subLayer.cornerRadius = 12;
    _subLayer.backgroundColor=[[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
    _subLayer.masksToBounds=NO;
    _subLayer.shadowColor=[UIColor grayColor].CGColor;
    _subLayer.shadowOffset=CGSizeMake(0,4);
    _subLayer.shadowOpacity=0.4f;
    _subLayer.shadowRadius= 12;
    [self.layer insertSublayer:_subLayer below:self.gradientLayer];
    
    [self addSubview:_pickerView];
    
    self.songLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,  CGRectGetMaxY(self.pickerView.frame) + kAUTOHEIGHT(25), ScreenWidth, kAUTOHEIGHT(44))];
    self.songLabel.text = @"   计时结束时启用";
    self.songLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    
    
    
    if (@available(iOS 13.0, *)) {
          self.songLabel.backgroundColor = [UIColor systemBackgroundColor];
        self.songLabel.textColor = [UIColor labelColor];

      } else {
          self.songLabel.backgroundColor = [UIColor whiteColor];
          self.songLabel.textColor = [UIColor blackColor];

      }
    
    self.songLabel.textAlignment = NSTextAlignmentLeft;
    self.songLabel.userInteractionEnabled = YES;
    [self addSubview:self.songLabel];
    
    
    self.songLabel.layer.shadowColor=[UIColor grayColor].CGColor;
    self.songLabel.layer.shadowOffset=CGSizeMake(0, 4);
    self.songLabel.layer.shadowOpacity=0.4f;
    self.songLabel.layer.shadowRadius=12;
    
    if (@available(iOS 13.0, *)) {
    UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return PNCColorWithHexA(0xdcdcdc, 0.9);
            }else {
                return PNCColorWithHexA(0xffffff, 0.5);
            }
        }];
        
       self.songLabel.layer.shadowColor = backViewColor.CGColor;

    } else {
        self.songLabel.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
    }
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.songLabel.bounds;
    button.backgroundColor = [UIColor clearColor];
    [self.songLabel addSubview:button];
    [button addTarget:self action:@selector(songLabelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.selectedSongLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(150),  CGRectGetMaxY(self.pickerView.frame) + kAUTOHEIGHT(25), kAUTOWIDTH(120), kAUTOHEIGHT(44))];
    self.selectedSongLabel.text = @"欢快的音乐1";
    self.selectedSongLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
    self.selectedSongLabel.backgroundColor = [UIColor clearColor];
    self.selectedSongLabel.textColor = [UIColor blackColor];
    self.selectedSongLabel.textAlignment = NSTextAlignmentRight;
    self.selectedSongLabel.userInteractionEnabled = YES;
    [self addSubview:self.selectedSongLabel];
    self.selectedSongLabel.adjustsFontSizeToFitWidth = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(songLabelButtonClick)];
    [self.selectedSongLabel addGestureRecognizer:tapGesture];
    
    UIImageView *jianTouImagView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - kAUTOWIDTH(20),  CGRectGetMaxY(self.pickerView.frame) + kAUTOHEIGHT(25) + (kAUTOHEIGHT(44) - 15)/2, 8,15)];
    jianTouImagView.image = [UIImage imageNamed:@"ap_arrow_right"];
    jianTouImagView.alpha = 0.8;
    [self addSubview:jianTouImagView];
    
    
}


- (void)songLabelButtonClick{
    if (self.selectSongBlock) {
        self.selectSongBlock();
    }
}

- (void)initializationTopView{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_HEIGHT-50 , VIEW_WIDTH, 44)];
     self.topView.backgroundColor = [UIColor clearColor];
    if (PNCisIPHONEX) {
        self.topView.frame = CGRectMake(0, VIEW_HEIGHT - 94 , VIEW_WIDTH, 44);
    }
    [self addSubview:_topView];
    
}
- (void)initializationCancleButton
{
    self.cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleButton.frame = CGRectMake(SCREEN_WIDTH/2 - 130, 0, 30, 30);
    [self.cancleButton addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleButton setBackgroundImage:[UIImage imageNamed:@"关闭123"] forState:UIControlStateNormal];
    [self.topView addSubview:_cancleButton];
}
- (void)initializationDetermineButton
{
    self.determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _determineButton.frame = CGRectMake(SCREEN_WIDTH/2 + 100, 0, 30, 30);
    [self.determineButton addTarget:self action:@selector(determineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.determineButton setBackgroundImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [self.topView addSubview:self.determineButton];
    
    
    
}


- (void)cancleButtonClick:(UIButton *)sender
{
    [BCShanNianKaPianManager maDaQingZhenDong];
    if (self.cancaleBlock) {
        self.cancaleBlock();
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];

    }];
}

- (void)determineButtonClick:(UIButton *)sender
{
    [BCShanNianKaPianManager maDaQingZhenDong];
    NSString *hour = nil;
    NSString *minute = nil;
    NSString *second = nil;
    NSInteger hourSelectedRow = [self.pickerView selectedRowInComponent:0];
    NSInteger minuteSelectedRow = [self.pickerView  selectedRowInComponent:1];
    NSInteger secondSelectedRow = [self.pickerView  selectedRowInComponent:2];
    hour = [_hoursArray objectAtIndex:hourSelectedRow];
    minute = [_minuteArray objectAtIndex:minuteSelectedRow];
    second = [_secondArray objectAtIndex:secondSelectedRow];
    
    NSString *time = [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
    
    NSInteger hourSecond   = [hour integerValue]*3600;
    NSInteger minuteSecond = [minute integerValue]*60;
    NSInteger secondeValue = [second integerValue];
    NSInteger reutrenValue = hourSecond+minuteSecond+secondeValue;
  
    if (self.timeThingTextField.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请您输入备注"];

    }else{
        if (reutrenValue == 0) {
            [SVProgressHUD showErrorWithStatus:@"请您选择时间"];
        }else{
            if ([_delegate respondsToSelector:@selector(determinReturnSencond:)])
            {
                [_delegate determinReturnSencond:reutrenValue];
            }
            if ([_delegate respondsToSelector:@selector(determinSelected:)]) {
                [_delegate determinSelected:time];
            }
            
            
            if (self.sureBlock) {
                self.sureBlock(self.timeThingTextField.text,time, reutrenValue,self.bgColor1,self.bgColor2,self.songName);
            }
            [self cancleButtonClick:nil];
        }
    }
    
    
}
- (void)showWithFatherView:(UIView *)view{
    [view addSubview:self];
//     [[UIApplication sharedApplication].keyWindow addSubview:self];
}
#pragma mark - UIPickerViewDelegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            return 24;
        }
            
            break;
        case 1:
        {
            return 60;
        }
            break;
        case 2:
        {
            return 60;
        }
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    switch (component)
    {
        case 0:
        {
            NSString *str = [_hoursArray objectAtIndex:row];
            NSString *returnStr = [NSString stringWithFormat:@"%@%@",str,HOUR];
            return returnStr;
        }
            
            break;
        case 1:
        {
            NSString *str = [_minuteArray objectAtIndex:row];
            NSString *returnStr = [NSString stringWithFormat:@"%@%@",str,MINUTE];
            return returnStr;
        }
            break;
        case 2:
        {
            NSString *str = [_secondArray objectAtIndex:row];
            NSString *returnStr = [NSString stringWithFormat:@"%@%@",str,SECOND];
            return returnStr;
            
        }
            break;
            
        default:
            return 0;
            break;
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
//    switch (component)
//    {
//        case 0:
//        {
//            [_pickerView reloadComponent:1];
//            [_pickerView reloadComponent:2];
//        }
//            
//            break;
//        case 1:
//        {
//            [_pickerView reloadComponent:2];
//        }
//            
//            break;
//            
//        default:
//            break;
//    }
    [self changeSpearatorLineColor];
    NSString *hour = nil;
    NSString *minute = nil;
    NSString *second = nil;
    NSInteger hourSelectedRow = [pickerView selectedRowInComponent:0];
    NSInteger minuteSelectedRow = [pickerView selectedRowInComponent:1];
    NSInteger secondSelectedRow = [pickerView selectedRowInComponent:2];
    hour = [_hoursArray objectAtIndex:hourSelectedRow];
    minute = [_minuteArray objectAtIndex:minuteSelectedRow];
    second = [_secondArray objectAtIndex:secondSelectedRow];
    NSString *returnStr = [NSString stringWithFormat:@"%@:%@:%@",hour,minute,second];
    NSLog(@"%@:%@:%@",hour,minute,second);
    if ([self.delegate respondsToSelector:@selector(changeTime:)]) {
        [_delegate changeTime:returnStr];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:15];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textColor = [UIColor whiteColor];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    [self changeSpearatorLineColor];
    return pickerLabel;
}


#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor whiteColor];//隐藏分割线
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_timeThingTextField resignFirstResponder];
}
@end
