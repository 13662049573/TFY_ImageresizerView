//
//  ShapeListViewController.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/21.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShapeListViewController : UICollectionViewController
+ (instancetype)shapeListViewController:(void(^)(UIImage *shapeImage))getShapeImageBlock;
@end

NS_ASSUME_NONNULL_END
