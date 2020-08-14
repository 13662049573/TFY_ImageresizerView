//
//  TFY_ImageController.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImageController.h"
#import "ShapeListViewController.h"
#import "TFY_ImageViewsController.h"
#import "TFY_ExportCancelView.h"
#define TFY_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define TFY_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TFY_RandomColor TFY_RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define TFY_RandomAColor(a) TFY_RGBAColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), a)

@interface TFY_ImageController ()
TFY_CATEGORY_ASSIGN_PROPERTY TFY_ImageresizerFrameType frameType;
TFY_CATEGORY_STRONG_PROPERTY UIImage *borderImage;
TFY_CATEGORY_ASSIGN_PROPERTY BOOL isToBeArbitrarily,selected_bool;
TFY_CATEGORY_STRONG_PROPERTY TFY_StackView *stackView;
@property (nonatomic, strong) UIImage *maskImage;
@property (nonatomic, assign) BOOL isExporting;
@end

@implementation TFY_ImageController

+ (UIImage *)stretchBorderImage {
    static UIImage *stretchBorderImage_;
    if (!stretchBorderImage_) {
        UIImage *stretchBorderImage = [UIImage imageNamed:@"real_line"];
        // 裁剪掉上下多余的空白部分
        CGFloat inset = 1.5 * stretchBorderImage.scale;
        CGImageRef sbImageRef = stretchBorderImage.CGImage;
        sbImageRef = CGImageCreateWithImageInRect(sbImageRef, CGRectMake(0, inset, CGImageGetWidth(sbImageRef), CGImageGetHeight(sbImageRef) - 2 * inset));
        stretchBorderImage = [UIImage imageWithCGImage:sbImageRef scale:stretchBorderImage.scale orientation:stretchBorderImage.imageOrientation];
        CGImageRelease(sbImageRef);
        // 设定拉伸区域
        stretchBorderImage_ = [stretchBorderImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    }
    return stretchBorderImage_;
}
+ (CGPoint)stretchBorderImageRectInset {
    return CGPointMake(-2, -2);
}

+ (UIImage *)tileBorderImage {
    static UIImage *tileBorderImage_;
    if (!tileBorderImage_) {
        UIImage *tileBorderImage = [UIImage imageNamed:@"dotted_line"];
        // 设定平铺区域
        tileBorderImage_ = [tileBorderImage resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14) resizingMode:UIImageResizingModeTile];
    }
    return tileBorderImage_;
}
+ (CGPoint)tileBorderImageRectInset {
    return CGPointMake(-1.75, -1.75);
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setConfigure:(TFY_ImageresizerConfigure *)configure{
    _configure = configure;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController tfy_navigationBarTransparent];
    self.view.backgroundColor = _configure.bgColor;//背景颜色
    self.frameType = _configure.frameType;//边框类型
    self.borderImage = _configure.borderImage;//边框图片
    self.maskImage = self.configure.maskImage;
    self.selected_bool = NO;
    
    UIBarButtonItem *item1 = tfy_barbtnItem().tfy_titleItem(@"模板图片",13,[UIColor redColor],self,@selector(replaceMaskImage));
    UIBarButtonItem *item2 = tfy_barbtnItem().tfy_titleItem(@"浏览",13,[UIColor redColor],self,@selector(previewAction));
    UIBarButtonItem *item3 = tfy_barbtnItem().tfy_titleItem(@"水平镜像",13,[UIColor redColor],self,@selector(horMirror));
    UIBarButtonItem *item4 = tfy_barbtnItem().tfy_titleItem(@"垂直镜像",13,[UIColor redColor],self,@selector(verMirror));
    UIBarButtonItem *item5 = tfy_barbtnItem().tfy_titleItem(@"锁紧",13,[UIColor redColor],self,@selector(lockFrame));
    self.navigationItem.rightBarButtonItems = @[item5,item4,item3,item2,item1];

    [self.view addSubview:self.stackView];
    self.stackView.tfy_LeftSpace(0).tfy_BottomSpace(0).tfy_RightSpace(0).tfy_Height(120);
    
    NSArray *title_Arr = @[@"更换样式",@"旋转",@"重置",@"裁剪",@"更换比例",@"模糊效果",@"随机颜色",@"更换图片"];
    [title_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = tfy_button();
        button.tfy_title(obj, UIControlStateNormal, [UIColor redColor], UIControlStateNormal, [UIFont systemFontOfSize:15]).tfy_alAlignment(1).tfy_cornerRadius(10).tfy_backgroundColor([UIColor whiteColor], 1).tfy_action(self, @selector(buttonClick:), UIControlEventTouchUpInside);
        button.tag = idx+10;
        [self.stackView addSubview:button];
    }];
    [self.stackView tfy_StartLayout];
    
    
    self.configure.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.configure.viewFrame = [UIScreen mainScreen].bounds;
    
    __weak typeof(self) wSelf = self;
    TFY_ImageresizerView *imageresizerView = [TFY_ImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当不需要重置设置按钮不可点
        
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
        NSLog(@"------------%u",enabled);
    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
    self.configure = nil;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.imageresizerView.clipsToBounds = YES;
    // 横竖屏切换
    [self.imageresizerView updateFrame:self.view.bounds contentInsets:UIEdgeInsetsMake(15, 15, 15, 15) duration:1];
}


