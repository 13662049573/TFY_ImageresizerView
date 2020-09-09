//
//  TFY_ImageresizerType.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

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

/**
 * 裁剪视频错误原因
 * TFY_IEReason_NilObject：裁剪元素为空
 * TFY_IEReason_CacheURLAlreadyExists：缓存路径已存在其他文件
 * TFY_IEReason_NoSupportedFileType：不支持的文件类型
 * TFY_IEReason_VideoAlreadyDamage：视频文件已损坏
 * TFY_IEReason_VideoExportFailed：视频导出失败
 * TFY_IEReason_VideoExportCancelled：视频导出取消
 */
typedef NS_ENUM(NSUInteger, TFY_ImageresizerErrorReason) {
    TFY_IEReason_NilObject,
    TFY_IEReason_CacheURLAlreadyExists,
    TFY_IEReason_NoSupportedFileType,
    TFY_IEReason_VideoAlreadyDamage,
    TFY_IEReason_VideoExportFailed,
    TFY_IEReason_VideoExportCancelled
};

#pragma mark - Block

/**
 * 是否可以重置的回调
 * 当裁剪区域缩放至适应范围后就会触发该回调
    - YES：可重置
    - NO：不需要重置，裁剪区域跟图片区域一致，并且没有旋转、镜像过
 */
typedef  void(^TFY_ImageresizerIsCanRecoveryBlock)(BOOL isCanRecovery);

/**
 * 是否预备缩放裁剪区域至适应范围
 * 当裁剪区域发生变化的开始和结束就会触发该回调
    - YES：预备缩放，此时裁剪、旋转、镜像功能不可用
    - NO：没有预备缩放
 */
typedef void(^TFY_ImageresizerIsPrepareToScaleBlock)(BOOL isPrepareToScale);

/**
 * 错误的回调
    - cacheURL：目标存放路径
    - reason：错误原因（TFY_ImageresizerErrorReason）
 */
typedef void(^TFY_ImageresizerErrorBlock)(NSURL * cacheURL, TFY_ImageresizerErrorReason reason);

/**
 * 图片裁剪完成的回调
    - finalImage：裁剪后的图片/GIF
    - cacheURL：目标存放路径
    - isCacheSuccess：是否缓存成功（缓存不成功则cacheURL为nil）
 */
typedef void(^TFY_CropPictureDoneBlock)(UIImage * finalImage, NSURL * cacheURL, BOOL isCacheSuccess);

/**
 * 视频裁剪导出的进度
    - progress：进度，单位 0~1
 */
typedef void(^TFY_ExportVideoProgressBlock)(float progress);

/**
 * 视频导出开始的回调
    - exportSession：导出会话，可用于取消
 */
typedef void(^TFY_ExportVideoStartBlock)(AVAssetExportSession * exportSession);

/**
 * 视频导出完成的回调
    - cacheURL：修正方向/裁剪后的视频导出后的最终存放路径，默认该路径为NSTemporaryDirectory文件夹下
        - 如果是修正方向的视频，是无需修正的视频，cacheURL则以原路径返回
        - 如果是裁剪的视频，裁剪后自定义的路径转移失败，cacheURL返回的是也是在NSTemporaryDirectory里
 */
typedef void(^TFY_ExportVideoCompleteBlock)(NSURL *  cacheURL);

#pragma mark - 裁剪属性

struct TFY_CropConfigure {
    TFY_ImageresizerRotationDirection direction;
    BOOL isVerMirror;
    BOOL isHorMirror;
    BOOL isRoundClip;
    CGSize resizeContentSize;
    CGFloat resizeWHScale;
    CGRect cropFrame;
};
typedef struct CG_BOXABLE TFY_CropConfigure TFY_CropConfigure;

CG_INLINE TFY_CropConfigure TFY_CropConfigureMake(TFY_ImageresizerRotationDirection direction,
                                              BOOL isVerMirror,
                                              BOOL isHorMirror,
                                              BOOL isRoundClip,
                                              CGSize resizeContentSize,
                                              CGFloat resizeWHScale,
                                              CGRect cropFrame) {
    TFY_CropConfigure configure;
    configure.direction = direction;
    configure.isVerMirror = isVerMirror;
    configure.isHorMirror = isHorMirror;
    configure.isRoundClip = isRoundClip;
    configure.resizeContentSize = resizeContentSize;
    configure.resizeWHScale = resizeWHScale;
    configure.cropFrame = cropFrame;
    return configure;
}

/**
 * 获取当前页码
 */
CG_INLINE NSInteger TFY_GetCurrentPageNumber(CGFloat offsetValue, CGFloat pageSizeValue) {
    return (NSInteger)((offsetValue + pageSizeValue * 0.5) / pageSizeValue);
}

/**
 * 弧度 --> 角度（ π --> 180° ）
 */
CG_INLINE CGFloat TFY_Radian2Angle(CGFloat radian) {
    return (radian * 180.0) / M_PI;
}

/**
 * 角度 --> 弧度（ 180° -->  π  ）
 */
CG_INLINE CGFloat TFY_Angle2Radian(CGFloat angle) {
    return (angle / 180.0) * M_PI;
}

