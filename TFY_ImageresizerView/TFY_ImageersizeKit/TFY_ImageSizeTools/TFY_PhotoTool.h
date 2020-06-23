//
//  TFY_PhotoTool.h
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/22.
//  Copyright © 2020 田风有. All rights reserved.
//

/**

1.PHAsset：一个PHAsset对象代表相册中的一张图片或一个视频
   查：[PHAsset fetchAssets...]
   增删改：PHAssetChangeRequest

2.PHAssetCollection：一个PHAssetCollection代表一个相册
   查：[PHAssetCollection fetchAssetCollections...]
   增删改：PHAssetCollectionChangeRequest

任何*增删改*的操作只能写在 -[PHPhotoLibrary performChanges:] 或 -[PHPhotoLibrary performChangesAndWait:] 里面的block中执行

1.异步执行修改操作
   [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
       // 修改操作
   } completionHandler:^(BOOL success, NSError * _Nullable error) {
       // 修改完毕
   }];

2.同步执行修改操作（执行这段代码时程序会停住，执行完才能继续后面的代码，不过很快就会执行完了）
   NSError *error = nil;
   [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
       // 修改操作
   } error:&error];

   if (error) {
       // 失败
   } else {
       // 成功
   }

*/

#import <Foundation/Foundation.h>
#import "TFY_ImageresizerType.h"
#import <Photos/Photos.h>

#define TFY_PhotoToolSI [TFY_PhotoTool sharedInstance]

typedef void(^TFY_AssetCollectionFastEnumeration)(PHAssetCollection * _Nonnull collection, NSInteger index, NSInteger totalCount);
typedef void(^TFY_AssetFastEnumeration)(PHAsset *_Nonnull asset, NSUInteger index, NSUInteger totalCount);

typedef void(^TFY_GetAssetsCompletion)(NSArray *_Nonnull assets);
typedef void(^TFY_AssetsCachingHandle)(NSArray *_Nonnull indexPaths, TFY_GetAssetsCompletion _Nonnull getAssetsCompletion);

typedef void(^TFY_PhotoImageResultHandler)(PHAsset *_Nonnull requestAsset, UIImage *_Nonnull resultImage, BOOL isFinalImage);
typedef void(^TFY_LivePhotoResultHandler)(PHAsset *_Nonnull requestAsset, PHLivePhoto *_Nonnull livePhoto, BOOL isFinalLivePhoto);

NS_ASSUME_NONNULL_BEGIN

@interface TFY_PhotoTool : NSObject

TFY_SingtonInterface

#pragma mark - 访问权限

/**
 是否有相册的访问权限 相册的访问权限
 */
- (BOOL)isAllowAlbumAccessAuthority;

/**
 验证是否有相册的访问权限以及相应处理  相册的访问权限
 */
- (void)albumAccessAuthorityWithAllowAccessAuthorityHandler:(void (^)(void))allowBlock
                               refuseAccessAuthorityHandler:(void (^)(void))refuseBlock
                        alreadyRefuseAccessAuthorityHandler:(void (^)(void))alreadyRefuseBlock
                               canNotAccessAuthorityHandler:(void (^)(void))canNotBlock
                                           isRegisterChange:(BOOL)isRegisterChange fromVC:(UIViewController *)fromVC;

/**
 验证是否有相机的访问权限以及相应处理  相机的访问权限
 */
- (void)cameraAuthorityWithAllowAccessAuthorityHandler:(void (^)(void))allowBlock
                          refuseAccessAuthorityHandler:(void (^)(void))refuseBlock
                   alreadyRefuseAccessAuthorityHandler:(void (^)(void))alreadyRefuseBlock
                          canNotAccessAuthorityHandler:(void (^)(void))canNotBlock fromVC:(UIViewController *)fromVC;

#pragma mark - 相册监听

/** 取消监听 */
- (void)unRegisterChange;

/** 相册发生改变时调用的block */
@property (nonatomic, copy) void(^photoLibraryDidChangeHandler)(PHAssetCollection *assetCollection, PHFetchResultChangeDetails *changeDetails, PHFetchResult *fetchResult);

#pragma mark - 获取相册

/**
 获取所有相册
 */
- (void)getAllAssetCollectionWithFastEnumeration:(TFY_AssetCollectionFastEnumeration)fastEnumeration
                                      completion:(void(^)(void))completion;

/**
 获取所有【系统创建】的相册
 */
- (void)getAllSystemCreateAssetCollectionWithFastEnumeration:(TFY_AssetCollectionFastEnumeration)fastEnumeration
                                                  completion:(void(^)(void))completion;

