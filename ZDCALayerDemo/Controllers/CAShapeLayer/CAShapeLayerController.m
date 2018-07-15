//
//  CAShapeLayerController.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 16/1/12.
//  Copyright © 2016年 Zero.D.Saber. All rights reserved.
//  https://github.com/ole/Animated-Paths
//  https://github.com/leiyanACWorld123/LYLYCoreText && http://www.tuicool.com/articles/n6Bny2A

#import "CAShapeLayerController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CAShapeLayerController ()<CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) CALayer *penLayer;

@end

@implementation CAShapeLayerController

#pragma mark - UI LifeCycel
- (void)dealloc
{
    NSLog(@"第%d行执行了%s", __LINE__, __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self events];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event

- (void)events
{
    [self textPathAction];
}

#pragma mark - SubEvent

- (void)textPathAction
{
    [self setupTextLayer];
    [self startAnimation];
}

- (void)setupTextLayer
{
    if (self.timeInterval > 0) {
        self.slider.maximumValue = self.timeInterval;
    }
    
    [self resetLayer];
    
    CGMutablePathRef letters = CGPathCreateMutable();
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 64.0f, NULL);
    NSDictionary *fontAttribute = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id _Nonnull)(font), kCTFontAttributeName, nil];
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:(self.drawText ? : @"Sephiroth") attributes:fontAttribute];
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributeString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    //each run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        //font for this run
        CTRunRef run = CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        //each Glyph in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            //Glyph & Glyph-date
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            //path of outline
            CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
            CGPathAddPath(letters, &transform, letter);
            CGPathRelease(letter);
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    [path closePath];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    self.pathLayer = ({
        CAShapeLayer *pathLayer = [CAShapeLayer layer];
        pathLayer.frame = self.animationLayer.bounds;
        pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
        // layer背景色
        pathLayer.backgroundColor = [UIColor redColor].CGColor;
        pathLayer.geometryFlipped = YES;
        pathLayer.path = path.CGPath;
        // 画线颜色
        pathLayer.strokeColor = [UIColor yellowColor].CGColor;
        // 文字原来的颜色(默认为黑色)
        pathLayer.fillColor = [UIColor clearColor].CGColor;
        pathLayer.lineWidth = 1.0f;
        pathLayer.lineJoin = kCALineJoinBevel;
        //MARK: 手动控制timeOffset来显示动画
        pathLayer.speed = 0;
        pathLayer.timeOffset = 0;
        [self.animationLayer addSublayer:pathLayer];
        pathLayer;
    });
    
    self.penLayer = ({
        UIImage *penImage = [UIImage imageNamed:@"pen.png"];
        CALayer *penLayer = [CALayer layer];
        penLayer.contents = (id)penImage.CGImage;
        penLayer.anchorPoint = CGPointZero;
        penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
        //penLayer.hidden = YES;
        [self.pathLayer addSublayer:penLayer];
        penLayer;
    });

}

- (void)startAnimation
{
    [self.pathLayer removeAllAnimations];
    [self.penLayer removeAllAnimations];
    
    self.penLayer.hidden = NO;
    
    CFTimeInterval timeInterval = (self.timeInterval > 0) ? self.timeInterval : 10;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = timeInterval;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
    CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    penAnimation.duration = timeInterval;
    penAnimation.path = self.pathLayer.path;
    penAnimation.calculationMode = kCAAnimationPaced;
    penAnimation.delegate = self;
    [self.penLayer addAnimation:penAnimation forKey:@"position"];
}

- (void)resetLayer
{
    if (self.pathLayer) {
        [self.penLayer removeFromSuperlayer];
        [self.pathLayer removeFromSuperlayer];
        
        self.pathLayer = nil;
        self.penLayer = nil;
    }
}

#pragma mark - Private Method

- (IBAction)chageSliderValue:(UISlider *)sender
{
    CGFloat value = sender.value;
//    NSLog(@"\nslider value = %f", value);
//    if (value == 0 || value == sender.maximumValue) {
//        self.penLayer.hidden = YES;
//    } else {
//        self.penLayer.hidden = NO;
//    }
    self.pathLayer.timeOffset = value;
}

- (IBAction)copleteAction:(id)sender
{
    self.drawText = self.textField.text;
}

#pragma mark - Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.penLayer.hidden = YES;
}

#pragma mark - Property
- (CALayer *)animationLayer
{
    if (!_animationLayer) {
        _animationLayer = ({
            CALayer *layer = [CALayer layer];
            layer.frame = (CGRect){20, 60, CGRectGetWidth(self.view.layer.bounds) - 40, CGRectGetHeight(self.view.layer.bounds) - 84};
            [self.view.layer addSublayer:layer];
            layer;
        });
    }
    return _animationLayer;
}

- (void)setDrawText:(NSString *)drawText
{
    if (_drawText != drawText) {
        _drawText = nil;
        _drawText = [drawText copy];
        
        [self textPathAction];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)setupDrawingLayer
//{
//    [self resetLayer];
//    
//    CGRect pathRect = CGRectInset(self.animationLayer.bounds, 100.0f, 100.0f);
//    CGPoint bottomLeft 	= CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect));
//    CGPoint topLeft		= CGPointMake(CGRectGetMinX(pathRect), CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * 2.0f/3.0f);
//    CGPoint bottomRight = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect));
//    CGPoint topRight	= CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMinY(pathRect) + CGRectGetHeight(pathRect) * 2.0f/3.0f);
//    CGPoint roofTip		= CGPointMake(CGRectGetMidX(pathRect), CGRectGetMaxY(pathRect));
//    
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:bottomLeft];
//    [path addLineToPoint:topLeft];
//    [path addLineToPoint:roofTip];
//    [path addLineToPoint:topRight];
//    [path addLineToPoint:topLeft];
//    [path addLineToPoint:bottomRight];
//    [path addLineToPoint:topRight];
//    [path addLineToPoint:bottomLeft];
//    [path addLineToPoint:bottomRight];
//    [path closePath];
//    
//    self.pathLayer = ({
//        CAShapeLayer *pathLayer = [CAShapeLayer layer];
//        pathLayer.frame = self.animationLayer.bounds;
//        pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
//        //: 背景色
//        pathLayer.backgroundColor = [UIColor purpleColor].CGColor;
//        pathLayer.geometryFlipped = YES;
//        pathLayer.path = path.CGPath;
//        //: 画线颜色
//        pathLayer.strokeColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1].CGColor;
//        //: 线条填充色
//        pathLayer.fillColor = nil;
//        pathLayer.lineWidth = 1.0f;
//        pathLayer.lineJoin = kCALineJoinBevel;
//        [self.animationLayer addSublayer:pathLayer];
//        pathLayer;
//    });
//    
//    self.penLayer = ({
//        UIImage *penImage = [UIImage imageNamed:@"pen.png"];
//        CALayer *penLayer = [CALayer layer];
//        penLayer.contents = (id)penImage.CGImage;
//        penLayer.anchorPoint = CGPointZero;
//        penLayer.frame = CGRectMake(0.0f, 0.0f, penImage.size.width, penImage.size.height);
//        [self.pathLayer addSublayer:penLayer];
//        penLayer;
//    });
//}

- (void)line {
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = (CGRect){0, 0, 100, 5};
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(100, 0)];
    progressLayer.path = path.CGPath;
    progressLayer.fillColor = nil;
    progressLayer.strokeColor = [UIColor redColor].CGColor;
    progressLayer.lineWidth = 5.0f;
    progressLayer.lineCap = kCALineCapButt;
    progressLayer.strokeStart = 0.0f;
    progressLayer.strokeEnd = 1.0f;
}

@end
