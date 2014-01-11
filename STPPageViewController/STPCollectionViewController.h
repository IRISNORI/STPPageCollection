//
//  STPCollectionViewController.h
//  LPInterface
//
//  Created by Muramoto on 2013/11/29.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPListPickUpCell.h"

@interface STPCollectionViewController : UICollectionViewController

@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic) NSString *listCellIdentifier;
@property (nonatomic) NSString *pickUpCellIdentifier;
@property (nonatomic) NSString *listPickUpCellIdentifier;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point;
- (UICollectionViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath;
- (UICollectionViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath gesture:(UIGestureRecognizer *)gesture;
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout indexPath:(NSIndexPath *)indexPath;

@end
