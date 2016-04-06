//
//  MLSShopWaterflowLayout.m
//  Meilishuo
//
//  Created by boyancao on 15/8/24.
//  Copyright (c) 2015年 Meilishuo, Inc. All rights reserved.
//

#import "MLSShopWaterflowLayout.h"

/** 每一行的最大列数 */
static const int kMLSDefaultMaxColumns = 2;
/** 每一行的间距 */
static const CGFloat kMLSDefaultRowMargin = 5;
/** 每一列的间距 */
static const CGFloat kMLSDefaultColumnMargin = 5;
/** section上下左右的间距 */
static const UIEdgeInsets kMLSDefaultInsets = {0, 5, 0, 5};
/** headerView的高度 */
static const CGFloat kMLSHeaderViewHeight = 0;
/** headerView的间距 */
static const UIEdgeInsets kMLSDefaultHeaderViewInsets = {0, 0, 0, 0};
/** footerView的高度 */
static const CGFloat kMLSFooterViewHeight = 0;
/** footerView的间距 */
static const UIEdgeInsets kMLSDefaultFooterViewInsets = {0, 0, 0, 0};
/** 背景色 */
UIColor *BackgroundColor;

NSString * const elementKindWaterflowHeaderView = @"HeaderView";
NSString * const elementKindWaterflowFooterView = @"FooterView";
NSString * const elementKindWaterflowBackgroundView = @"BackgroundView";

/**
 因为在layout中拿不到DecorationView的实例，所以通过全局变量<BackgroundColor>来提供Layout中DecorationView的背景色
 
 - returns: Layout中DecorationView
 */
@interface MLSShopWatetflowBackgroundView : UICollectionReusableView

@end

@implementation MLSShopWatetflowBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = BackgroundColor;
    }
    return self;
}

@end

@interface MLSShopWaterflowLayout()

/** 存放布局属性 */
@property (nonatomic, strong) NSMutableArray *attrs;
/** 存放每一列的最大Y值 */
@property (nonatomic, strong) NSMutableArray *maxYs;

@end

@implementation MLSShopWaterflowLayout

#pragma mark - <Override Methods>

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSInteger numOfSections = [self.collectionView numberOfSections];
    if (numOfSections == 0) return;

    BackgroundColor = nil;
    if ([self.delegate respondsToSelector:@selector(backgroundColorForWaterflowLayout:)]) {
        BackgroundColor = [self.delegate backgroundColorForWaterflowLayout:self];
        if (BackgroundColor) {
            [self registerClass:[MLSShopWatetflowBackgroundView class] forDecorationViewOfKind:elementKindWaterflowBackgroundView];
        }
    }

    // 初始化最大y值数组
    self.maxYs = [NSMutableArray array];

    // 初始化布局属性数组
    self.attrs = [NSMutableArray array];
    for (NSUInteger j = 0; j < numOfSections; j++) {
        
        NSUInteger count = [self.collectionView numberOfItemsInSection:j];
        
        CGFloat startY = [self maxYFromMaxYs];
        
        for (NSUInteger i = 0; i < count; i++) {
        
            if (i == 0) {
                [self setMaxYForMaxYs:[self maxYFromMaxYs] + [self insetsInSection:j].top
                           resetCount:[self columnsInSection:j]];
                
                // 计算headerView的frame
                if ([self headerViewHeight:j] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:j];
                    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:elementKindWaterflowHeaderView atIndexPath:indexPath];
                    [self.attrs addObject:attributes];
                }
            }
            
            // 计算itemView的frame
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrs addObject:attributes];
            
            if (i == count - 1) {
                // 计算footerView的frame
                if ([self footerViewHeight:j] > 0) {
                   
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:j];
                    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:elementKindWaterflowFooterView atIndexPath:indexPath];
                    [self.attrs addObject:attributes];
                }
                
                [self setMaxYForMaxYs:[self maxYFromMaxYs] + [self insetsInSection:j].bottom];
            }
        }
        
        CGFloat endY = [self maxYFromMaxYs];

        if (BackgroundColor) {
            [self layoutBackgroundViewWithStartY:startY endY:endY section:j kind:elementKindWaterflowBackgroundView];
        }
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [self maxYFromMaxYs]);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrs;
}

#pragma mark - <Private Method>

