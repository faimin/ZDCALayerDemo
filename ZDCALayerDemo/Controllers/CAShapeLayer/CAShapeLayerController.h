//
//  CAShapeLayerController.h
//  ZDCALayerDemo
//
//  Created by Zero.D.Saber on 16/1/12.
//  Copyright © 2016年 Zero.D.Saber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAShapeLayerController : UIViewController

@property (nonatomic, copy  ) NSString *drawText;           ///< 显示的文字
@property (nonatomic, assign) CFTimeInterval timeInterval;  ///< 动画持续时间

@end
