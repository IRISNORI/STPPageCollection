//
//  STPDataController.m
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPDataController.h"
#import "STPDataViewController.h"


@interface STPDataController()
@property (nonatomic, strong) NSFetchedResultsController *resultsController;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation STPDataController


- (id)initWithDataSource:(id)dataSource
{
    self = [super init];
    if (self) {
        if ([dataSource isKindOfClass:[NSArray class]]) {
            _dataSourceType = STPDataSourceModeArray;
            _dataArray = dataSource;
            _resultsController = nil;
        }
        if ([dataSource isKindOfClass:[NSFetchedResultsController class]]) {
            _dataSourceType = STPDataSourceModeCoreData;
            _resultsController = dataSource;
            _dataArray = nil;
        }
    }
    return self;
}

- (STPDataViewController *)viewControllerAtIndex:(NSUInteger)index
{
    
    STPDataViewController *dataViewController;
    
    switch (self.dataSourceType) {
        case STPDataSourceModeCoreData:
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.resultsController sections][0];
            if (([sectionInfo numberOfObjects] == 0) || (index >= [sectionInfo numberOfObjects])) {
                return nil;
            }
            dataViewController = [[STPDataViewController alloc] init];
            dataViewController.dataObject = [self.resultsController objectAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
            break;
        }
        case STPDataSourceModeArray:
        default:
            if (([self.dataArray count] == 0) || (index >= [self.dataArray count])) {
                return nil;
            }
            dataViewController = [[STPDataViewController alloc] init];
            dataViewController.dataObject = self.dataArray[index];
            break;
    }
    
    return dataViewController;
}

- (NSUInteger)count
{
    NSUInteger cnt;
    switch (self.dataSourceType) {
        case STPDataSourceModeCoreData:
        {
            id <NSFetchedResultsSectionInfo> sectionInfo = [self.resultsController sections][0];
            cnt = [sectionInfo numberOfObjects];
            break;
        }
        case STPDataSourceModeArray:
        default:
            cnt = [self.dataArray count];
            break;
    }
    return cnt;
}

- (id)objectDataAtIndex:(NSUInteger)index
{
    id object;
    switch (self.dataSourceType) {
        case STPDataSourceModeCoreData:
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
            object = [self.resultsController objectAtIndexPath:indexPath];
            break;
        }
        case STPDataSourceModeArray:
        default:
            object = [self.dataArray objectAtIndex:index];
            break;
    }
    return object;
}

- (NSUInteger)indexOfViewController:(STPDataViewController *)viewController
{
    return [self.dataArray indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.dataArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (UIView *)pageViewController:(NMPageViewController *)pageViewController beforeBackgroundView:(UIViewController *)viewController
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    view.backgroundColor = [UIColor colorWithHue:floorf(index)/self.dataArray.count saturation:1 brightness:1 alpha:1];
    return view;
}

- (UIView *)pageViewController:(NMPageViewController *)pageViewController afterBackgroundView:(UIViewController *)viewController
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.dataArray count]) {
        return nil;
    }
    view.backgroundColor = [UIColor colorWithHue:floorf(index)/self.dataArray.count saturation:1 brightness:1 alpha:1];
    return view;
}



@end