/**
 *  item的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat columnMargin = [self columnMarginInSection:indexPath.section];
    CGFloat rowMargin = [self rowMarginInSection:indexPath.section];
    CGFloat collectionW = self.collectionView.bounds.size.width;
    NSInteger maxColumns = [self columnsInSection:indexPath.section];
    UIEdgeInsets insets = [self insetsInSection:indexPath.section];
    
    CGFloat minMaxY = [self.maxYs[0] doubleValue]; // 最短那一列 的 最大Y值
    int minColumn = 0; // 最短那一列 的 列号
    for (int i = 1; i < maxColumns; i++) {
        CGFloat maxY = [self.maxYs[i] doubleValue];
        if (maxY < minMaxY) {
            minMaxY = maxY;
            minColumn = i;
        }
    }
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat itemW = (collectionW - insets.left - insets.right - (maxColumns - 1) * columnMargin) / maxColumns;
    CGFloat itemH = [self.delegate waterflowLayout:self heightForItemAtIndexPath:indexPath itemWidth:itemW];
    CGFloat itemY = indexPath.row < [self columnsInSection:indexPath.section] ? minMaxY : minMaxY + rowMargin;
    CGFloat itemX = insets.left + minColumn * (itemW + columnMargin); // 第一行不需要行距
    attributes.frame = CGRectMake(itemX, itemY, itemW, itemH);
    
    // 累加这一列的最大Y值
    self.maxYs[minColumn] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}

/**
 *  headerView和footerView的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if ([elementKind isEqualToString:elementKindWaterflowHeaderView]) {
        
        CGFloat x = [self insetsForHeaderInSection:indexPath.section].left;
        CGFloat y = [self maxYFromMaxYs] + [self insetsForHeaderInSection:indexPath.section].top;
        CGFloat w = [UIScreen mainScreen].bounds.size.width - [self insetsForHeaderInSection:indexPath.section].left - [self insetsForHeaderInSection:indexPath.section].right;
        CGFloat h = [self headerViewHeight:indexPath.section];
        attributes.frame = CGRectMake(x, y, w, h);
        [self setMaxYForMaxYs:y + [self headerViewHeight:indexPath.section] + [self insetsForHeaderInSection:indexPath.section].bottom];
        
    } else if ([elementKind isEqualToString:elementKindWaterflowFooterView]) {
        
        CGFloat x = [self insetsForFooterInSection:indexPath.section].left;
        CGFloat y = [self maxYFromMaxYs] + [self insetsForFooterInSection:indexPath.section].top;
        CGFloat w = [UIScreen mainScreen].bounds.size.width - [self insetsForFooterInSection:indexPath.section].left - [self insetsForFooterInSection:indexPath.section].right;
        CGFloat h = [self footerViewHeight:indexPath.section];
        attributes.frame = CGRectMake(x, y, w, h);
        [self setMaxYForMaxYs:y + [self footerViewHeight:indexPath.section] + [self insetsForFooterInSection:indexPath.section].bottom];
    }
    return attributes;
}

/**
 *  backgroundView的布局属性
 */
- (void)layoutBackgroundViewWithStartY:(CGFloat)startY
                                  endY:(CGFloat)endY
                               section:(NSInteger)section
                                  kind:(NSString *)kind {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    UIEdgeInsets insets = [self insetsForBackgroundViewInSection:section];
    CGFloat x = insets.left;
    CGFloat y = startY + insets.top;
    CGFloat w = [UIScreen mainScreen].bounds.size.width - insets.left - insets.right;
    CGFloat h = endY - startY - insets.top - insets.bottom;
    attributes.frame = CGRectMake(x, y, w, h);
    attributes.zIndex = -1;
    [self.attrs addObject:attributes];
}

/**
 *  从maxYs数组中获取Y值最大的那一列的值
 */
- (CGFloat)maxYFromMaxYs {
    if (!self.maxYs.count) return 0.0;
    
    CGFloat longMaxY = [self.maxYs[0] doubleValue];
    for (int i = 1; i < self.maxYs.count; i++) {
        CGFloat maxY = [self.maxYs[i] doubleValue];
        if (maxY > longMaxY) {
            longMaxY = maxY;
        }
    }
    return longMaxY;
}

/**
 *  给maxYs数组中每个对象统一设置y值
 */
- (void)setMaxYForMaxYs:(CGFloat)maxY {
    if (self.maxYs.count) {
        for (NSInteger i = 0; i < self.maxYs.count; i++) {
            self.maxYs[i] = @(maxY);
        }
    }
}

/**
 *  给maxYs数组中每个对象统一设置y值，并重置数组中对象的个数
 */
- (void)setMaxYForMaxYs:(CGFloat)maxY resetCount:(NSInteger)resetCount {
    if (resetCount) {
        [self.maxYs removeAllObjects];
        for (NSInteger i = 0; i < resetCount; i++) {
            [self.maxYs addObject:@(maxY)];
        }
    } else {
        [self setMaxYForMaxYs:maxY];
    }
}

#pragma mark - <Getter>

- (NSInteger)columnsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:columnsInSection:)]) {
        return [self.delegate waterflowLayout:self columnsInSection:section];
    }
    return kMLSDefaultMaxColumns;
}

- (CGFloat)rowMarginInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:rowMarginInSection:)]) {
        return [self.delegate waterflowLayout:self rowMarginInSection:section];
    }
    return kMLSDefaultRowMargin;
}

- (CGFloat)columnMarginInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:columnMarginInSection:)]) {
        return [self.delegate waterflowLayout:self columnMarginInSection:section];
    }
    return kMLSDefaultColumnMargin;
}

- (CGFloat)headerViewHeight:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:heightForHeaderInSection:)]) {
        return [self.delegate waterflowLayout:self heightForHeaderInSection:section];
    }
    return kMLSHeaderViewHeight;
}

- (CGFloat)footerViewHeight:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:heightForFooterInSection:)]) {
        return [self.delegate waterflowLayout:self heightForFooterInSection:section];
    }
    return kMLSFooterViewHeight;
}

- (UIEdgeInsets)insetsForHeaderInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:insetsForHeaderInSection:)]) {
        return [self.delegate waterflowLayout:self insetsForHeaderInSection:section];
    }
    return kMLSDefaultHeaderViewInsets;
}

- (UIEdgeInsets)insetsForFooterInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:insetsForFooterInSection:)]) {
        return [self.delegate waterflowLayout:self insetsForFooterInSection:section];
    }
    return kMLSDefaultFooterViewInsets;
}

- (UIEdgeInsets)insetsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:insetsInSection:)]) {
        return [self.delegate waterflowLayout:self insetsInSection:section];
    }
    return kMLSDefaultInsets;
}

- (UIEdgeInsets)insetsForBackgroundViewInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(waterflowLayout:insetsForBackgroundViewInSection:)]) {
        return [self.delegate waterflowLayout:self insetsForBackgroundViewInSection:section];
    }
    return [self insetsInSection:section];
}

@end
