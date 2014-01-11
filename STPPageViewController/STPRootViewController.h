//
//  STPRootViewController.h
//  STPPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STPPageViewControllerDelegate, STPPageViewControllerDataSource;


@interface STPRootViewController : UIViewController

- (id)initWithRootViewController:(UIViewController *)controller;

@property (nonatomic, assign) id <STPPageViewControllerDelegate> delegate;
@property (nonatomic, assign) id <STPPageViewControllerDataSource> dataSource;
@property (nonatomic, readonly) NSArray *gestureRecognizers;
@property (nonatomic, readonly) NSArray *viewControllers;

@end


@protocol STPPageViewControllerDelegate <NSObject>



@end



@protocol STPPageViewControllerDataSource <NSObject>

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

