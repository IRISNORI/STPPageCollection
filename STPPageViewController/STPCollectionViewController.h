//
//  STPCollectionViewController.h
//  LPInterface
//
//  Created by Muramoto on 2013/11/29.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "STPDataController.h"
#import "STPListPickUpCell.h"

UIKIT_EXTERN NSString * const STPListCellIdetifier;
UIKIT_EXTERN NSString * const STPPickUpCellIdentifier;
UIKIT_EXTERN NSString * const STPListPickUpCellIdentifier;

@interface STPCollectionViewController : UICollectionViewController

@property (nonatomic) NSIndexPath *selectedIndexPath;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) STPDataController *dataController;

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point;
- (UICollectionViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath;
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout dataController:(STPDataController *)dataController;
- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout indexPath:(NSIndexPath *)indexPath;

@end
