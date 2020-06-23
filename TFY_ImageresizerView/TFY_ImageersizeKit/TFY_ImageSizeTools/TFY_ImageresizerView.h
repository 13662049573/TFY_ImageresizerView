//
//  TFY_ImageresizerView.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ImageresizerConfigure.h"
#import "TFY_ImageresizerFrame.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerView : UIView
/**
 * 层级结构
    - TFY_ImageresizerView（self）
        - scrollView
            - imageView（裁剪的imageView）
        - frameView（绘制裁剪边框的view）
 * scrollView与frameView的frame一致
 */
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) TFY_ImageresizerFrame *frameView;

/**
 类方法（推荐）
 configure --- 包含了所有初始化参数
 使用TFY_ImageresizerConfigure配置好参数
 */
+ (instancetype)imageresizerViewWithConfigure:(TFY_ImageresizerConfigure *)configure
                    imageresizerIsCanRecovery:(TFY_ImageresizerIsCanRecoveryBlock)imageresizerIsCanRecovery
                 imageresizerIsPrepareToScale:(TFY_ImageresizerIsPrepareToScaleBlock)imageresizerIsPrepareToScale;

/**
 工厂方法
 resizeImage --- 裁剪图片
 frame --- 相对父视图的区域
 frameType --- 边框样式
 animationCurve --- 动画曲线
 blurEffect --- 模糊效果
 bgColor --- 背景颜色
 maskAlpha --- 遮罩颜色的透明度（背景颜色 * 透明度）
 strokeColor ---裁剪线颜色
 resizeWHScale --- 裁剪宽高比
 isArbitrarilyInitial --- 初始化后裁剪宽高比是否可以任意改变（resizeWHScale 为 0 则为任意比例，该值则为 YES）
 contentInsets --- 裁剪区域与主视图的内边距（可以通过 -updateFrame:contentInsets:duration: 方法进行修改）
 isClockwiseRotation --- 是否顺时针旋转
 borderImage --- 边框图片（若为nil则使用frameType的边框）
 borderImageRectInset --- 边框图片与边线的偏移量（即CGRectInset，用于调整边框图片与边线的差距）
 maximumZoomScale --- 最大缩放比例
 isRoundResize --- 是否初始化圆切（若为YES则resizeWHScale为1）
 isShowMidDots --- 是否显示中间的4个点（上、下、左、右的中点）
 isBlurWhenDragging --- 拖拽时是否遮罩裁剪区域以外的区域
 isShowGridlinesWhenDragging --- 拖拽时是否能继续显示网格线（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格）
 gridCount --- 每行/列的网格数（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格）
 maskImage --- 蒙版图片
 isArbitrarilyMask --- 蒙版图片是否可以以任意比例进行拖拽形变
 imageresizerIsCanRecovery --- 是否可以重置的回调（当裁剪区域缩放至适应范围后就会触发该回调）
 imageresizerIsPrepareToScale --- 是否预备缩放裁剪区域至适应范围（当裁剪区域发生变化的开始和结束就会触发该回调）
 自行配置参数
 */
- (instancetype)initWithResizeImage:(UIImage *)resizeImage
                              frame:(CGRect)frame
                          frameType:(TFY_ImageresizerFrameType)frameType
                     animationCurve:(TFY_AnimationCurve)animationCurve
                         blurEffect:(UIBlurEffect *)blurEffect
                            bgColor:(UIColor *)bgColor
                          maskAlpha:(CGFloat)maskAlpha
                        strokeColor:(UIColor *)strokeColor
                      resizeWHScale:(CGFloat)resizeWHScale
               isArbitrarilyInitial:(BOOL)isArbitrarilyInitial
                      contentInsets:(UIEdgeInsets)contentInsets
                isClockwiseRotation:(BOOL)isClockwiseRotation
                        borderImage:(UIImage *)borderImage
               borderImageRectInset:(CGPoint)borderImageRectInset
                   maximumZoomScale:(CGFloat)maximumZoomScale
                      isRoundResize:(BOOL)isRoundResize
                      isShowMidDots:(BOOL)isShowMidDots
                 isBlurWhenDragging:(BOOL)isBlurWhenDragging
        isShowGridlinesWhenDragging:(BOOL)isShowGridlinesWhenDragging
                          gridCount:(NSUInteger)gridCount
                          maskImage:(UIImage *)maskImage
                  isArbitrarilyMask:(BOOL)isArbitrarilyMask
          imageresizerIsCanRecovery:(TFY_ImageresizerIsCanRecoveryBlock)imageresizerIsCanRecovery
       imageresizerIsPrepareToScale:(TFY_ImageresizerIsPrepareToScaleBlock)imageresizerIsPrepareToScale;

