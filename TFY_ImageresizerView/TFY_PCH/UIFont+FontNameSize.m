//
//  UIFont+FontNameSize.m
//  Electricblanket
//
//  Created by tiandengyou on 2019/12/13.
//  Copyright © 2019 田风有. All rights reserved.
//

#import "UIFont+FontNameSize.h"
#import <objc/runtime.h>

@implementation UIFont (FontNameSize)

+(void)load{
    [super load];
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(systemFontOfSize:);
        SEL originalSelector3 = @selector(italicSystemFontOfSize:);
        SEL swizzledSelector = @selector(tfy_systemFontOfSize:);
        SEL swizzledSelector3 = @selector(tfy_digitalsystemFontOfSize:);
        
        Method originalMethod = class_getClassMethod(class, originalSelector);
        Method originalMethod3 = class_getClassMethod(class, originalSelector3);
        Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
        Method swizzledMethod3 = class_getClassMethod(class, swizzledSelector3);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        method_exchangeImplementations(originalMethod3, swizzledMethod3);
    });
    
}
/**
 *在这些方法中将你的字体名字换进去    FZZJ-ZSCWBJW
 */
+(UIFont *)tfy_systemFontOfSize:(CGFloat)fontSize{
    UIFont * font = [UIFont fontWithName:@"shape" size:fontSize];
    if (!font) {
        return [self tfy_systemFontOfSize:fontSize];
    }
    return font;
}

+(UIFont *)tfy_digitalsystemFontOfSize:(CGFloat)fontSize{
    UIFont * font = [UIFont fontWithName:@"Digital-7Mono" size:fontSize];
    if (!font) {
        return [self tfy_digitalsystemFontOfSize:fontSize];
    }
    return font;
}

@end
