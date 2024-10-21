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
#if 1
    [self setupUI];
#else
    [self setuptailwaveAnimation];
#endif
}

// 音乐千千静听效果
- (void)setupUI {
    NSUInteger count = 5;
    CGFloat subLayerWidth = 40.0, transformX = 60.0, totoalWidth = transformX*count-(transformX-subLayerWidth);
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(50, 100, totoalWidth, 500)];
    container.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:container];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [container.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [container.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [container.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50],
        [container.heightAnchor constraintEqualToConstant:500],
    ]];
    
    CAReplicatorLayer *replacatorLayer = [CAReplicatorLayer layer];
    replacatorLayer.frame = container.bounds;
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
    [container.layer addSublayer:replacatorLayer];
}

// 省略号波浪动画
- (void)setuptailwaveAnimation {
    NSUInteger count = 3;
    UIFont *font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    CGFloat width = 10.0;
    CGFloat totoalWidth = width * count;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(50, 100, totoalWidth, font.lineHeight)];
    container.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:container];
    container.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [container.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:50],
        [container.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [container.widthAnchor constraintEqualToConstant:totoalWidth],
        [container.heightAnchor constraintEqualToConstant:font.lineHeight],
    ]];
    
    CAReplicatorLayer *replacatorLayer = ({
        __auto_type layer = [CAReplicatorLayer layer];
        layer.frame = container.bounds;
        layer.instanceCount = count;
        layer.instanceTransform = CATransform3DMakeTranslation(width, 0, 0);
        layer.instanceDelay = 0.2;
        //layer.instanceColor = UIColor.orangeColor.CGColor;
        //layer.instanceBlueOffset = 0.1;
        layer;
    });
    
    // 创建复制层的sublayer
    CATextLayer *textLayer = ({
        __auto_type layer = [CATextLayer layer];
        layer.frame = CGRectMake(0, 0, width, CGRectGetHeight(replacatorLayer.frame));
        layer.string = @"·";
        layer.font = (__bridge CFTypeRef)(font);
        layer.fontSize = font.pointSize;
        layer.foregroundColor = UIColor.whiteColor.CGColor;
        layer.anchorPoint = CGPointMake(0.5, 0.5);
        layer;
    });
    
    CABasicAnimation *waveAnimation = ({
        __auto_type animation = [CABasicAnimation animation];
        animation.keyPath = @"transform.translation.y";
        animation.fromValue = @(-CGRectGetHeight(replacatorLayer.bounds)/4.0);
        animation.toValue = @(CGRectGetHeight(replacatorLayer.bounds)/4.0);
        animation.duration = 0.5;
        animation.autoreverses = YES;
        animation.repeatCount = MAXFLOAT;
        animation.fillMode = kCAFillModeBackwards; //开始动画时就在fromValue的位置
        animation;
    });
    
    [textLayer addAnimation:waveAnimation forKey:@"CAReplicatorLayer_Wave"];
    [replacatorLayer addSublayer:textLayer];
    [container.layer addSublayer:replacatorLayer];
}

@end
