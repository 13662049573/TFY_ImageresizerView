//
//  UIAlertController+TFY_Tools.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (TFY_Tools)
+ (void)changeResizeWHScale:(void(^)(CGFloat resizeWHScale))handler fromVC:(UIViewController *)fromVC;
+ (void)changeBlurEffect:(void(^)(UIBlurEffect *blurEffect))handler fromVC:(UIViewController *)fromVC;
+ (void)replaceImage:(void(^)(UIImage *image))handler fromVC:(UIViewController *)fromVC;
@end

NS_ASSUME_NONNULL_END
