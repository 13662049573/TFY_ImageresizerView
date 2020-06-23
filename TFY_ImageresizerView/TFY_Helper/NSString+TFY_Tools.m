//
//  NSString+TFY_Tools.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/20.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "NSString+TFY_Tools.h"

@implementation NSString (TFY_Tools)

- (BOOL)tfy_containsChinese {
    for (NSInteger i = 0; i < self.length; i++) {
        int a = [self characterAtIndex:i];
        if (a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