-(void)buttonClick:(UIButton *)btn{
    if (btn.tag==10) {
        [self changeFrameType:btn];
    }
    else if (btn.tag==11){
        [self rotate];
    }
    else if (btn.tag==12){
        [self recovery];
    }
    else if (btn.tag==13){
        [self resize:@""];
    }
    else if (btn.tag==14){
        [self changeResizeWHScale];
    }
    else if (btn.tag==15){
        [self changeBlurEffect];
    }
    else if (btn.tag==16){
        [self changeRandomColor];
    }
    else if (btn.tag==17){
        [self replaceImage];
    }
}


-(TFY_StackView *)stackView{
    if (!_stackView) {
        _stackView = [TFY_StackView new];
        _stackView.backgroundColor = [UIColor clearColor];
        _stackView.tfy_Edge = UIEdgeInsetsMake(10, 10, 20, 10);
        _stackView.tfy_Orientation = All;// 自动横向垂直混合布局
        _stackView.tfy_HSpace = 10;
        _stackView.tfy_VSpace = 10;
        _stackView.tfy_Column = 4;
    }
    return _stackView;
}

//设置模板
- (void)replaceMaskImage {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"蒙版列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TFY_NavigationController *navCtr = [[TFY_NavigationController alloc] initWithRootViewController:[ShapeListViewController shapeListViewController:^(UIImage *shapeImage) {
            if (!self) return;
            self.imageresizerView.maskImage = shapeImage;
        
        }]];
        if (@available(iOS 13.0, *)) {
            navCtr.modalPresentationStyle = UIModalPresentationPageSheet;
        } else {
            navCtr.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self presentViewController:navCtr animated:YES completion:nil];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"love" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = [UIImage imageNamed:@"love.png"];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"Supreme" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = [UIImage imageNamed:@"supreme.png"];
    }]];
    
    if (self.isBecomeDanielWu) {
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"DanielWu-Face" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imageresizerView.maskImage = self.maskImage;
        }]];
    }
    
    if (self.imageresizerView.maskImage) {
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"移除蒙版" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.imageresizerView.maskImage = nil;
        }]];
    }
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark - 裁剪完成

