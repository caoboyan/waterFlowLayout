//
//  ViewController.m
//  flowLayout
//
//  Created by Boyan Cao on 16/4/6.
//  Copyright © 2016年 2015-293. All rights reserved.
//

#import "ViewController.h"
#import "MLSShopWaterflowLayout.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MLSWaterflowLayoutDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MLSShopWaterflowLayout *layout = [[MLSShopWaterflowLayout alloc] init];
    layout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:elementKindWaterflowHeaderView withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:elementKindWaterflowFooterView withReuseIdentifier:@"footer"];
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:elementKindWaterflowHeaderView]) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:elementKindWaterflowHeaderView withReuseIdentifier:@"header" forIndexPath:indexPath];
        view.backgroundColor = [UIColor blueColor];
        return view;
    } else if ([kind isEqualToString:elementKindWaterflowFooterView]) {
        UICollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:elementKindWaterflowFooterView withReuseIdentifier:@"footer" forIndexPath:indexPath];
        view.backgroundColor = [UIColor redColor];
        return view;
    }
    return reusableView;
}

-(CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    return 40;
}

-(CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForFooterInSection:(NSInteger)section{
    return 20;
}




@end
