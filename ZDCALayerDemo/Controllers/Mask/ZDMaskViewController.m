//
//  ZDMaskViewController.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 2019/1/16.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import "ZDMaskViewController.h"
#import "ZDImageMaskView.h"
#import "ZDLyricsView.h"

@interface ZDMaskViewController ()
@property (nonatomic, strong) ZDLyricsView *lyricView;
@end

@implementation ZDMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)setup {
    [self setupMaskHeart];
    [self setupMaskLyrics];
}

- (void)setupMaskHeart {
    ZDImageMaskView *maskView = [[ZDImageMaskView alloc] initWithFrame:(CGRect){20, 100, 50, 50}];
    [self.view addSubview:maskView];
}

- (void)setupMaskLyrics {
    ZDLyricsView *view = [[ZDLyricsView alloc] initWithFrame:(CGRect){10, 150, CGRectGetWidth(self.view.frame) - 10*2, 30}];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.lyricText = @"大家好，我是智能机器人!!!";
    [self.view addSubview:view];
    _lyricView = view;
}

- (IBAction)updateSliderValue:(UISlider *)sender {
    CGFloat value = sender.value;
    self.lyricView.progress = value;
}

@end