/**
 * 随机整数（from <= number <= to）
 */
CG_INLINE NSInteger TFY_RandomNumber(NSInteger from, NSInteger to) {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

/**
 * 随机布尔值（YES or NO）
 */
CG_INLINE BOOL TFY_RandomBool() {
    return TFY_RandomNumber(0, 1);
}

/**
 * 随机比例值（0.0 ~ 1.0）
 */
CG_INLINE CGFloat TFY_RandomUnsignedScale() {
    return TFY_RandomNumber(0, 100) * 1.0 / 100.0;
}

/**
 * 随机比例值（-1.0 ~ 1.0）
 */
CG_INLINE CGFloat TFY_RandomScale() {
    return (TFY_RandomBool() ? 1.0 : -1.0) * TFY_RandomUnsignedScale();
}

/**
 * 随机小写字母（a ~ z）
 */
CG_INLINE NSString * TFY_RandomLowercaseLetters() {
    char data[1];
    data[0] = (char)('a' + TFY_RandomNumber(0, 25));
    return [[NSString alloc] initWithBytes:data length:1 encoding:NSUTF8StringEncoding];
}

/**
 * 随机大写字母（A ~ Z）
 */
CG_INLINE NSString * TFY_RandomCapitalLetter() {
    char data[1];
    data[0] = (char)('A' + TFY_RandomNumber(0, 25));
    return [[NSString alloc] initWithBytes:data length:1 encoding:NSUTF8StringEncoding];
}

CG_INLINE CGFloat TFY_FromSourceToTargetValueByDifferValue(CGFloat sourceValue, CGFloat differValue, CGFloat progress) {
    return sourceValue + progress * differValue;
}

CG_INLINE CGFloat TFY_FromSourceToTargetValue(CGFloat sourceValue, CGFloat targetValue, CGFloat progress) {
    return TFY_FromSourceToTargetValueByDifferValue(sourceValue, (targetValue - sourceValue), progress);
}

CG_INLINE CGFloat TFY_HalfOfDiff(CGFloat value1, CGFloat value2) {
    return (value1 - value2) * 0.5;
}

CG_INLINE CGFloat TFY_ScaleValue(CGFloat value) {
    return value * 1;
}

CG_INLINE CGFloat TFY_HScaleValue(CGFloat value) {
    return value * 1;
}

CG_INLINE UIFont * TFY_ScaleFont(CGFloat fontSize)  {
    return [UIFont systemFontOfSize:TFY_ScaleValue(fontSize)];
}

CG_INLINE UIFont * TFY_ScaleBoldFont(CGFloat fontSize) {
    return [UIFont boldSystemFontOfSize:TFY_ScaleValue(fontSize)];
}

CG_INLINE UIFont * TFY_ScaleOswaldMediumFont(CGFloat fontSize) {
    return [UIFont fontWithName:@"Oswald-Medium" size:TFY_ScaleValue(fontSize)];
}


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
#define  Clip_ScreenBounds [UIScreen mainScreen].bounds
#define  Clip_ScreenSize [UIScreen mainScreen].bounds.size


#define Clip_isPortrait  ( [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait ||  [UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown ) ?YES:NO

#define Clip_DEBI_width(width)    width *(Clip_isPortrait ?(375/Clip_Width_W):(Clip_Height_H/375))

#define Clip_DEBI_height(height)  height *(Clip_isPortrait ?(667/Clip_Height_H):(Clip_Width_W/667))

#define Clip_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ((NSInteger)(([[UIScreen mainScreen] currentMode].size.height/[[UIScreen mainScreen] currentMode].size.width)*100) == 216) : NO)

#define Clip_kNavBarHeight           (Clip_iPhoneX ? 88.0 : 64.0)
#define Clip_kBottomBarHeight        (Clip_iPhoneX ? 83.0 : 49.0)
#define Clip_kNavTimebarHeight       (Clip_iPhoneX ? 44.0 : 20.0)
#define Clip_kContentHeight          (Clip_Height_H - Clip_kNavBarHeight - Clip_kBottomBarHeight)

/** MainBundle */
#define Clip_MainBundle [NSBundle mainBundle]
#define Clip_MainBundleResourcePath(name, type) [[NSBundle mainBundle] pathForResource:name ofType:type]

/** 主窗口 */
#define Clip_KeyWindow [UIApplication sharedApplication].delegate.window
#define Clip_MakeKeyWindow [[UIApplication sharedApplication].delegate.window makeKeyWindow]

/** keypath */
#define Clip_KeyPath(objc, keyPath) @(((void)objc.keyPath, #keyPath))

/** 发送通知 */
#define Clip_PostNotification(name, obj, info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]

/** 监听通知 */
#define Clip_ObserveNotification(observer, aSelector, aName, obj) [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:aName object:obj]

/** 移除通知 */
#define Clip_RemoveNotification(observer) [[NSNotificationCenter defaultCenter] removeObserver:observer]
#define Clip_RemoveOneNotification(observer, aName, obj) [[NSNotificationCenter defaultCenter] removeObserver:observer name:aName object:obj]
