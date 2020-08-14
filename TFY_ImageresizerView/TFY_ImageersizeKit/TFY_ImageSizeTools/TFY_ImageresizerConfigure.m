//
//  TFY_ImageresizerConfigure.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImageresizerConfigure.h"

@implementation TFY_ImageresizerConfigure

+ (instancetype)defaultConfigureWithImage:(UIImage *)image make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure.image = image;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)defaultConfigureWithImageData:(NSData *)imageData make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure.imageData = imageData;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)defaultConfigureWithVideoURL:(NSURL *)videoURL
                                        make:(void (^)(TFY_ImageresizerConfigure *))make
                               fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                               fixStartBlock:(void(^)(void))fixStartBlock
                            fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                            fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure.videoURL = videoURL;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)defaultConfigureWithVideoAsset:(AVURLAsset *)videoAsset
                                          make:(void (^)(TFY_ImageresizerConfigure *))make
                                 fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                                 fixStartBlock:(void(^)(void))fixStartBlock
                              fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                              fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure.videoAsset = videoAsset;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}

+ (instancetype)lightBlurMaskTypeConfigureWithImage:(UIImage *)image make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __lightBlurMaskTypeConfigure];
    configure.image = image;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)lightBlurMaskTypeConfigureWithImageData:(NSData *)imageData make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __lightBlurMaskTypeConfigure];
    configure.imageData = imageData;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)lightBlurMaskTypeConfigureWithVideoURL:(NSURL *)videoURL
                                                  make:(void (^)(TFY_ImageresizerConfigure *))make
                                         fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                                         fixStartBlock:(void(^)(void))fixStartBlock
                                      fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                                      fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __lightBlurMaskTypeConfigure];
    configure.videoURL = videoURL;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)lightBlurMaskTypeConfigureWithVideoAsset:(AVURLAsset *)videoAsset
                                                    make:(void (^)(TFY_ImageresizerConfigure *))make
                                           fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                                           fixStartBlock:(void(^)(void))fixStartBlock
                                        fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                                        fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __lightBlurMaskTypeConfigure];
    configure.videoAsset = videoAsset;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}

+ (instancetype)darkBlurMaskTypeConfigureWithImage:(UIImage *)image make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __darkBlurMaskTypeConfigure];
    configure.image = image;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)darkBlurMaskTypeConfigureWithImageData:(NSData *)imageData make:(void (^)(TFY_ImageresizerConfigure *))make {
    TFY_ImageresizerConfigure *configure = [self __darkBlurMaskTypeConfigure];
    configure.imageData = imageData;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)darkBlurMaskTypeConfigureWithVideoURL:(NSURL *)videoURL
                                                 make:(void (^)(TFY_ImageresizerConfigure *))make
                                        fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                                        fixStartBlock:(void(^)(void))fixStartBlock
                                     fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                                     fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __darkBlurMaskTypeConfigure];
    configure.videoURL = videoURL;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}
+ (instancetype)darkBlurMaskTypeConfigureWithVideoAsset:(AVURLAsset *)videoAsset
                                                   make:(void (^)(TFY_ImageresizerConfigure *))make
                                          fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                                          fixStartBlock:(void(^)(void))fixStartBlock
                                       fixProgressBlock:(TFY_ExportVideoProgressBlock)fixProgressBlock
                                       fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock {
    TFY_ImageresizerConfigure *configure = [self __darkBlurMaskTypeConfigure];
    configure.videoAsset = videoAsset;
    configure.fixErrorBlock = fixErrorBlock;
    configure.fixStartBlock = fixStartBlock;
    configure.fixProgressBlock = fixProgressBlock;
    configure.fixCompleteBlock = fixCompleteBlock;
    !make ? : make(configure);
    return configure;
}

+ (instancetype)__defaultConfigure {
    TFY_ImageresizerConfigure *configure = [[self alloc] init];
    configure
    .tfy_viewFrame([UIScreen mainScreen].bounds)
    .tfy_blurEffect(nil)
    .tfy_frameType(TFY_ConciseFrameType)
    .tfy_animationCurve(TFY_AnimationCurveEaseOut)
    .tfy_strokeColor(UIColor.whiteColor)
    .tfy_bgColor(UIColor.blackColor)
    .tfy_maskAlpha(0.75)
    .tfy_resizeWHScale(0.0)
    .tfy_isRoundResize(NO)
    .tfy_maskImage(nil)
    .tfy_isArbitrarily(YES)
    .tfy_edgeLineIsEnabled(YES)
    .tfy_contentInsets(UIEdgeInsetsZero)
    .tfy_borderImage(nil)
    .tfy_borderImageRectInset(CGPointZero)
    .tfy_maximumZoomScale(10.0)
    .tfy_isShowMidDots(YES)
    .tfy_isBlurWhenDragging(NO)
    .tfy_isShowGridlinesWhenIdle(NO)
    .tfy_isShowGridlinesWhenDragging(YES)
    .tfy_gridCount(3)
    .tfy_isLoopPlaybackGIF(NO);
    return configure;
}

