//
//  STPPickUpLayout.h
//  STPUserInterface
//
//  Created by Norikazu on 2013/11/18.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const PickUpCell = @"PickUpCell";

@interface STPPickUpLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGSize selectedItemSize;
@property (nonatomic) CGFloat interItemSpacingX;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) BOOL horizon;

@end