- (void)__imageresizerDone:(UIImage *)resizeImage {
    if (!resizeImage) {
        [TFY_ProgressHUD showErrorWithStatus:@"没有裁剪图片"];
        return;
    }
    [TFY_ProgressHUD dismiss];
    TFY_ImageViewsController *vc = [TFY_ImageViewsController new];
    vc.image = resizeImage;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 按钮点击事件
//更改样式
- (void)changeFrameType:(UIButton *)sender {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (self.imageresizerView.isGIF) {
        [alertCtr addAction:[UIAlertAction actionWithTitle:(self.imageresizerView.isLoopPlaybackGIF ? @"GIF自主选择" : @"GIF自动播放") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.imageresizerView.isLoopPlaybackGIF = !self.imageresizerView.isLoopPlaybackGIF;
        }]];
    }
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"简洁样式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.borderImage = nil;
        self.imageresizerView.frameType = TFY_ConciseFrameType;
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"经典样式" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.borderImage = nil;
        self.imageresizerView.frameType = TFY_ClassicFrameType;
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"拉伸的边框图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.borderImageRectInset = [self.class stretchBorderImageRectInset];
        self.imageresizerView.borderImage = [self.class stretchBorderImage];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"平铺的边框图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.borderImageRectInset = [self.class tileBorderImageRectInset];
        self.imageresizerView.borderImage = [self.class tileBorderImage];
    }]];
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertCtr animated:YES completion:nil];
}
//旋转
- (void)rotate{
    [self.imageresizerView rotation];
}
//重置
- (void)recovery {
    [self.imageresizerView recovery];
}
//裁剪
#pragma mark 裁剪
- (void)resize:(id)sender {
    @tfy_weakify(self);
    // 裁剪视频
    if (self.imageresizerView.videoURL) {
        UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"裁剪当前帧画面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TFY_ProgressHUD showWithStatus:@"开始..."];
            [self.imageresizerView cropVideoCurrentFrameWithCacheURL:nil errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
                @tfy_strongify(self);
                if (!self) return;
                [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            } completeBlock:^(UIImage *finalImage, NSURL *cacheURL, BOOL isCacheSuccess) {
                @tfy_strongify(self);
                if (!self) return;
                [self __imageresizerDone:finalImage cacheURL:cacheURL];
            }];
        }]];
        [alertCtr addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"截取%.0lf秒为GIF", 5.00] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [TFY_ProgressHUD showWithStatus:@"开始..."];
            [self.imageresizerView cropVideoToGIFFromCurrentSecondWithDuration:5 cacheURL:[self __cacheURL:@"gif"] errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
                @tfy_strongify(self);
                if (!self) return;
                [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            } completeBlock:^(UIImage *finalImage, NSURL *cacheURL, BOOL isCacheSuccess) {
                @tfy_strongify(self);
                if (!self) return;
                [self __imageresizerDone:finalImage cacheURL:cacheURL];
            }];
        }]];
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"裁剪视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self __cropVideo];
        }]];
        [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertCtr animated:YES completion:nil];
        return;
    }
    
    // 裁剪GIF
    if (self.imageresizerView.isGIF) {
        void (^cropGIF)(void) = ^{
            [TFY_ProgressHUD showWithStatus:@"开始..."];
            [self.imageresizerView cropGIFWithCacheURL:[self __cacheURL:@"gif"] errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
                @tfy_strongify(self);
                if (!self) return;
                [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            } completeBlock:^(UIImage *finalImage, NSURL *cacheURL, BOOL isCacheSuccess) {
                // 裁剪完成，finalImage为裁剪后的图片
                // 注意循环引用
                @tfy_strongify(self);
                if (!self) return;
                [self __imageresizerDone:finalImage cacheURL:cacheURL];
            }];
        };
        if (self.imageresizerView.isLoopPlaybackGIF) {
            cropGIF();
        } else {
            UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"裁剪当前帧画面" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [TFY_ProgressHUD showWithStatus:@"开始..."];
                [self.imageresizerView cropGIFCurrentIndexWithCacheURL:nil errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
                    @tfy_strongify(self);
                    if (!self) return;
                    [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
                } completeBlock:^(UIImage *finalImage, NSURL *cacheURL, BOOL isCacheSuccess) {
                    // 裁剪完成，finalImage为裁剪后的图片
                    // 注意循环引用
                    @tfy_strongify(self);
                    if (!self) return;
                    [self __imageresizerDone:finalImage cacheURL:cacheURL];
                }];
            }]];
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"裁剪GIF" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                cropGIF();
            }]];
            [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertCtr animated:YES completion:nil];
        }
        return;
    }
    
    // 裁剪图片
    [TFY_ProgressHUD showWithStatus:@"开始..."];
    [self.imageresizerView cropPictureWithCacheURL:[self __cacheURL:@"jpeg"] errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
        @tfy_strongify(self);
        if (!self) return;
        [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
    } completeBlock:^(UIImage *finalImage, NSURL *cacheURL, BOOL isCacheSuccess) {
        // 裁剪完成，finalImage为裁剪后的图片
        // 注意循环引用
        @tfy_strongify(self);
        if (!self) return;
        [self __imageresizerDone:finalImage cacheURL:cacheURL];
    }];
}


