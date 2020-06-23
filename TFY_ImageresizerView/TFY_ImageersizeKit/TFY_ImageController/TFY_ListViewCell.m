//
//  TFY_ListViewCell.m
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/23.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ListViewCell.h"

@interface TFY_ListViewCell ()
@property(nonatomic , strong) UILabel *title_label;
@end

@implementation TFY_ListViewCell

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
    
    self.title_label.tfy_text(_name_str);
}

-(UILabel *)title_label{
    if (!_title_label) {
        _title_label = [[UILabel alloc] initWithFrame:self.bounds];
        _title_label.textColor = [UIColor blackColor];
        _title_label.font = [UIFont boldSystemFontOfSize:50];
        _title_label.textAlignment = NSTextAlignmentCenter;
    }
    return _title_label;
}


@end
