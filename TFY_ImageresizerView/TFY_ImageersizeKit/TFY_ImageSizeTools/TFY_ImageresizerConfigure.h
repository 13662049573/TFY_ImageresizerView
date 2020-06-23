//
//  TFY_ImageresizerConfigure.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFY_ImageresizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerConfigure : NSObject
/**
 * 默认参数值：
    - viewFrame = [UIScreen mainScreen].bounds;
    - frameType = TFY_ConciseFrameType;
    - animationCurve = TFY_AnimationCurveLinear;
    - blurEffect = nil;
    - bgColor = [UIColor blackColor];
    - maskAlpha = 0.75;
    - strokeColor = [UIColor whiteColor];
    - resizeWHScale = 0.0;
    - isArbitrarilyInitial = YES;
    - contentInsets = UIEdgeInsetsZero;
    - borderImage = nil;
    - borderImageRectInset = CGPointZero;
    - maximumZoomScale = 10.0;
    - isRoundResize = NO;
    - isShowMidDots = YES;
    - isBlurWhenDragging = NO;
    - isShowGridlinesWhenDragging = NO;
    - gridCount = 3;
    - maskImage = nil;
    - isArbitrarilyMask = NO;
 */
+ (instancetype)defaultConfigureWithResizeImage:(UIImage *_Nonnull)resizeImage make:(void(^)(TFY_ImageresizerConfigure *configure))make;

/**
 * 默认参数的基础上：
    - blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    - bgColor = [UIColor whiteColor];
    - maskAlpha = 0.3;
 */
+ (instancetype)lightBlurMaskTypeConfigureWithResizeImage:(UIImage *_Nonnull)resizeImage make:(void (^)(TFY_ImageresizerConfigure *configure))make;

/**
 * 默认参数的基础上：
    - blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    - bgColor = [UIColor blackColor];
    - maskAlpha = 0.3;
 */
+ (instancetype)darkBlurMaskTypeConfigureWithResizeImage:(UIImage *_Nonnull)resizeImage make:(void (^)(TFY_ImageresizerConfigure *configure))make;

/** 裁剪图片 */
@property (nonatomic, strong) UIImage *_Nonnull resizeImage;

/** 视图区域 */
@property (nonatomic, assign) CGRect viewFrame;

/** 边框样式 */
@property (nonatomic, assign) TFY_ImageresizerFrameType frameType;

/** 动画曲线 */
@property (nonatomic, assign) TFY_AnimationCurve animationCurve;

/** 模糊效果 */
@property (nonatomic, strong) UIBlurEffect *_Nonnull blurEffect;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *_Nonnull bgColor;

/** 遮罩颜色的透明度（背景颜色 * 透明度） */
@property (nonatomic, assign) CGFloat maskAlpha;

/** 裁剪线颜色 */
@property (nonatomic, strong) UIColor *_Nonnull strokeColor;

/** 裁剪宽高比（0则为任意比例） */
@property (nonatomic, assign) CGFloat resizeWHScale;

/** 初始化后裁剪宽高比是否可以任意改变（resizeWHScale 为 0 则为任意比例，该值则为 YES） */
@property (nonatomic, assign) BOOL isArbitrarilyInitial;

/** 裁剪框边线能否进行对边拖拽（当裁剪宽高比为0，即任意比例时才有效，默认为yes） */
@property (nonatomic, assign) BOOL edgeLineIsEnabled;

/** 裁剪区域与主视图的内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/** 是否顺时针旋转 */
@property (nonatomic, assign) BOOL isClockwiseRotation;

/** 边框图片 */
@property (nonatomic, strong) UIImage *borderImage;

/** 边框图片与边线的偏移量 */
@property (nonatomic, assign) CGPoint borderImageRectInset;

/** 最大缩放比例（默认为3.0，小于1.0则无效） */
@property (nonatomic, assign) CGFloat maximumZoomScale;

/** 是否初始化圆切（若为YES则resizeWHScale为1） */
@property (nonatomic, assign) BOOL isRoundResize;

/** 是否显示中间的4个点（上、下、左、右的中点） */
@property (nonatomic, assign) BOOL isShowMidDots;

/** 拖拽时是否遮罩裁剪区域以外的区域 */
@property (nonatomic) BOOL isBlurWhenDragging;

/** 拖拽时是否能继续显示网格线（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格） */
@property (nonatomic) BOOL isShowGridlinesWhenDragging;

/** 每行/列的网格数（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格） */
@property (nonatomic, assign) NSUInteger gridCount;

/** 蒙版图片 */
@property (nonatomic, strong) UIImage *_Nonnull maskImage;

/** 蒙版图片是否可以拖拽形变 */
@property (nonatomic, assign) BOOL isArbitrarilyMask;

@property (readonly) TFY_ImageresizerConfigure *(^tfy_resizeImage)(UIImage *resizeImage);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_viewFrame)(CGRect viewFrame);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_frameType)(TFY_ImageresizerFrameType frameType);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_animationCurve)(TFY_AnimationCurve animationCurve);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_blurEffect)(UIBlurEffect *_Nonnull blurEffect);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_bgColor)(UIColor *_Nonnull bgColor);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_maskAlpha)(CGFloat maskAlpha);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_strokeColor)(UIColor *_Nonnull strokeColor);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_resizeWHScale)(CGFloat resizeWHScale);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isArbitrarilyInitial)(BOOL isArbitrarilyInitial);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_edgeLineIsEnabled)(BOOL edgeLineIsEnabled);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_contentInsets)(UIEdgeInsets contentInsets);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isClockwiseRotation)(BOOL isClockwiseRotation);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_borderImage)(UIImage *_Nonnull borderImage);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_borderImageRectInset)(CGPoint borderImageRectInset);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_maximumZoomScale)(CGFloat maximumZoomScale);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isRoundResize)(BOOL isRoundResize);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isShowMidDots)(BOOL isShowMidDots);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isBlurWhenDragging)(BOOL isBlurWhenDragging);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isShowGridlinesWhenDragging)(BOOL isShowGridlinesWhenDragging);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_gridCount)(NSUInteger gridCount);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_maskImage)(UIImage *_Nonnull maskImage);
@property (readonly) TFY_ImageresizerConfigure *(^tfy_isArbitrarilyMask)(BOOL isArbitrarilyMask);
@end

NS_ASSUME_NONNULL_END