#pragma mark 设置宽高比
- (void)changeResizeWHScale:(id)sender {
    [UIAlertController changeResizeWHScale:^(CGFloat resizeWHScale) {
        if (resizeWHScale < 0) {
            self.imageresizerView.isArbitrarily = !self.imageresizerView.isArbitrarily;
        } else if (resizeWHScale == 0) {
            self.imageresizerView.isRoundResize = !self.imageresizerView.isRoundResize;
        } else {
            self.imageresizerView.resizeWHScale = resizeWHScale;
        }
    } isArbitrarily:self.imageresizerView.isArbitrarily isRoundResize:self.imageresizerView.isRoundResize fromVC:self];
}

#pragma mark 设置毛玻璃
- (void)changeBlurEffect:(id)sender {
    [UIAlertController changeBlurEffect:^(UIBlurEffect *blurEffect) {
        self.imageresizerView.blurEffect = blurEffect;
    } fromVC:self];
}


static UIViewController *tmpVC_;
- (void)pop{
    if (self.backBlock) {
        self.backBlock(self);
        return;
    }
    
    CATransition *cubeAnim = [CATransition animation];
    cubeAnim.duration = 0.45;
    cubeAnim.type = @"cube";
    cubeAnim.subtype = kCATransitionFromLeft;
    cubeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.navigationController.view.layer addAnimation:cubeAnim forKey:@"cube"];
    
    tmpVC_ = self; // 晚一些再死，不然视频画面会立即消失
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tmpVC_ = nil;
    });
}


#pragma mark - 以当前时间戳生成缓存路径

