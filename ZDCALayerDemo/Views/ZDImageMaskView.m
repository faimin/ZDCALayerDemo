//
//  ZDImageMaskView.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 2019/1/16.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import "ZDImageMaskView.h"

@interface ZDImageMaskView ()
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation ZDImageMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupMask];
    }
    return self;
}

#pragma mark -

- (void)setupMask {
    [self addSubview:self.animationView];
    
    self.animationView.layer.mask = ({
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = self.animationView.bounds;
        UIImage *maskImage = [UIImage imageNamed:@"icon_water_mask"];
        maskLayer.contents = (__bridge id)maskImage.CGImage;
        maskLayer;
    });
    [self.animationView.layer addSublayer:self.gradientLayer];
}

#pragma mark - Property

- (UIView *)animationView {
    if (!_animationView) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){8, (self.bounds.size.height-12)/2.0, 14, 12}];
        view.backgroundColor = UIColor.yellowColor;
        _animationView = view;
    }
    return _animationView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        CAGradientLayer *layer = [CAGradientLayer layer];
        layer.frame = (CGRect){0, 4, self.animationView.bounds.size.width, self.animationView.bounds.size.height};
        layer.startPoint = (CGPoint){0, 0};
        layer.endPoint = (CGPoint){1, 1};
        layer.colors = @[(__bridge id)[UIColor orangeColor].CGColor, (__bridge id)[UIColor purpleColor].CGColor];
        _gradientLayer = layer;
    }
    return _gradientLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
