//
//  STPTransitionManager.h
//  LPInterface
//
//  Created by Muramoto on 2013/11/29.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STPPickUpLayout.h"
@class STPTransitionManager;

@protocol STPTransitionManagerDelegate <NSObject>
- (void)interactionBeganAtPoint:(CGPoint)point;
- (void)interactionBeganAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol STPTransitionViewDelegate <NSObject>
- (void)selectedIndexPath:(NSIndexPath *)indexPath;
- (void)addGesture:(UIPinchGestureRecognizer *)pinch;
- (void)startWithIndexPath:(NSIndexPath *)indexPath presenting:(BOOL)present;
- (void)startAnimation:(NSTimeInterval)transitionDuration presenting:(BOOL)present;
- (void)updateWithProgress:(CGFloat)progress presenting:(BOOL)present;
- (void)finishInteractiveTransition:(CGFloat)progress presenting:(BOOL)present;
- (void)cancelInteractiveTransition:(CGFloat)progress presenting:(BOOL)present;
@end

@interface STPTransitionManager : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning>

@property (nonatomic) id <STPTransitionManagerDelegate> delegate;
@property (nonatomic) id <STPTransitionViewDelegate> viewDelegate;
@property (nonatomic) BOOL hasActiveInteraction;
@property (nonatomic) UINavigationControllerOperation navigationOperation;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UICollectionViewController *parentViewController;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchGesture;

- (instancetype)initWithCollectionView:(UICollectionViewController *)collectionView;
- (instancetype)initWithCollectionViewController:(UICollectionViewController *)collectionViewController;

@end