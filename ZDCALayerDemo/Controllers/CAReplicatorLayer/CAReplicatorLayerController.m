//
//  CAReplicatorLayerController.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 2018/7/15.
//  Copyright © 2018年 Zero.D.Saber. All rights reserved.
//
//  https://zsisme.gitbooks.io/ios-/content/chapter6/careplicatorLayer.html
//  https://www.jianshu.com/p/2e6facd8142f

#import "CAReplicatorLayerController.h"

@interface CAReplicatorLayerController ()

@end

@implementation CAReplicatorLayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSStringFromClass(self.class);
    [self setup];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup {
    //[self setupUI];
    [self setuptailwaveAnimation];
}

// 音乐千千静听效果
- (void)setupUI {
    NSUInteger count = 5;
    CGFloat subLayerWidth = 40.0, transformX = 60.0, totoalWidth = transformX*count-(transformX-subLayerWidth);
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, totoalWidth, 500)];
    animationView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:animationView];
    
    CAReplicatorLayer *replacatorLayer = [CAReplicatorLayer layer];
    replacatorLayer.frame = animationView.bounds;
    // 复制层个数
    replacatorLayer.instanceCount = count;
    // 60 = 复制层宽度 + 复制层之间的间隔
    replacatorLayer.instanceTransform = CATransform3DMakeTranslation(transformX, 0, 0);
    // 设置复制层的动画延迟时间
    replacatorLayer.instanceDelay = 0.1;
    //replacatorLayer.instanceColor = UIColor.orangeColor.CGColor;
    replacatorLayer.instanceBlueOffset = 0.1;
    
    // 创建复制层的sublayer
    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0, 1);
    layer.frame = CGRectMake(0, 0, subLayerWidth, CGRectGetHeight(replacatorLayer.frame));
    layer.backgroundColor = UIColor.redColor.CGColor;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale.y";
    animation.toValue = @0.05;
    //animation.keyPath = @"transform.translation.y";
    //animation.toValue = @(600);
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    
    [layer addAnimation:animation forKey:@"CAReplicatorLayer.animation"];
    [replacatorLayer addSublayer:layer];
    [animationView.layer addSublayer:replacatorLayer];
}

// 省略号波浪动画
- (void)setuptailwaveAnimation {
    NSUInteger count = 3;
    UIFont *font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    CGFloat width = 10.0;
    CGFloat totoalWidth = width * count;
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, totoalWidth, font.lineHeight * 1)];
    animationView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:animationView];
    
    CAReplicatorLayer *replacatorLayer = [CAReplicatorLayer layer];
    replacatorLayer.frame = animationView.bounds;
    replacatorLayer.instanceCount = count;
    // 60 = 复制层宽度 + 复制层之间的间隔
    replacatorLayer.instanceTransform = CATransform3DMakeTranslation(width, 0, 0);
    replacatorLayer.instanceDelay = 0.1;
    //replacatorLayer.instanceColor = UIColor.orangeColor.CGColor;
    replacatorLayer.instanceBlueOffset = 0.1;
    
    // 创建复制层的sublayer
    CATextLayer *textLayer = ({
        CATextLayer *layer = [CATextLayer layer];
        layer.string = @"·";
        layer.font = (__bridge CFTypeRef)(font);
        layer.fontSize = font.pointSize;
        layer.foregroundColor = UIColor.grayColor.CGColor;
        //layer.anchorPoint = CGPointMake(0.5, 0.5);
        layer.frame = CGRectMake(0, 0, width, CGRectGetHeight(replacatorLayer.frame)/2);
        layer;
    });
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.toValue = @(CGRectGetHeight(replacatorLayer.bounds)/2.0);
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    
    [textLayer addAnimation:animation forKey:@"CAReplicatorLayer"];
    [replacatorLayer addSublayer:textLayer];
    [animationView.layer addSublayer:replacatorLayer];
}

@end
