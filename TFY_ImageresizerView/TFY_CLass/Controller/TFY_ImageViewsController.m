//
//  TFY_ImageViewsController.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/21.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ImageViewsController.h"

@interface TFY_ImageViewsController ()
TFY_CATEGORY_STRONG_PROPERTY UIImageView *imageView;
@end

@implementation TFY_ImageViewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
    
    self.navigationItem.rightBarButtonItem = tfy_barbtnItem().tfy_titleItem(@"保持",20,[UIColor redColor],self,@selector(timeimageClick));
    
    [self.view addSubview:self.imageView];
    self.imageView.tfy_Center(0, 0).tfy_size(self.image.size.width/2.5, self.image.size.height/2.5);
}

-(void)timeimageClick{
    [self saveImageToPhotos:self.image];
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = tfy_imageView();
    }
    return _imageView;
}

//保存图片到相册
- (void)saveImageToPhotos:(UIImage*)savedImage{
    TFY_queueMainStart
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    TFY_queueEnd
}
//回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败";
    }
    else{
        msg = @"保存图片成功";
    }
    [TFY_ProgressHUD showPromptWithStatus:msg];
}


@end
