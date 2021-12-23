//
//  ZDLyricsView.m
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 2019/2/20.
//  Copyright © 2019 Zero.D.Saber. All rights reserved.
//

#import "ZDLyricsView.h"

@interface ZDLyricsView ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *lyricsLabel;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation ZDLyricsView

- (void)dealloc {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self setupUI];
}

- (void)setupUI {
    self.backgroundColor = UIColor.cyanColor;

    [self.containerView.layer addSublayer:self.progressLayer];
    [self addSubview:self.containerView];
}

- (void)setLyricText:(NSString *)lyricText {
    if ([_lyricText isEqualToString:lyricText]) return;
    _lyricText = lyricText;
    
    self.lyricsLabel.text = lyricText;
    [self.lyricsLabel sizeToFit];
    self.lyricsLabel.center = CGPointMake(CGRectGetWidth(self.containerView.frame)/2.0, CGRectGetHeight(self.containerView.frame)/2.0);
    self.containerView.maskView = self.lyricsLabel;
    
    self.progressLayer.frame = self.lyricsLabel.frame;
    self.progressLayer.lineWidth = CGRectGetHeight(self.lyricsLabel.frame);
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGFloat centerY = CGRectGetHeight(self.lyricsLabel.frame) / 2.0;
    [linePath moveToPoint:CGPointMake(0, centerY)];
    linePath.lineWidth = CGRectGetHeight(self.lyricsLabel.frame);
    [linePath addLineToPoint:CGPointMake(CGRectGetWidth(self.lyricsLabel.frame), centerY)];
    self.progressLayer.path = linePath.CGPath;
}

- (void)setProgress:(CGFloat)progress {
    progress = MAX(0, MIN(1, progress));
    _progress = progress;

    [self updatePlayProgressNoAnimation:progress];
}

// 更新歌词进度
- (void)updatePlayProgressNoAnimation:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.progressLayer.strokeEnd = progress;
    [CATransaction commit];
}

#pragma mark - Private

- (UILabel *)label {
    UILabel *view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 16)];
    view.numberOfLines = 1;
    view.backgroundColor = [UIColor clearColor];
    view.font = [UIFont boldSystemFontOfSize:16];
    view.textAlignment = NSTextAlignmentCenter;
    return view;
}

#pragma mark - Property

- (UILabel *)lyricsLabel {
    if (!_lyricsLabel) {
        _lyricsLabel = [self label];
    }
    return _lyricsLabel;
}

- (UIView *)containerView {
    if (!_containerView) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.backgroundColor = UIColor.yellowColor;
        _containerView = view;
    }
    return _containerView;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.strokeColor = [UIColor redColor].CGColor;
        layer.strokeStart = 0.0f;
        layer.strokeEnd = 0.0;
        _progressLayer = layer;
    }
    return _progressLayer;
}

@end