/** 边框样式 */
@property (nonatomic) TFY_ImageresizerFrameType frameType;

/** 动画曲线（默认是线性Linear） */
@property (nonatomic, assign) TFY_AnimationCurve animationCurve;

/** 缩放系数zoomScale为最小时的裁剪最大显示区域 */
@property (readonly) CGSize baseContentMaxSize;

/**
 * 裁剪的图片
 * 设置该值会调用 -setResizeImage: animated: transition: 方法（isAnimated = YES，transition = UIViewAnimationTransitionCurlUp）
 */
@property (nonatomic) UIImage *resizeImage;

/**
 * 模糊效果
 * 设置该值会调用 -setupStrokeColor: blurEffect: bgColor: maskAlpha: animated: 方法（其他参数为当前值，isAnimated = YES）
 */
@property (nonatomic) UIBlurEffect *blurEffect;

/**
 * 背景颜色
 * 设置该值会调用 -setupStrokeColor: blurEffect: bgColor: maskAlpha: animated: 方法（其他参数为当前值，isAnimated = YES）
 */
@property (nonatomic) UIColor *bgColor;

/**
 * 遮罩颜色的透明度（背景颜色 * 透明度）
 * 设置该值会调用 -setupStrokeColor: blurEffect: bgColor: maskAlpha: animated: 方法（其他参数为当前值，isAnimated = YES）
 */
@property (nonatomic) CGFloat maskAlpha;

/**
 * 裁剪线颜色
 * 设置该值会调用 -setupStrokeColor: blurEffect: bgColor: maskAlpha: animated: 方法（其他参数为当前值，isAnimated = YES）
 */
@property (nonatomic) UIColor *strokeColor;

/**
 * 裁剪宽高比（0则为任意比例）
 * 设置该值会调用 -setResizeWHScale: isToBeArbitrarily: animated: 方法（isToBeArbitrarily = NO，isAnimated = YES）
 */
@property (nonatomic) CGFloat resizeWHScale;

/**
 * 初始裁剪宽高比（默认为初始化时的resizeWHScalem）
 * 调用 -recoveryByInitialResizeWHScale 方法进行重置则 resizeWHScale 会重置为该属性的值
 */
@property (nonatomic) CGFloat initialResizeWHScale;

/** 裁剪框当前的宽高比 */
@property (readonly) CGFloat imageresizeWHScale;

/** 裁剪框边线能否进行对边拖拽（当裁剪宽高比为0，即任意比例时才有效，默认为yes） */
@property (nonatomic, assign) BOOL edgeLineIsEnabled;

/** 是否顺时针旋转（默认逆时针） */
@property (nonatomic, assign) BOOL isClockwiseRotation;

/** 是否锁定裁剪区域（锁定后无法拖动裁剪区域） */
@property (nonatomic) BOOL isLockResizeFrame;

/**
 * 垂直镜像（沿着Y轴旋转180）
 * 设置该值会调用 -setVerticalityMirror: animated: 方法（isAnimated = YES）
 */
@property (nonatomic, assign) BOOL verticalityMirror;

