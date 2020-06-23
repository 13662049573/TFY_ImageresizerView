//
//  UIWindow+TFY_Tools.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TFY_Tools)
/** 获取顶层控制器 */
- (UIViewController *)tfy_topViewController;
+ (UIViewController *)tfy_topViewControllerFromKeyWindow;
+ (UIViewController *)tfy_topViewControllerFromDelegateWindow;
@end

NS_ASSUME_NONNULL_END
