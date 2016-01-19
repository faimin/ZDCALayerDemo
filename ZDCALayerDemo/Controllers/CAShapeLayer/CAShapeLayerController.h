//
//  CAShapeLayerController.h
//  ZDCALayerDemo
//
//  Created by 符现超 on 16/1/12.
//  Copyright © 2016年 Fate.D.Bourne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAShapeLayerController : UIViewController

@property (nonatomic, copy  ) NSString *drawText;           ///< 显示的文字
@property (nonatomic, assign) CFTimeInterval timeInterval;  ///< 动画持续时间

@end
