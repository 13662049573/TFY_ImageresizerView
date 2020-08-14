//
//  TFY_ImageresizerSlider.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/14.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImageresizerSlider : UIView
+ (CGFloat)viewHeight;
+ (instancetype)imageresizerSlider:(float)seconds second:(float)second;
- (void)setImageresizerFrame:(CGRect)imageresizerFrame isRoundResize:(BOOL)isRoundResize;
- (void)resetSeconds:(float)seconds second:(float)second;
- (float)seconds;
@property (nonatomic) float second;
@property (nonatomic, copy) void (^sliderBeginBlock)(float second, float totalSecond);
@property (nonatomic, copy) void (^sliderDragingBlock)(float second, float totalSecond);
@property (nonatomic, copy) void (^sliderEndBlock)(float second, float totalSecond);
@end

NS_ASSUME_NONNULL_END
