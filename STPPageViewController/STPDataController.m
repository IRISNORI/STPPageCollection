//
//  STPModelController.m
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPModelController.h"

#import "STPDataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface STPModelController()
@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation STPModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        _pageData = [[dateFormatter monthSymbols] copy];
    }
    return self;
}

- (STPDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    STPDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"STPDataViewController"];

    dataViewController.view.backgroundColor = [UIColor colorWithHue:floorf(index)/self.pageData.count saturation:1 brightness:1 alpha:1];
    dataViewController.dataObject = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(STPDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return [self.pageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(NMPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(NMPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIView *)pageViewController:(NMPageViewController *)pageViewController afterBackgroundView:(UIViewController *)viewController
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    view.backgroundColor = [UIColor colorWithHue:floorf(index)/self.pageData.count saturation:1 brightness:1 alpha:1];
    return view;
}

- (UIView *)pageViewController:(NMPageViewController *)pageViewController beforeBackgroundView:(UIViewController *)viewController
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NSUInteger index = [self indexOfViewController:(STPDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    view.backgroundColor = [UIColor colorWithHue:floorf(index)/self.pageData.count saturation:1 brightness:1 alpha:1];
    return view;
}

@end
