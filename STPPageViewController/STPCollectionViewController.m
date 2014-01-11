//
//  STPCollectionViewController.m
//  LPInterface
//
//  Created by Muramoto on 2013/11/29.
//  Copyright (c) 2013年 Norikazu Muramoto. All rights reserved.
//

#import "STPCollectionViewController.h"

NSString * const STPListCellIdetifier          = @"ListCell";
NSString * const STPPickUpCellIdentifier       = @"PickUpCell";
NSString * const STPListPickUpCellIdentifier   = @"listPickUpCell";

@interface STPCollectionViewController ()


@end

@implementation STPCollectionViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout dataController:(STPDataController *)dataController
{
    if (self = [super initWithCollectionViewLayout:layout]) {
        _dataController = dataController;
    }
    return self;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout indexPath:(NSIndexPath *)indexPath
{
    if (self = [super initWithCollectionViewLayout:layout])
    {
        _selectedIndexPath = indexPath;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView registerClass:[STPListPickUpCell class] forCellWithReuseIdentifier:STPListPickUpCellIdentifier];
}

- (UICollectionViewController *)nextViewControllerAtPoint:(CGPoint)point
{
    self.selectedIndexPath = [self.collectionView indexPathForItemAtPoint:point];
    return nil;
}


- (UICollectionViewController *)nextViewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndexPath = indexPath;
    return nil;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    _selectedIndexPath = selectedIndexPath;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    STPListPickUpCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:STPListPickUpCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHue:1.0f/[self collectionView:collectionView numberOfItemsInSection:0] * indexPath.row saturation:1 brightness:1 alpha:1];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataController count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UICollectionViewTransitionLayout *)collectionView:(UICollectionView *)collectionView transitionLayoutForOldLayout:(UICollectionViewLayout *)fromLayout newLayout:(UICollectionViewLayout *)toLayout
{
    UICollectionViewTransitionLayout *layout = [[UICollectionViewTransitionLayout alloc] initWithCurrentLayout:fromLayout nextLayout:toLayout];
    
    return layout;
}

- (STPDataController *)dataController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_dataController) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSArray *data = [[dateFormatter monthSymbols] copy];
        
        _dataController = [[STPDataController alloc] initWithDataSource:data];
    }
    return _dataController;
}


@end
