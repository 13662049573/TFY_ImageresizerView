//
//  TFY_ImagePickerController.m
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/22.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>
#import "TFY_ClipViewController.h"
#import "TFY_ImageresizerType.h"

static TFY_ImagePickerController *PickerInstance = nil;

@interface TFY_ImageObject : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, copy) void (^replaceHandler)(UIImage *image, NSData *imageData, NSURL *videoURL);
@property (nonatomic , assign)BOOL allowsEditing;
@end

static TFY_ImageObject *obj_;

@implementation TFY_ImageObject

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image;
    NSData *imageData;
    NSURL *videoURL;
    NSURL *mediaURL = info[UIImagePickerControllerMediaURL];
    if (!mediaURL) {
        if (@available(iOS 11.0, *)) {
            NSURL *url = info[UIImagePickerControllerImageURL];
            imageData = [NSData dataWithContentsOfURL:url];
        } else {
            image = info[UIImagePickerControllerOriginalImage];
        }
    } else {
        videoURL = mediaURL;
    }
    if (image && self.replaceHandler && self.allowsEditing) {
        TFY_ClipViewController *vc = [TFY_ClipViewController new];
        vc.configure = [TFY_ImageresizerConfigure defaultConfigureWithImage:image make:^(TFY_ImageresizerConfigure * _Nonnull configure) {
            
        }];
        vc.clip_Block = ^(UIImage *image, NSData *imageData, NSURL *videoURL) {
            [picker dismissViewControllerAnimated:YES completion:^{
                if ((image || imageData || videoURL) && self.replaceHandler) self.replaceHandler(image, imageData, videoURL);
                obj_ = nil;
            }];
        };
        CATransition *cubeAnim = [CATransition animation];
        cubeAnim.duration = 0.5;
        cubeAnim.type = @"cube";
        cubeAnim.subtype = kCATransitionFromRight;
        cubeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [picker.view.window.layer addAnimation:cubeAnim forKey:@"cube"];
        [picker pushViewController:vc animated:YES];
    }
    else{
        [picker dismissViewControllerAnimated:YES completion:^{
            if (image && self.replaceHandler) self.replaceHandler(image, imageData, videoURL);
            obj_ = nil;
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        obj_ = nil;
    }];
}

@end

@implementation TFY_ImagePickerController

/**
 *  allowsEditing 是否开启编辑模式 fromVC 控制器
 */
+ (void)showImagePickerallowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction fromVC:(UIViewController *)fromVC{
    if (PickerInstance == nil) {
        PickerInstance = [[TFY_ImagePickerController alloc] init];
    }
    [PickerInstance showImagePickerFromViewController:fromVC allowsEditing:allowsEditing finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(ImagePickerFinishAction)finishAction {
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    obj_ = [TFY_ImageObject new];
    obj_.allowsEditing = allowsEditing;
    obj_.replaceHandler  = finishAction;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择相册" message:@"有裁剪和未裁剪功能" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController sourcetype:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController sourcetype:UIImagePickerControllerSourceTypeCamera];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController sourcetype:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }]];
        
    }else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self PickerController:viewController sourcetype:UIImagePickerControllerSourceTypePhotoLibrary];
        }]];
    }
   [viewController presentViewController:alertController animated:YES completion:nil];
}

-(void)PickerController:(UIViewController *)fromVC sourcetype:(UIImagePickerControllerSourceType)sourcetype{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = obj_;
    NSMutableArray *mediaTypes = @[(NSString *)kUTTypeMovie,
                                   (NSString *)kUTTypeVideo,
                                   (NSString *)kUTTypeImage].mutableCopy;
    
    picker.mediaTypes = mediaTypes;
    picker.sourceType = sourcetype;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    [fromVC presentViewController:picker animated:YES completion:nil];
}


@end
