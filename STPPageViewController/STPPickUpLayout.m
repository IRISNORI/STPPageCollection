//
//  STPPickUpLayout.m
//  STPUserInterface
//
//  Created by Norikazu on 2013/11/18.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPPickUpLayout.h"

@interface STPPickUpLayout ()

@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) NSInteger offsetX;
@property (nonatomic) NSInteger offsetY;
@property (nonatomic) CGSize screen;

@end

@implementation STPPickUpLayout

- (id)init
{
    self = [super init];
    if (self) {
        _screen = [UIScreen mainScreen].bounds.size;
        _itemInsets = UIEdgeInsetsZero;
        _itemSize = _screen;
        _selectedItemSize = _screen;
        _interItemSpacingX = 0;
        _interItemSpacingY = 0;
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _horizon = NO;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _screen = [UIScreen mainScreen].bounds.size;
        _itemInsets = UIEdgeInsetsZero;
        _itemSize = _screen;
        _selectedItemSize = _screen;
        _interItemSpacingX = 0;
        _interItemSpacingY = 0;
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _horizon = NO;
    }
    return self;
}

-(void)prepareLayout
{
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameAtIndexPath:indexPath];
            itemAttributes.zIndex = indexPath.row;
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    newLayoutInfo[PickUpCell] = cellLayoutInfo;
    self.layoutInfo = newLayoutInfo;
}

- (CGRect)frameAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat originX;
    CGFloat originY;
    CGRect rect;
     
    NSComparisonResult result = [self.selectedIndexPath compare:indexPath];
    
    CGFloat pickUpHeight = _selectedItemSize.height;
    CGFloat pickUpWidth = _selectedItemSize.width;
    CGFloat horizonOffset = (self.itemInsets.left + self.selectedIndexPath.row * (self.itemSize.width + self.interItemSpacingX) + self.itemInsets.right);
    CGFloat verticalOffset = (self.itemInsets.top + self.selectedIndexPath.row * (self.itemSize.height + self.interItemSpacingY) + self.itemInsets.bottom);
    horizonOffset = 0;
    verticalOffset = 0;
    
    switch (result) {
        case NSOrderedSame:
            if (_horizon) {
                originX = floor(self.itemInsets.left + (self.itemSize.width + self.interItemSpacingX) * indexPath.row) - horizonOffset;
                originY = floor(self.itemInsets.top);
            } else {
                originX = floor(self.itemInsets.left);
                originY = floor(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * indexPath.row) - verticalOffset;
            }
            CGFloat width = [UIScreen mainScreen].bounds.size.width;
            CGFloat height = [UIScreen mainScreen].bounds.size.height;
            rect = CGRectMake(originX, originY, width, height);
            break;

        
        case NSOrderedAscending:
            if (_horizon) {
                originX = floor(self.itemInsets.left + (self.itemSize.width + self.interItemSpacingX) * (indexPath.row - 1) + pickUpWidth + self.interItemSpacingX) - horizonOffset;
                originY = floor(self.itemInsets.top);
            } else {
                originX = floor(self.itemInsets.left);
                originY = floor(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * (indexPath.row - 1) + pickUpHeight + self.interItemSpacingY) - verticalOffset;
            }
            rect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
            break;
            
        case NSOrderedDescending:
        default:
            if (_horizon) {
                originX = floor(self.itemInsets.left + (self.itemSize.width + self.interItemSpacingX) * indexPath.row) - horizonOffset;
                originY = floor(self.itemInsets.top);
            } else {
                originX = floor(self.itemInsets.left);
                originY = floor(self.itemInsets.top + (self.itemSize.height + self.interItemSpacingY) * indexPath.row) - verticalOffset;
            }
            rect = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
            break;
    }
    return rect;
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop) {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop) {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                
                [allAttributes addObject:attributes];
            }
            
        }];
    }];
    
    return allAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[PickUpCell][indexPath];
}

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfItemsInSection:0];
    
    CGSize size;
    if (_horizon) {
        
        CGFloat width = self.itemInsets.left +
        (rowCount - 1) * self.itemSize.width + _selectedItemSize.width + (rowCount - 1) * self.interItemSpacingX +
        self.itemInsets.right;
        size = CGSizeMake(width, self.collectionView.bounds.size.height);
        
        
    } else {
        
        CGFloat height = self.itemInsets.top +
        (rowCount - 1) * self.itemSize.height + _selectedItemSize.height + (rowCount - 1) * self.interItemSpacingY +
        self.itemInsets.bottom;
        size = CGSizeMake(self.collectionView.bounds.size.width, height);
        
    }
    return size;
}

#pragma mark - Properties

- (void)setHorizon:(BOOL)horizon
{
    if (_horizon == horizon) return;
    
    _horizon = horizon;
    
    [self invalidateLayout];
}

- (void)setSelectedItemSize:(CGSize)selectedItemSize
{
    if (CGSizeEqualToSize(_selectedItemSize, selectedItemSize)) return;
    
    _selectedItemSize = selectedItemSize;
    
    [self invalidateLayout];
}


- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets)) return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}

- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize)) return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}

- (void)setinterItemSpacingX:(CGFloat)interItemSpacingX
{
    if (_interItemSpacingX == interItemSpacingX) return;
    
    _interItemSpacingX = interItemSpacingX;
    
    [self invalidateLayout];
}

- (void)setinterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY) return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    if ([_selectedIndexPath compare:selectedIndexPath] == NSOrderedSame) {
        return;
    }
    _selectedIndexPath = selectedIndexPath;
    
    [self invalidateLayout];
}


@end
