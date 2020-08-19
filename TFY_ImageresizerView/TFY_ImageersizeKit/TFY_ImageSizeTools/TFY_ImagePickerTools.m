//
//  TFY_ImagePickerTools.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/19.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImagePickerTools.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

static TFY_ImagePickerTools *PickerInstance = nil;

@interface TFY_ImageTools : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) void (^replaceHandler)(UIImage *image, NSData *imageData, NSURL *videoURL);
@property (nonatomic , assign)BOOL allowsEditing;
@end

static TFY_ImageTools *obj_;

@implementation TFY_ImageTools

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    NSData *imageData;
    NSURL *videoURL;
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    if (!mediaURL) {
        if (@available(iOS 11.0, *)) {
            NSURL *url = info[UIImagePickerControllerImageURL];
            imageData = [NSData dataWithContentsOfURL:url];
            if (imageData==nil) {
                image = info[UIImagePickerControllerOriginalImage];
            }
        } else {
           image = info[UIImagePickerControllerOriginalImage];
        }
    } else {
        videoURL = mediaURL;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        if ((image || imageData || videoURL) && self.replaceHandler) self.replaceHandler(image, imageData, videoURL);
        obj_ = nil;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        obj_ = nil;
    }];
}

@end


@implementation TFY_ImagePickerTools
/**
 *  allowsEditing 是否开启编辑模式 fromVC 控制器
 */
+ (void)showImagePickerallowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerAction)finishAction fromVC:(UIViewController *)fromVC{
    if (PickerInstance == nil) {
        PickerInstance = [[TFY_ImagePickerTools alloc] init];
    }
    [PickerInstance showImagePickerFromViewController:fromVC allowsEditing:allowsEditing finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerAction)finishAction {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    obj_ = [TFY_ImageTools new];
    obj_.allowsEditing = allowsEditing;
    obj_.replaceHandler  = finishAction;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择相册" message:@"有裁剪和未裁剪功能" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController allowsEditing:allowsEditing sourcetype:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController allowsEditing:allowsEditing sourcetype:UIImagePickerControllerSourceTypeCamera];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"获取视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController allowsEditing:allowsEditing sourcetype:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        
    }else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController allowsEditing:allowsEditing sourcetype:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
    }
   [viewController presentViewController:alertController animated:YES completion:nil];
}

-(void)PickerController:(UIViewController *)fromVC allowsEditing:(BOOL)allowsEditing sourcetype:(UIImagePickerControllerSourceType)sourcetype{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = obj_;
    NSMutableArray *mediaTypes = @[(NSString *)kUTTypeMovie,
                                   (NSString *)kUTTypeVideo,
                                   (NSString *)kUTTypeImage].mutableCopy;
    
    picker.mediaTypes = mediaTypes;
    picker.sourceType = sourcetype;
    picker.allowsEditing = allowsEditing;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    [fromVC presentViewController:picker animated:YES completion:nil];
}


@end
