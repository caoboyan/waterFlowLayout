//
//  MLSShopWaterflowLayout.h
//  Meilishuo
//
//  Maintained by boyancao
//  Created by boyancao on 15/8/24.
//  Copyright (c) 2015年 Meilishuo, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const elementKindWaterflowHeaderView;
extern NSString * const elementKindWaterflowFooterView;

@class MLSShopWaterflowLayout;

@protocol MLSWaterflowLayoutDelegate <NSObject>

@required

/**
 *  @author sichenwang, 15-09-21 17:09:51
 *
 *  Asks the delegate for the height of the item that corresponds to the specified item in the collection view.
 *
 *  @param waterflowLayout The waterflow layout object to use for organizing items.
 *  @param indexPath       The index path that specifies the location of the item.
 *  @param itemWidth       The width of the item.
 *
 *  @return The height of the item in collectionView.
 *
 *  @since 7.1.0
 */
- (CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;

@optional

/**
 *  @author sichenwang, 15-09-21 18:09:31
 *
 *  询问代理以几列来布局, 默认值为2
 *
 *  @param waterflowLayout 流水布局对象
 *
 *  @return 列数
 *
 *  @since 7.1.0
 */
- (NSInteger)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout columnsInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:47
 *
 *  询问代理每行之间的距离, 默认是5
 *
 *  @param waterflowLayout 流水布局对象
 *
 *  @return 行距
 *
 *  @since 7.1.0
 */
- (CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout rowMarginInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:56
 *
 *  询问代理每列之间的距离，默认值为5
 *
 *  @param waterflowLayout 流水布局对象
 *
 *  @return 列距
 *
 *  @since 7.1.0
 */
- (CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout columnMarginInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:09
 *
 *  询问代理headerView的高度，默认值为0（如果对应的section返回了大于0的值，则必须注册并返回headerView）
 *
 *  @param waterflowLayout 流水布局对象
 *  @param section         headerView对应的section
 *
 *  @return headerView的高度
 *
 *  @since 7.1.0
 */
- (CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForHeaderInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:09
 *
 *  询问代理footerView的高度，默认值为0（如果对应的section返回了大于0的值，则必须注册并返回footerView）
 *
 *  @param waterflowLayout 流水布局对象
 *  @param section         headerView对应的section
 *
 *  @return footerView的高度
 *
 *  @since 7.1.0
 */
- (CGFloat)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout heightForFooterInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:25
 *
 *  询问代理headerView距离上下左右的边距，默认值为UIEdgeInsetsMake(0, 0, 0, 0)
 *
 *  @param waterflowLayout 流水布局对象
 *  @param section         headerView对应的section
 *
 *  @return headerView距离上下左右的边距
 *
 *  @since 7.1.0
 */
- (UIEdgeInsets)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout insetsForHeaderInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:25
 *
 *  询问代理footerView距离上下左右的边距，默认值为UIEdgeInsetsMake(0, 0, 0, 0)
 *
 *  @param waterflowLayout 流水布局对象
 *  @param section         footerView对应的section
 *
 *  @return footerView距离上下左右的边距
 *
 *  @since 7.1.0
 */
- (UIEdgeInsets)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout insetsForFooterInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-21 18:09:41
 *
 *  询问代理每个section对应的View距离四边的边距，默认值为UIEdgeInsetsMake(0, 5, 0, 5)
 *
 *  @param waterflowLayout 流水布局对象
 *
 *  @return 每个section对应的View距离四边的边距
 *
 *  @since 7.1.0
 */
- (UIEdgeInsets)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout insetsInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-23 19:09:40
 *
 *  询问代理backgroundView距离每个section上下左右的边距，默认值等于每个section对应的View距离四边的边距
 *
 *  @param waterflowLayout 流水布局对象
 *  @param section         backgroundView
 *
 *  @return backgroundView距离上下左右的边距
 *
 *  @since 7.1.0
 */
- (UIEdgeInsets)waterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout insetsForBackgroundViewInSection:(NSInteger)section;

/**
 *  @author sichenwang, 15-09-22 10:09:31
 *
 *  背景色，默认不生成背景View
 *
 *  @param waterflowLayout 流水布局对象
 *
 *  @return 背景色
 *
 *  @since 7.1.0
 */
- (UIColor *)backgroundColorForWaterflowLayout:(MLSShopWaterflowLayout *)waterflowLayout;

@end

@interface MLSShopWaterflowLayout : UICollectionViewLayout

@property (nonatomic, weak) id<MLSWaterflowLayoutDelegate> delegate;

@end
