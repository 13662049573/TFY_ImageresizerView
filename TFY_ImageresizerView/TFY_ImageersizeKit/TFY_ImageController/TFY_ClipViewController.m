//
//  TFY_ClipViewController.m
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/22.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ClipViewController.h"
#import "TFY_ImageresizerView.h"
#import "TFY_ImageresizerType.h"
#import "TFY_ListViewController.h"
#import "UIAlertController+TFY_Tools.h"

#define TFY_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define TFY_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TFY_RandomColor TFY_RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define TFY_RandomAColor(a) TFY_RGBAColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), a)

CG_INLINE NSInteger TFY_RandomNumber(NSInteger from, NSInteger to) {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

@interface TFY_ClipViewController ()
@property(nonatomic, assign) UIInterfaceOrientation statusBarOrientation;
@property(nonatomic, strong)UIButton *nav_btn;
@property(nonatomic, strong)UIView *nav_View,*butom_View;
@property(nonatomic, strong) TFY_ImageresizerView *imageresizerView;
@property(nonatomic, assign) TFY_ImageresizerFrameType frameType;
@property(nonatomic, strong) UIImage *borderImage;
@property(nonatomic, assign) BOOL isToBeArbitrarily,selected_bool;
@property(nonatomic, copy)NSArray *title_Arr,*botem_Arr;
@end

@implementation TFY_ClipViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setConfigure:(TFY_ImageresizerConfigure *)configure{
    _configure = configure;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    //禁止手势滑动
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    //添加容器
    [self.view addSubview:self.nav_btn];
    [self.view addSubview:self.nav_View];
    [self.view addSubview:self.butom_View];
    [self.view insertSubview:self.imageresizerView atIndex:0];
    
    //监听屏幕旋转
   self.statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    self.title_Arr = @[@"模板设置",@"浏览效果",@"水平镜像",@"重置镜像",@"锁定边框"];
    [self.title_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(1+idx*((Clip_Width_W-60)/self.title_Arr.count), 0, ((Clip_Width_W-100)/self.title_Arr.count), 30);
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.nav_View addSubview:button];
        button.tag = idx+10;
    }];
    
    self.botem_Arr = @[@"更换样式",@"旋转图片",@"回到初始",@"裁剪图片",@"更换比例",@"模糊效果",@"随机颜色",@"更换图片"];
    __block  NSInteger rank = 4;
    __block  CGFloat W = (Clip_Width_W - 60) / rank;
    __block  CGFloat H = 30;
    __block  CGFloat rankMargin = (Clip_Width_W - rank * W) / (rank );
    __block  CGFloat rowMargin = 10;
    [self.botem_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat X = (idx % rank) * (W + rankMargin) + 5;
        NSUInteger Y = (idx / rank) * (H +rowMargin);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(X, Y, W, H);
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.butom_View addSubview:button];
        button.tag = idx+20;
    }];
}

-(void)buttonClick:(UIButton *)btn{
    if (btn.tag==10) {
        [self replaceMaskImage];
    }
    else if (btn.tag==11){
        [self previewAction:btn];
    }
    else if (btn.tag==12){
        [self horMirror];
    }
    else if (btn.tag==13){
        [self verMirror];
    }
    else if (btn.tag==14){
        [self lockFrame:btn];
    }
    else if (btn.tag==20){
        [self changeFrameType:btn];
    }
    else if (btn.tag==21){
        [self rotate];
    }
    else if (btn.tag==22){
        [self recovery];
    }
    else if (btn.tag==23){
        [self resize];
    }
    else if (btn.tag==24){
        [self changeResizeWHScale];
    }
    else if (btn.tag==25){
        [self changeBlurEffect];
    }
    else if (btn.tag==26){
        [self changeRandomColor];
    }
    else if (btn.tag==27){
        [self replaceImage];
    }
}

#pragma mark - 监听屏幕旋转

- (void)didChangeStatusBarOrientation {
    [self setStatusBarOrientation:[UIApplication sharedApplication].statusBarOrientation duration:1];
}

- (void)setStatusBarOrientation:(UIInterfaceOrientation)statusBarOrientation {
    [self setStatusBarOrientation:statusBarOrientation duration:1];
}

