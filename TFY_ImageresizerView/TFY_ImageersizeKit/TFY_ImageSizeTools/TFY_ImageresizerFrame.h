//
//  TFY_ImageresizerFrame.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ImageresizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerFrame : UIView

- (instancetype)initWithFrame:(CGRect)frame
           baseContentMaxSize:(CGSize)baseContentMaxSize
                    frameType:(TFY_ImageresizerFrameType)frameType
               animationCurve:(TFY_AnimationCurve)animationCurve
                   blurEffect:(UIBlurEffect *)blurEffect
                      bgColor:(UIColor *)bgColor
                    maskAlpha:(CGFloat)maskAlpha
                  strokeColor:(UIColor *)strokeColor
                resizeWHScale:(CGFloat)resizeWHScale
         isArbitrarilyInitial:(BOOL)isArbitrarilyInitial
                   scrollView:(UIScrollView *)scrollView
                    imageView:(UIImageView *)imageView
                  borderImage:(UIImage *)borderImage
         borderImageRectInset:(CGPoint)borderImageRectInset
                isRoundResize:(BOOL)isRoundResize
                isShowMidDots:(BOOL)isShowMidDots
           isBlurWhenDragging:(BOOL)isBlurWhenDragging
  isShowGridlinesWhenDragging:(BOOL)isShowGridlinesWhenDragging
                    gridCount:(NSUInteger)gridCount
                    maskImage:(UIImage *)maskImage
            isArbitrarilyMask:(BOOL)isArbitrarilyMask
    imageresizerIsCanRecovery:(TFY_ImageresizerIsCanRecoveryBlock)imageresizerIsCanRecovery
 imageresizerIsPrepareToScale:(TFY_ImageresizerIsPrepareToScaleBlock)imageresizerIsPrepareToScale;

@property (nonatomic, assign, readonly) CGSize baseContentMaxSize;

@property (nonatomic, weak, readonly) UIPanGestureRecognizer *panGR;

@property (nonatomic, assign, readonly) TFY_ImageresizerFrameType frameType;

@property (nonatomic, assign, readonly) NSTimeInterval defaultDuration;

@property (nonatomic, assign) TFY_AnimationCurve animationCurve;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) UIBlurEffect *blurEffect;
@property (nonatomic) UIColor *bgColor;
@property (nonatomic) CGFloat maskAlpha;
- (void)setupStrokeColor:(UIColor *)strokeColor
              blurEffect:(UIBlurEffect *)blurEffect
                 bgColor:(UIColor *)bgColor
               maskAlpha:(CGFloat)maskAlpha
                animated:(BOOL)isAnimated;

@property (nonatomic, assign, readonly) CGRect imageresizerFrame;

@property (nonatomic, assign) CGFloat resizeWHScale;
- (void)setResizeWHScale:(CGFloat)resizeWHScale isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;

- (void)roundResize:(BOOL)isAnimated;
- (BOOL)isRoundResizing;

@property (nonatomic, assign) BOOL isPreview;
- (void)setIsPreview:(BOOL)isPreview animated:(BOOL)isAnimated;

@property (nonatomic, assign) CGFloat initialResizeWHScale;

@property (nonatomic, assign) BOOL edgeLineIsEnabled;

@property (nonatomic, assign, readonly) BOOL isCanRecovery;
@property (nonatomic, copy) TFY_ImageresizerIsCanRecoveryBlock imageresizerIsCanRecovery;

@property (nonatomic, assign, readonly) BOOL isPrepareToScale;
@property (nonatomic, copy) TFY_ImageresizerIsPrepareToScaleBlock imageresizerIsPrepareToScale;

@property (nonatomic, assign, readonly) TFY_ImageresizerRotationDirection rotationDirection;

@property (nonatomic, assign, readonly) CGFloat scrollViewMinZoomScale;

@property (nonatomic, strong) UIImage *borderImage;
@property (nonatomic, assign) CGPoint borderImageRectInset;

@property (nonatomic, assign) BOOL isShowMidDots;
@property (nonatomic, assign) BOOL isBlurWhenDragging;
@property (nonatomic, assign) BOOL isShowGridlinesWhenDragging;
@property (nonatomic, assign) NSUInteger gridCount;

@property (nonatomic, copy) BOOL (^isVerticalityMirror)(void);
@property (nonatomic, copy) BOOL (^isHorizontalMirror)(void);

- (void)updateFrameType:(TFY_ImageresizerFrameType)frameType;

- (void)updateImageOriginFrameWithDuration:(NSTimeInterval)duration;

- (void)startImageresizer;
- (void)endedImageresizer;

- (NSTimeInterval)willRotationWithDirection:(TFY_ImageresizerRotationDirection)direction;
- (void)rotating:(CGFloat)angle duration:(NSTimeInterval)duration;
- (void)rotationDone;

- (NSTimeInterval)willMirror:(BOOL)isHorizontalMirror diffValue:(CGFloat)diffValue afterFrame:(CGRect *)afterFrame animated:(BOOL)isAnimated;
- (void)mirrorDone;

- (NSTimeInterval)willRecoveryToRoundResize:(BOOL)isAnimated;
- (NSTimeInterval)willRecoveryToMaskImage:(UIImage *)maskImage animated:(BOOL)isAnimated;
- (NSTimeInterval)willRecoveryToResizeWHScale:(CGFloat)resizeWHScale isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;
- (void)recoveryWithDuration:(NSTimeInterval)duration;
- (void)recoveryDone:(BOOL)isUpdateMaskImage;

- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete compressScale:(CGFloat)compressScale;

- (void)superViewUpdateFrame:(CGRect)superViewFrame contentInsets:(UIEdgeInsets)contentInsets duration:(NSTimeInterval)duration;

@property (nonatomic, strong) UIImage *maskImage;
- (void)setMaskImage:(UIImage *)maskImage animated:(BOOL)isAnaimated;

@property (nonatomic, assign) BOOL isArbitrarilyMask;
- (void)setIsArbitrarilyMask:(BOOL)isArbitrarilyMask animated:(BOOL)isAnimated;
@end

NS_ASSUME_NONNULL_END
