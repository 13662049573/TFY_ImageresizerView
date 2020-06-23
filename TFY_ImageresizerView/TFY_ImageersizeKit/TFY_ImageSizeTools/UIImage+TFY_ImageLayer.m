//
//  UIImage+TFY_ImageLayer.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "UIImage+TFY_ImageLayer.h"

@implementation UIImage (TFY_ImageLayer)

- (UIImage *)tfy_destinationOutImage {
    if (!self) return nil;
    CGRect rect = (CGRect){CGPointZero, self.size};
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    [UIColor.blackColor setFill];
    UIRectFill(rect);
    [self drawInRect:rect blendMode:kCGBlendModeDestinationOut alpha:1.0];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)tfy_resultImageWithImage:(UIImage *)originImage
                             cropFrame:(CGRect)cropFrame
                          relativeSize:(CGSize)relativeSize
                           isVerMirror:(BOOL)isVerMirror
                           isHorMirror:(BOOL)isHorMirror
                     rotateOrientation:(UIImageOrientation)orientation
                           isRoundClip:(BOOL)isRoundClip
                         compressScale:(CGFloat)compressScale
                             maskImage:(UIImage *)maskImage {
    @autoreleasepool {
        // 修正图片方向
        UIImage *resultImage = [originImage tfy_fixOrientation];

        // 镜像处理
        if (isVerMirror) resultImage = [resultImage tfy_rotate:UIImageOrientationUpMirrored isRoundClip:NO];
        if (isHorMirror) resultImage = [resultImage tfy_rotate:UIImageOrientationDownMirrored isRoundClip:NO];

        UIImage *finalImage = resultImage;
        
        if (!CGSizeEqualToSize(cropFrame.size, relativeSize)) {
            // 获取裁剪区域
            CGFloat imageScale = resultImage.scale;
            CGFloat imageWidth = resultImage.size.width;
            CGFloat imageHeight = resultImage.size.height;
            CGFloat relativeScale = imageWidth / relativeSize.width;
            if (cropFrame.origin.x < 0) cropFrame.origin.x = 0;
            if (cropFrame.origin.y < 0) cropFrame.origin.y = 0;
            cropFrame.origin.x *= relativeScale;
            cropFrame.origin.y *= relativeScale;
            cropFrame.size.width *= relativeScale;
            cropFrame.size.height *= relativeScale;
            if (cropFrame.size.width > imageWidth) cropFrame.size.width = imageWidth;
            if (cropFrame.size.height > imageHeight) cropFrame.size.height = imageHeight;
            if (CGRectGetMaxX(cropFrame) > imageWidth) cropFrame.origin.x = imageWidth - cropFrame.size.width;
            if (CGRectGetMaxY(cropFrame) > imageHeight) cropFrame.origin.y = imageHeight - cropFrame.size.height;
            if (isVerMirror) cropFrame.origin.x = imageWidth - CGRectGetMaxX(cropFrame);
            if (isHorMirror) cropFrame.origin.y = imageHeight - CGRectGetMaxY(cropFrame);
            
            // 裁剪
            UIGraphicsBeginImageContextWithOptions(cropFrame.size, NO, imageScale);
            [resultImage drawInRect:CGRectMake(-cropFrame.origin.x, -cropFrame.origin.y, imageWidth, imageHeight)];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        // 旋转并切圆
        finalImage = [finalImage tfy_rotate:orientation isRoundClip:isRoundClip];
        
        // 压缩并蒙版
        finalImage = [finalImage tfy_resizeImageWithScale:compressScale maskImage:maskImage];
        
        return finalImage;
    }
}

#pragma mark - 修正方向

- (UIImage *)tfy_fixOrientation {
    
    UIImageOrientation orientation = self.imageOrientation;
    if (orientation == UIImageOrientationUp) return self;
    
    // 我们需要计算适当的变换，使图像直立。
    // 我们分两步完成:如果向左/向右/向下旋转，如果镜像，则翻转。
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (orientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (orientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // 现在，我们将底层CGImage绘制到一个新的上下文中，并应用转换
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

#pragma mark - 旋转并切圆

CG_INLINE CGRect
TFY_RectSwapWH(CGRect rect) {
    CGFloat width = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = width;
    return rect;
}

- (UIImage *)tfy_rotate:(UIImageOrientation)orientation isRoundClip:(BOOL)isRoundClip {
    
    CGImageRef imageRef = self.CGImage;
    CGRect bounds = CGRectMake(0, 0, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect rect = bounds;
    CGAffineTransform transform = CGAffineTransformIdentity;

    switch (orientation)
    {
        case UIImageOrientationUp:
            if (!isRoundClip) return self;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(rect.size.width, rect.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeft:
            bounds = TFY_RectSwapWH(bounds);
            transform = CGAffineTransformMakeTranslation(0.0, rect.size.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            bounds = TFY_RectSwapWH(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, rect.size.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            bounds = TFY_RectSwapWH(bounds);
            transform = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            bounds = TFY_RectSwapWH(bounds);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            if (!isRoundClip) return self;
            break;
    }
    
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    switch (orientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextScaleCTM(ctx, -1.0, 1.0);
            CGContextTranslateCTM(ctx, -rect.size.height, 0.0);
            break;
        default:
            CGContextScaleCTM(ctx, 1.0, -1.0);
            CGContextTranslateCTM(ctx, 0.0, -rect.size.height);
            break;
    }
    
    CGContextConcatCTM(ctx, transform);
    
    if (isRoundClip) {
        CGRect clipRect = rect;
        CGFloat radius;
        if (clipRect.size.width >= clipRect.size.height) {
            clipRect.origin.x = (clipRect.size.width - clipRect.size.height) * 0.5;
            clipRect.size.width = clipRect.size.height;
            radius = clipRect.size.height;
        } else {
            clipRect.origin.y = (clipRect.size.height - clipRect.size.width) * 0.5;
            clipRect.size.height = clipRect.size.width;
            radius = clipRect.size.width;
        }
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:clipRect cornerRadius:radius];
        CGContextAddPath(ctx, path.CGPath);
        CGContextClip(ctx);
    }
    
    CGContextDrawImage(ctx, rect, imageRef);
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - 压缩并蒙版

- (UIImage *)tfy_resizeImageWithScale:(CGFloat)scale maskImage:(UIImage *)maskImage {
    if (scale <= 0 || scale > 1) scale = 1;
    if (scale == 1 && maskImage == nil) return self;
    
    CGImageRef imageRef = self.CGImage;
    
    CGFloat pixelWidth = CGImageGetWidth(imageRef) * scale;
    CGFloat pixelHeight = CGImageGetHeight(imageRef) * scale;
    CGRect rect = CGRectMake(0, 0, pixelWidth, pixelHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    if (maskImage) {
        bitmapInfo |= kCGImageAlphaPremultipliedLast;
    } else {
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;
        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    }
    CGContextRef context = CGBitmapContextCreate(NULL, pixelWidth, pixelHeight, 8, 0, colorSpace, bitmapInfo);
    
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    if (maskImage != nil) {
        CGImageRef maskImageRef = maskImage.CGImage;
        CGContextClipToMask(context, rect, maskImageRef);
    }
    CGContextDrawImage(context, rect, imageRef);
    
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CGImageRelease(newImageRef);
    
    return newImage;
}

@end

@implementation CABasicAnimation (TFY_ImageLayer)

+ (CABasicAnimation *)tfy_backwardsAnimationWithKeyPath:(NSString *)keyPath
                                                fromValue:(id)fromValue
                                                 toValue:(id)toValue
                                      timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                                duration:(NSTimeInterval)duration {
    if (duration <= 0) return nil;
    CABasicAnimation *anim = [self animationWithKeyPath:keyPath];
    anim.fillMode = kCAFillModeBackwards;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:timingFunctionName];
    anim.duration = duration;
    anim.fromValue = fromValue;
    anim.toValue = toValue;
    return anim;
}

@end

@implementation CALayer (TFY_ImageLayer)

- (void)tfy_addBackwardsAnimationWithKeyPath:(NSString *)keyPath
                                    fromValue:(id)fromValue
                                      toValue:(id)toValue
                           timingFunctionName:(CAMediaTimingFunctionName)timingFunctionName
                                     duration:(NSTimeInterval)duration {
    CABasicAnimation *anim = [CABasicAnimation tfy_backwardsAnimationWithKeyPath:keyPath fromValue:fromValue toValue:toValue timingFunctionName:timingFunctionName duration:duration];
    if (anim) [self addAnimation:anim forKey:keyPath];
}

@end
