//
//  TFY_ImagePickerTools.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/19.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**image 拍照获取图片 imageData 从相册获取的图片   videoURL 拍视频地址*/
typedef void (^ImagePickerAction)(UIImage * _Nonnull image, NSData *_Nonnull imageData, NSURL *_Nonnull videoURL);

@interface TFY_ImagePickerTools : NSObject
/**
 *  allowsEditing 是否开启编辑模式 fromVC 控制器
 */
+ (void)showImagePickerallowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerAction)finishAction fromVC:(UIViewController *)fromVC;

@end

NS_ASSUME_NONNULL_END
