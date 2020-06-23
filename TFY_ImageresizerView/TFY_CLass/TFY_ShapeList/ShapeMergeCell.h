//
//  ShapeMergeCell.h
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/21.
//  Copyright © 2020 田风有. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShapeMergeCell : UICollectionViewCell
TFY_CATEGORY_CHAIN_PROPERTY NSString *name_str;
TFY_CATEGORY_CHAIN_BLOCK_PROPERTY void (^tapShapeBlock)(NSString *shape);
@end

NS_ASSUME_NONNULL_END
