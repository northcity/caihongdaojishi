//
//  SelectSongViewController.m
//  daojishi
//
//  Created by 北城 on 2018/11/22.
//  Copyright © 2018年 com.beicheng. All rights reserved.
//

#import "SelectSongViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "ShanNianVoiceSetCell.h"

@interface SelectSongViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>
{
    AVAudioPlayer *_avAudioPlayer; // 播放器palyer
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,copy)NSString *songName;
@property(nonatomic,strong)NSMutableArray *songNameArray;
@end

@implementation SelectSongViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (PNCisIOS13Later) {
          self.view.backgroundColor = [UIColor systemBackgroundColor];

      }else{
          self.view.backgroundColor = [UIColor whiteColor];

      }
      
    [self initOtherUI];
    [self createSubViews];
//    [self initPlayer];
    
}

- (void)initOtherUI{
    self.navigationController.navigationBar.hidden = YES;
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PCTopBarHeight)];
    if (@available(iOS 13.0, *)) {
          _titleView.backgroundColor = [UIColor systemBackgroundColor];
      } else {
          _titleView.backgroundColor = [UIColor whiteColor];
      }

    _titleView.layer.shadowColor=[UIColor grayColor].CGColor;
    _titleView.layer.shadowOffset=CGSizeMake(0, 2);
    _titleView.layer.shadowOpacity=0.1f;
    _titleView.layer.shadowRadius=12;
    [self.view addSubview:_titleView];
    [self.view insertSubview:_titleView atIndex:99];
    
    if (@available(iOS 13.0, *)) {
    UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                return PNCColorWithHexA(0xdbdbdb, 0.9);
            }else {
                return PNCColorWithHexA(0xffffff, 0.5);
            }
        }];
        
       _titleView.layer.shadowColor = backViewColor.CGColor;

    } else {
        _titleView.layer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
    }
    
    _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(5), kAUTOWIDTH(200), kAUTOHEIGHT(66))];
    if (PNCisIPHONEX) {
        _navTitleLabel.frame = CGRectMake(ScreenWidth/2 - kAUTOWIDTH(200)/2, kAUTOHEIGHT(25), kAUTOWIDTH(200), kAUTOHEIGHT(66));
    }
    _navTitleLabel.text = @"选择曲目";
    _navTitleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:15];
    _navTitleLabel.textColor = PNCColorWithHex(0xFB409C);
    _navTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleView addSubview:_navTitleLabel];
    
    YQMotionShadowView *showLabel = [YQMotionShadowView fromView:_navTitleLabel];
    [_titleView addSubview:showLabel];
    
    _backBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(20, 28, 25, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(back)];
    [_backBtn setImage:[UIImage imageNamed:@"newfanhui"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _backBtn.frame = CGRectMake(20, 48, 25, 25);
    }
    _backBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    [_titleView addSubview:_backBtn];
    
    _sureBtn = [Factory createButtonWithTitle:@"" frame:CGRectMake(ScreenWidth - 80, 28, 60, 25) backgroundColor:[UIColor clearColor] backgroundImage:[UIImage imageNamed:@""] target:self action:@selector(sureClick)];
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    
    if (PNCisIOS13Later) {
        [_sureBtn setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];

    }else{
        [_sureBtn setTitleColor:PNCColorWithHex(0x222222) forState:UIControlStateNormal];

    }
    
    
    _sureBtn.titleLabel.font = [UIFont fontWithName:@"HeiTi SC" size:13];
//    [_sureBtn setImage:[UIImage imageNamed:@"返回箭头2"] forState:UIControlStateNormal];
    if (PNCisIPHONEX) {
        _sureBtn.frame = CGRectMake(ScreenWidth - 80, 48, 60, 25);
    }
//    _sureBtn.transform = CGAffineTransformMakeRotation(M_PI_4);
    [_titleView addSubview:_sureBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CABasicAnimation* rotationAnimation;
        
        rotationAnimation =[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue =[NSNumber numberWithFloat: 0];
        rotationAnimation.duration =0.4;
        rotationAnimation.repeatCount =1;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [_backBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    });
}


- (void)sureClick{
    if (self.songBlock) {
        self.songBlock(self.songName);
    }
    [self back];
}
-(void)initPlayerWithName:(NSString *)songName{
    // 2.播放本地音频文件
    // (1)从boudle路径下读取音频文件 陈小春 - 独家记忆文件名，mp3文件格式
    NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"caf"];
    // (2)把音频文件转化成url格式
    NSURL *url = [NSURL fileURLWithPath:path];
    // (3)初始化音频类 并且添加播放文件
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    // (4) 设置代理
    _avAudioPlayer.delegate = self;
    // (5) 设置初始音量大小 默认1，取值范围 0~1
    _avAudioPlayer.volume = 1;
    // (6)设置音乐播放次数 负数为一直循环，直到stop，0为一次，1为2次，以此类推
    _avAudioPlayer.numberOfLoops = 0;
    // (5)准备播放
    [_avAudioPlayer prepareToPlay];

}
- (void)createSubViews{
    
    self.songNameArray =[NSMutableArray arrayWithArray: @[@"欢快的音乐1",@"欢快的音乐2",@"欢快的音乐3",@"欢快的音乐4",@"欢快的音乐5",@"欢快的音乐6",@"欢快的音乐7",@"欢快的音乐8",@"欢快的音乐9",@"欢快的音乐10",@"欢快的音乐11",@"欢快的音乐12",@"欢快的音乐13",@"欢快的音乐14",@"欢快的音乐15",@"欢快的音乐16",@"欢快的音乐17",@"欢快的音乐18",@"欢快的音乐19",@"欢快的音乐20",@"欢快的音乐21"]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, PCTopBarHeight + kAUTOWIDTH(10), ScreenWidth, ScreenHeight - PCTopBarHeight - kAUTOWIDTH(10)) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (PNCisIOS13Later) {
        self.tableView.backgroundColor = [UIColor systemBackgroundColor];

    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];

    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ShanNianVoiceSetCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    NSInteger selectedIndex = 0;
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songNameArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kAUTOWIDTH(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ind = @"cell";
    ShanNianVoiceSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ind forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.textLabel.text = self.songNameArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"音乐"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [_avAudioPlayer play];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [BCUserDeafaults setObject:[NSString stringWithFormat:@"我是一首歌%ld",indexPath.row] forKey:@"SONG"];
    self.songName = self.songNameArray[indexPath.row];
    [self initPlayerWithName:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];
    [_avAudioPlayer play];
    
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
