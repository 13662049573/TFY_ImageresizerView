//
//  TFY_ExportCancelView.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/8/14.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ExportCancelView.h"
#import "TFY_ImageersizeHeader.h"

@interface TFY_ExportCancelView ()
@property (nonatomic, weak) UIButton *cancelBtn;
@property (nonatomic, copy) void (^cancelHandler)(void);
@end

@implementation TFY_ExportCancelView

+ (void)showWithCancelHandler:(void (^)(void))cancelHandler {
    TFY_ExportCancelView *ecView = (TFY_ExportCancelView *)[Clip_KeyWindow viewWithTag:184669029];
    if (!ecView) {
        ecView = [[self alloc] init];
        ecView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        UIButton *cancelBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
            btn.layer.cornerRadius = 2;
            btn.backgroundColor = UIColor.whiteColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitle:@"取消导出" forState:UIControlStateNormal];
            [btn addTarget:ecView action:@selector(__cancelAction) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        [ecView addSubview:cancelBtn];
        ecView.cancelBtn = cancelBtn;
        
        [ecView __didChangeStatusBarOrientation];
        Clip_ObserveNotification(ecView, @selector(__didChangeStatusBarOrientation), UIApplicationDidChangeStatusBarOrientationNotification, nil);
        
        ecView.tag = 184669029;
        ecView.alpha = 0;
        [Clip_KeyWindow addSubview:ecView];
    }
    
    ecView.cancelHandler = cancelHandler;
    
    [UIView animateWithDuration:0.25 animations:^{
        ecView.alpha = 1;
    }];
}

+ (void)hide {
    TFY_ExportCancelView *ecView = (TFY_ExportCancelView *)[Clip_KeyWindow viewWithTag:184669029];
    if (ecView) [ecView __hideView];
}

- (void)dealloc {
    Clip_RemoveNotification(self);
}

- (void)__didChangeStatusBarOrientation {
    self.frame = Clip_ScreenBounds;
    CGFloat w = 70;
    CGFloat h = 30;
    CGFloat x = TFY_HalfOfDiff(Clip_Width_W, w);
    CGFloat y = Clip_Height_H * 0.6;
    self.cancelBtn.frame = CGRectMake(x, y, w, h);
}

- (void)__cancelAction {
    !self.cancelHandler ? : self.cancelHandler();
    [self __hideView];
}

- (void)__hideView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
