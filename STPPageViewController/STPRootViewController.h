//
//  STPRootViewController.h
//  NMPageViewController
//
//  Created by Norikazu on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPDataController.h"
#import "NMPageViewController.h"

@protocol STPPageViewControllerDelegate <NSObject>
@optional;
- (void)pagingViewWillChange:(NSInteger)index;
- (void)pagingViewDidChange:(NSInteger)index;

@end

@interface STPRootViewController : UIViewController <NMPageViewControllerDelegate>

@property (weak, nonatomic) id <STPPageViewControllerDelegate> delegate;
@property (strong, nonatomic) NMPageViewController *pageViewController;
@property (strong, nonatomic) UIPageViewController *oldpageViewController;
@property (weak, nonatomic) STPDataController *dataController;
@property (nonatomic) NSIndexPath *selectedIndexPath;

- (id)initWithDataController:(STPDataController *)dataController indexPath:(NSIndexPath *)indexPath;
@end
