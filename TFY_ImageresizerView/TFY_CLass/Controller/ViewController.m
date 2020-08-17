//
//  ViewController.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "ViewController.h"
#import "TFY_ImageersizeHeader.h"
#import "TFY_ImageController.h"
#import "TFY_ImagePickerController.h"
#import "UIAlertController+TFY_Tools.h"
#import "TFY_ExportCancelView.h"
#import "TFY_ImagePickerController.h"
@interface TFY_ConfigureModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) TFY_ImageresizerConfigure *configure;
+ (NSArray<TFY_ConfigureModel *> *)testModels;
@end

@implementation TFY_ConfigureModel

+ (NSArray<TFY_ConfigureModel *> *)testModels {
        TFY_ConfigureModel *model1 = [self new];
        model1.title = @"默认样式";
        model1.configure = [TFY_ImageresizerConfigure defaultConfigureWithImage:nil make:nil];

        TFY_ConfigureModel *model2 = [self new];
        model2.title = @"深色毛玻璃遮罩";
        model2.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithImage:nil make:nil];

        TFY_ConfigureModel *model3 = [self new];
        model3.title = @"浅色毛玻璃遮罩";
        model3.configure = [TFY_ImageresizerConfigure lightBlurMaskTypeConfigureWithImage:nil make:nil];

        TFY_ConfigureModel *model4 = [self new];
        model4.title = @"拉伸样式的边框图片";
        model4.configure = [TFY_ImageresizerConfigure lightBlurMaskTypeConfigureWithImage:nil make:^(TFY_ImageresizerConfigure *configure) {
            configure
            .tfy_strokeColor([UIColor colorWithRed:(205.0 / 255.0) green:(107.0 / 255.0) blue:(153.0 / 255.0) alpha:1.0])
            .tfy_borderImage([TFY_ImageController stretchBorderImage])
            .tfy_borderImageRectInset([TFY_ImageController stretchBorderImageRectInset]);
        }];

        TFY_ConfigureModel *model5 = [self new];
        model5.title = @"平铺样式的边框图片";
        model5.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithImage:nil make:^(TFY_ImageresizerConfigure *configure) {
            configure
            .tfy_frameType(TFY_ClassicFrameType)
            .tfy_borderImage([TFY_ImageController tileBorderImage])
            .tfy_borderImageRectInset([TFY_ImageController tileBorderImageRectInset]);
        }];

        TFY_ConfigureModel *model6 = [self new];
        model6.title = @"圆切样式";
        model6.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithImage:nil make:^(TFY_ImageresizerConfigure *configure) {
            configure
            .tfy_strokeColor(UIColor.redColor)
            .tfy_frameType(TFY_ClassicFrameType)
            .tfy_isClockwiseRotation(YES)
            .tfy_animationCurve(TFY_AnimationCurveEaseOut)
            .tfy_isRoundResize(YES)
            .tfy_isArbitrarily(NO);
        }];

        TFY_ConfigureModel *model7 = [self new];
        model7.title = @"蒙版样式";
        model7.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithImage:nil make:^(TFY_ImageresizerConfigure *configure) {
            configure
            .tfy_frameType(TFY_ClassicFrameType)
            .tfy_maskImage([UIImage imageNamed:@"love.png"])
            .tfy_isArbitrarily(NO);
        }];
    return @[model1, model2, model3, model4, model5, model6, model7];
}
@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableVieew;
@property (nonatomic, copy) NSArray<TFY_ConfigureModel *> *models;
@property (nonatomic, strong) NSURL *tmpURL;
@property (nonatomic, weak) AVAssetExportSession *exporterSession;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, copy) TFY_ExportVideoProgressBlock progressBlock;
@property (nonatomic, assign) BOOL isExporting;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Example";
    self.models = [TFY_ConfigureModel testModels];
    
    [self.view addSubview:self.tableVieew];
    [self.tableVieew tfy_AutoSize:0 top:0 right:0 bottom:0];
}

-(UITableView *)tableVieew{
    if (!_tableVieew) {
        if (@available(iOS 13.0, *)) {
            _tableVieew = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
        } else {
            _tableVieew = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        }
        _tableVieew.delegate = self;
        _tableVieew.dataSource = self;
        _tableVieew.backgroundColor = [UIColor tfy_colorWithHex:@"FFC2BA"];
    }
    return _tableVieew;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.models.count;
    } else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        TFY_ConfigureModel *model = self.models[indexPath.row];
        cell.textLabel.text = model.title;
    } else if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            cell.textLabel.text = @"裁剪本地GIF";
        } else {
            cell.textLabel.text = @"裁剪本地视频";
        }
    } else if (indexPath.section == 2) {
        if (indexPath.item == 0) {
           cell.textLabel.text = @"暂停选老婆";
        } else {
           cell.textLabel.text = @"从系统相册选择";
        }
    }
    return cell;
}