- (void)setStatusBarOrientation:(UIInterfaceOrientation)statusBarOrientation duration:(NSTimeInterval)duration {
    if (_statusBarOrientation == statusBarOrientation) return;
    _statusBarOrientation = statusBarOrientation;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.nav_btn.frame = CGRectMake(20, Clip_kNavTimebarHeight, 40, 40);
//    NSInteger index = 0;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if (statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            self.nav_View.frame = CGRectMake(Clip_kNavTimebarHeight+10, Clip_kNavTimebarHeight+5, 100, 200);
            self.butom_View.frame = CGRectMake(Clip_Width_W-100, Clip_kNavTimebarHeight, 100, Clip_Width_W-Clip_kNavBarHeight);
            
        } else {
            self.nav_View.frame = CGRectMake(20, Clip_kNavBarHeight, 100, 200);
            self.butom_View.frame = CGRectMake(Clip_Width_W-120, Clip_kNavTimebarHeight, 100, Clip_Width_W-Clip_kNavBarHeight);
        }
        
    } else {
        if (statusBarOrientation == UIInterfaceOrientationPortrait) {
            self.nav_View.frame = CGRectMake(self.nav_btn.frame.origin.x+self.nav_btn.frame.size.width, Clip_kNavTimebarHeight+5, Clip_Width_W-self.nav_btn.bounds.size.width, 30);
            self.butom_View.frame = CGRectMake(0, Clip_Height_H-100, Clip_Width_W, 100);
    
        } else {
            self.butom_View.frame = CGRectMake(0, Clip_Height_H-100, Clip_Width_W, 100);
        }
        
    }
    __block  NSInteger rank = 4;
    __block  CGFloat W = (Clip_Width_W - 60) / rank;
    __block  CGFloat H = 30;
    __block  CGFloat rankMargin = (Clip_Width_W - rank * W) / (rank );
    __block  CGFloat rowMargin = 10;
    [self.botem_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat X = (idx % rank) * (W + rankMargin) + 5;
        NSUInteger Y = (idx / rank) * (H +rowMargin);
        UIButton *btn = (UIButton *)[self.view viewWithTag:idx+20];
        if (Clip_isPortrait) {
            btn.frame = CGRectMake(X, Y, W, H);
        }
        else{
            btn.frame = CGRectMake(10, 10+idx*40, 80, H);
        }
    }];
    
    
    [self.title_Arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:idx+10];
        if (Clip_isPortrait) {
            btn.frame = CGRectMake(1+idx*((Clip_Width_W-60)/self.title_Arr.count), 0, ((Clip_Width_W-100)/self.title_Arr.count), 30);
        }
        else{
            btn.frame = CGRectMake(10, 5+idx*(200/self.title_Arr.count), 80, 30);
        }
    }];
    
    
    if (duration) {
        UIViewAnimationOptions options;
        switch (self.imageresizerView.animationCurve) {
            case TFY_AnimationCurveEaseInOut:
                options = UIViewAnimationOptionCurveEaseInOut;
                break;
            case TFY_AnimationCurveEaseIn:
                options = UIViewAnimationOptionCurveEaseIn;
                break;
            case TFY_AnimationCurveEaseOut:
                options = UIViewAnimationOptionCurveEaseOut;
                break;
            case TFY_AnimationCurveLinear:
                options = UIViewAnimationOptionCurveLinear;
                break;
        }
        
        self.imageresizerView.clipsToBounds = NO;
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.imageresizerView.clipsToBounds = YES;
        }];
    } else {
        [self.view layoutIfNeeded];
    }
    // 横竖屏切换
    [self.imageresizerView updateFrame:[UIScreen mainScreen].bounds contentInsets:contentInsets duration:duration];
}


