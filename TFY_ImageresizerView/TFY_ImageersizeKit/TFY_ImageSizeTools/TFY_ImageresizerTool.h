//
//  TFY_ImageresizerTool.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/14.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFY_ImageresizerType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerTool : NSObject
/**
 * 转换成黑色轮廓的图片
 */
+ (UIImage *)convertBlackImage:(UIImage *)image;

/**
 * 解码GIF【该方法采用的是 YYKit 的代码（膜拜大神）】
 */
+ (UIImage *)decodeGIFData:(NSData *)data;

/**
 * 是否GIF
 */
+ (BOOL)isGIFData:(NSData *)data;

#pragma mark - 裁剪图片
/**
 * 裁剪图片（UIImage）
 */
+ (void)cropPictureWithImage:(UIImage *)image
                   maskImage:(UIImage *)maskImage
                   configure:(TFY_CropConfigure)configure
               compressScale:(CGFloat)compressScale
                    cacheURL:(NSURL *)cacheURL
                  errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
               completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 裁剪图片（NSData）
 */
+ (void)cropPictureWithImageData:(NSData *)imageData
                       maskImage:(UIImage *)maskImage
                       configure:(TFY_CropConfigure)configure
                   compressScale:(CGFloat)compressScale
                        cacheURL:(NSURL *)cacheURL
                      errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
                   completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

#pragma mark - 裁剪GIF
/**
 * 裁剪GIF（UIImage）
 */
+ (void)cropGIFWithGifImage:(UIImage *)gifImage
             isReverseOrder:(BOOL)isReverseOrder
                       rate:(float)rate
                  maskImage:(UIImage *)maskImage
                  configure:(TFY_CropConfigure)configure
              compressScale:(CGFloat)compressScale
                   cacheURL:(NSURL *)cacheURL
                 errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
              completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 裁剪GIF其中一帧（UIImage）
 */
+ (void)cropGIFWithGifImage:(UIImage *)gifImage
                      index:(NSInteger)index
                  maskImage:(UIImage *)maskImage
                  configure:(TFY_CropConfigure)configure
              compressScale:(CGFloat)compressScale
                   cacheURL:(NSURL *)cacheURL
                 errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
              completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 裁剪GIF（NSData）
 */
+ (void)cropGIFWithGifData:(NSData *)gifData
            isReverseOrder:(BOOL)isReverseOrder
                      rate:(float)rate
                 maskImage:(UIImage *)maskImage
                 configure:(TFY_CropConfigure)configure
             compressScale:(CGFloat)compressScale
                  cacheURL:(NSURL *)cacheURL
                errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
             completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 裁剪GIF其中一帧（NSData）
 */
+ (void)cropGIFWithGifData:(NSData *)gifData
                     index:(NSInteger)index
                 maskImage:(UIImage *)maskImage
                 configure:(TFY_CropConfigure)configure
             compressScale:(CGFloat)compressScale
                  cacheURL:(NSURL *)cacheURL
                errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
             completeBlock:(TFY_CropPictureDoneBlock)completeBlock;


#pragma mark - 裁剪视频
/**
 * 裁剪视频其中一帧
 */
+ (void)cropVideoWithAsset:(AVURLAsset *)asset
                      time:(CMTime)time
               maximumSize:(CGSize)maximumSize
                 maskImage:(UIImage *)maskImage
                 configure:(TFY_CropConfigure)configure
             compressScale:(CGFloat)compressScale
                  cacheURL:(NSURL *)cacheURL
                errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
             completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 截取视频一小段并裁剪成GIF
 */
+ (void)cropVideoToGIFWithAsset:(AVURLAsset *)asset
                    startSecond:(NSTimeInterval)startSecond
                       duration:(NSTimeInterval)duration
                            fps:(float)fps
                           rate:(float)rate
                    maximumSize:(CGSize)maximumSize
                      maskImage:(UIImage *)maskImage
                      configure:(TFY_CropConfigure)configure
                       cacheURL:(NSURL *)cacheURL
                     errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
                  completeBlock:(TFY_CropPictureDoneBlock)completeBlock;

/**
 * 裁剪视频
 */
+ (void)cropVideoWithAsset:(AVURLAsset *)asset
                 timeRange:(CMTimeRange)timeRange
             frameDuration:(CMTime)frameDuration
                presetName:(NSString *)presetName
                 configure:(TFY_CropConfigure)configure
                  cacheURL:(NSURL *)cacheURL
                errorBlock:(TFY_ImageresizerErrorBlock)errorBlock
                startBlock:(TFY_ExportVideoStartBlock)startBlock
             completeBlock:(TFY_ExportVideoCompleteBlock)completeBlock;

#pragma mark - 修正视频方向
+ (void)fixOrientationVideoWithAsset:(AVURLAsset *)asset
                       fixErrorBlock:(TFY_ImageresizerErrorBlock)fixErrorBlock
                       fixStartBlock:(TFY_ExportVideoStartBlock)fixStartBlock
                    fixCompleteBlock:(TFY_ExportVideoCompleteBlock)fixCompleteBlock;


- (instancetype)initWithAsset:(AVURLAsset *)asset isFixedOrientation:(BOOL)isFixedOrientation;
@property (nonatomic, strong, readonly) AVURLAsset *asset;
@property (nonatomic, assign, readonly) NSTimeInterval seconds;
@property (nonatomic, assign, readonly) CMTimeScale timescale;
@property (nonatomic, assign, readonly) CMTimeRange timeRange;
@property (nonatomic, assign, readonly) CMTime toleranceTime;
@property (nonatomic, assign, readonly) CMTime frameDuration;
@property (nonatomic, assign, readonly) CGSize videoSize;

@end

@interface TFY_PlayerView : UIView
- (instancetype)initWithVideoObj:(TFY_ImageresizerTool *)videoObj;
- (AVPlayerLayer *)playerLayer;
@property (nonatomic, weak) TFY_ImageresizerTool *videoObj;
@property (nonatomic, strong, readonly) AVPlayerItem *item;
@property (nonatomic, strong, readonly) AVPlayer *player;
@end

NS_ASSUME_NONNULL_END
