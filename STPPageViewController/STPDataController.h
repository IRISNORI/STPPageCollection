//
//  STPModelController.h
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMPageViewController.h"

@class STPDataViewController;

@interface STPModelController : NSObject <NMPageViewControllerDataSource>

- (STPDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(STPDataViewController *)viewController;

@end
