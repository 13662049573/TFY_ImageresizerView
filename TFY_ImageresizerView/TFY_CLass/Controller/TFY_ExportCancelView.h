//
//  TFY_ExportCancelView.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/14.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ExportCancelView : UIView
+ (void)showWithCancelHandler:(void(^)(void))cancelHandler;
+ (void)hide;
@end

NS_ASSUME_NONNULL_END
