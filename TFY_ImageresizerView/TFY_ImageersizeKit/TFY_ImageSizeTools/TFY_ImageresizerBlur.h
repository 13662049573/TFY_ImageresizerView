//
//  TFY_ImageresizerBlur.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerBlur : UIView
/**
 *  初始化模糊版
 */
- (instancetype)initWithFrame:(CGRect)frame
                   blurEffect:(UIBlurEffect *)blurEffect
                      bgColor:(UIColor *)bgColor
                    maskAlpha:(CGFloat)maskAlpha;
/**
 * 开启
 */
- (BOOL)isBlur;
/**
 *  设计模板
 */
- (UIBlurEffect *)blurEffect;
/**
 *  模板颜色
 */
- (UIColor *)bgColor;
/**
 *  模板透明度
 */
- (CGFloat)maskAlpha;
/**
 *  是否开启透明度
 */
- (BOOL)isMaskAlpha;
/**
 * 动画时间
 */
- (void)setIsBlur:(BOOL)isBlur duration:(NSTimeInterval)duration;
/**
 * 模板的时间
 */
- (void)setBlurEffect:(UIBlurEffect *)blurEffect duration:(NSTimeInterval)duration;
/**
 *  模板颜色 和 时间
 */
- (void)setBgColor:(UIColor *)bgColor duration:(NSTimeInterval)duration;
/**
 *  透明度 的时间设计
 */
- (void)setMaskAlpha:(BOOL)maskAlpha duration:(NSTimeInterval)duration;
/**
 *  最大透明度 时间
 */
- (void)setIsMaskAlpha:(BOOL)isMaskAlpha duration:(NSTimeInterval)duration;
/**
 *  模板总体设计
 */
- (void)setupIsBlur:(BOOL)isBlur
         blurEffect:(UIBlurEffect *)blurEffect
            bgColor:(UIColor *)bgColor
          maskAlpha:(CGFloat)maskAlpha
        isMaskAlpha:(BOOL)isMaskAlpha
           duration:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
