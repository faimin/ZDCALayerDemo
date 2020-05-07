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
    [self setupUI];
}

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
    animation.duration = 0.5;
    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    
    [layer addAnimation:animation forKey:@"CAReplicatorLayer.animation"];
    [replacatorLayer addSublayer:layer];
    [animationView.layer addSublayer:replacatorLayer];
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