-(UIButton *)nav_btn{
    if (!_nav_btn) {
        _nav_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        _nav_btn.frame = CGRectMake(20, Clip_kNavTimebarHeight, 40, 40);
        [_nav_btn setImage:[self navigationBarBackIconImage] forState:UIControlStateNormal];
        [_nav_btn addTarget:self action:@selector(navigationBarClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nav_btn;
}

-(UIView *)nav_View{
    if (!_nav_View) {
        _nav_View = [[UIView alloc] initWithFrame:CGRectMake(self.nav_btn.frame.origin.x+self.nav_btn.frame.size.width, Clip_kNavTimebarHeight+5, Clip_Width_W-self.nav_btn.bounds.size.width, 30)];
    }
    return _nav_View;
}

-(UIView *)butom_View{
    if (!_butom_View) {
        _butom_View = [[UIView alloc] initWithFrame:CGRectMake(0, Clip_Height_H-100, Clip_Width_W, 100)];
    }
    return _butom_View;
}


-(void)navigationBarClick{
    CATransition *cubeAnim = [CATransition animation];
    cubeAnim.duration = 0.5;
    cubeAnim.type = @"cube";
    cubeAnim.subtype = kCATransitionFromLeft;
    cubeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.view.window.layer addAnimation:cubeAnim forKey:@"cube"];
    
    if (self.navigationController.viewControllers.count <= 1) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

-(TFY_ImageresizerView *)imageresizerView{
    if (!_imageresizerView) {
        _imageresizerView = [TFY_ImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {} imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {}];
    }
    return _imageresizerView;
}

- (UIImage *)navigationBarBackIconImage {
    CGSize const size = CGSizeMake(15.0, 21.0);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    
    UIColor *color = [UIColor blackColor];
    [color setFill];
    [color setStroke];
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10.9, 0)];
    [bezierPath addLineToPoint: CGPointMake(12, 1.1)];
    [bezierPath addLineToPoint: CGPointMake(1.1, 11.75)];
    [bezierPath addLineToPoint: CGPointMake(0, 10.7)];
    [bezierPath addLineToPoint: CGPointMake(10.9, 0)];
    [bezierPath closePath];
    [bezierPath moveToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath addLineToPoint: CGPointMake(10.88, 21)];
    [bezierPath addLineToPoint: CGPointMake(0.54, 11.21)];
    [bezierPath addLineToPoint: CGPointMake(1.64, 10.11)];
    [bezierPath addLineToPoint: CGPointMake(11.98, 19.9)];
    [bezierPath closePath];
    [bezierPath setLineWidth:1.0];
    [bezierPath fill];
    [bezierPath stroke];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//设置模板
- (void)replaceMaskImage {
    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"蒙版列表" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UINavigationController *navCtr = [[UINavigationController alloc] initWithRootViewController:[TFY_ListViewController shapeListViewController:^(UIImage *shapeImage) {
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
    
    BOOL isArbitrarilyMask = self.imageresizerView.isArbitrarilyMask;
    [alertCtr addAction:[UIAlertAction actionWithTitle:(isArbitrarilyMask ? @"蒙版使用固定比例" : @"蒙版使用任意比例") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.isArbitrarilyMask = !isArbitrarilyMask;
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"移除蒙版" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = nil;
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark - 裁剪完成

- (void)__imageresizerDone:(UIImage *)resizeImage {
    if (!resizeImage) {
        return;
    }
    if (self.clip_Block) {
        self.clip_Block(resizeImage);
    }
}

#pragma mark - 按钮点击事件
//更改样式
- (void)changeFrameType:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.borderImage) {
        self.imageresizerView.borderImage = sender.selected ? nil : self.borderImage;
        return;
    } else {
        self.imageresizerView.frameType = sender.selected ? (self.frameType == TFY_ClassicFrameType ? TFY_ConciseFrameType : TFY_ClassicFrameType) : self.frameType;
    }
}
//旋转
- (void)rotate{
    [self.imageresizerView rotation];
}
//重置
- (void)recovery {
    if (self.imageresizerView.maskImage) {
        [self.imageresizerView recoveryByCurrentMaskImage];
    } else if ([self.imageresizerView isRoundResizing]) {
        [self.imageresizerView recoveryToRoundResize];
    } else {
        [self.imageresizerView recoveryByInitialResizeWHScale:self.isToBeArbitrarily];
    }
}
//裁剪
- (void)resize{
    __weak typeof(self) wSelf = self;
    [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        [sSelf __imageresizerDone:resizeImage];
    }];
}

//锁定
- (void)lockFrame:(UIButton *)btn {
    btn.selected = !btn.selected;
    self.imageresizerView.isLockResizeFrame = btn.selected;
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
- (void)previewAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    self.imageresizerView.isPreview = btn.selected;
}
//更改比例
- (void)changeResizeWHScale {
    [UIAlertController changeResizeWHScale:^(CGFloat resizeWHScale) {
        if (resizeWHScale < 0) {
            [self.imageresizerView roundResize:YES];
        } else {
            [self.imageresizerView setResizeWHScale:resizeWHScale isToBeArbitrarily:self.isToBeArbitrarily animated:YES];
        }
    } fromVC:self];
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
    [UIAlertController replaceImage:^(UIImage *image) {
        self.imageresizerView.resizeImage = image;
    } fromVC:self];
}

@end
