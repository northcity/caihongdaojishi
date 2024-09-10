//
//  LaunchViewController.m
//  shijianjiaonang
//
//  Created by chenxi on 2018/3/23.
//  Copyright © 2018年 chenxi. All rights reserved.
//

#import "LaunchViewController.h"

#import "DaoJiShiViewController.h"

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (PNCisIOS13Later) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];

    }else{
        self.view.backgroundColor = [UIColor whiteColor];

    }
    
//    [self createImageView];
    
    self.navigationController.navigationBar.hidden = YES;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        DaoJiShiViewController *lvc = [[DaoJiShiViewController alloc]init];
//        [self.navigationController pushViewController:lvc animated:NO];
//    });
    
    
    
    NSString *isVip = [BCUserDeafaults objectForKey:IS_NO_AD];
    if ([isVip isEqualToString:@"1"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    DaoJiShiViewController *lvc = [[DaoJiShiViewController alloc]init];
                    [self.navigationController pushViewController:lvc animated:NO];
        });
    }else{
//        [self createAD];
        DaoJiShiViewController *lvc = [[DaoJiShiViewController alloc]init];
        [self.navigationController pushViewController:lvc animated:NO];
    }
    
    
}

- (void)createAD{
//    APAdSplash *splash = [[APAdSplash alloc] initWithSlot:@"dADjzBye" delegate:self];
//    [splash loadAndPresentWithViewController:self];
}

// Ad present has failed
//- (void) splashAdPresentDidFail:(nonnull NSString *)splashAdSlot
//                      withError:(nonnull NSError *)error{
//    DaoJiShiViewController *lvc = [[DaoJiShiViewController alloc]init];
//    [self.navigationController pushViewController:lvc animated:NO];
//}
//
//- (void) splashAdWillDismiss:(nonnull APAdSplash *)splashAd{
//    DaoJiShiViewController *lvc = [[DaoJiShiViewController alloc]init];
//    [self.navigationController pushViewController:lvc animated:NO];
//}


- (void)createImageView{
   
    UIImageView *iconImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icondaojishi"]];
    iconImageView.frame = CGRectMake(0, 0, 70, 70);
    iconImageView.center = self.view.center;
    [self.view addSubview:iconImageView];
    iconImageView.layer.cornerRadius = 12;
    iconImageView.layer.masksToBounds = YES;
    
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe=iconImageView.layer.frame;
    subLayer.frame = fixframe;
    subLayer.cornerRadius = 8;
    subLayer.backgroundColor=[[UIColor redColor] colorWithAlphaComponent:0.5].CGColor;
    subLayer.masksToBounds=NO;
    subLayer.shadowColor=[UIColor redColor].CGColor;
    subLayer.shadowOffset=CGSizeMake(0,3);
    subLayer.shadowOpacity=0.8f;
    subLayer.shadowRadius= 6;
    [self.view.layer insertSublayer:subLayer below:iconImageView.layer];
    
    
    if (@available(iOS 13.0, *)) {
          UIColor *backViewColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
                  if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleLight) {
                      return PNCColorWithHexA(0xdcdcdc, 0.9);
                  }else {
                      return PNCColorWithHexA(0xffffff, 0.9);
                  }
              }];
              
             subLayer.shadowColor = backViewColor.CGColor;

          } else {
              subLayer.shadowColor=PNCColorWithHexA(0xdcdcdc, 0.9).CGColor;
          }

    
    
    UILabel * label = [Factory createLabelWithTitle:@"Create BY NorthCity 北城出品" frame:CGRectMake(30, ScreenHeight - kAUTOHEIGHT(74), ScreenWidth - 60, 44)];
    [self.view addSubview:label];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir-Medium" size:7.5f];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        subLayer.shadowColor = [UIColor clearColor].CGColor;
        subLayer.hidden = YES;
        [UIView animateWithDuration:0.5 animations:^{
            iconImageView.alpha = 0;
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.view.alpha = 0;
            }];
        }];
    });
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
