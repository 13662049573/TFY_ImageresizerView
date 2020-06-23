//
//  TFY_ClipViewController.h
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/22.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFY_ImageresizerConfigure.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ClipViewController : UIViewController
@property (nonatomic, copy) void (^clip_Block)(UIImage *images);
@property (nonatomic, strong) TFY_ImageresizerConfigure *configure;
@end

NS_ASSUME_NONNULL_END
