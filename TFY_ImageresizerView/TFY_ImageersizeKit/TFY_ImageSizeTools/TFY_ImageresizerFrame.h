//
//  TFY_ImageresizerFrame.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ImageresizerType.h"

@class TFY_ImageresizerSlider;

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerProxy : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak) id target;
@end

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
                isRoundResize:(BOOL)isRoundResize
                    maskImage:(UIImage *)maskImage
                isArbitrarily:(BOOL)isArbitrarily
                   scrollView:(UIScrollView *)scrollView
                    imageView:(UIImageView *)imageView
                  borderImage:(UIImage *)borderImage
         borderImageRectInset:(CGPoint)borderImageRectInset
                isShowMidDots:(BOOL)isShowMidDots
           isBlurWhenDragging:(BOOL)isBlurWhenDragging
      isShowGridlinesWhenIdle:(BOOL)isShowGridlinesWhenIdle
  isShowGridlinesWhenDragging:(BOOL)isShowGridlinesWhenDragging
                    gridCount:(NSUInteger)gridCount
    imageresizerIsCanRecovery:(TFY_ImageresizerIsCanRecoveryBlock)imageresizerIsCanRecovery
 imageresizerIsPrepareToScale:(TFY_ImageresizerIsPrepareToScaleBlock)imageresizerIsPrepareToScale
          isVerticalityMirror:(BOOL(^)(void))isVerticalityMirror
           isHorizontalMirror:(BOOL(^)(void))isHorizontalMirror
             resizeObjWhScale:(CGFloat(^)(void))resizeObjWhScale;

@property (nonatomic, copy) BOOL (^isVerticalityMirror)(void);
@property (nonatomic, copy) BOOL (^isHorizontalMirror)(void);
@property (nonatomic, copy) CGFloat (^resizeObjWhScale)(void);

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
@property (readonly) CGFloat imageresizerWHScale;

@property (nonatomic, assign) CGFloat resizeWHScale;
- (void)setResizeWHScale:(CGFloat)resizeWHScale isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;

@property (nonatomic, assign) BOOL isRoundResize;
- (void)setIsRoundResize:(BOOL)isRoundResize isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;

@property (nonatomic, strong) UIImage *maskImage;
- (void)setMaskImage:(UIImage *)maskImage isToBeArbitrarily:(BOOL)isToBeArbitrarily animated:(BOOL)isAnimated;

@property (nonatomic, assign) BOOL isArbitrarily;
- (void)setIsArbitrarily:(BOOL)isArbitrarily animated:(BOOL)isAnimated;

@property (nonatomic, assign) BOOL isPreview;
- (void)setIsPreview:(BOOL)isPreview animated:(BOOL)isAnimated;

@property (nonatomic, assign) CGFloat initialResizeWHScale;

@property (nonatomic, assign) BOOL edgeLineIsEnabled;

@property (nonatomic, assign, readonly) BOOL isCanRecovery;
@property (nonatomic, copy) TFY_ImageresizerIsCanRecoveryBlock imageresizerIsCanRecovery;

@property (nonatomic, assign) BOOL isPrepareToScale;
@property (nonatomic, copy) TFY_ImageresizerIsPrepareToScaleBlock imageresizerIsPrepareToScale;

@property (nonatomic, assign, readonly) TFY_ImageresizerRotationDirection rotationDirection;

@property (nonatomic, strong) UIImage *borderImage;
@property (nonatomic, assign) CGPoint borderImageRectInset;

@property (nonatomic, assign) BOOL isShowMidDots;
@property (nonatomic, assign) BOOL isBlurWhenDragging;
@property (nonatomic, assign) BOOL isShowGridlinesWhenIdle;
@property (nonatomic, assign) BOOL isShowGridlinesWhenDragging;
@property (nonatomic, assign) NSUInteger gridCount;

- (void)updateFrameType:(TFY_ImageresizerFrameType)frameType;

- (void)updateImageOriginFrameWithDuration:(NSTimeInterval)duration;

- (void)startImageresizer;
- (void)endedImageresizer;

- (NSTimeInterval)willRotationWithDirection:(TFY_ImageresizerRotationDirection)direction;
- (void)rotating:(CGFloat)angle duration:(NSTimeInterval)duration;
- (void)rotationDone;

- (NSTimeInterval)willMirror:(BOOL)isHorizontalMirror diffValue:(CGFloat)diffValue afterFrame:(CGRect *)afterFrame animated:(BOOL)isAnimated;
- (void)mirrorDone;

- (NSTimeInterval)willRecoveryToResizeWHScale:(CGFloat)resizeWHScale
                              orToRoundResize:(BOOL)isRoundResize
                                orToMaskImage:(UIImage *)maskImage
                            isToBeArbitrarily:(BOOL)isToBeArbitrarily
                                     animated:(BOOL)isAnimated;
- (void)recoveryWithDuration:(NSTimeInterval)duration;
- (void)recoveryDone:(BOOL)isUpdateMaskImage;

- (void)superViewUpdateFrame:(CGRect)superViewFrame contentInsets:(UIEdgeInsets)contentInsets duration:(NSTimeInterval)duration;

@property (nonatomic, weak) UIView *playerView;
@property (nonatomic, weak) TFY_ImageresizerSlider *slider;

- (TFY_CropConfigure)currentCropConfigure;

@end


NS_ASSUME_NONNULL_END
