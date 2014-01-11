//
//  STPDataController.h
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NMPageViewController.h"



@class STPDataViewController;

typedef NS_ENUM(NSInteger, STPDataSourceType) {
    STPDataSourceModeCoreData,
    STPDataSourceModeArray
};


/*
@protocol STPDataViewControllerDelegate <NSObject>
@required
- (STPDataCollectionViewController *)startViewCollectionController;
@end
*/

@interface STPDataController : NSObject <NMPageViewControllerDataSource>

@property (nonatomic, readonly) STPDataSourceType dataSourceType;

- (id)initWithDataSource:(id)dataSource;

- (STPDataViewController *)viewControllerAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfViewController:(STPDataViewController *)viewController;
- (NSUInteger)count;

@end

