//
//  STPDataCollectionViewController.h
//  Apinii
//
//  Created by Norikazu on 2013/12/09.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit.h>
#import <CoreData.h>
#import "PLNObjectManager.h"

@interface STPDataCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) RKManagedObjectStore *managedObjectStore;

@property (strong, nonatomic) id dataObject;


@end
