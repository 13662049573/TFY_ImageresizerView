//
//  TFY_ImageController.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ImageersizeHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageController : UIViewController
+ (UIImage *)stretchBorderImage;
+ (CGPoint)stretchBorderImageRectInset;
+ (UIImage *)tileBorderImage;
+ (CGPoint)tileBorderImageRectInset;

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) TFY_ImageresizerConfigure *configure;
@property (nonatomic, assign) BOOL isBecomeDanielWu;
@property (nonatomic, weak) TFY_ImageresizerView *imageresizerView;
@property (nonatomic, copy) void (^backBlock)(TFY_ImageController *vc);

@end

NS_ASSUME_NONNULL_END
