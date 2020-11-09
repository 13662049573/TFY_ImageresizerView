//
//  TFY_ImageersizeKit.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/9/10.
//  Copyright © 2020 田风有. All rights reserved.
//  最新版本：2.1.8

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT double TFY_ImageersizeKitVersionNumber;

FOUNDATION_EXPORT const unsigned char TFY_ImageersizeKitVersionString[];

#define TFY_ImageersizeKitRelease 0

#if TFY_ImageersizeKitRelease

#import <TFY_ImageSizeTools/TFY_ImageresizerView.h>
#import <TFY_ImageSizeTools/TFY_ImageresizerTool.h>
#import <TFY_ImageSizeTools/TFY_ImageresizerSlider.h>
#import <TFY_ImageSizeTools/TFY_PhotoTool.h>
#import <TFY_ImageSizeTools/TFY_ImagePickerTools.h>


#else

//裁剪图片
#import "TFY_ImageresizerView.h"
#import "TFY_ImageresizerTool.h"
#import "TFY_ImageresizerSlider.h"
//授权工具
#import "TFY_PhotoTool.h"
//相册选择器
#import "TFY_ImagePickerTools.h"

#endif
