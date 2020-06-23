//
//  UIWindow+TFY_Tools.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "UIWindow+TFY_Tools.h"

@implementation UIWindow (TFY_Tools)
/** 获取顶层控制器 */
- (UIViewController *)tfy_topViewController {
    if (!self.rootViewController) return nil;
    UIViewController *resultVC;
    resultVC = [self tfy_getTopViewController:self.rootViewController];
    while (resultVC.presentedViewController) { // 看看有没有moda出来的
        resultVC = [self tfy_getTopViewController:resultVC.presentedViewController];
    }
    if ([resultVC isKindOfClass:UIAlertController.class]) {
        resultVC = resultVC.presentingViewController; // 从哪里moda的那个才是
        return [self tfy_getTopViewController:resultVC];
    }
    return resultVC;
}

- (UIViewController *)tfy_getTopViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self tfy_getTopViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self tfy_getTopViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
}

+ (UIViewController *)tfy_topViewControllerFromKeyWindow {
    return [[UIApplication sharedApplication].keyWindow tfy_topViewController];
}

+ (UIViewController *)tfy_topViewControllerFromDelegateWindow {
    return [[UIApplication sharedApplication].delegate.window tfy_topViewController];
}

@end
