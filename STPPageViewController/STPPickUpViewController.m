//
//  STPPickUpViewController.m
//  LPCollection
//
//  Created by Muramoto on 2013/12/03.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPPickUpViewController.h"
#import "STPDataController.h"

@interface STPPickUpViewController () <STPPageViewControllerDelegate>

@end

@implementation STPPickUpViewController

- (STPRootViewController *)pagingViewController
{
    if (!_pagingViewController) {
        _pagingViewController = [[STPRootViewController alloc] initWithDataController:self.dataController indexPath:self.selectedIndexPath];
        _pagingViewController.delegate = self;
    }
    return _pagingViewController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(www)];
    //self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self addChildViewController:self.pagingViewController];
    [self.pagingViewController didMoveToParentViewController:self];
    
    self.collectionView.scrollEnabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pagingViewController.view removeFromSuperview];
    [self.view addSubview:self.pagingViewController.view];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.pagingViewController.view removeFromSuperview];
    STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    [cell addSubview:self.pagingViewController.view];
    [self.pagingViewController willMoveToParentViewController:self];
    [super viewDidDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.pagingViewController removeFromParentViewController];
    [super viewDidDisappear:animated];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STPListPickUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:STPListPickUpCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHue:1.0f/20 * indexPath.row saturation:1 brightness:1 alpha:1];
    return cell;
}

#pragma mark - TransitionViewDelegate

- (void)selectedIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    ((STPPickUpLayout *)self.collectionView.collectionViewLayout).selectedIndexPath = indexPath;
    ((STPPickUpLayout *)self.collectionViewLayout).selectedIndexPath = indexPath;
}

- (void)startAnimation:(NSTimeInterval)transitionDuration presenting:(BOOL)present
{
    STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (present) {
        self.pagingViewController.view.alpha = 0.0f;
        [cell addSubview:self.pagingViewController.view];
        [UIView animateWithDuration:transitionDuration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.pagingViewController.view.alpha = 1.0f;
            cell.contentView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:transitionDuration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.pagingViewController.view.alpha = 0.0f;
            cell.contentView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (void)startWithIndexPath:(NSIndexPath *)indexPath presenting:(BOOL)present
{
    if (present) {
        self.pagingViewController.view.alpha = 0.0f;
        STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell addSubview:self.pagingViewController.view];
    }
    
}

- (void)updateWithProgress:(CGFloat)progress presenting:(BOOL)present
{
    STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (present) {
        self.pagingViewController.view.alpha = progress;
        cell.contentView.alpha = 1.0f - progress;
    } else {
        self.pagingViewController.view.alpha = 1.0f - progress;
        cell.contentView.alpha = progress;
    }
}

- (void)finishInteractiveTransition:(CGFloat)progress presenting:(BOOL)present
{
    STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (present) {
        self.pagingViewController.view.alpha = 1.0f;
        cell.contentView.alpha = 0.0f;
    } else {
        self.pagingViewController.view.alpha = 0.0f;
        cell.contentView.alpha = 1.0f;
        [self.pagingViewController.view willMoveToSuperview:nil];
        [self.pagingViewController.view removeFromSuperview];
    }
}

- (void)cancelInteractiveTransition:(CGFloat)progress presenting:(BOOL)present
{
    STPListPickUpCell *cell = (STPListPickUpCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    if (present) {
        self.pagingViewController.view.alpha = 0.0f;
        cell.contentView.alpha = 1.0f;
    } else {
        self.pagingViewController.view.alpha = 1.0f;
        cell.contentView.alpha = 0.0f;
    }
}

- (void)addGesture:(UIPinchGestureRecognizer *)pinch
{
    [self.view addGestureRecognizer:pinch];
}

- (void)pagingViewDidChange:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    STPPickUpLayout *layout = (STPPickUpLayout *)self.collectionViewLayout;
    layout.selectedIndexPath = indexPath;
    
    [self.collectionView setCollectionViewLayout:layout animated:NO];
    UICollectionViewScrollPosition position = (self.selectedIndexPath.row > index) ? UICollectionViewScrollPositionTop : UICollectionViewScrollPositionBottom;
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:position];
    self.selectedIndexPath = indexPath;
    
}

#pragma mark - STPDataViewControllerDelegate methods
/*
- (STPDataCollectionViewController *)startViewCollectionController
{
    STPDataCollectionViewController *dataViewController = [[STPDataCollectionViewController alloc] init];
    return dataViewController;
}
*/


@end