/**
 * 水平镜像（沿着X轴旋转180）
 * 设置该值会调用 -setHorizontalMirror: animated: 方法（isAnimated = YES）
 */
@property (nonatomic, assign) BOOL horizontalMirror;

/**
 * 预览模式（隐藏边框，停止拖拽操作，用于预览裁剪后的区域）
 * 设置该值会调用 -setIsPreview: animated: 方法（isAnimated = YES）
 */
@property (nonatomic, assign) BOOL isPreview;

/** 边框图片（若为nil则使用frameType的边框） */
@property (nonatomic) UIImage *borderImage;

/** 边框图片与边线的偏移量（即CGRectInset，用于调整边框图片与边线的差距） */
@property (nonatomic) CGPoint borderImageRectInset;

/** 是否显示中间的4个点（上、下、左、右的中点） */
@property (nonatomic) BOOL isShowMidDots;

/** 拖拽时是否遮罩裁剪区域以外的区域 */
@property (nonatomic) BOOL isBlurWhenDragging;

/** 拖拽时是否能继续显示网格线（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格） */
@property (nonatomic) BOOL isShowGridlinesWhenDragging;

/** 每行/列的网格数（frameType 为 TFY_ClassicFrameType 且 gridCount > 1 且 maskImage 为 nil 才显示网格） */
@property (nonatomic, assign) NSUInteger gridCount;

/** 蒙版图片 */
@property (nonatomic) UIImage *maskImage;

/** 蒙版图片是否可以拖拽形变 */
@property (nonatomic) BOOL isArbitrarilyMask;

/**
 更换裁剪的图片
 resizeImage --- 裁剪的图片
 transition --- 切换效果（isAnimated为YES才生效，若为UIViewAnimationTransitionNone则由淡入淡出效果代替）
 isAnimated --- 是否带动画效果
 更换裁剪的图片，裁剪宽高比会重置
 */
- (void)setResizeImage:(UIImage *)resizeImage animated:(BOOL)isAnimated transition:(UIViewAnimationTransition)transition;

/**
 设置颜色
 strokeColor --- 裁剪线颜色
 blurEffect --- 模糊效果
 bgColor --- 背景颜色
 maskAlpha --- 遮罩颜色的透明度（背景颜色 * 透明度）
 isAnimated --- 是否带动画效果
 同时修改UI元素
 */
- (void)setupStrokeColor:(UIColor *)strokeColor
              blurEffect:(UIBlurEffect *)blurEffect
                 bgColor:(UIColor *)bgColor
               maskAlpha:(CGFloat)maskAlpha
                animated:(BOOL)isAnimated;

/**
 设置裁剪宽高比
 resizeWHScale --- 目标裁剪宽高比
 isToBeArbitrarily --- 设置之后 resizeWHScale 是否为任意比例（若为YES，最后 resizeWHScale = 0）
 isAnimated --- 是否带动画效果
 以最合适的尺寸更新裁剪框的尺寸（0则为任意比例）
 */
- (void)setResizeWHScale:(CGFloat)resizeWHScale isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;

/**
 圆切
 isAnimated --- 是否带动画效果
 以圆形裁剪，此状态下边框图片会隐藏，并且宽高比是1:1，恢复矩形则重设resizeWHScale
 */
- (void)roundResize:(BOOL)isAnimated;

/**
 是否正在圆切
 YES：圆切，NO：矩形
 */
- (BOOL)isRoundResizing;

/**
 设置是否垂直镜像
 verticalityMirror --- 是否垂直镜像
 isAnimated --- 是否带动画效果
 垂直镜像，沿着Y轴旋转180°
 */
- (void)setVerticalityMirror:(BOOL)verticalityMirror animated:(BOOL)isAnimated;

/**
 设置是否水平镜像
 horizontalMirror --- 是否水平镜像
 isAnimated --- 是否带动画效果
 水平镜像，沿着X轴旋转180°
 */