#pragma mark - Table view delegate

static TFY_ImageresizerConfigure *gifConfigure_;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        TFY_ConfigureModel *model = self.models[indexPath.row];
        model.configure.image = [self __randomImage];
        [self __startImageresizer:model.configure];
    } else if (indexPath.section == 1) {
        TFY_ConfigureModel *model = [TFY_ConfigureModel new];
        if (indexPath.item == 0) {
            NSString *gifPath =(arc4random() % 2) ? Clip_MainBundleResourcePath(@"Gem.gif", nil) : Clip_MainBundleResourcePath(@"Dilraba.gif", nil);
            BOOL isLoopPlaybackGIF = arc4random() % 2;
            model.title = @"裁剪本地GIF";
           
            model.configure = [TFY_ImageresizerConfigure defaultConfigureWithImageData:[NSData dataWithContentsOfFile:gifPath] make:^(TFY_ImageresizerConfigure *configure) {
                configure.tfy_frameType(TFY_ClassicFrameType);
                configure.tfy_isLoopPlaybackGIF(isLoopPlaybackGIF);
            }];
        } else {
            NSString *videoPath = Clip_MainBundleResourcePath(@"yaorenmao.mov", nil);
            model.title = @"裁剪本地视频";
           
            model.configure = [TFY_ImageresizerConfigure lightBlurMaskTypeConfigureWithVideoURL:[NSURL fileURLWithPath:videoPath] make:^(TFY_ImageresizerConfigure *configure) {
                configure
                .tfy_borderImage([TFY_ImageController stretchBorderImage])
                .tfy_borderImageRectInset([TFY_ImageController stretchBorderImageRectInset]);
            } fixErrorBlock:nil fixStartBlock:nil fixProgressBlock:nil fixCompleteBlock:nil];
        }
        [self __startImageresizer:model.configure];
    } else if (indexPath.section == 2) {
        if (indexPath.item == 0) {
            if (!gifConfigure_) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    gifConfigure_ = [TFY_ImageresizerConfigure defaultConfigureWithImage:[self __createGIFImage] make:^(TFY_ImageresizerConfigure *configure) {
                        configure.tfy_isLoopPlaybackGIF(YES);
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        [self __startImageresizer:gifConfigure_];
                    });
                });
                return;
            }
            [self __startImageresizer:gifConfigure_];
        } else {
            [self __openAlbum:YES];
        }
    }
}

#pragma mark - 随机图片
- (UIImage *)__randomImage {
    NSString *imageName;
    NSInteger index = 1 + arc4random() % (8 + 2);
    if (index > 8) {
        if (index == 8 + 1) {
            imageName = @"Kobe.jpg";
        } else {
            imageName = @"Flowers.jpg";
        }
    } else {
        imageName = [NSString stringWithFormat:@"Girl%zd.jpg", index];
    }
    return [UIImage imageWithContentsOfFile:Clip_MainBundleResourcePath(imageName, nil)];
}

#pragma mark - 生成GIF图片
- (UIImage *)__createGIFImage {
    NSMutableArray *images = [NSMutableArray array];
    CGSize size = CGSizeMake(500, 500);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, bitmapInfo);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    for (NSInteger i = 1; i <= 8; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Girl%zd.jpg", i];
        UIImage *image = [UIImage imageWithContentsOfFile:Clip_MainBundleResourcePath(imageName, nil)];
        
        CGContextSaveGState(context);
        
        CGImageRef cgImage = image.CGImage;
        CGFloat width;
        CGFloat height;
        if (image.size.width >= image.size.height) {
            width = size.width;
            height = width * (image.size.height / image.size.width);
        } else {
            height = size.height;
            width = height * (image.size.width / image.size.height);
        }
        CGFloat x = (size.width - width) * 0.5;
        CGFloat y = (size.height - height) * 0.5;
        
        CGContextDrawImage(context, CGRectMake(x, y, width, height), cgImage);
        CGImageRef resizedCGImage = CGBitmapContextCreateImage(context);
        [images addObject:[UIImage imageWithCGImage:resizedCGImage]];
        CGImageRelease(resizedCGImage);
        
        CGContextClearRect(context, (CGRect){CGPointZero, size});
        CGContextRestoreGState(context);
    }
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return [UIImage animatedImageWithImages:images duration:2];
}

#pragma mark - 打开相册
- (void)__openAlbum:(BOOL)isBecomeDanielWu {
    [TFY_ImagePickerController showImagePickerallowsEditing:YES finishAction:^(UIImage * _Nonnull image, NSData * _Nonnull imageData, NSURL * _Nonnull videoURL) {
        if (image) {
            TFY_ImageresizerConfigure *configure = [TFY_ImageresizerConfigure defaultConfigureWithImage:image make:nil];
            [self __startImageresizer:configure];
        } else if (imageData) {
            TFY_ImageresizerConfigure *configure = [TFY_ImageresizerConfigure defaultConfigureWithImageData:imageData make:nil];
            [self __startImageresizer:configure];
        } else if (videoURL) {
            [self __confirmVideo:videoURL];
        }
    } fromVC:self];
}