/**
 获取所有【用户创建】的相册
 */
- (void)getAllUserCreateAssetCollectionWithFastEnumeration:(TFY_AssetCollectionFastEnumeration)fastEnumeration
                                                completion:(void(^)(void))completion;

#pragma mark - 获取照片

/**
  获取【所有】相册内所有照片资源
 */
- (void)getAllAssetInPhotoAblumWithFastEnumeration:(TFY_AssetFastEnumeration)fastEnumeration
                                        completion:(void(^)(void))completion;

/**
  获取【指定】相册内所有照片资源，assetCollection为nil则获取全部照片
 */
- (void)getAssetsInAssetCollection:(PHAssetCollection *)assetCollection
                   fastEnumeration:(TFY_AssetFastEnumeration)fastEnumeration
                        completion:(void(^)(void))completion;

/**
  获取最新的一张照片  最新的一张照片
 */
- (PHAsset *)getNewestAsset;

#pragma mark - 解析照片

/**
 根据获取的PHAsset对象，解析固定尺寸的照片并缓存 PHAsset对象
 */
- (void)requestThumbnailPhotoImageForAsset:(PHAsset *)asset
                             resultHandler:(TFY_PhotoImageResultHandler)resultHandler;

/**
 根据获取的PHAsset对象，解析指定尺寸的照片并缓存 PHAsset对象
 */
- (void)requestThumbnailPhotoImageForAsset:(PHAsset *)asset
                                targetSize:(CGSize)targetSize
                             resultHandler:(TFY_PhotoImageResultHandler)resultHandler;

/**
  根据获取的PHAsset对象，解析原图尺寸的照片 PHAsset对象
 */
- (void)requestOriginalPhotoImageForAsset:(PHAsset *)asset
                               isFastMode:(BOOL)isFastMode
                         isFixOrientation:(BOOL)isFixOrientation
                      isJustGetFinalPhoto:(BOOL)isJustGetFinalPhoto
                            resultHandler:(TFY_PhotoImageResultHandler)resultHandler;

/**
 根据获取的PHAsset对象，解析指定尺寸的照片 PHAsset对象
 */
- (void)requestPhotoImageForAsset:(PHAsset *)asset
                       targetSize:(CGSize)targetSize
                       isFastMode:(BOOL)isFastMode
                 isFixOrientation:(BOOL)isFixOrientation
              isJustGetFinalPhoto:(BOOL)isJustGetFinalPhoto
                    resultHandler:(TFY_PhotoImageResultHandler)resultHandler;

/**
  根据获取的PHAsset对象，解析指定尺寸的实况照片 PHAsset对象
 */
- (void)requestLivePhotoForAsset:(PHAsset *)asset
                      targetSize:(CGSize)targetSize
                         options:(PHLivePhotoRequestOptions *)options
             isJustGetFinalPhoto:(BOOL)isJustGetFinalPhoto
                   resultHandler:(TFY_LivePhotoResultHandler)resultHandler;

#pragma mark - 保存照片/文件

/**
  保存图片到【相机胶卷】
 */
- (void)savePhotoWithImage:(UIImage *)image
             successHandle:(void (^)(NSString *assetID))successHandle
                failHandle:(void (^)(void))failHandle;

/**
  保存图片到【App相册】
 */
- (void)savePhotoToAppAlbumWithImage:(UIImage *)image
                       successHandle:(void (^)(NSString *assetID))successHandle
                          failHandle:(void (^)(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail))failHandle;

/**
 保存视频到【相机胶卷】
 */
- (void)saveVideoWithFileURL:(NSURL *)fileURL
               successHandle:(void (^)(NSString *assetID))successHandle
                  failHandle:(void (^)(void))failHandle;

/**
  保存视频到【App相册】
 */
- (void)saveVideoToAppAlbumWithFileURL:(NSURL *)fileURL
                         successHandle:(void (^)(NSString *assetID))successHandle
                            failHandle:(void (^)(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail))failHandle;

/**
  保存文件到【相机胶卷】
 */
- (void)saveFileWithFileURL:(NSURL *)fileURL
              successHandle:(void (^)(NSString *assetID))successHandle
                 failHandle:(void (^)(void))failHandle;

/**
  保存文件到【App相册】
 */
- (void)saveFileToAppAlbumWithFileURL:(NSURL *)fileURL
                        successHandle:(void (^)(NSString *assetID))successHandle
                           failHandle:(void (^)(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail))failHandle;

@end

NS_ASSUME_NONNULL_END