- (void)setHorizontalMirror:(BOOL)horizontalMirror animated:(BOOL)isAnimated;

/**
 设置是否预览
 isPreview --- 是否预览
 isAnimated --- 是否带动画效果
 隐藏边框，停止拖拽操作，用于预览裁剪后的区域
 */
- (void)setIsPreview:(BOOL)isPreview animated:(BOOL)isAnimated;

/**
 更新图片
 同步更新
 */
- (void)updateResizeImage:(UIImage *)resizeImage;

/**
 旋转图片
 旋转90度，支持4个方向，分别是垂直向上、水平向左、垂直向下、水平向右
 */
- (void)rotation;

/**
 重置回圆切状态
 以圆切状态回到最初状态
 */
- (void)recoveryToRoundResize;

/**
 按当前蒙版图片重置
 以当前蒙版图片的宽高比作为裁剪宽高比回到最初状态
 */
- (void)recoveryByCurrentMaskImage;

/**
 按指定蒙版图片重置
 重置指定蒙版图片，并以蒙版图片的宽高比作为裁剪宽高比回到最初状态
 */
- (void)recoveryToMaskImage:(UIImage *)maskImage;

/*!
 按当前裁剪宽高比（resizeWHScale）进行重置
 回到最初状态，resizeWHScale 不会被重置
 */
- (void)recoveryByCurrentResizeWHScale;

/**
 按当前裁剪宽高比（resizeWHScale）进行重置
 isToBeArbitrarily --- 重置之后 resizeWHScale 是否为任意比例（若为YES，最后 resizeWHScale = 0）
 回到最初状态，若 isToBeArbitrarily 为 YES，则重置之后 resizeWHScale =  0
 */
- (void)recoveryByCurrentResizeWHScale:(BOOL)isToBeArbitrarily;

/**
 按初始裁剪宽高比（initialResizeWHScale）进行重置
 isToBeArbitrarily --- 重置之后 resizeWHScale 是否为任意比例（若为YES，最后 resizeWHScale = 0）
 回到最初状态，若 isToBeArbitrarily 为 NO，则重置之后 resizeWHScale =  initialResizeWHScale
 */
- (void)recoveryByInitialResizeWHScale:(BOOL)isToBeArbitrarily;

/**
 按目标裁剪宽高比进行重置
 targetResizeWHScale --- 目标裁剪宽高比
 isToBeArbitrarily --- 重置之后 resizeWHScale 是否为任意比例（若为YES，最后 resizeWHScale = 0）
 回到最初状态，若 isToBeArbitrarily 为 NO，则重置之后 resizeWHScale  = targetResizeWHScale
 */
- (void)recoveryToTargetResizeWHScale:(CGFloat)targetResizeWHScale isToBeArbitrarily:(BOOL)isToBeArbitrarily;

/**
 原图尺寸裁剪
 complete --- 裁剪完成的回调
 裁剪过程在子线程，回调已切回到主线程，可调用该方法前加上状态提示
 */
- (void)originImageresizerWithComplete:(void(^)(UIImage *resizeImage))complete;

/**
 压缩尺寸裁剪
 complete --- 裁剪完成的回调
 compressScale --- 压缩比例，大于等于1按原图尺寸裁剪，小于等于0则返回nil（例：compressScale = 0.5，1000 x 500 --> 500 x 250）
 裁剪过程在子线程，回调已切回到主线程，可调用该方法前加上状态提示
 */
- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete compressScale:(CGFloat)compressScale;

/**
 修改视图整体Frame
 frame --- 刷新的Frame（例如横竖屏切换，传入self.view.bounds即可）
 contentInsets --- 裁剪区域与主视图的内边距
 duration --- 刷新时长（大于0即带有动画效果）
 可用在【横竖屏的切换】
 */
- (void)updateFrame:(CGRect)frame contentInsets:(UIEdgeInsets)contentInsets duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END
