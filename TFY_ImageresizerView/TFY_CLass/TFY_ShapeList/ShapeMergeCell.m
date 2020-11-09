//
//  ShapeMergeCell.m
//  TFY_ImageresizerView
//
//  Created by 田风有 on 2020/6/21.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "ShapeMergeCell.h"

@interface ShapeMergeCell ()
TFY_PROPERTY_STRONG UILabel *title_label;
@end

@implementation ShapeMergeCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.title_label];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.title_label.frame = self.bounds;
}

-(void)setName_str:(NSString *)name_str{
    _name_str = name_str;
    
    self.title_label.makeChain.text(_name_str);
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = UILabelSet();
        _title_label.makeChain
        .textColor([UIColor blackColor])
        .font([UIFont systemFontOfSize:50])
        .textAlignment(NSTextAlignmentCenter);
    }
    return _title_label;
}

@end
