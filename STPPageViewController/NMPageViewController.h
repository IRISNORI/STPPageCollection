//
//  NMPageViewController.h
//  NMPageViewController
//
//  Created by Muramoto on 2013/12/26.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//


#define PANGESTURE_LOCATION_THRESHOLD 0.35
#define PANGESTURE_VELOCITY_THRESHOLD 500


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NMPageViewControllerNavigationDirection) {
    NMPageViewControllerNavigationDirectionForward,
    NMPageViewControllerNavigationDirectionReverse
};

typedef NS_ENUM(NSInteger, NMPageViewControllerTransitionStyle) {
    NMPageViewControllerTransitionStyleBackgroundCrossDissolve = 0, // Navigate between views via a page curl transition.
    NMPageViewControllerTransitionStyleScroll = 1 // Navigate between views by scrolling.
};

UIKIT_EXTERN NSString * const STPPageViewCurrentControllerKey;
UIKIT_EXTERN NSString * const STPPageViewNextControllerKey;
UIKIT_EXTERN NSString * const STPPageViewPreviousControllerKey;

@protocol NMPageViewControllerDelegate, NMPageViewControllerDataSource;


@interface NMPageViewController : UIViewController

- (id)initWithStartViewController:(UIViewController *)controller;
- (void)setStartViewController:(UIViewController *)controller;

@property (nonatomic, assign) UIView *backgroundView;
@property (nonatomic, assign) id <NMPageViewControllerDelegate> delegate;
@property (nonatomic, assign) id <NMPageViewControllerDataSource> dataSource;
@property (nonatomic, readonly) NSArray *gestureRecognizers;
@property (nonatomic, readonly) NSArray *viewControllers;
@property (nonatomic) NMPageViewControllerTransitionStyle transitionStyle;

@end


@protocol NMPageViewControllerDelegate <NSObject>

@optional

- (void)pageViewController:(NMPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers NS_AVAILABLE_IOS(7_0);

- (void)pageViewController:(NMPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed NS_AVAILABLE_IOS(7_0);
- (void)pageViewController:(NMPageViewController *)pageViewController updateInteractiveTransition:(CGFloat)percentComplete NS_AVAILABLE_IOS(7_0);

@end



@protocol NMPageViewControllerDataSource <NSObject>

@required

- (UIViewController *)pageViewController:(NMPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(7_0);
- (UIViewController *)pageViewController:(NMPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(7_0);
- (UIView *)pageViewController:(NMPageViewController *)pageViewController beforeBackgroundView:(UIViewController *)viewController NS_AVAILABLE_IOS(7_0);
- (UIView *)pageViewController:(NMPageViewController *)pageViewController afterBackgroundView:(UIViewController *)viewController NS_AVAILABLE_IOS(7_0);

@optional

- (NSInteger)presentationCountForPageViewController:(NMPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0); // The number of items reflected in the page indicator.
- (NSInteger)presentationIndexForPageViewController:(NMPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0); // The selected item reflected in the page indicator.

@end