#pragma mark - 判断视频是否需要修正方向（内部or外部修正）
- (void)__confirmVideo:(NSURL *)videoURL {
    // 校验视频信息
    AVURLAsset *videoAsset = [AVURLAsset assetWithURL:videoURL];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [videoAsset loadValuesAsynchronouslyForKeys:@[@"duration", @"tracks"] completionHandler:^{
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    // 方向没被修改过，无需修正，直接进入
    AVAssetTrack *videoTrack = [videoAsset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    if (CGAffineTransformEqualToTransform(videoTrack.preferredTransform, CGAffineTransformIdentity)) {
        TFY_ImageresizerConfigure *configure = [TFY_ImageresizerConfigure defaultConfigureWithVideoAsset:videoAsset make:nil fixErrorBlock:nil fixStartBlock:nil fixProgressBlock:nil fixCompleteBlock:nil];
        [self __startImageresizer:configure];
        return;
    }
    
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:@"该视频方向需要先修正" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
#pragma mark 内部修正
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"先进页面再修正" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @tfy_weakify(self);
        TFY_ImageresizerConfigure *configure = [TFY_ImageresizerConfigure defaultConfigureWithVideoURL:videoURL make:nil fixErrorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
            [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            @tfy_strongify(self);
            if (!self) return;
            [self.navigationController popViewControllerAnimated:YES];
        } fixStartBlock:^{
           
        } fixProgressBlock:^(float progress) {
            
        } fixCompleteBlock:^(NSURL *cacheURL) {
            
        }];
        [self __startImageresizer:configure];
    }]];
    
#pragma mark 外部修正
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"先修正再进页面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        @tfy_weakify(self);
        [TFY_ImageresizerTool fixOrientationVideoWithAsset:videoAsset fixErrorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
            
            [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            
            @tfy_strongify(self);
            if (!self) return;
            self.isExporting = NO;
            
        } fixStartBlock:^(AVAssetExportSession *exportSession) {
            
            @tfy_strongify(self);
            if (!self) return;
            self.isExporting = YES;
            
            [self __addProgressTimer:^(float progress) {
               
            } exporterSession:exportSession];
            
        } fixCompleteBlock:^(NSURL *cacheURL) {
            
            
            @tfy_strongify(self);
            if (!self) return;
            self.isExporting = NO;
            self.tmpURL = cacheURL; // 保存该路径，裁剪后删除视频。
            
            TFY_ImageresizerConfigure *configure = [TFY_ImageresizerConfigure defaultConfigureWithVideoAsset:[AVURLAsset assetWithURL:cacheURL] make:nil fixErrorBlock:nil fixStartBlock:nil fixProgressBlock:nil fixCompleteBlock:nil];
            [self __startImageresizer:configure];
        }];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtr animated:YES completion:nil];
}

- (void)setIsExporting:(BOOL)isExporting {
    if (_isExporting == isExporting) return;
    _isExporting = isExporting;
    if (isExporting) {
        @tfy_weakify(self);
        [TFY_ExportCancelView showWithCancelHandler:^{
            @tfy_strongify(self);
            if (!self) return;
            [self.exporterSession cancelExport];
        }];
    } else {
        [TFY_ExportCancelView hide];
    }
}

#pragma mark - 开始裁剪
- (void)__startImageresizer:(TFY_ImageresizerConfigure *)configure {
    TFY_ImageController *vc = [TFY_ImageController new];
    vc.configure = configure;
    
    CATransition *cubeAnim = [CATransition animation];
    cubeAnim.duration = 0.45;
    cubeAnim.type = @"cube";
    cubeAnim.subtype = kCATransitionFromRight;
    cubeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:cubeAnim forKey:@"cube"];
    
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - 监听视频导出进度的定时器

- (void)__addProgressTimer:(TFY_ExportVideoProgressBlock)progressBlock exporterSession:(AVAssetExportSession *)exporterSession {
    [self __removeProgressTimer];
    if (progressBlock == nil || exporterSession == nil) return;
    self.exporterSession = exporterSession;
    self.progressBlock = progressBlock;
    self.progressTimer = [NSTimer timerWithTimeInterval:0.02 target:self selector:@selector(__progressTimerHandle) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)__removeProgressTimer {
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    self.progressBlock = nil;
    self.exporterSession = nil;
}

- (void)__progressTimerHandle {
    if (self.progressBlock && self.exporterSession) self.progressBlock(self.exporterSession.progress);
}


@end
