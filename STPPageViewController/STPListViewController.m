//
//  STPListViewController.m
//  LPCollection
//
//  Created by Muramoto on 2013/12/03.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPListViewController.h"
#import "STPPickUpViewController.h"
#import "STPPickUpLayout.h"

@interface STPListViewController ()

@end

@implementation STPListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.scrollEnabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = [self nextViewControllerAtIndexPath:indexPath];
    [self.navigationController pushViewController:controller animated:YES];
}

- (UICollectionViewController*)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    // We could have multiple section stacks and find the right one,
    STPPickUpLayout *layout = [STPPickUpLayout new];
    
    layout.itemSize = CGSizeMake(320, 130);
    layout.selectedItemSize = [UIScreen mainScreen].bounds.size;
    layout.selectedIndexPath = indexPath;
    
    STPPickUpViewController* nextCollectionViewController = [[STPPickUpViewController alloc] initWithCollectionViewLayout:layout indexPath:indexPath];
    nextCollectionViewController.view.gestureRecognizers = self.view.gestureRecognizers;
    nextCollectionViewController.fetchedResultsController = self.fetchedResultsController;
    nextCollectionViewController.useLayoutToLayoutNavigationTransitions = YES;
    nextCollectionViewController.title = @"Layout 2";
    return nextCollectionViewController;
}


@end