- (NSURL *)__cacheURL:(NSString *)extension {
    NSString *fileName = [NSString stringWithFormat:@"%.0lf.%@", [[NSDate date] timeIntervalSince1970], extension];
    NSString *cachePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    return [NSURL fileURLWithPath:cachePath];
}
//锁定
- (void)lockFrame {
    self.selected_bool = !self.selected_bool;
    self.imageresizerView.isLockResizeFrame =self.selected_bool;
}
//垂直镜像
- (void)verMirror{
    self.imageresizerView.verticalityMirror = !self.imageresizerView.verticalityMirror;
}
//水平镜像
- (void)horMirror{
    self.imageresizerView.horizontalMirror = !self.imageresizerView.horizontalMirror;
}
//浏览
- (void)previewAction{
    self.selected_bool = !self.selected_bool;
    self.imageresizerView.isPreview = self.selected_bool;
}
//更改比例
- (void)changeResizeWHScale {
   [UIAlertController changeResizeWHScale:^(CGFloat resizeWHScale) {
        if (resizeWHScale < 0) {
            self.imageresizerView.isArbitrarily = !self.imageresizerView.isArbitrarily;
        } else if (resizeWHScale == 0) {
            self.imageresizerView.isRoundResize = !self.imageresizerView.isRoundResize;
        } else {
            self.imageresizerView.resizeWHScale = resizeWHScale;
        }
    } isArbitrarily:self.imageresizerView.isArbitrarily isRoundResize:self.imageresizerView.isRoundResize fromVC:self];
}
//模糊效果
- (void)changeBlurEffect {
    [UIAlertController changeBlurEffect:^(UIBlurEffect *blurEffect) {
        self.imageresizerView.blurEffect = blurEffect;
    } fromVC:self];
}
//随机颜色额
- (void)changeRandomColor {
    CGFloat maskAlpha = (CGFloat)TFY_RandomNumber(0, 10) / 10.0;
    UIColor *strokeColor;
    UIColor *bgColor;
    if (@available(iOS 13, *)) {
        UIColor *strokeColor1 = TFY_RandomColor;
        UIColor *strokeColor2 = TFY_RandomColor;
        strokeColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return strokeColor1;
            } else {
                return strokeColor2;
            }
        }];
        UIColor *bgColor1 = TFY_RandomColor;
        UIColor *bgColor2 = TFY_RandomColor;
        bgColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return bgColor1;
            } else {
                return bgColor2;
            }
        }];
    } else {
        strokeColor = TFY_RandomColor;
        bgColor = TFY_RandomColor;
    }
    [self.imageresizerView setupStrokeColor:strokeColor blurEffect:self.imageresizerView.blurEffect bgColor:bgColor maskAlpha:maskAlpha animated:YES];
    // 随机网格数
    self.imageresizerView.gridCount = TFY_RandomNumber(2, 20);
}
//更改图片
- (void)replaceImage{
    [UIAlertController replaceObj:^(UIImage *image, NSData *imageData, NSURL *videoURL) {
        if (image) {
            self.imageresizerView.image = image;
        } else if (imageData) {
            self.imageresizerView.imageData = imageData;
        } else if (videoURL) {
            @tfy_weakify(self);
            [self.imageresizerView setVideoURL:videoURL animated:YES fixErrorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
                weak_self.isExporting = NO;
                [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
            } fixStartBlock:^{
               
            } fixProgressBlock:^(float progress) {
                weak_self.isExporting = YES;
                NSLog(@"修正方向中...%.0lf%%",progress * 100);
                
            } fixCompleteBlock:^(NSURL *cacheURL) {
                weak_self.isExporting = NO;
                
            }];
        }
    } fromVC:self];
}

#pragma mark - 图片裁剪完成

- (void)__imageresizerDone:(UIImage *)finalImage cacheURL:(NSURL *)cacheURL {
    if (!finalImage && !cacheURL) {
        [TFY_ProgressHUD showErrorWithStatus:@"裁剪失败"];
        return;
    }
    [TFY_ProgressHUD dismiss];
    if (self.isBecomeDanielWu) {
//        DanielWuViewController *vc = [DanielWuViewController DanielWuVC:finalImage];
//        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TFY_ImageViewsController *vc = [TFY_ImageViewsController new];
        if (cacheURL) {
            vc.imageURL = cacheURL;
        } else {
            vc.image = finalImage;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 裁剪视频

- (void)__cropVideo {
    
    @tfy_weakify(self);
    [self.imageresizerView cropVideoWithCacheURL:[self __cacheURL:@"mov"] errorBlock:^(NSURL *cacheURL, TFY_ImageresizerErrorReason reason) {
        weak_self.isExporting = NO;
        [TFY_ImageController showErrorMsg:reason pathExtension:[cacheURL pathExtension]];
    } progressBlock:^(float progress) {
        // 监听进度
        weak_self.isExporting = YES;
        NSLog(@"%.2f",progress * 100);
        
    } completeBlock:^(NSURL *cacheURL) {
        // 裁剪完成
        [TFY_ProgressHUD dismiss];
        
        @tfy_strongify(self);
        if (!self) return;
        self.isExporting = NO;
        
        TFY_ImageViewsController *vc = [TFY_ImageViewsController new];
        vc.videoURL = cacheURL;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)setIsExporting:(BOOL)isExporting {
    if (_isExporting == isExporting) return;
    _isExporting = isExporting;
    if (isExporting) {
        @tfy_weakify(self);
        [TFY_ExportCancelView showWithCancelHandler:^{
            @tfy_strongify(self);
            if (!self) return;
            [self.imageresizerView videoCancelExport];
        }];
    } else {
        [TFY_ExportCancelView hide];
    }
}
@end
