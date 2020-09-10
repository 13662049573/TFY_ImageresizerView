//
//  TFY_ImageViewsController.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/21.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImageViewsController.h"


@interface TFY_ImageViewsController ()
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) AVPlayer *player;
@property (nonatomic, weak) AVPlayerLayer *playerLayer;
@property (nonatomic, weak) TFY_ImageresizerSlider *slider;
@property (nonatomic, strong) id timeObserver;
@end

@implementation TFY_ImageViewsController

{
    BOOL _isDidAppear;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Finish";
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self __setupNavigationBar];

    if (self.image || self.imageURL) {
        [self __setupImageView];
    } else if (self.videoURL) {
        [self __setupPlayerLayer];
        [self __setupSlider];
    }
    
    Clip_ObserveNotification(self, @selector(__didChangeStatusBarOrientation), UIApplicationDidChangeStatusBarOrientationNotification, nil);
    [self __didChangeStatusBarOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_isDidAppear) return;
    _isDidAppear = YES;
    
    [self.player play];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];
}

- (void)dealloc {
    
    NSURL *imageURL = self.imageURL;
    NSURL *videoURL = self.videoURL;
    if (videoURL) {
        Clip_RemoveNotification(self);
        [self.playerLayer removeFromSuperlayer];
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (imageURL) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:imageURL error:&error];
            if (error) {
                NSLog(@"删除图片文件失败 %@ --- %@", error, imageURL.absoluteString);
            } else {
                NSLog(@"已删除图片文件");
            }
        }
        if (videoURL) {
            NSError *error;
            [[NSFileManager defaultManager] removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"删除视频文件失败 %@ --- %@", error, videoURL.absoluteString);
            } else {
                NSLog(@"已删除视频文件");
            }
        }
    });
}

#pragma mark - 初始布局

- (void)__setupNavigationBar {
    UIButton *camceraBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    camceraBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [camceraBtn setTitle:@"保存相册" forState:UIControlStateNormal];
    [camceraBtn addTarget:self action:@selector(__savePhotoToAppAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:camceraBtn];
}

- (void)__setupPlayerLayer {
    AVURLAsset *asset = [AVURLAsset assetWithURL:self.videoURL];
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    self.playerLayer = playerLayer;
    self.player = player;
    
    @tfy_weakify(self);
    self.timeObserver = [player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        @tfy_strongify(self);
        if (!self) return;
        self.slider.second = CMTimeGetSeconds(time);
    }];
    
    Clip_ObserveNotification(self, @selector(__playDidEnd), AVPlayerItemDidPlayToEndTimeNotification, item);
}

- (void)__setupSlider {
    @tfy_weakify(self);
    TFY_ImageresizerSlider *slider = [TFY_ImageresizerSlider imageresizerSlider:CMTimeGetSeconds(self.player.currentItem.asset.duration) second:0];
    slider.sliderBeginBlock = ^(float second, float totalSecond) {
        @tfy_strongify(self);
        if (!self) return;
        [self.player pause];
    };
    slider.sliderDragingBlock = ^(float second, float totalSecond) {
        @tfy_strongify(self);
        if (!self) return;
        [self.player seekToTime:CMTimeMakeWithSeconds(second, 600) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    };
    slider.sliderEndBlock = ^(float second, float totalSecond) {
        @tfy_strongify(self);
        if (!self) return;
        [self.player play];
    };
    [self.view addSubview:slider];
    self.slider = slider;
}

- (void)__setupImageView {
    
    
    NSData *data = [NSData dataWithContentsOfURL:self.imageURL];
    UIImage *image = self.image;
    if (!image) image = [UIImage imageWithData:data];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    if (data && [TFY_ImageresizerTool isGIFData:data]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [TFY_ImageresizerTool decodeGIFData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:self.imageView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.imageView.image = image;
                } completion:nil];
            });
        });
    }
}

#pragma mark - 通知方法

- (void)__didChangeStatusBarOrientation {
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    BOOL isLandscape = Clip_Width_W > Clip_Height_H;
    if (isLandscape) {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
            contentInsets.left += Clip_Width_W;
            contentInsets.right += Clip_Height_H;
        } else {
            contentInsets.left += 0;
            contentInsets.right += 0;
        }
    } else {
        contentInsets.top += 0;
    }
    CGFloat x = contentInsets.left;
    CGFloat y = contentInsets.top;
    CGFloat w = Clip_Width_W - contentInsets.left - contentInsets.right;
    CGFloat h = Clip_Height_H - contentInsets.top - contentInsets.bottom;
    if (self.videoURL) {
        if (!isLandscape) h -= 44;
        [self.slider setImageresizerFrame:CGRectMake(x, y, w, h) isRoundResize:NO];
        h -= [TFY_ImageresizerSlider viewHeight];
        self.playerLayer.frame = CGRectMake(x, y, w, h);
    } else {
        self.imageView.frame = CGRectMake(x, y, w, h);
    }
}

- (void)__playDidEnd {
    [self.player seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.player pause];
}

#pragma mark - 事件触发方法

- (void)__savePhotoToAppAlbum {
    
    if (self.videoURL) {
        [TFY_PhotoToolSI saveVideoToAppAlbumWithFileURL:self.videoURL successHandle:^(NSString *assetID) {
            [TFY_ProgressHUD showSuccessWithStatus:@"保存成功"];
        } failHandle:^(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail) {
            [TFY_ProgressHUD showErrorWithStatus:@"保存失败"];
        }];
    } else if (self.imageURL) {
        [TFY_PhotoToolSI saveFileToAppAlbumWithFileURL:self.imageURL successHandle:^(NSString *assetID) {
            [TFY_ProgressHUD showSuccessWithStatus:@"保存成功"];
        } failHandle:^(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail) {
            [TFY_ProgressHUD showErrorWithStatus:@"保存失败"];
        }];
    } else {
        [TFY_PhotoToolSI savePhotoToAppAlbumWithImage:self.image successHandle:^(NSString *assetID) {
            [TFY_ProgressHUD showSuccessWithStatus:@"保存成功"];
        } failHandle:^(NSString *assetID, BOOL isGetAlbumFail, BOOL isSaveFail) {
            [TFY_ProgressHUD showErrorWithStatus:@"保存失败"];
        }];
    }
}


- (void)play:(id)sender {
    [self.player play];
}

- (void)pause:(id)sender {
    [self.player pause];
}

@end