+ (TFY_ImageresizerConfigure *)__lightBlurMaskTypeConfigure {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure
    .tfy_blurEffect([UIBlurEffect effectWithStyle:UIBlurEffectStyleLight])
    .tfy_bgColor(UIColor.whiteColor)
    .tfy_maskAlpha(0.25)
    .tfy_strokeColor([UIColor colorWithRed:(56.0 / 255.0) green:(121.0 / 255.0) blue:(242.0 / 255.0) alpha:1.0]);
    return configure;
}

+ (TFY_ImageresizerConfigure *)__darkBlurMaskTypeConfigure {
    TFY_ImageresizerConfigure *configure = [self __defaultConfigure];
    configure
    .tfy_blurEffect([UIBlurEffect effectWithStyle:UIBlurEffectStyleDark])
    .tfy_bgColor(UIColor.blackColor)
    .tfy_maskAlpha(0.25);
    return configure;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        _imageData = nil;
        _videoURL = nil;
        _videoAsset = nil;
    }
}

- (void)setImageData:(NSData *)imageData {
    _imageData = imageData;
    if (imageData) {
        _image = nil;
        _videoURL = nil;
        _videoAsset = nil;
    }
}

- (void)setVideoURL:(NSURL *)videoURL {
    _videoURL = videoURL;
    if (videoURL) {
        _image = nil;
        _imageData = nil;
        _videoAsset = nil;
    }
}

- (void)setVideoAsset:(AVURLAsset *)videoAsset {
    _videoAsset = videoAsset;
    if (videoAsset) {
        _image = nil;
        _imageData = nil;
        _videoURL = nil;
    }
}

- (TFY_ImageresizerConfigure *(^)(CGRect))tfy_viewFrame {
    return ^(CGRect viewFrame) {
        self.viewFrame = viewFrame;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(TFY_ImageresizerFrameType))tfy_frameType {
    return ^(TFY_ImageresizerFrameType frameType) {
        self.frameType = frameType;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(TFY_AnimationCurve))tfy_animationCurve {
    return ^(TFY_AnimationCurve animationCurve) {
        self.animationCurve = animationCurve;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIBlurEffect *))tfy_blurEffect {
    return ^(UIBlurEffect *blurEffect) {
        self.blurEffect = blurEffect;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIColor *))tfy_bgColor {
    return ^(UIColor *bgColor) {
        self.bgColor = bgColor;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(CGFloat))tfy_maskAlpha {
    return ^(CGFloat maskAlpha) {
        self.maskAlpha = maskAlpha;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIColor *))tfy_strokeColor {
    return ^(UIColor *strokeColor) {
        self.strokeColor = strokeColor;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(CGFloat))tfy_resizeWHScale {
    return ^(CGFloat resizeWHScale) {
        self.resizeWHScale = resizeWHScale;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isRoundResize {
    return ^(BOOL isRoundResize) {
        self.isRoundResize = isRoundResize;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIImage *))tfy_maskImage {
    return ^(UIImage *maskImage) {
        self.maskImage = maskImage;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isArbitrarily {
    return ^(BOOL isArbitrarily) {
        self.isArbitrarily = isArbitrarily;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_edgeLineIsEnabled {
    return ^(BOOL edgeLineIsEnabled) {
        self.edgeLineIsEnabled = edgeLineIsEnabled;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIEdgeInsets))tfy_contentInsets {
    return ^(UIEdgeInsets contentInsets) {
        self.contentInsets = contentInsets;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isClockwiseRotation {
    return ^(BOOL isClockwiseRotation) {
        self.isClockwiseRotation = isClockwiseRotation;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(UIImage *))tfy_borderImage {
    return ^(UIImage *borderImage) {
        self.borderImage = borderImage;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(CGPoint))tfy_borderImageRectInset {
    return ^(CGPoint borderImageRectInset) {
        self.borderImageRectInset = borderImageRectInset;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(CGFloat))tfy_maximumZoomScale {
    return ^(CGFloat maximumZoomScale) {
        self.maximumZoomScale = maximumZoomScale;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isShowMidDots {
    return ^(BOOL isShowMidDots) {
        self.isShowMidDots = isShowMidDots;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isBlurWhenDragging {
    return ^(BOOL isBlurWhenDragging) {
        self.isBlurWhenDragging = isBlurWhenDragging;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isShowGridlinesWhenIdle {
    return ^(BOOL isShowGridlinesWhenIdle) {
        self.isShowGridlinesWhenIdle = isShowGridlinesWhenIdle;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isShowGridlinesWhenDragging {
    return ^(BOOL isShowGridlinesWhenDragging) {
        self.isShowGridlinesWhenDragging = isShowGridlinesWhenDragging;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(NSUInteger))tfy_gridCount {
    return ^(NSUInteger gridCount) {
        self.gridCount = gridCount;
        return self;
    };
}

- (TFY_ImageresizerConfigure *(^)(BOOL))tfy_isLoopPlaybackGIF {
    return ^(BOOL isLoopPlaybackGIF) {
        self.isLoopPlaybackGIF = isLoopPlaybackGIF;
        return self;
    };
}

@end
