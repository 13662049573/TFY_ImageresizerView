//
//  TFY_ImageresizerType.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#pragma mark - 枚举

/**
 * 边框样式
 * TFY_ConciseFrameType：简洁样式
 * TFY_ClassicFrameType：经典样式，类似微信的裁剪边框样式
 */
typedef NS_ENUM(NSUInteger, TFY_ImageresizerFrameType) {
    TFY_ConciseFrameType, // default
    TFY_ClassicFrameType
};

/**
 * 动画曲线
 * TFY_AnimationCurveEaseInOut：慢进慢出，中间快
 * TFY_AnimationCurveEaseIn：由慢到快
 * TFY_AnimationCurveEaseOut：由快到慢
 * TFY_AnimationCurveLinear：匀速
 */
typedef NS_ENUM(NSUInteger, TFY_AnimationCurve) {
    TFY_AnimationCurveEaseInOut, // default
    TFY_AnimationCurveEaseIn,
    TFY_AnimationCurveEaseOut,
    TFY_AnimationCurveLinear
};

/**
 * 当前方向
 * TFY_ImageresizerVerticalUpDirection：垂直向上
 * TFY_ImageresizerHorizontalLeftDirection：水平向左
 * TFY_ImageresizerVerticalDownDirection：垂直向下
 * TFY_ImageresizerHorizontalRightDirection：水平向右
 */
typedef NS_ENUM(NSUInteger, TFY_ImageresizerRotationDirection) {
    TFY_ImageresizerVerticalUpDirection = 0,  // default
    TFY_ImageresizerHorizontalLeftDirection,
    TFY_ImageresizerVerticalDownDirection,
    TFY_ImageresizerHorizontalRightDirection
};

#pragma mark - Block

/**
 * 是否可以重置的回调
 * 当裁剪区域缩放至适应范围后就会触发该回调
    - YES：可重置
    - NO：不需要重置，裁剪区域跟图片区域一致，并且没有旋转、镜像过
 */
typedef void(^TFY_ImageresizerIsCanRecoveryBlock)(BOOL isCanRecovery);

/**
 * 是否预备缩放裁剪区域至适应范围
 * 当裁剪区域发生变化的开始和结束就会触发该回调
    - YES：预备缩放，此时裁剪、旋转、镜像功能不可用
    - NO：没有预备缩放
 */
typedef void(^TFY_ImageresizerIsPrepareToScaleBlock)(BOOL isPrepareToScale);

/** 单例（声明） */
#define TFY_SingtonInterface + (instancetype)sharedInstance;
/** 单例（实现） */
#define TFY_SingtonImplement(class) \
\
static class *sharedInstance_; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance_ = [super allocWithZone:zone]; \
    }); \
    return sharedInstance_; \
} \
\
+ (instancetype)sharedInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        sharedInstance_ = [[class alloc] init]; \
    }); \
    return sharedInstance_; \
} \
\
- (id)copyWithZone:(NSZone *)zone { \
    return sharedInstance_; \
}

/** weakSelf */
#ifndef tfy_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define tfy_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define tfy_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define tfy_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define tfy_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

/** strongSelf */
#ifndef tfy_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define tfy_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define tfy_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define tfy_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define tfy_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

//屏幕高
#define  Clip_Height_H [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define  Clip_Width_W  [UIScreen mainScreen].bounds.size.width

#define Clip_isPortrait  ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown ) ?YES:NO

#define Clip_DEBI_width(width)    width *(Clip_isPortrait ?(375/Clip_Width_W):(Clip_Height_H/375))

#define Clip_DEBI_height(height)  height *(Clip_isPortrait ?(667/Clip_Height_H):(Clip_Width_W/667))

#define Clip_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define Clip_kNavBarHeight           (Clip_iPhoneX ? 88.0 : 64.0)
#define Clip_kBottomBarHeight        (Clip_iPhoneX ? 83.0 : 49.0)
#define Clip_kNavTimebarHeight       (Clip_iPhoneX ? 44.0 : 20.0)
#define Clip_kContentHeight          (Clip_Height_H - Clip_kNavBarHeight - Clip_kBottomBarHeight)
