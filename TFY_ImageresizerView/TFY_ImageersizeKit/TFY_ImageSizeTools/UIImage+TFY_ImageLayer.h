//
//  UIImage+TFY_ImageLayer.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TFY_ImageLayer)
/**
 图片大小
 */
- (UIImage *)tfy_destinationOutImage;
/**
 *  图片裁剪
 */
+ (UIImage *)tfy_resultImageWithImage:(UIImage *)originImage
                             cropFrame:(CGRect)cropFrame
                          relativeSize:(CGSize)relativeSize
                           isVerMirror:(BOOL)isVerMirror
                           isHorMirror:(BOOL)isHorMirror
                     rotateOrientation:(UIImageOrientation)orientation
                           isRoundClip:(BOOL)isRoundClip
                         compressScale:(CGFloat)compressScale
                             maskImage:(UIImage *)maskImage;

@end



@interface CABasicAnimation (TFY_ImageLayer)
/**
 *  动画
 */
+ (CABasicAnimation *)tfy_backwardsAnimationWithKeyPath:(NSString *)keyPath
                                               fromValue:(id)fromValue
                                                 toValue:(id)toValue
                                      timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                                duration:(NSTimeInterval)duration;

@end

@interface CALayer (TFY_ImageLayer)
/**
 * 绘制路径
 */
- (void)tfy_addBackwardsAnimationWithKeyPath:(NSString *)keyPath
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                           timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                     duration:(NSTimeInterval)duration;

@end


NS_ASSUME_NONNULL_END
