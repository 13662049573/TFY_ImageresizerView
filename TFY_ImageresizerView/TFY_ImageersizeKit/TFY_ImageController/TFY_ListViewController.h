//
//  TFY_ListViewController.h
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/23.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFY_ListViewController : UICollectionViewController
+ (instancetype)shapeListViewController:(void(^)(UIImage *shapeImage))getShapeImageBlock;
@end

NS_ASSUME_NONNULL_END
