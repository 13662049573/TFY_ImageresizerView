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

@interface TFY_ConfigureModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, strong) TFY_ImageresizerConfigure *configure;
+ (NSArray<TFY_ConfigureModel *> *)testModels;
@end

@implementation TFY_ConfigureModel
+ (NSArray<TFY_ConfigureModel *> *)testModels {
    TFY_ConfigureModel *model1 = [self new];
    model1.title = @"默认样式";
    model1.configure = [TFY_ImageresizerConfigure defaultConfigureWithResizeImage:[UIImage imageNamed:@"run"] make:nil];
    
    TFY_ConfigureModel *model2 = [self new];
    model2.title = @"深色毛玻璃遮罩";
    model2.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure.tfy_strokeColor([UIColor orangeColor]);
    }];
    
    TFY_ConfigureModel *model3 = [self new];
    model3.title = @"浅色毛玻璃遮罩";
    model3.configure = [TFY_ImageresizerConfigure lightBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure.tfy_strokeColor([UIColor yellowColor]);
    }];
    
    TFY_ConfigureModel *model4 = [self new];
    model4.title = @"其他样式";
    model4.configure = [TFY_ImageresizerConfigure defaultConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure
        .tfy_maskAlpha(0.5)
        .tfy_strokeColor([UIColor redColor])
        .tfy_frameType(TFY_ClassicFrameType)
        .tfy_bgColor([UIColor blueColor])
        .tfy_isClockwiseRotation(YES)
        .tfy_animationCurve(TFY_AnimationCurveEaseOut);
    }];
    
    TFY_ConfigureModel *model5 = [self new];
    model5.title = @"自定义边框图片（拉伸模式）";
    model5.statusBarStyle = UIStatusBarStyleDefault;
    
    UIImage *stretchBorderImage = [UIImage imageNamed:@"real_line"];
    // 裁剪掉上下多余的空白部分
    CGFloat inset = 1.5 * stretchBorderImage.scale;
    CGImageRef sbImageRef = stretchBorderImage.CGImage;
    sbImageRef = CGImageCreateWithImageInRect(sbImageRef, CGRectMake(0, inset, CGImageGetWidth(sbImageRef), CGImageGetHeight(sbImageRef) - 2 * inset));
    stretchBorderImage = [UIImage imageWithCGImage:sbImageRef scale:stretchBorderImage.scale orientation:stretchBorderImage.imageOrientation];
    CGImageRelease(sbImageRef);
    // 设定拉伸区域
    stretchBorderImage = [stretchBorderImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    
    model5.configure = [TFY_ImageresizerConfigure lightBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure
        .tfy_strokeColor([UIColor colorWithRed:(205.0 / 255.0) green:(107.0 / 255.0) blue:(153.0 / 255.0) alpha:1.0])
        .tfy_borderImage(stretchBorderImage)
        .tfy_borderImageRectInset(CGPointMake(-2, -2));
    }];
    
    TFY_ConfigureModel *model6 = [self new];
    model6.title = @"自定义边框图片（平铺模式）";
    model6.statusBarStyle = UIStatusBarStyleLightContent;
    
    UIImage *tileBorderImage = [UIImage imageNamed:@"dotted_line"];
    // 设定平铺区域
    tileBorderImage = [tileBorderImage resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14) resizingMode:UIImageResizingModeTile];
    
    model6.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure
        .tfy_frameType(TFY_ClassicFrameType)
        .tfy_borderImage(tileBorderImage)
        .tfy_borderImageRectInset(CGPointMake(-1.75, -1.75));
    }];
    
    
    TFY_ConfigureModel *model7 = [self new];
    model7.title = @"自定义蒙版图片（固定比例）";
    model7.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure.tfy_maskImage([UIImage imageNamed:@"moban2.png"]);
    }];
    
    TFY_ConfigureModel *model8 = [self new];
    model8.title = @"自定义蒙版图片（任意比例）";
    model8.configure = [TFY_ImageresizerConfigure darkBlurMaskTypeConfigureWithResizeImage:nil make:^(TFY_ImageresizerConfigure *configure) {
        configure
        .tfy_frameType(TFY_ClassicFrameType)
        .tfy_maskImage([UIImage imageNamed:@"love.png"])
        .tfy_isArbitrarilyMask(YES);
    }];
    
    return @[model1, model2, model3, model4, model5, model6, model7, model8];
}
@end


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableVieew;
@property (nonatomic, copy) NSArray<TFY_ConfigureModel *> *models;
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell cellFromCodeWithTableView:tableView];
    TFY_ConfigureModel *model = self.models[indexPath.row];
    if (indexPath.section==0) {
        cell.textLabel.text = model.title;
    }
    else{
        cell.textLabel.text = @"相册相机访问";
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        TFY_ConfigureModel *model = self.models[indexPath.row];
        model.configure.resizeImage = self.randomResizeImage;
        
        TFY_ImageController *vc = [TFY_ImageController new];
        vc.configure = model.configure;
        CATransition *cubeAnim = [CATransition animation];
        cubeAnim.duration = 0.5;
        cubeAnim.type = @"cube";
        cubeAnim.subtype = kCATransitionFromRight;
        cubeAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.view.window.layer addAnimation:cubeAnim forKey:@"cube"];
        [self.navigationController pushViewController:vc animated:NO];
    }
    else{
        [TFY_ImagePickerController showImagePickerallowsEditing:YES finishAction:^(UIImage * _Nonnull image) {
            
            
            
        } fromVC:self];
    }
}

#pragma mark - 随机图片

- (UIImage *)randomResizeImage {
    NSString *imageName;
    NSInteger index = 1 + arc4random() % 9;
    if (index > 5) {
        switch (index) {
            case 6:
                imageName = @"Kobe.jpg";
                break;
            case 7:
                imageName = @"Woman.jpg";
                break;
            case 8:
                imageName = @"Beauty.jpg";
                break;
            default:
                imageName = @"Train.jpg";
                break;
        }
    } else {
        imageName = [NSString stringWithFormat:@"Girl%zd.jpg", index];
    }
    return [UIImage imageNamed:imageName];
}

@end
