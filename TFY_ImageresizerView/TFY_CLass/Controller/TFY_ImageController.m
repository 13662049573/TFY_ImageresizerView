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

#define TFY_RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define TFY_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define TFY_RandomColor TFY_RGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define TFY_RandomAColor(a) TFY_RGBAColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), a)

CG_INLINE NSInteger TFY_RandomNumber(NSInteger from, NSInteger to) {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

@interface TFY_ImageController ()
TFY_CATEGORY_ASSIGN_PROPERTY TFY_ImageresizerFrameType frameType;
TFY_CATEGORY_STRONG_PROPERTY TFY_ImageresizerView *imageresizerView;
TFY_CATEGORY_STRONG_PROPERTY UIImage *borderImage;
TFY_CATEGORY_ASSIGN_PROPERTY BOOL isToBeArbitrarily,selected_bool;
TFY_CATEGORY_STRONG_PROPERTY TFY_StackView *stackView;
@end

@implementation TFY_ImageController

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
    
    
    [self.view insertSubview:self.imageresizerView atIndex:0];
   
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
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
        [self resize];
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

-(TFY_ImageresizerView *)imageresizerView{
    if (!_imageresizerView) {
        _imageresizerView = [TFY_ImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
            
        } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
            
        }];
    }
    return _imageresizerView;
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
    //
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"run" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = [UIImage imageNamed:@"run.png"];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"moban" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = [UIImage imageNamed:@"moban.png"];
    }]];
    
    [alertCtr addAction:[UIAlertAction actionWithTitle:@"moban2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.imageresizerView.maskImage = [UIImage imageNamed:@"moban2.png"];
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

- (void)pop{
    if (self.backBlock) {
        self.backBlock(self);
        return;
    }
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
