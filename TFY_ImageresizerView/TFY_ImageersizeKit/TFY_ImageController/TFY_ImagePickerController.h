//
//  TFY_ImagePickerController.h
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/22.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ImagePickerFinishAction)(UIImage * _Nonnull image);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ImagePickerController : NSObject
/**
 *  allowsEditing 是否开启编辑模式 fromVC 控制器
 */
+ (void)showImagePickerallowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction fromVC:(UIViewController *)fromVC;

@end

NS_ASSUME_NONNULL_END
