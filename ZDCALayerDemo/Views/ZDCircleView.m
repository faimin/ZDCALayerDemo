//
//  ZDCircleView.m
//  ZDTest
//
//  Created by Zero.D.Saber on 16/4/15.
//  Copyright © 2016年 Zero.D.Saber. All rights reserved.
//

#import "ZDCircleView.h"

#define UIColorFromHEX(rgbValue)                                        \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0    \
                green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0       \
                 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha: 1.0]    \


@interface UIColor (RGB)

- (CGFloat)R;

- (CGFloat)G;

- (CGFloat)B;

@end

@interface ZDCircleView ()

@end

@implementation ZDCircleView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //[self setupLayer];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupLayer];
}

/*
 http://blog.csdn.net/rhljiayou/article/details/9919713
 
 http://www.cnblogs.com/xingchen/p/3615346.html
 
 http://blog.csdn.net/zhoutao198712/article/details/20864143
 */

/*
- (void)drawRect:(CGRect)rect
{
    UIColor *color = UIColorFromHEX(0xb5b5b5);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(contextRef, color.R, color.G, color.B, 1);
    CGContextSetLineWidth(contextRef, 5.0f);
    CGContextAddArc(contextRef, 150, 150, 150, 0, M_PI*2, 0);
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    
    UIColor *newColor = UIColorFromHEX(0xff6060);
    CGContextSetRGBStrokeColor(contextRef, newColor.R, newColor.G, newColor.B, 1);
    CGContextSetLineWidth(contextRef, 5.0f);
    CGContextAddArc(contextRef, 150, 150, 150, 0, M_PI, 1);
    CGContextDrawPath(contextRef, kCGPathStroke);
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] =
    {
        1,1,1, 1.00,
        1,1,0, 1.00,
        1,0,0, 1.00,
        1,0,1, 1.00,
        0,1,1, 1.00,
        0,1,0, 1.00,
        0,0,1, 1.00,
        0,0,0, 1.00,
    };
    CGGradientRef gradient = CGGradientCreateWithColorComponents
    (rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
    CGColorSpaceRelease(rgb);
}*/

/// http://www.cocoachina.com/ios/20150318/11350.html
- (void)setupLayer
{
    CGPoint center = {150, 150};
    CGFloat width, height;
    width = height = 150;
    CGFloat lineWidth = 50.0f;
    
    CAShapeLayer *circleLayer = ({
        CAShapeLayer *circleLayer =[CAShapeLayer layer];
        circleLayer.frame = self.bounds;
        circleLayer.fillColor = nil;
        circleLayer.strokeColor = UIColorFromHEX(0xb5b5b5).CGColor;
        circleLayer.lineWidth = lineWidth;
        circleLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds) - lineWidth)/2.0f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
        circleLayer;
    });
    [self.layer addSublayer:circleLayer];
    
    CAShapeLayer *progressLayer = ({
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.path = [UIBezierPath bezierPathWithArcCenter:center radius:(CGRectGetWidth(self.bounds) - lineWidth)/2.0f startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
        progressLayer.fillColor = nil;
        progressLayer.strokeColor = UIColorFromHEX(0xff6060).CGColor;
        progressLayer.lineWidth = lineWidth;
        progressLayer.lineCap = kCALineCapRound;
        progressLayer.lineJoin = kCALineJoinRound;
        progressLayer;
    });
    [self.layer addSublayer:progressLayer];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.layer.bounds;
    
    CAGradientLayer *gradientLayerR = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(150, 0, 150, 300);
        gradientLayer.colors = @[(__bridge id)UIColorFromHEX(0xff6060).CGColor,
                                 (__bridge id)UIColorFromHEX(0xff5050).CGColor];
        //locations属性可以使用一个数组（元素取值范围0到1），指定渐变图层参照colors顺序取用下一个过渡点颜色的位置。
        //未设定时默认会平均分配过渡点。一旦设定就必须与colors的数量保持一致，否则会出错。
        gradientLayer.locations = @[@0.1, @0.6];
        gradientLayer.startPoint = CGPointMake(0.5, 1);
        gradientLayer.endPoint = CGPointMake(0.5, 0);
        gradientLayer;
    });
    
    CAGradientLayer *gradientLayerL = ({
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 150, 300);
        gradientLayer.colors = @[(__bridge id)UIColorFromHEX(0xff5050).CGColor,
                                 (__bridge id)UIColorFromHEX(0xff6060).CGColor];
        gradientLayer.locations = @[@0.1, @0.6];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        gradientLayer;
    });
    
    [gradientLayer addSublayer:gradientLayerL];
    [gradientLayer addSublayer:gradientLayerR];
    gradientLayer.mask = progressLayer;
    [self.layer addSublayer:gradientLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 2.0f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.fromValue = @(0.0f);
    animation.toValue = @(1.0f);
    animation.fillMode = kCAFillModeForwards;
    [progressLayer addAnimation:animation forKey:@"strokerEndAnimation"];
    //progressLayer.strokeEnd = 1.0f;
}




@end



@implementation UIColor (RGB)

- (CGFloat)R
{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r;
}

- (CGFloat)G
{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return g;
}

- (CGFloat)B
{
    CGFloat r, g, b = 0, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return b;
}

@end




