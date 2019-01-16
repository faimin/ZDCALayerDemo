//
//  ZDMaskViewController.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 2019/1/16.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import "ZDMaskViewController.h"
#import "ZDImageMaskView.h"

@interface ZDMaskViewController ()

@end

@implementation ZDMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)setup {
    ZDImageMaskView *maskView = [[ZDImageMaskView alloc] initWithFrame:(CGRect){20, 100, 50, 50}];
    [self.view addSubview:maskView];
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
