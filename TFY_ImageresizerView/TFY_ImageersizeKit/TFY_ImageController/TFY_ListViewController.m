//
//  TFY_ListViewController.m
//  TFY_ImageresizerView
//
//  Created by tiandengyou on 2020/6/23.
//  Copyright © 2020 田风有. All rights reserved.
//

#import "TFY_ListViewController.h"
#import "TFY_ListViewFlowLayout.h"
#import "TFY_ListViewCell.h"
#import "TFY_ImageresizerType.h"

@interface TFY_ListViewController ()
@property (nonatomic, copy) void (^getShapeImageBlock)(UIImage *shapeImage);
@property (nonatomic, copy) NSArray<NSString *> *dataSource;
@end

@implementation TFY_ListViewController{
    BOOL _isDidAppear;
    UIFont *_baseFont;
    UIFont *_smallFont;
}
static NSString *const ShapeMergeCellID = @"TFY_ListViewCell";
static NSArray<NSString *> *shapes_;


+ (instancetype)shapeListViewController:(void (^)(UIImage *))getShapeImageBlock {
   
    TFY_ListViewFlowLayout *layout = [[TFY_ListViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(Clip_Width_W/4-2, Clip_Width_W/3);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    TFY_ListViewController *vc = [[self alloc] initWithCollectionViewLayout:layout];
    vc.getShapeImageBlock = getShapeImageBlock;
    return vc;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    return self;
}

#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"蒙版列表";
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(__back)];
    
    _baseFont = [UIFont systemFontOfSize:55];
    _smallFont = [UIFont systemFontOfSize:30];
    
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:TFY_ListViewCell.class forCellWithReuseIdentifier:ShapeMergeCellID];
    self.collectionView.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isDidAppear) return;
    _isDidAppear = YES;
    if (!shapes_) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            shapes_ = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageList" ofType:@"plist"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self __reloadData:shapes_];
            });
        });
    } else {
       [self __reloadData:shapes_];
    }
}

#pragma mark - 私有方法

- (void)__reloadData:(NSArray<NSString *> *)shapes {
    TFY_ListViewFlowLayout *layout = (TFY_ListViewFlowLayout *)self.collectionView.collectionViewLayout;
    layout.springinessEnabled = YES;
    
    self.dataSource = shapes;
    [self.collectionView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.alpha = 1;
    }];
}

- (void)__back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFY_ListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ShapeMergeCellID forIndexPath:indexPath];
    NSString *shape = self.dataSource[indexPath.row];
    cell.name_str = shape;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *shape = self.dataSource[indexPath.row];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            CGFloat fontSize = Clip_Width_W;
            NSDictionary *attDic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
            CGRect rect = [shape boundingRectWithSize:CGSizeMake(9999, 9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attDic context:nil];
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
            [shape drawInRect:rect withAttributes:attDic];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!self || !self.getShapeImageBlock) return;
                [self dismissViewControllerAnimated:YES completion:^{
                    self.getShapeImageBlock(newImage);
                }];
            });
        });
}

@end
